clear;
close all;
clc;

global a;
global m;

a = 0;  % ������� �������� ��������
m = 0;  % ������� �������� ���������

% ��������� �������
N = 960;     % ����� �������
fd = 1000;    % ������� �������������
f1 = 20;   % ������� �������
t = 0:N-1;   % ��������� �������

% ��������� ��������� �������
X = sin(t * 2 * pi * f1 / fd);

% ����������� ��������� �������
figure(1);
plot(t, X); 
grid on;  
title('�������� ������');
xlabel('�������');
ylabel('���������');

% ���������� ��� ���������� ����-����� ��� N=960
Y1 = kl_tk960(X);
a 
m

% ���������� ��� �� ����������� (������ �����)
Y2 = opred(X, N);

% ��������� ����������� ���� �������
figure(2);
subplot(2,1,1);
plot(t*fd/N, abs(Y1), '.--g'); 
grid on; 
title('��� �� ����-�����');
xlabel('�������');
ylabel('���������');

subplot(2,1,2);
plot(t*fd/N, abs(Y2), 'r'); 
grid on; 
title('��� �� �����������');
xlabel('�������');
ylabel('���������');

% �������� ��������������
Z = conj(Y1);
Z1 = conj(kl_tk960(Z)) / N;


figure(3);
subplot(2,1,1);
plot(t, X, 'g'); 
grid on;
title('�������� ������');
xlabel('�������');
ylabel('���������');

subplot(2,1,2);
plot(t, real(Z1), 'r'); 
grid on;
title('��������������� ������ (����)');
xlabel('�������');
ylabel('���������');

% ����� ��������� ��������
%fprintf('����� �������� ��������: %d\n', a);
%fprintf('����� �������� ���������: %d\n', m);

%% ������� ��� �� ��������� ����-����� ��� N=960 (32?30)
function [Y] = kl_tk960(X)
    global a;
    global m;
    
    N = 960;
    N1 = 32;  % ������ ������
    N2 = 30;  % ������ �������
    
    % 1) ����������� ������� ������������������ � 2-������ ������� 30?32
    Y = zeros(N2, N1);
    for n = 1:N2
        for j = 1:N1
            Y(n, j) = X((n-1)*N1 + j);
        end
    end
    
    % 2) ���������� ��� ������� ������� (32 ��� ������ 30)
    for n = 1:N1
        temp = opred(Y(:, n), N2);
        for j = 1:N2
            Y(j, n) = temp(j);
        end
    end
    
    % 3) ��������� �� �������������� ��������� W_N^(nk)
    for n = 1:N2
        for k = 1:N1
            Y(n, k) = Y(n, k) * exp(-1i * 2 * pi * (k-1) * (n-1) / N);
            m = m + 1;
        end
    end
    
    % 4) ���������� ��� ������ ������ (30 ��� ������ 32)
    for n = 1:N2
        Y(n, :) = vrem_32(Y(n, :));
    end
    
    % 5) ����������� 2-������ ������� � �������� ������������������
    Y_out = zeros(1, N);
    for i = 1:N1
        for j = 1:N2
            Y_out((i-1)*N2 + j) = Y(j, i);
        end
    end
    
    Y = Y_out;
end

%% ������� ���������� ��� �� �����������
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

%% ���������������� ������� ���������� ��� ��� N=32 (������������ � ����-�����)
function Y = vrem_32(A)
    global a;
    global m;
    
    N = 32;
    
    % 1) ���� ������������ (���-������)
    NV2 = round(N/2);
    NM1 = N-1;
    J = 1;
    
    for I = 1:NM1
        if I < J
            % ������ ������� ��������
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
    
    % 2) ��������������� ���������� �������������� ����������
    koef = zeros(1, 512);
    for index = 1:512
        tx = pi/512 * (index-1);
        koef(index) = complex(cos(tx), -sin(tx));
    end
    
    % 3) �������� ���� ��� (5 ������ ��� N=32)
    DIND = round(N/2);
    LE = 1;
    
    for L = 1:5
        LE1 = LE;
        LE = LE * 2;
        IND = 1;
        
        for J = 1:LE1
            I = J;
            INDM = round((IND-1)*1024/N + 1); %������ � ���� ��� ����
            
            while I <= N
                IP = I + LE1;
                T = A(IP) * koef(INDM); %��������� �� ��� ����
                m = m + 1;
                
                A(IP) = A(I) - T; % ������� ��������
                A(I) = A(I) + T; % ������� �������
                a = a + 2;
                
                I = I + LE;
            end
            IND = IND + DIND;
        end
        DIND = round(DIND/2);
    end
    
    Y = A;
end