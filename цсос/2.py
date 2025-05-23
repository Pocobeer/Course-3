import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import tf2sos, sosfilt, residuez, lfilter

# Коэффициенты фильтра
b = np.array([0.1517, 1.3619, 6.2526, 19.0533, 42.6848, 73.9640, 101.9159,
              113.2440, 101.9159, 73.9640, 42.6848, 19.0533, 6.2526, 1.3619, 0.1517])
a = np.array([1.0000, 6.7022, 22.7081, 51.3303, 86.0246, 112.2148, 116.6174,
              97.2611, 64.5141, 32.9031, 11.7852, 2.0495, -0.5390, -0.4585, -0.1004])

# Масштабирование коэффициентов (чтобы избежать переполнения)
max_coeff = max(np.max(np.abs(a)), np.max(np.abs(b)))
b_scaled = b / max_coeff
a_scaled = a / max_coeff

# 1. Реализации фильтра (плавающая точка)
def direct_form(b, a, x):
    return lfilter(b, a, x)

def canonical_form(b, a, x):
    return lfilter(b, a, x)

sos = tf2sos(b_scaled, a_scaled)  # Последовательная форма (SOS)
r, p, k = residuez(b_scaled, a_scaled)  # Параллельная форма

def sos_form(sos, x):
    return sosfilt(sos, x)

def parallel_form(r, p, k, x):
    y = np.zeros_like(x, dtype=complex)
    for i in range(len(r)):
        y += lfilter([r[i]], [1, -p[i]], x)
    if not np.isclose(k, 0):
        y += k * x
    return np.real(y)

# 2. Fixed-point реализация (16 бит, Q15)
def to_fixed(x, frac_bits=15):
    return int(np.clip(np.round(x * (2**frac_bits)), -2**15, 2**15-1))

def direct_form_fixed(b, a, x, frac_bits=15):
    b_fixed = np.array([to_fixed(v, frac_bits) for v in b], dtype=np.int32)
    a_fixed = np.array([to_fixed(v, frac_bits) for v in a], dtype=np.int32)
    x_fixed = np.array([to_fixed(v, frac_bits) for v in x], dtype=np.int32)
    
    y_fixed = np.zeros(len(x), dtype=np.int64)  # Используем int64 для аккумулятора
    for n in range(len(x)):
        acc = 0
        for i in range(len(b)):
            if n - i >= 0:
                acc += b_fixed[i] * x_fixed[n - i]
        for j in range(1, len(a)):
            if n - j >= 0:
                acc -= a_fixed[j] * y_fixed[n - j]
        y_fixed[n] = np.clip(acc >> frac_bits, -2**31, 2**31-1)  # Приводим к int32
    
    return y_fixed / (2**frac_bits)

def canonical_form_fixed(b, a, x, frac_bits=15):
    b_fixed = np.array([to_fixed(v, frac_bits) for v in b], dtype=np.int32)
    a_fixed = np.array([to_fixed(v, frac_bits) for v in a], dtype=np.int32)
    x_fixed = np.array([to_fixed(v, frac_bits) for v in x], dtype=np.int32)
    
    y_fixed = np.zeros(len(x), dtype=np.int64)  # Используем int64 для аккумулятора
    w_fixed = np.zeros(len(x), dtype=np.int64)
    
    for n in range(len(x)):
        acc = x_fixed[n] << frac_bits  # Умножаем на 2^frac_bits
        for j in range(1, len(a)):
            if n - j >= 0:
                acc -= a_fixed[j] * w_fixed[n - j]
        w_fixed[n] = np.clip(acc >> frac_bits, -2**31, 2**31-1)  # Приводим к int32
        
        acc = 0
        for i in range(len(b)):
            if n - i >= 0:
                acc += b_fixed[i] * w_fixed[n - i]
        y_fixed[n] = np.clip(acc >> frac_bits, -2**31, 2**31-1)  # Приводим к int32
    
    return y_fixed / (2**frac_bits)

# 3. Тестовые сигналы (убедимся, что они в диапазоне [-1, 1])
def test_signals():
    length = 50
    signals = {
        "Единичный импульс": np.append(1, np.zeros(length-1)),
        "Единичный ступенчатый": np.ones(length),
        "Синусоидальный": 0.99 * np.sin(2*np.pi*0.05*np.arange(length))  # Умножаем на 0.99, чтобы избежать переполнения
    }
    
    forms = [
        ("Прямая форма", lambda x: direct_form(b_scaled, a_scaled, x), lambda x: direct_form_fixed(b_scaled, a_scaled, x)),
        ("Каноническая форма", lambda x: canonical_form(b_scaled, a_scaled, x), lambda x: canonical_form_fixed(b_scaled, a_scaled, x)),
        ("SOS форма", lambda x: sos_form(sos, x), None),
        ("Параллельная форма", lambda x: parallel_form(r, p, k, x), None)
    ]
    
    for name, x in signals.items():
        plt.figure(figsize=(15, 10))
        for i, (form_name, float_func, fixed_func) in enumerate(forms, 1):
            plt.subplot(2, 2, i)
            plt.plot(x, 'k-', alpha=0.3, linewidth=3, label='Вход')
            
            # Плавающая точка
            y_float = float_func(x)
            plt.plot(y_float, 'b-', label=f'{form_name} (float)')
            
            # Фиксированная точка (если реализована)
            if fixed_func is not None:
                y_fixed = fixed_func(x)
                plt.plot(y_fixed, 'r--', label=f'{form_name} (fixed)')
            
            plt.title(form_name)
            plt.xlabel('Отсчеты')
            plt.ylabel('Амплитуда')
            plt.legend()
            plt.grid()
        
        plt.suptitle(f'Реакция на {name} сигнал')
        plt.tight_layout()
    
    plt.show()

test_signals()