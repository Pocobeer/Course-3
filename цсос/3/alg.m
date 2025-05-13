function Y = alg(X, N1, N2)
global a;
global m;

N = N1 * N2;
Y = zeros(N1, N2);

% Преобразование входного вектора в матрицу N1?N2
for i = 1:N1
    for j = 1:N2
        Y(i, j) = X((i - 1) * N2 + j);
    end
end

% Вычисление N1-точечного БПФ для каждого столбца (прореживание по времени)
for j = 1:N2
    Y(:, j) = FFT_32point_time_decimation(Y(:, j));
end

% Умножение на поворачивающие множители
for i = 1:N1
    for j = 1:N2
        Y(i, j) = Y(i, j) * exp(-1i * 2 * pi * (i - 1) * (j - 1) / N);
        m = m + 1;
    end
end

% Вычисление N2-точечного ДПФ для каждой строки (по определению)
for i = 1:N1
    Y(i, :) = DFT_30point(Y(i, :));
end

% Преобразование матрицы обратно в вектор
result = zeros(1, N);
for i = 1:N1
    for j = 1:N2
        result((j - 1) * N1 + i) = Y(i, j);
    end
end

Y = result;
end

% Реализация 32-точечного БПФ с прореживанием по времени
function X = FFT_32point_time_decimation(x)
    N = length(x);
    if N == 1
        X = x;
    else
        % Разделение на четные и нечетные
        even = FFT_32point_time_decimation(x(1:2:N));
        odd = FFT_32point_time_decimation(x(2:2:N));
        
        % Комбинирование результатов
        X = zeros(1, N);
        half = N/2;
        for k = 0:half-1
            twiddle = exp(-2i*pi*k/N)*odd(k+1);
            X(k+1) = even(k+1) + twiddle;
            X(k+1+half) = even(k+1) - twiddle;
            
            % Учет операций
            global a m;
            a = a + 2;
            m = m + 1;
        end
    end
end

% Реализация 30-точечного ДПФ по определению
function X = DFT_30point(x)
    N = length(x);
    X = zeros(1, N);
    for k = 0:N-1
        for n = 0:N-1
            X(k+1) = X(k+1) + x(n+1) * exp(-2i*pi*k*n/N);
        end
    end
    % Учет операций
    global a m;
    a = a + N*(N-1);  % Сложений
    m = m + N*N;       % Умножений
end