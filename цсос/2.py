import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# Коэффициенты фильтра
b = np.array([0.1517, 1.3619, 6.2526, 19.0533, 42.6848, 73.9640, 
              101.9159, 113.2440, 101.9159, 73.9640, 42.6848, 
              19.0533, 6.2526, 1.3619, 0.1517])

a = np.array([1.0000, 6.7022, 22.7081, 51.3303, 86.0246, 112.2148,
              116.6174, 97.2611, 64.5141, 32.9031, 11.7852, 2.0495,
              -0.5390, -0.4585, -0.1004])

# Параметры фиксированной точки
FRACTIONAL_BITS = 14  # 16 бит: 1 знак + 1 целый + 14 дробных

def to_fixed(x):
    return np.round(x * (1 << FRACTIONAL_BITS)).astype(np.int32)

def from_fixed(x):
    return x.astype(float) / (1 << FRACTIONAL_BITS)

# 1. Прямая форма (Direct Form I)
def direct_form1(x, b, a, fixed_point=False):
    y = np.zeros_like(x)
    x_buf = np.zeros(len(b))
    y_buf = np.zeros(len(a))
    
    for n in range(len(x)):
        x_buf = np.roll(x_buf, 1)
        x_buf[0] = x[n]
        
        if fixed_point:
            b_fixed = to_fixed(b)
            a_fixed = to_fixed(a)
            x_fixed = to_fixed(x_buf)
            y_fixed = to_fixed(y_buf)
            
            acc = np.sum(b_fixed * x_fixed) - np.sum(a_fixed[1:] * y_fixed[1:])
            y[n] = from_fixed(acc // a_fixed[0])
        else:
            y[n] = (np.sum(b * x_buf) - np.sum(a[1:] * y_buf[1:])) / a[0]
        
        y_buf = np.roll(y_buf, 1)
        y_buf[0] = y[n]
    
    return y

# 2. Каноническая форма (Direct Form II)
def direct_form2(x, b, a, fixed_point=False):
    y = np.zeros_like(x)
    w_buf = np.zeros(max(len(a), len(b)))
    
    for n in range(len(x)):
        if fixed_point:
            b_fixed = to_fixed(b)
            a_fixed = to_fixed(a)
            w = (to_fixed(x[n]) << FRACTIONAL_BITS) - np.sum(a_fixed[1:] * to_fixed(w_buf[1:]))
            w = w // a_fixed[0]
            y[n] = from_fixed(np.sum(b_fixed * to_fixed(w_buf)) >> FRACTIONAL_BITS)
        else:
            w = (x[n] - np.sum(a[1:] * w_buf[1:])) / a[0]
            y[n] = np.sum(b * w_buf)
        
        w_buf = np.roll(w_buf, 1)
        w_buf[0] = w if not fixed_point else from_fixed(w)
    
    return y

# 3. Последовательная форма (SOS)
def sos_form(x, sos, fixed_point=False):
    y = x.copy()
    for section in sos:
        b = section[:3]
        a = section[3:]
        y = direct_form2(y, b, a, fixed_point)
    return y

# 4. Параллельная форма
def parallel_form(x, r, p, k, fixed_point=False):
    y = np.zeros_like(x, dtype=complex if np.iscomplexobj(r) else float)
    
    if np.any(k != 0):
        y += k * x
    
    for i in range(0, len(p), 2):
        if i+1 >= len(p):
            break
            
        b = [np.real(r[i] + r[i+1]), -np.real(r[i]*p[i+1] + r[i+1]*p[i])]
        a = [1, -np.real(p[i] + p[i+1]), np.real(p[i]*p[i+1])]
        y += direct_form2(x, b, a, fixed_point)
    
    return np.real(y)

# Генерация тестовых сигналов
def generate_signals(length=100):
    impulse = np.zeros(length)
    impulse[0] = 1
    
    step = np.ones(length)
    
    t = np.arange(length)
    sine = np.sin(2 * np.pi * 700 * t / 2000)
    
    return impulse, step, sine

# Основная функция
def main():
    # Преобразование в разные формы
    sos = signal.tf2sos(b, a)
    r, p, k = signal.residuez(b, a)
    
    # Генерация сигналов
    impulse, step, sine = generate_signals()
    
    # Обработка сигналов
    results = {
        'Прямая форма (float)': direct_form1(impulse, b, a),
        'Прямая форма (fixed)': direct_form1(impulse, b, a, True),
        'Каноническая форма (float)': direct_form2(step, b, a),
        'Каноническая форма (fixed)': direct_form2(step, b, a, True),
        'Последовательная форма (float)': sos_form(sine, sos),
        'Последовательная форма (fixed)': sos_form(sine, sos, True),
        'Параллельная форма (float)': parallel_form(impulse, r, p, k),
        'Параллельная форма (fixed)': parallel_form(impulse, r, p, k, True)
    }
    
    # Визуализация
    plt.figure(figsize=(15, 10))
    
    # Импульсная характеристика
    plt.subplot(3, 1, 1)
    markerline, stemlines, baseline = plt.stem(results['Прямая форма (float)'], label='Прямая (float)')
    plt.setp(stemlines, 'linewidth', 0.5)
    plt.setp(markerline, 'markersize', 2)
    markerline, stemlines, baseline = plt.stem(results['Прямая форма (fixed)'], label='Прямая (fixed)', linefmt='r-', markerfmt='ro')
    plt.setp(stemlines, 'linewidth', 0.5)
    plt.setp(markerline, 'markersize', 2)
    plt.title('Импульсная характеристика')
    plt.legend()
    plt.grid(True)
    
    # Ступенчатая характеристика
    plt.subplot(3, 1, 2)
    plt.plot(results['Каноническая форма (float)'], label='Каноническая (float)')
    plt.plot(results['Каноническая форма (fixed)'], 'r--', label='Каноническая (fixed)')
    plt.title('Ступенчатая характеристика')
    plt.legend()
    plt.grid(True)
    
    # Реакция на синус
    plt.subplot(3, 1, 3)
    plt.plot(results['Последовательная форма (float)'], label='Последовательная (float)')
    plt.plot(results['Последовательная форма (fixed)'], 'r--', label='Последовательная (fixed)')
    plt.plot(sine, 'g:', label='Исходный сигнал')
    plt.title('Реакция на синус 700 Гц')
    plt.legend()
    plt.grid(True)
    
    plt.tight_layout()
    plt.show()
    
    # Вывод коэффициентов
    print("\nКоэффициенты передаточной функции:")
    print("b =", b)
    print("a =", a)
    
    print("\nКоэффициенты последовательной формы (SOS):")
    print(sos)
    
    print("\nПараллельная форма:")
    print("Вычеты (r) =", r)
    print("Полюса (p) =", p)
    print("Прямой путь (k) =", k)

if __name__ == "__main__":
    main()