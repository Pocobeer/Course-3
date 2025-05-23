% ����� �������������� �������
% ������� �������������
Fd = 2000;

% �������� ���������;
Rp = 1.2;     % ��������������� � ������ ����������� (��)
Rs = 75;       % ��������� � ������ ����������� (��)

% ������� ������ ����������� (����������� ������)
fp_low = 600;    % ������ ������� ������ ������ �����������
fp_high = 850;   % ������� ������� ������� ������ �����������
fs_low = 650;    % ������ ������� ������ �����������
fs_high = 800;   % ������� ������� ������ �����������

% ��������� �������
fd2 = Fd / 2;
Wp = [fp_low fp_high] / fd2;  % ������ �����������
Ws = [fs_low fs_high] / fd2;  % ������ �����������

% ������ �������
% ��������� ������� ������� � ������� �����
[n, Wn] = ellipord(Wp, Ws, Rp, Rs);
global a;
global b;
[b, a] = ellip(n, Rp, Rs, Wn, 'stop');
disp('���� b:'); b
disp('���� a:'); a

[h,w] = freqz(b,a);
ff = w/pi*fd2;

% �������� ������������ ��� ������ ���� ����������
disp('������������ ���������������� �����:');
global sos
global g
[sos, g] = tf2sos(b, a)

disp('������������ ������������ �����:');
global k;
[r,p,k] = residuez(b,a);
r
p
k
global Ai;
global Bi;

Bi=[];
Ai=[];
for i=1:2:floor(n)*2
    [bi, ai] = residuez(r(i : i+1), p(i : i+1), 0);
    Bi((i+1)/2, :) = bi;
    Ai((i+1)/2, :) = ai;
end
Bi = real(Bi)

% �������� �������
max = 100;
nn = 0:max-1;

%% 1. ������������ ����� (������ ����� II)
figure(1);
sgtitle('������������ ����� (������ ����� II)');

% ���������� ��������������
subplot(3,1,1);
x = eye(1,max);
y = zeros(1,max);
oldw = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterCanon(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('���������� ��������������');

% ����� 300 �� (������ �����������)
subplot(3,1,2);
f = 300;
x = sin(2*pi*(f/Fd)*nn);
y = zeros(1,max);
oldw = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterCanon(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('����� 300 �� (������ �����������)');

% ����������� ������
subplot(3,1,3);
x = ones(1,max);
y = zeros(1,max);
oldw = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterCanon(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('����������� ������');

%% 2. ���������������� ����� (SOS)
figure(2);
sgtitle('���������������� ����� (SOS)');

% ���������� ��������������
subplot(3,1,1);
x = eye(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterSerial(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('���������� ��������������');

% ����� 300 �� (������ �����������)
subplot(3,1,2);
f = 300;
x = sin(2*pi*(f/Fd)*nn);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterSerial(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('����� 300 �� (������ �����������)');

% ����������� ������
subplot(3,1,3);
x = ones(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterSerial(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('����������� ������');

%% 3. ������������ �����
figure(3);
sgtitle('������������ �����');
[t, s] = size(Ai);

% ���������� ��������������
subplot(3,1,1);
x = eye(1,max);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallel(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('���������� ��������������');

% ����� 300 �� (������ �����������)
subplot(3,1,2);
f = 300;
x = sin(2*pi*(f/Fd)*nn);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallel(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('����� 300 �� (������ �����������)');

% ����������� ������
subplot(3,1,3);
x = ones(1,max);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallel(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('����������� ������');

%% 4. ������ ����� I
figure(4);
sgtitle('������ ����� I');

% ���������� ��������������
subplot(3,1,1);
x = eye(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterDirect(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('���������� ��������������');

% ����� 300 �� (������ �����������)
subplot(3,1,2);
f = 300;
x = sin(2*pi*(f/Fd)*nn);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterDirect(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('����� 300 �� (������ �����������)');

% ����������� ������
subplot(3,1,3);
x = ones(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterDirect(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('����', '�����');
title('����������� ������');

%% ������������� ����������
m = 1024;
sos_int = round(m*sos);
g_int = round(m*g);
Ai_int = round(m*Ai);
Bi_int = round(m*Bi);
k_int = round(m*k);
a_int = round(m*a);
b_int = round(m*b);

%% 5. ���������������� ����� (�������������)
figure(5);
sgtitle('���������������� ����� (�������������, m=1024)');

% ���������� ��������������
subplot(3,1,1);
x_int = m * eye(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b_int));
oldy = zeros(1, length(b_int));
for temp = 1:max
    y(temp) = myFilterSerialInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('����', '�����');
title('���������� ��������������');

% ����� 300 �� (������ �����������)
subplot(3,1,2);
f = 300;
x = sin(2*pi*(f/Fd)*nn);
x_int = round(m*x);
y = zeros(1,max);
oldx = zeros(1, length(b_int));
oldy = zeros(1, length(b_int));
for temp = 1:max
    y(temp) = myFilterSerialInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('����', '�����');
title('����� 300 �� (������ �����������)');

% ����������� ������
subplot(3,1,3);
x_int = m * ones(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b_int));
oldy = zeros(1, length(b_int));
for temp = 1:max
    y(temp) = myFilterSerialInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('����', '�����');
title('����������� ������');

%% 6. ������������ ����� (�������������)
figure(6);
sgtitle('������������ ����� (�������������, m=1024)');
[t, s] = size(Ai_int);

% ���������� ��������������
subplot(3,1,1);
x_int = m * eye(1,max);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallelInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('����', '�����');
title('���������� ��������������');

% ����� 300 �� (������ �����������)
subplot(3,1,2);
f = 300;
x = sin(2*pi*(f/Fd)*nn);
x_int = round(m*x);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallelInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('����', '�����');
title('����� 300 �� (������ �����������)');

% ����������� ������
subplot(3,1,3);
x_int = m * ones(1,max);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallelInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('����', '�����');
title('����������� ������');