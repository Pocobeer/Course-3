clear;
close all;
clc;

global a;
global m;

a = 0;  % Счетчик операций сложения
m = 0;  % Счетчик операций умножения

% Параметры сигнала
N = 960;     % Длина сигнала
fd = 1000;    % Частота дискретизации
f1 = 20;   % Частота сигнала
t = 0:N-1;   % Временные отсчеты

% Генерация тестового сигнала
X = sin(t * 2 * pi * f1 / fd);

% Отображение исходного сигнала
figure(1);
plot(t, X); 
grid on;  
title('Исходный сигнал');
xlabel('Отсчеты');
ylabel('Амплитуда');

% Вычисление ДПФ алгоритмом Кули-Тьюки для N=960
Y1 = kl_tk960(X);
a 
m

% Вычисление ДПФ по определению (прямой метод)
Y2 = opred(X, N);

% Сравнение результатов двух методов
figure(2);
subplot(2,1,1);
plot(t*fd/N, abs(Y1), '.--g'); 
grid on; 
title('ДПФ по Кули-Тьюки');
xlabel('Отсчеты');
ylabel('Амплитуда');

subplot(2,1,2);
plot(t*fd/N, abs(Y2), 'r'); 
grid on; 
title('ДПФ по определению');
xlabel('Отсчеты');
ylabel('Амплитуда');

% Обратное преобразование
Z = conj(Y1);
Z1 = conj(kl_tk960(Z)) / N;


figure(3);
subplot(2,1,1);
plot(t, X, 'g'); 
grid on;
title('Исходный сигнал');
xlabel('Отсчеты');
ylabel('Амплитуда');

subplot(2,1,2);
plot(t, real(Z1), 'r'); 
grid on;
title('Восстановленный сигнал (ОДПФ)');
xlabel('Отсчеты');
ylabel('Амплитуда');

% Вывод счетчиков операций
%fprintf('Всего операций сложения: %d\n', a);
%fprintf('Всего операций умножения: %d\n', m);

%% Функция ДПФ по алгоритму Кули-Тьюки для N=960 (32?30)
function [Y] = kl_tk960(X)
    global a;
    global m;
    
    N = 960;
    N1 = 32;  % Размер строки
    N2 = 30;  % Размер столбца
    
    % 1) Отображение входной последовательности в 2-мерную таблицу 30?32
    Y = zeros(N2, N1);
    for n = 1:N2
        for j = 1:N1
            Y(n, j) = X((n-1)*N1 + j);
        end
    end
    
    % 2) Вычисление ДПФ каждого столбца (32 ДПФ длиной 30)
    for n = 1:N1
        temp = opred(Y(:, n), N2);
        for j = 1:N2
            Y(j, n) = temp(j);
        end
    end
    
    % 3) Умножение на поворачивающие множители W_N^(nk)
    for n = 1:N2
        for k = 1:N1
            Y(n, k) = Y(n, k) * exp(-1i * 2 * pi * (k-1) * (n-1) / N);
            m = m + 1;
        end
    end
    
    % 4) Вычисление ДПФ каждой строки (30 ДПФ длиной 32)
    for n = 1:N2
        Y(n, :) = vrem_32(Y(n, :));
    end
    
    % 5) Отображение 2-мерной таблицы в выходную последовательность
    Y_out = zeros(1, N);
    for i = 1:N1
        for j = 1:N2
            Y_out((i-1)*N2 + j) = Y(j, i);
        end
    end
    
    Y = Y_out;
end

%% Функция вычисления ДПФ по определению
function Y = opred(X, N)
    global a;
    global m;
    
    Y = zeros(1, N);
    
    for k = 1:N
        for n = 1:N
            Y(k) = Y(k) + X(n) * exp(-1i * 2 * pi * (n-1) * (k-1) / N); %X(k)=?_(n=0)^959??x(n)?*W_960^nk
             a = a + 1;
             m = m + 1;
        end
    end
end

%% Оптимизированная функция вычисления ДПФ для N=32 (используется в Кули-Тьюки)
function Y = vrem_32(A)
    global a;
    global m;
    
    N = 32;
    
    % 1) Этап перестановки (бит-реверс)
    NV2 = round(N/2);
    NM1 = N-1;
    J = 1;
    
    for I = 1:NM1
        if I < J
            % Меняем местами элементы
            T = A(J);
            A(J) = A(I);
            A(I) = T;
        end
        K = NV2;
        while K < J
            J = J - K;
            K = round(K/2);
        end
        J = J + K;
    end
    
    % 2) Предварительное вычисление поворачивающих множителей
    koef = zeros(1, 512);
    for index = 1:512
        tx = pi/512 * (index-1);
        koef(index) = complex(cos(tx), -sin(tx));
    end
    
    % 3) Основной цикл БПФ (5 этапов для N=32)
    DIND = round(N/2);
    LE = 1;
    
    for L = 1:5
        LE1 = LE;
        LE = LE * 2;
        IND = 1;
        
        for J = 1:LE1
            I = J;
            INDM = round((IND-1)*1024/N + 1); %индекс в табл пов множ
            
            while I <= N
                IP = I + LE1;
                T = A(IP) * koef(INDM); %умножение на пов множ
                m = m + 1;
                
                A(IP) = A(I) - T; % нижняяя бабаочка
                A(I) = A(I) + T; % верхняя бабочка
                a = a + 2;
                
                I = I + LE;
            end
            IND = IND + DIND;
        end
        DIND = round(DIND/2);
    end
    
    Y = A;
end