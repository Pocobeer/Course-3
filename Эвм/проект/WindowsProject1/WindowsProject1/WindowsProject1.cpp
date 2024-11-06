#include <windows.h>
#include <shellapi.h>
#include <iostream>

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    case WM_COMMAND:
        switch (LOWORD(wParam)) {
        case 1: // Запустить экранный диктор
            ShellExecute(NULL, L"open", L"C:\\Windows\\System32\\Narrator.exe", NULL, NULL, SW_SHOWNORMAL);
            break;
        case 2: // Запустить увеличительное стекло
            ShellExecute(NULL, L"open", L"C:\\Windows\\System32\\Magnify.exe", NULL, NULL, SW_SHOWNORMAL);
            break;
        case 3: // Запустить экранную клавиатуру
            ShellExecute(NULL, L"open", L"C:\\Windows\\System32\\osk.exe", NULL, NULL, SW_SHOWNORMAL);
            break;
        case 4: // Включить высокий контраст
            system("powershell -Command \"Set-ItemProperty -Path 'HKCU:\\Control Panel\\Accessibility' -Name 'HighContrast' -Value '1'\"");
            break;
        case 5: // Запустить голосовой доступ
            ShellExecute(NULL, L"open", L"C:\\Windows\\System32\\VoiceAccess.exe", NULL, NULL, SW_SHOWNORMAL);
            break;
        case 6: // Включить фильтры цвета
            system("powershell -Command \"Set-ItemProperty -Path 'HKCU:\\Software\\Microsoft\\ColorFiltering' -Name 'ColorFilter' -Value '1'\"");
            break;
        case 7: // Открыть настройки специальных возможностей
            ShellExecute(NULL, L"open", L"control", L"access.cpl", NULL, SW_SHOWNORMAL);
            break;
        }
        return 0;
    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int nShowCmd) {
    const wchar_t CLASS_NAME[] = L"AccessibilityApp";

    WNDCLASS wc = {};
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = CLASS_NAME;

    RegisterClass(&wc);

    HWND hwnd = CreateWindowEx(
        0, CLASS_NAME, L"Специальные возможности Windows",
        WS_OVERLAPPEDWINDOW | WS_VISIBLE, CW_USEDEFAULT, CW_USEDEFAULT,
        300, 300, NULL, NULL, hInstance, NULL
    );

    // Создание кнопок
    CreateWindow(L"BUTTON", L"Экранный диктор", WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
        10, 10, 260, 30, hwnd, (HMENU)1, hInstance, NULL);
    CreateWindow(L"BUTTON", L"Увеличительное стекло", WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
        10, 50, 260, 30, hwnd, (HMENU)2, hInstance, NULL);
    CreateWindow(L"BUTTON", L"Экранная клавиатура", WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
        10, 90, 260, 30, hwnd, (HMENU)3, hInstance, NULL);
    CreateWindow(L"BUTTON", L"Высокий контраст", WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
        10, 130, 260, 30, hwnd, (HMENU)4, hInstance, NULL);
    CreateWindow(L"BUTTON", L"Голосовой доступ", WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
        10, 170, 260, 30, hwnd, (HMENU)5, hInstance, NULL);
    CreateWindow(L"BUTTON", L"Фильтры цвета", WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
        10, 210, 260, 30, hwnd, (HMENU)6, hInstance, NULL);
    CreateWindow(L"BUTTON", L"Настройки специальных возможностей", WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON,
        10, 250, 260, 30, hwnd, (HMENU)7, hInstance, NULL);

    MSG msg = {};
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return 0;
}
