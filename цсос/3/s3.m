clc
clear all
global a;
global m;
a = 0;  % ������� ��������
m = 0;  % ������� ���������
N = 960;
N1 = 32;
N2 = 30;
Y = zeros(N1, N2);
f = 100;
Fd = 1000;
n = 0:N-1;

% �������� ������
X = sin(2*pi*f*n/Fd);

figure(1)
plot(n, X, 'r');
title('�������� ������');
grid on;

% ������ ��� (������� �������������� �����)
figure(2);
Y1 = fft(X);
plot(n, abs(Y1), 'b');
grid on;
title('������ ���');

% �������� ���
figure(3);
Y2 = ifft(Y1);
plot(n, Y2, 'b');
grid on;
title('�������� ���');

% ��������� � ��� (���������� ��������������� �����)
figure(4);
Fin = my_dft(X); % ���������� ���
plot(n, abs(Fin), 'b', n, abs(Y1), 'r--');
title("��������� ��� � ���");
legend('���', '���');
grid on;

% ������� �������� ��� ��������� ����-�����
a = 0; m = 0;
Y_kt = my_cooley_tukey(X, N1, N2);

disp('���������� ����������� ��������:'); a
disp('���������� ����������� ���������:'); m

% ���������� ��� (������ �����)
function X = my_dft(x)
    N = length(x);
    X = zeros(1,N);
    for k = 1:N
        for n = 1:N
            X(k) = X(k) + x(n)*exp(-1i*2*pi*(k-1)*(n-1)/N);
        end
    end
end

% ���������� ��������� ����-�����
function X = my_cooley_tukey(x, N1, N2)
    global a;
    global m;
    
    N = length(x);
    if N ~= N1*N2
        error('������ ������� ������ ���� ����� N1*N2');
    end
    
    % 1. ������������������ ������� ������
    x_reshaped = reshape(x, N1, N2);
    
    % 2. N1-�������� ��� �� �������
    X1 = zeros(N1, N2);
    for n2 = 1:N2
        X1(:,n2) = fft(x_reshaped(:,n2));
        a = a + N1*log2(N1); % ��������� ������ ��������
        m = m + N1*log2(N1)/2; % ��������� ������ ���������
    end
    
    % 3. ��������� �� �������������� ���������
    twiddle = exp(-2i*pi*(0:N1-1)'*(0:N2-1)/N);
    X2 = X1 .* twiddle;
    a = a + N1*N2; % ���� ����������� ���������
    m = m + N1*N2;
    
    % 4. N2-�������� ��� �� ��������
    X3 = zeros(N1, N2);
    for n1 = 1:N1
        X3(n1,:) = fft(X2(n1,:));
        a = a + N2*log2(N2);
        m = m + N2*log2(N2)/2;
    end
    
    % 5. ������������������ �������� ������
    X = reshape(X3.', 1, N);
end