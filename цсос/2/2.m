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

Bi=[ ; ];
Ai =[ ; ];
for i=1:2:floor(n)*2
    [bi ai] = residuez(r(i : i+1), p(i : i+1), 0);
    Bi((i+1)/2, :) = bi;
    Ai((i+1)/2, :) = ai;
end
Bi = real(Bi)

% ������������ �������
f = 280;
max = 30;
nn=0:max-1;
% ���������
x = eye(1,max);
% �����������;
x1 = ones(1,max);
% ��������������
x2 = sin(2*pi*f*nn/Fd);
y = filter(b,a,x);

[s t] = size(b);
global oldx;
global oldy;

% ������ ����� (float)
oldx = zeros(1,t);
oldy = zeros(1,t);
yd = zeros(1,max);
yd1 = zeros(1,max);
yd2 = zeros(1,max);
for temp=1:max
    yd(temp) = myFilterDirect(x(temp));
end
oldx = zeros(1,t);
oldy=zeros(1,t);
for temp=1:max
    yd1(temp) = myFilterDirect(x1(temp));
end
oldx = zeros(1,t);
oldy=zeros(1,t);
for temp=1:max
    yd2(temp) = myFilterDirect(x2(temp));
end

figure(10)
subplot(2,3,1);
plot(nn,yd);
title('������� �� ��������� �������')
subplot(2,3,2);
plot(nn,yd1);
title('������� �� ��������� ����������� ������')
subplot(2,3,3)
plot(nn,x2,'r',nn,yd2,'g');
title('������� �� �������������� ������')

% ������������ ����� (float)
oldw = zeros(1,t);
yc = zeros(1,max);
yc1 = zeros(1,max);
yc2 = zeros(1,max);
for temp=1:max
    yc(temp) = myFilterCanon(x(temp));
end
oldw=zeros(1,t);
for temp=1:max
    yc1(temp) = myFilterCanon(x1(temp));
end
oldw=zeros(1,t);
for temp=1:max
    yc2(temp) = myFilterCanon(x2(temp));
end

figure(11)
subplot(2,3,1);
plot(nn,yc);
title('������� �� ��������� �������')
subplot(2,3,2);
plot(nn,yc1);
title('������� �� ��������� ����������� ������')
subplot(2,3,3)
plot(nn,x2,'r',nn,yc2,'g');
title('������� �� �������������� ������')

% ������������ ����� (float)
oldx = 0;
oldy = zeros(1,2*t);
yP = zeros(1,max);
yP1 = zeros(1,max);
yP2 = zeros(1,max);
for temp=1:max
    yP(temp) = myFilterParallel(x(temp));
end
oldx = 0;
oldy=zeros(1,2*t);
for temp=1:max
    yP1(temp) = myFilterParallel(x1(temp));
end
oldx = 0;
oldy=zeros(1,2*t);
for temp=1:max
    yP2(temp) = myFilterParallel(x2(temp));
end

figure(12)
subplot(2,3,1);
plot(nn,yP);
title('������� �� ��������� �������')
subplot(2,3,2);
plot(nn,yP1);
title('������� �� ��������� ����������� ������')
subplot(2,3,3)
plot(nn,x2,'r',nn,yP2,'g');
title('������� �� �������������� ������')

% ���������������� ����� (float)
oldx = zeros(1,t);
oldy = zeros(1,t);
yS = zeros(1,max);
yS1 = zeros(1,max);
yS2 = zeros(1,max);
for temp=1:max
    yS(temp) = myFilterSerial(x(temp));
end
oldx = zeros(1,t);
oldy=zeros(1,t);
for temp=1:max
    yS1(temp) = myFilterSerial(x1(temp));
end
oldx = zeros(1,t);
oldy=zeros(1,t);
for temp=1:max
    yS2(temp) = myFilterSerial(x2(temp));
end

figure(13)
subplot(2,3,1);
plot(nn,yS);
title('������� �� ��������� �������')
subplot(2,3,2);
plot(nn,yS1);
title('������� �� ��������� ����������� ������')
subplot(2,3,3)
plot(nn,x2,'r',nn,yS2,'g');
title('������� �� �������������� ������')

% ������������� ����������
global m;
m = 2048;

