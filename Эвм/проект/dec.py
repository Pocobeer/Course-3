import ctypes
from ctypes import wintypes

# Определяем константы
SPI_SETHIGHCONTRAST = 0x0042
SPI_GETHIGHCONTRAST = 0x0041

HCF_HIGHCONTRASTON = 0x00000001
HCF_AVAILABLE = 0x00000002

# Определяем структуру HIGHCONTRASTW
class HIGHCONTRASTW(ctypes.Structure):
    _fields_ = [
        ("cbSize", wintypes.UINT),
        ("dwFlags", wintypes.DWORD),
        ("lpszDefaultScheme", wintypes.LPWSTR)  # Используем LPWSTR для Unicode
    ]

def get_high_contrast_state():
    # Создаем экземпляр структуры HIGHCONTRASTW
    high_contrast = HIGHCONTRASTW()
    high_contrast.cbSize = ctypes.sizeof(HIGHCONTRASTW)
    
    # Получаем текущее состояние режима повышенной контрастности
    result = ctypes.windll.user32.SystemParametersInfoW(
        SPI_GETHIGHCONTRAST,
        0,
        ctypes.byref(high_contrast),
        0
    )

    if not result:
        print("Ошибка при получении состояния режима повышенной контрастности:", ctypes.GetLastError())
        return None
    return high_contrast.dwFlags & HCF_HIGHCONTRASTON != 0

def toggle_high_contrast():
    # Получаем текущее состояние
    current_state = get_high_contrast_state()
    
    if current_state is None:
        return  # Если не удалось получить состояние, выходим

    # Устанавливаем новое состояние
    new_state = not current_state

    # Создаем экземпляр структуры HIGHCONTRASTW
    high_contrast = HIGHCONTRASTW()
    high_contrast.cbSize = ctypes.sizeof(HIGHCONTRASTW)
    high_contrast.dwFlags = HCF_HIGHCONTRASTON if new_state else 0
    high_contrast.lpszDefaultScheme = None  # Не устанавливаем схему

    # Вызываем SystemParametersInfo для установки нового состояния
    result = ctypes.windll.user32.SystemParametersInfoW(
        SPI_SETHIGHCONTRAST,
        0,
        ctypes.byref(high_contrast),
        0
    )

    if not result:
        print("Ошибка при переключении режима повышенной контрастности:", ctypes.GetLastError())
    else:
        print("Режим повышенной контрастности успешно переключен на", "включен" if new_state else "выключен")

# Пример использования
toggle_high_contrast()  # Включить или отключить режим повышенной контрастности
