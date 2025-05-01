import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import tf2sos, sosfilt, residuez, lfilter

# Коэффициенты фильтра
b = np.array([0.1517, 1.3619, 6.2526, 19.0533, 42.6848, 73.9640, 101.9159,
              113.2440, 101.9159, 73.9640, 42.6848, 19.0533, 6.2526, 1.3619, 0.1517])
a = np.array([1.0000, 6.7022, 22.7081, 51.3303, 86.0246, 112.2148, 116.6174,
              97.2611, 64.5141, 32.9031, 11.7852, 2.0495, -0.5390, -0.4585, -0.1004])

# 1. Реализации фильтра (плавающая точка)
def direct_form(b, a, x):
    y = np.zeros_like(x)
    for n in range(len(x)):
        y[n] = sum(b[i]*x[n-i] for i in range(len(b)) if n-i >= 0)
        y[n] -= sum(a[j]*y[n-j] for j in range(1, len(a)) if n-j >= 0)
        y[n] /= a[0]
    return y

def canonical_form(b, a, x):
    y = np.zeros_like(x)
    w = np.zeros_like(x)
    for n in range(len(x)):
        w[n] = x[n] - sum(a[j]*w[n-j] for j in range(1, len(a)) if n-j >= 0)
        w[n] /= a[0]
        y[n] = sum(b[i]*w[n-i] for i in range(len(b)) if n-i >= 0)
    return y

sos = tf2sos(b, a)  # Последовательная форма
r, p, k = residuez(b, a)  # Параллельная форма

def sos_form(sos, x):
    return sosfilt(sos, x)

def parallel_form(r, p, k, x):
    y = np.zeros_like(x, dtype=complex)
    for i in range(len(r)):
        y += lfilter([r[i]], [1, -p[i]], x)
    if not np.isclose(k, 0):
        y += k * x
    return np.real(y)

# 2. Fixed-point реализация (16 бит)
def to_fixed(x, frac_bits=14):
    return int(np.round(x * (2**frac_bits)))

def direct_form_fixed(b, a, x, frac_bits=14):
    b_fixed = [to_fixed(v, frac_bits) for v in b]
    a_fixed = [to_fixed(v, frac_bits) for v in a]
    x_fixed = [to_fixed(v, frac_bits) for v in x]
    
    y_fixed = np.zeros(len(x), dtype=np.int64)
    for n in range(len(x)):
        acc = 0
        for i in range(len(b)):
            if n-i >= 0: acc += b_fixed[i] * x_fixed[n-i]
        for j in range(1, len(a)):
            if n-j >= 0: acc -= a_fixed[j] * y_fixed[n-j]
        y_fixed[n] = acc // a_fixed[0]
    
    return y_fixed / (2**frac_bits)

# 3. Тестовые сигналы
def test_signals():
    length = 50
    signals = {
        "Единичный импульс": np.append(1, np.zeros(length-1)),
        "Единичный ступенчатый": np.ones(length),
        "Синусоидальный": np.sin(2*np.pi*0.05*np.arange(length))
    }
    
    for name, x in signals.items():
        # Floating-point
        y_direct = direct_form(b, a, x)
        y_canon = canonical_form(b, a, x)
        y_sos = sos_form(sos, x)
        y_par = parallel_form(r, p, k, x)
        
        # Fixed-point
        y_fixed = direct_form_fixed(b, a, x)
        
        # Визуализация
        plt.figure(figsize=(10, 5))
        plt.plot(x, 'k-', alpha=0.3, linewidth=3, label='Вход')
        plt.plot(y_direct, label='Прямая форма')
        plt.plot(y_canon, '--', label='Каноническая форма')
        plt.plot(y_sos, '-.', label='SOS форма')
        plt.plot(y_par, ':', label='Параллельная форма')
        plt.plot(y_fixed, 'x', label='Fixed-point (16 бит)')
        
        plt.title(f'Реакция на {name} сигнал')
        plt.xlabel('Отсчеты')
        plt.ylabel('Амплитуда')
        plt.legend()
        plt.grid()
        plt.show()

test_signals()