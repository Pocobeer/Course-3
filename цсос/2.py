import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# Заданные коэффициенты фильтра
b_float = np.array([0.1517, 1.3619, 6.2526, 19.0533, 42.6848, 73.9640, 
                  101.9159, 113.2440, 101.9159, 73.9640, 42.6848, 
                  19.0533, 6.2526, 1.3619, 0.1517])

a_float = np.array([1.0000, 6.7022, 22.7081, 51.3303, 86.0246, 112.2148,
                  116.6174, 97.2611, 64.5141, 32.9031, 11.7852, 2.0495,
                  -0.5390, -0.4585, -0.1004])

# Преобразование коэффициентов в формат с фиксированной точкой (16 бит)
def float_to_fixed(x, n_bits=16):
    max_val = 2**(n_bits-1) - 1
    scale = max_val / np.max(np.abs(x))
    return np.round(x * scale).astype(np.int32)

b_fixed = float_to_fixed(b_float)
a_fixed = float_to_fixed(a_float)

# Масштабный коэффициент для фиксированной точки
scale_factor = 2**15 - 1 / np.max(np.abs(np.concatenate((b_float, a_float))))

# Реализация фильтра в прямой форме
def direct_form_filter(b, a, x, floating_point=True):
    y = np.zeros_like(x)
    N = len(b) - 1
    M = len(a) - 1
    
    if floating_point:
        for n in range(len(x)):
            # Входная часть
            x_part = x[max(0, n-N):n+1][::-1]  # Берем последние N+1 отсчетов
            x_part_padded = np.pad(x_part, (0, max(0, N+1 - len(x_part))))[:N+1]
            y[n] = np.sum(b * x_part_padded)
            
            # Обратная связь
            if n >= 1:
                y_part = y[max(0, n-M):n][::-1]  # Берем последние M отсчетов
                y_part_padded = np.pad(y_part, (0, max(0, M - len(y_part))))[:M]
                y[n] -= np.sum(a[1:1+len(y_part_padded)] * y_part_padded)
    else:
        for n in range(len(x)):
            # Входная часть (фиксированная точка)
            x_part = x[max(0, n-N):n+1][::-1]
            x_part_padded = np.pad(x_part, (0, max(0, N+1 - len(x_part))))[:N+1]
            y[n] = np.sum((b[:len(x_part_padded)] * x_part_padded) // scale_factor)
            
            # Обратная связь (фиксированная точка)
            if n >= 1:
                y_part = y[max(0, n-M):n][::-1]
                y_part_padded = np.pad(y_part, (0, max(0, M - len(y_part))))[:M]
                y[n] -= np.sum((a[1:1+len(y_part_padded)] * y_part_padded) // scale_factor)
            
            # Ограничение диапазона
            y[n] = np.clip(y[n], -2**15, 2**15-1)
    
    return y

# Реализация фильтра в канонической форме
def canonical_form_filter(b, a, x, floating_point=True):
    y = np.zeros_like(x)
    N = len(b) - 1
    M = len(a) - 1
    w = np.zeros(max(N, M))  # Состояния фильтра
    
    if floating_point:
        for n in range(len(x)):
            # Вычисление состояния
            w_current = x[n] - np.sum(a[1:M+1] * w[:M])
            
            # Выход
            y[n] = b[0] * w_current + np.sum(b[1:N+1] * w[:N])
            
            # Обновление состояний
            w[1:] = w[:-1]
            w[0] = w_current
    else:
        for n in range(len(x)):
            # Вычисление состояния (фиксированная точка)
            w_current = x[n] - np.sum((a[1:M+1] * w[:M]) // scale_factor)
            w_current = np.clip(w_current, -2**15, 2**15-1)
            
            # Выход (фиксированная точка)
            y[n] = (b[0] * w_current) // scale_factor + np.sum((b[1:N+1] * w[:N]) // scale_factor)
            y[n] = np.clip(y[n], -2**15, 2**15-1)
            
            # Обновление состояний
            w[1:] = w[:-1]
            w[0] = w_current
    
    return y

# Разложение на секции второго порядка (для последовательной и параллельной форм)
def get_sos(b, a):
    # Используем scipy для разложения на биквадратные секции
    sos = signal.tf2sos(b, a)
    return sos

# Реализация последовательной формы
def serial_form_filter(b, a, x, floating_point=True):
    sos = get_sos(b, a)
    y = x.copy()
    
    for section in sos:
        b_section = section[:3]
        a_section = section[3:]
        
        if floating_point:
            y = signal.lfilter(b_section, a_section, y)
        else:
            # Преобразуем коэффициенты секции в фиксированную точку
            b_fixed = float_to_fixed(b_section)
            a_fixed = float_to_fixed(a_section)
            y = canonical_form_filter(b_fixed, a_fixed, y, floating_point=False)
    
    return y

# Реализация параллельной формы
def parallel_form_filter(b, a, x, floating_point=True):
    # Разложение на параллельную форму (используем scipy)
    r, p, k = signal.residuez(b, a)
    
    # Группировка комплексно-сопряженных пар
    sos = signal.residuez_to_sos(r, p)
    
    y = np.zeros_like(x)
    
    for section in sos:
        b_section = section[:3]
        a_section = section[3:]
        
        if floating_point:
            y += signal.lfilter(b_section, a_section, x)
        else:
            # Преобразуем коэффициенты секции в фиксированную точку
            b_fixed = float_to_fixed(b_section)
            a_fixed = float_to_fixed(a_section)
            y += canonical_form_filter(b_fixed, a_fixed, x, floating_point=False)
            y = np.clip(y, -2**15, 2**15-1)
    
    return y

# Генерация тестовых сигналов
def generate_signals(length=1000):
    # Единичный импульс
    unit_impulse = np.zeros(length)
    unit_impulse[0] = 1
    
    # Единичный ступенчатый сигнал
    step_signal = np.ones(length)
    
    # Синусоидальный сигнал (700 Гц - в центре режекторной полосы)
    t = np.arange(length) / 2000  # fd = 2000 Гц
    sine_signal = np.sin(2 * np.pi * 700 * t)
    
    return unit_impulse, step_signal, sine_signal

# Тестирование фильтров
def test_filters():
    signals = generate_signals()
    signal_names = ["Единичный импульс", "Единичный ступенчатый", "Синусоидальный (700 Гц)"]
    
    for signal_data, name in zip(signals, signal_names):
        print(f"\nОбработка сигнала: {name}")
        
        # Плавающая точка
        y_direct_float = direct_form_filter(b_float, a_float, signal_data)
        y_canonical_float = canonical_form_filter(b_float, a_float, signal_data)
        y_serial_float = serial_form_filter(b_float, a_float, signal_data)
        y_parallel_float = parallel_form_filter(b_float, a_float, signal_data)
        
        # Фиксированная точка
        y_direct_fixed = direct_form_filter(b_fixed, a_fixed, (signal_data * scale_factor).astype(np.int32), False)
        y_canonical_fixed = canonical_form_filter(b_fixed, a_fixed, (signal_data * scale_factor).astype(np.int32), False)
        y_serial_fixed = serial_form_filter(b_fixed, a_fixed, (signal_data * scale_factor).astype(np.int32), False)
        y_parallel_fixed = parallel_form_filter(b_fixed, a_fixed, (signal_data * scale_factor).astype(np.int32), False)
        
        # Визуализация результатов
        plt.figure(figsize=(14, 8))
        
        # Плавающая точка
        plt.subplot(2, 1, 1)
        plt.title(f"{name} (плавающая точка)")
        plt.plot(y_direct_float, label='Прямая форма')
        plt.plot(y_canonical_float, '--', label='Каноническая форма')
        plt.plot(y_serial_float, '-.', label='Последовательная форма')
        plt.plot(y_parallel_float, ':', label='Параллельная форма')
        plt.legend()
        plt.grid()
        
        # Фиксированная точка
        plt.subplot(2, 1, 2)
        plt.title(f"{name} (фиксированная точка)")
        plt.plot(y_direct_fixed, label='Прямая форма')
        plt.plot(y_canonical_fixed, '--', label='Каноническая форма')
        plt.plot(y_serial_fixed, '-.', label='Последовательная форма')
        plt.plot(y_parallel_fixed, ':', label='Параллельная форма')
        plt.legend()
        plt.grid()
        
        plt.tight_layout()
        plt.show()

# Запуск тестирования
test_filters()

# Дополнительно: построение АЧХ фильтра
def plot_frequency_response():
    w, h = signal.freqz(b_float, a_float, fs=2000)
    plt.figure()
    plt.title('АЧХ режекторного фильтра')
    plt.plot(w, 20 * np.log10(np.abs(h)))
    plt.xlabel('Частота (Гц)')
    plt.ylabel('Амплитуда (дБ)')
    plt.grid()
    plt.axvspan(650, 800, color='red', alpha=0.1, label='Режекторная полоса')
    plt.axvspan(600, 850, color='green', alpha=0.1, label='Переходная полоса')
    plt.legend()
    plt.show()

plot_frequency_response()