% ������ ����� (int)
a_int = round(a .* m);
b_int = round(b .* m);
oldw = zeros(1,t);
x_int = round(x .* m);
x1_int = round(x1 .*m);
x2_int = round(x2 .* m);
oldx = zeros(1,t);
oldy=zeros(1,t);
ydi = zeros(1,max);
yd1i = zeros(1,max);
yd2i = zeros(1,max);
for temp=1:max
    ydi(temp) = myFilterDirectInt(x_int(temp));
end
oldx = zeros(1,t);
oldy=zeros(1,t);
for temp=1:max
    yd1i(temp) = myFilterDirectInt(x1_int(temp));
end
oldx = zeros(1,t);
oldy=zeros(1,t);
for temp=1:max
    yd2i(temp) = myFilterDirectInt(x2_int(temp));
end

figure(10)
subplot(2,3,4);
plot(nn,ydi);
title('������� �� ��������� ������� (Int)')
subplot(2,3,5);
plot(nn,yd1i);
title('������� �� ��������� ����������� ������ (Int)')
subplot(2,3,6)
plot(nn,x2,'r',nn,yd2i,'g');
title('������� �� �������������� ������ (Int)')

% ������������ ����� (int)
oldw =zeros(1,t);
yci = zeros(1,max);
yc1i = zeros(1,max);
yc2i = zeros(1,max);
for temp=1:max
    yci(temp) = myFilterCanonInt(x_int(temp));
end
oldw = zeros(1,t);
for temp=1:max
    yc1i(temp) = myFilterCanonInt(x1_int(temp));
end
oldw = zeros(1,t);
for temp=1:max
    yc2i(temp) = myFilterCanonInt(x2_int(temp));
end

figure(11)
subplot(2,3,4);
plot(nn,yci);
title('������� �� ��������� ������� (Int)')
subplot(2,3,5);
plot(nn,yc1i);
title('������� �� ��������� ����������� ������ (Int)')
subplot(2,3,6)
plot(nn,x2,'r',nn,yc2i,'g');
title('������� �� �������������� ������ (Int)')

% ������������ ����� (int)
sos_int = round(m.*sos);
g_int = round(m.*g);
Bi_int=real(Bi);
Ai_int = round(m.*Ai);
Bi_int = round(m.*Bi);
k_int = round(k.*m);
oldx = 0;
oldy = zeros(1,t);
yPi = zeros(1,max);
yP1i = zeros(1,max);
yP2i = zeros(1,max);
for temp=1:max
    yPi(temp) = myFilterParallelInt(x_int(temp));
end
oldx = 0;
oldy=zeros(1,t);
for temp=1:max
    yP1i(temp) = myFilterParallelInt(x1_int(temp));
end
oldx = 0;
oldy=zeros(1,t);
for temp=1:max
    yP2i(temp) = myFilterParallelInt(x2_int(temp));
end

figure(12)
subplot(2,3,4);
plot(nn,yPi);
title('������� �� ��������� ������� (Int)')
subplot(2,3,5);
plot(nn,yP1i);
title('������� �� ��������� ����������� ������ (Int)')
subplot(2,3,6)
plot(nn,x2,'r',nn,yP2i,'g');
title('������� �� �������������� ������ (Int)')

% ���������������� ����� (int)
oldx = zeros(1,t);
oldy = zeros(1,t);
ySi = zeros(1,max);
for temp=1:max
    ySi(temp) = myFilterSerialInt(x_int(temp));
end
oldx = zeros(1,t);
oldy = zeros(1,t);
yS1i = zeros(1,max);
yS2i = zeros(1,max);
for temp=1:max
    ySi(temp) = myFilterSerialInt(x_int(temp));
end
oldx = zeros(1,t);
oldy=zeros(1,t);
for temp=1:max
    yS1i(temp) = myFilterSerialInt(x1_int(temp));
end
oldx = zeros(1,t);
oldy=zeros(1,t);
for temp=1:max
    yS2i(temp) = myFilterSerialInt(x2_int(temp));
end

figure(13)
subplot(2,3,4);
plot(nn,ySi);
title('������� �� ��������� ������� (Int)')
subplot(2,3,5);
plot(nn,yS1i);
title('������� �� ��������� ����������� ������ (Int)')
subplot(2,3,6)
plot(nn,x2,'r',nn,yS2i,'g');
title('������� �� �������������� ������ (Int)')