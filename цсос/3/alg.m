function Y = alg(X, N1, N2)
global a;
global m;

N = N1 * N2;
Y = zeros(N1, N2);

% �������������� �������� ������� � ������� N1?N2
for i = 1:N1
    for j = 1:N2
        Y(i, j) = X((i - 1) * N2 + j);
    end
end

% ���������� N1-��������� ��� ��� ������� ������� (������������ �� �������)
for j = 1:N2
    Y(:, j) = FFT_32point_time_decimation(Y(:, j));
end

% ��������� �� �������������� ���������
for i = 1:N1
    for j = 1:N2
        Y(i, j) = Y(i, j) * exp(-1i * 2 * pi * (i - 1) * (j - 1) / N);
        m = m + 1;
    end
end

% ���������� N2-��������� ��� ��� ������ ������ (�� �����������)
for i = 1:N1
    Y(i, :) = DFT_30point(Y(i, :));
end

% �������������� ������� ������� � ������
result = zeros(1, N);
for i = 1:N1
    for j = 1:N2
        result((j - 1) * N1 + i) = Y(i, j);
    end
end

Y = result;
end

% ���������� 32-��������� ��� � ������������� �� �������
function X = FFT_32point_time_decimation(x)
    N = length(x);
    if N == 1
        X = x;
    else
        % ���������� �� ������ � ��������
        even = FFT_32point_time_decimation(x(1:2:N));
        odd = FFT_32point_time_decimation(x(2:2:N));
        
        % �������������� �����������
        X = zeros(1, N);
        half = N/2;
        for k = 0:half-1
            twiddle = exp(-2i*pi*k/N)*odd(k+1);
            X(k+1) = even(k+1) + twiddle;
            X(k+1+half) = even(k+1) - twiddle;
            
            % ���� ��������
            global a m;
            a = a + 2;
            m = m + 1;
        end
    end
end

% ���������� 30-��������� ��� �� �����������
function X = DFT_30point(x)
    N = length(x);
    X = zeros(1, N);
    for k = 0:N-1
        for n = 0:N-1
            X(k+1) = X(k+1) + x(n+1) * exp(-2i*pi*k*n/N);
        end
    end
    % ���� ��������
    global a m;
    a = a + N*(N-1);  % ��������
    m = m + N*N;       % ���������
end