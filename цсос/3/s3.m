global add_count;  % ������� ��������
global mult_count; % ������� ���������
add_count = 0;
mult_count = 0;

N = 960;
N1 = 32;
N2 = 30;
f = 100; % ������� ������� (��)
Fs = 1000; % ������� ������������� (��)
n = 0:N-1; % ������ �������� �������

% �������� ������
x = sin(2*pi*f*n/Fs);

% 1. ������ ��������� �������
figure(1)
plot(n, x, 'r');
title('�������� ������');
xlabel('�������');
ylabel('���������');
grid on;

% 2. ������ ��� (MATLAB)
figure(2);
Y_matlab = fft(x); % ������� �������������� �����
plot(n, abs(Y_matlab), 'b');
title('������ ��� (MATLAB)');
xlabel('�������');
ylabel('���������');
grid on;

% 3. �������� ��� (MATLAB)
figure(3);
Y_inv = ifft(Y_matlab); % �������� ��������������
plot(n, real(Y_inv), 'b');
title('�������� ��� (MATLAB)');
xlabel('�������');
ylabel('���������');
grid on;

% 4. ������ ��� (������ ����������)
figure(4);
Y_dft = my_dft(x); % ���������� �������������� �����
plot(n, abs(Y_dft), 'b', n, abs(Y_matlab), 'r--');
title('��������� ��� � ���');
xlabel('�������');
ylabel('���������');
legend('��� (������)', '��� (MATLAB)');
grid on;

% ����� ����������� ��� ������� ���
disp('=== ������ ��� ===');
disp(['���������� ����������� ��������: ', num2str(add_count)]);
disp(['���������� ����������� ���������: ', num2str(mult_count)]);

% ����� ��������� ��� ��������� ����-�����
add_count = 0;
mult_count = 0;

% 5. ���������� ��������� ����-�����
try
    Y_ct = my_cooley_tukey(x, N1, N2); % ������� ��������������
    
    % ������� �� ������
    disp('=== �������� ����-����� ===');
    
    % 1. N1 ��� ������ N2 �����
    A1 = N1 * N2*(N2-1);  % 32*30*29 = 27840
    M1 = N1 * N2*N2;       % 32*30*30 = 28800
    disp(['1. N1 ��� N2 �����: A=', num2str(A1), ', M=', num2str(M1)]);
    
    % 2. ��������� �� �������������� ���������
    M_twiddle = N;         % 960
    disp(['2. M=', num2str(M_twiddle)]);
    
    % 3. N2 ��� ������ N1 �����
    A2 = N2 * N1*log2(N1); % 30*32*5 = 4800
    M2 = N2 * (N1/2)*log2(N1); % 30*16*5 = 2400
    disp(['3. N2 ��� N1 �����: A=', num2str(A2), ', M=', num2str(M2)]);
    
    % �����
    A_total = A1 + A2;  
    M_total = M1 + M_twiddle + M2;
    disp(['�����: A=', num2str(A_total), ', M=', num2str(M_total)]);
    
    % �������� ���������
    %disp(['����������� ��������: A=', num2str(add_count), ', M=', num2str(mult_count)]);
    %disp(['������ ����� ����-����� � ���: ', num2str(max(abs(Y_ct - Y_matlab)))]);
    
    % 6. ������ ��������� ����-����� � ��� MATLAB
    %figure(5);
    %plot(n, abs(Y_ct), 'b', n, abs(Y_matlab), 'r--');
    %%title('��������� ����-����� � ��� (MATLAB)');
    %xlabel('�������');
    %%ylabel('���������');
    %legend('����-�����', '��� (MATLAB)');
    %grid on;
end

% ���������� ��� (������ �����)
function X = my_dft(x)
    global add_count; global mult_count;
    N = length(x);
    X = zeros(1, N);
    
    for k = 0:N-1
        % ������ ������� (n=0)
        X(k+1) = x(1);  % W^0 = 1, ��������� �� ���������
        mult_count = mult_count + 1;
        
        for n = 1:N-1
            W = exp(-2i * pi * n * k / N);
            X(k+1) = X(k+1) + x(n+1) * W;
            add_count = add_count + 1;  % ���� ��������
            mult_count = mult_count + 1; % ���� ���������
        end
    end
end

% ���������� ��������� ����-�����
function X = my_cooley_tukey(x, N1, N2)
    global add_count; global mult_count;
    N = length(x);
    
    % 1. ������������������ � ������� N2?N1
    x_reshaped = reshape(x, N1, N2).';
    
    % 2. N1 ��� ����� N2 (�� �������)
    X1 = zeros(N2, N1);
    for n1 = 1:N1
        X1(:, n1) = my_dft_30(x_reshaped(:, n1));
    end
    
    % 3. ��������� �� �������������� ���������
    X2 = zeros(N2, N1);
    for n1 = 1:N1
        for n2 = 1:N2
            W = exp(-2i * pi * (n1-1)*(n2-1)/N);
            X2(n2, n1) = X1(n2, n1) * W;
            if (n1-1)*(n2-1) ~= 0  % �� ������� ��������� �� 1
                mult_count = mult_count + 1;
            end
        end
    end
    
    % 4. N2 ��� ����� N1 (�� ��������)
    X3 = zeros(N2, N1);
    for n2 = 1:N2
        X3(n2, :) = my_fft_32(X2(n2, :));
    end
    
    % 5. ������������������ ����������
    X = reshape(X3.', 1, N);
end

% ��� ����� 30 (������ �����)
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

% ��� ����� 32 (����������� ��������)
function X = my_fft_32(x)
    global add_count; global mult_count;
    x = x(:).'; % ����������� � ������
    N = length(x);
    
    if N == 1
        X = x;
        return;
    end
    
    % ����������� ���������� �� ������ � ��������
    X_even = my_fft_32(x(1:2:end));
    X_odd = my_fft_32(x(2:2:end));
    
    % �������������� �����������
    W = exp(-2i * pi * (0:N/2-1) / N);
    X = [X_even + W .* X_odd, X_even - W .* X_odd];
    
    % ������� ��������
    add_count = add_count + N;
    mult_count = mult_count + N/2;
end