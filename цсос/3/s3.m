global add_count;  % Счетчик сложений
global mult_count; % Счетчик умножений
add_count = 0;
mult_count = 0;

N = 960;
N1 = 32;
N2 = 30;
f = 100; % Частота сигнала (Гц)
Fs = 1000; % Частота дискретизации (Гц)
n = 0:N-1; % Вектор отсчетов времени

% Исходный сигнал
x = sin(2*pi*f*n/Fs);

% 1. График исходного сигнала
figure(1)
plot(n, x, 'r');
title('Исходный сигнал');
xlabel('Отсчеты');
ylabel('Амплитуда');
grid on;

% 2. Прямое БПФ (MATLAB)
figure(2);
Y_matlab = fft(x); % Быстрое преобразование Фурье
plot(n, abs(Y_matlab), 'b');
title('Прямое БПФ (MATLAB)');
xlabel('Частота');
ylabel('Амплитуда');
grid on;

% 3. Обратное БПФ (MATLAB)
figure(3);
Y_inv = ifft(Y_matlab); % Обратное преобразование
plot(n, real(Y_inv), 'b');
title('Обратное БПФ (MATLAB)');
xlabel('Отсчеты');
ylabel('Амплитуда');
grid on;

% 4. Прямое ДПФ (ручная реализация)
figure(4);
Y_dft = my_dft(x); % Дискретное преобразование Фурье
plot(n, abs(Y_dft), 'b', n, abs(Y_matlab), 'r--');
title('Сравнение ДПФ и БПФ');
xlabel('Частота');
ylabel('Амплитуда');
legend('ДПФ (ручной)', 'БПФ (MATLAB)');
grid on;

% Вывод результатов для прямого ДПФ
disp('=== Прямое ДПФ ===');
disp(['Количество комплексных сложений: ', num2str(add_count)]);
disp(['Количество комплексных умножений: ', num2str(mult_count)]);

% Сброс счетчиков для алгоритма Кули-Тьюки
add_count = 0;
mult_count = 0;

% 5. Реализация алгоритма Кули-Тьюки
try
    Y_ct = my_cooley_tukey(x, N1, N2); % Быстрое преобразование
    
    % Расчеты по этапам
    disp('=== Алгоритм Кули-Тьюки ===');
    
    % 1. N1 ДПФ длиной N2 точек
    A1 = N1 * N2*(N2-1);  % 32*30*29 = 27840
    M1 = N1 * N2*N2;       % 32*30*30 = 28800
    disp(['1. N1 ДПФ N2 точек: A=', num2str(A1), ', M=', num2str(M1)]);
    
    % 2. Умножение на поворачивающие множители
    M_twiddle = N;         % 960
    disp(['2. M=', num2str(M_twiddle)]);
    
    % 3. N2 БПФ длиной N1 точек
    A2 = N2 * N1*log2(N1); % 30*32*5 = 4800
    M2 = N2 * (N1/2)*log2(N1); % 30*16*5 = 2400
    disp(['3. N2 БПФ N1 точек: A=', num2str(A2), ', M=', num2str(M2)]);
    
    % Итого
    A_total = A1 + A2;  
    M_total = M1 + M_twiddle + M2;
    disp(['Итого: A=', num2str(A_total), ', M=', num2str(M_total)]);
    
    % Проверка счетчиков
    %disp(['Фактические счетчики: A=', num2str(add_count), ', M=', num2str(mult_count)]);
    %disp(['Ошибка между Кули-Тьюки и БПФ: ', num2str(max(abs(Y_ct - Y_matlab)))]);
    
    % 6. График сравнения Кули-Тьюки и БПФ MATLAB
    %figure(5);
    %plot(n, abs(Y_ct), 'b', n, abs(Y_matlab), 'r--');
    %%title('Сравнение Кули-Тьюки и БПФ (MATLAB)');
    %xlabel('Частота');
    %%ylabel('Амплитуда');
    %legend('Кули-Тьюки', 'БПФ (MATLAB)');
    %grid on;
end

% Реализация ДПФ (прямой метод)
function X = my_dft(x)
    global add_count; global mult_count;
    N = length(x);
    X = zeros(1, N);
    
    for k = 0:N-1
        % Первый элемент (n=0)
        X(k+1) = x(1);  % W^0 = 1, умножение не требуется
        mult_count = mult_count + 1;
        
        for n = 1:N-1
            W = exp(-2i * pi * n * k / N);
            X(k+1) = X(k+1) + x(n+1) * W;
            add_count = add_count + 1;  % Учёт сложения
            mult_count = mult_count + 1; % Учёт умножения
        end
    end
end

% Реализация алгоритма Кули-Тьюки
function X = my_cooley_tukey(x, N1, N2)
    global add_count; global mult_count;
    N = length(x);
    
    % 1. Переупорядочивание в матрицу N2?N1
    x_reshaped = reshape(x, N1, N2).';
    
    % 2. N1 ДПФ длины N2 (по строкам)
    X1 = zeros(N2, N1);
    for n1 = 1:N1
        X1(:, n1) = my_dft_30(x_reshaped(:, n1));
    end
    
    % 3. Умножение на поворачивающие множители
    X2 = zeros(N2, N1);
    for n1 = 1:N1
        for n2 = 1:N2
            W = exp(-2i * pi * (n1-1)*(n2-1)/N);
            X2(n2, n1) = X1(n2, n1) * W;
            if (n1-1)*(n2-1) ~= 0  % Не считаем умножение на 1
                mult_count = mult_count + 1;
            end
        end
    end
    
    % 4. N2 БПФ длины N1 (по столбцам)
    X3 = zeros(N2, N1);
    for n2 = 1:N2
        X3(n2, :) = my_fft_32(X2(n2, :));
    end
    
    % 5. Переупорядочивание результата
    X = reshape(X3.', 1, N);
end

% ДПФ длины 30 (прямой метод)
function X = my_dft_30(x)
    global add_count; global mult_count;
    N = length(x);
    X = zeros(N, 1);
    for k = 0:N-1
        for n = 0:N-1
            W = exp(-2i * pi * n * k / N);
            X(k+1) = X(k+1) + x(n+1) * W;
            add_count = add_count + 1;
            mult_count = mult_count + 1;
        end
    end
end

% БПФ длины 32 (рекурсивный алгоритм)
function X = my_fft_32(x)
    global add_count; global mult_count;
    x = x(:).'; % Преобразуем в строку
    N = length(x);
    
    if N == 1
        X = x;
        return;
    end
    
    % Рекурсивное разделение на четные и нечетные
    X_even = my_fft_32(x(1:2:end));
    X_odd = my_fft_32(x(2:2:end));
    
    % Комбинирование результатов
    W = exp(-2i * pi * (0:N/2-1) / N);
    X = [X_even + W .* X_odd, X_even - W .* X_odd];
    
    % Подсчет операций
    add_count = add_count + N;
    mult_count = mult_count + N/2;
end