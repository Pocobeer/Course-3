%часть 1
global b; 
global a;
global n;
global Wn;
global oldx;
global oldy;
global oldw;
global k;
global m;
global Ai;
global Bi;
global g;
global sos;
% Задаём характеристики фильтра
% частота дискретизации
Fd = 2000;
% частоты среза полосы пропускания и
% полосы непропускания
fp = [600 850];
fs = [650 800];
% величины затуханий
Rp = 1.2;
Rs = 75;
% Нормализуем частоты
fd2 = Fd / 2;
Wp = fp / fd2;
Ws = fs / fd2;
% Расчёт фильтра
% Вычисляем порядок фильтра и частоту среза
[n, Wn] = ellipord(Wp,Ws,Rp,Rs);
% Вычисляем коэффициенты фильтра
[b,a]=ellip(n,Rp,Rs,Wn,'stop');
disp('Коэффициенты b:');
b
disp('Коэффициенты a:');
a
% Построение частотных характеристик
% Вычисляем частотную характеристику
[h,w]=freqz(b,a);
% Задаем сетку частот
ff = w/pi*fd2;
% Построение АЧХ
%figure(1)
%plot(ff, abs(h));
%title('Amplitude frequency characteristic');
%xlabel('Frequency');
%ylabel('Amplitude');
% Построение ФЧХ
%figure(2)
%plot(ff, unwrap(angle(h)));
%title('Phase frequency characteristic');
%xlabel('Frequency');
%ylabel('Phase');
% Построение ЛАЧХ
%figure(3)
%plot(ff, 20 * log10(abs(h)));
%title('Logarithmic amplitude frequency characteristic');
%xlabel('Frequency');
%ylabel('Amplitude');
%grid on;
% Построение групповой задержки
%figure(4)
gd = grpdelay(b, a);
%plot(ff, gd);
%xlabel('Frequency');
%ylabel('delay');
%title('Group delay');
% Построение импульсной и временной характеристик
% Импульсная характеристика
%figure(5)
test1=impz(b,a,100);
%plot(0:99,test1);
% Временная характеристика
step_signal = ones(1, 200); % Создаем ступенчатый сигнал [1, 1, ..., 1]
%figure(6);
%plot(0:199,filter(b, a, ones(1, 200)));
% Вычисление и построение реакции фильтра
% на синусоидальный сигнал в полосе пропускания
% и непропускания
% а) в полосе пропускания
nn = (0:99);
f1 = 300;
x1 = sin(2*pi*f1*nn/Fd);
y1 = filter(b, a, x1);
%figure(7)
%plot(nn,x1,nn,y1);
%title('The bandwidth of the sinusoid');
% б) в полосе непропускания
f2 = 700;
x1 = sin(2*pi*f2*nn/Fd);
y1 = filter(b, a, x1);
%figure(8)
%plot(nn,x1,nn,y1);
%title('The band nontransmitting sinusoid');
% Получаем коэффициенты последовательной и параллельной % форм реализации фильтра
% Построение последовательной формы фильтра
disp('Коэффициенты последовательной формы:')
[sos, g] = tf2sos(b,a);
% Построение параллельной формы фильтра
disp('Коэффициенты последовательной формы:')
[r p k] = residuez(b, a);

r([14 1]) = r([1 14]);
p([14 1]) = p([1 14]);
r([11 2]) = r([2 11]);
p([11 2]) = p([2 11]);
r([13 11]) = r([11 13]);
p([13 11]) = p([11 13]);

Bi=[ ; ];
Ai =[ ; ];
for i = 1: 2: floor(n)*2
	[bi ai] = residuez(r(i : i+1), p(i : i+1), 0);
	Bi((i+1)/2, :) = bi;
	Ai((i+1)/2, :) = ai;
end
disp('Ai:')
Ai
disp('Bi:')
Bi

testImp = impz(b,a,100);
testStep = stepz(b,a,100);
testXPass = sin(2*pi*(300/Fd)*nn);

max = 100;
nn=0:max-1;
x = eye(1,100);
[s t] = size(b);
oldw = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterCanon(x(temp));
end
figure(9);
subplot(3, 1, 1);
plot(nn,x,'r',nn,y,'g',nn,testImp,'k--');

%Реакция на синусоидальный сигнал в полосе пропускания
f = 300;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);

%%Каноническая форма
[s t] = size(b);
oldw = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterCanon(x(temp));
end
%figure(10);
subplot(3, 1, 2);
plot(nn,x,'r',nn,y,'g',nn,testXPass,'k--');
% Единичный ступенчатый сигнал
x = ones(1,100);
[s t] = size(b);
oldw = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterCanon(x(temp));
end
%figure(11);
subplot(3, 1, 3);
plot(nn,x,'r',nn,y,'g',nn,testStep,'k--');

max = 100;
nn=0:max-1;
x = eye(1,100);
%%Последовательная форма
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
%Импульсная характеристика
for temp=1:max
y(temp) = myFilterSerial(x(temp));
end
figure(12);
subplot(3, 1, 1);
plot(nn,x,'r',nn,y,'g',nn,testImp,'k--');
f = 300;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);

%Реакция на синус в полосе пропускания
[s t] = size(b);
oldx = zeros(1,t);111
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterSerial(x(temp));
end
%figure(13);
subplot(3, 1, 2);
plot(nn,x,'r',nn,y,'g',nn,testXPass,'k--');
% Единичный ступенчатый сигнал
x = ones(1,100);
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterSerial(x(temp));
end
%figure(14);
subplot(3, 1, 3);
plot(nn,x,'r',nn,y,'g',nn,testStep,'k--');

max = 100;
nn=0:max-1;
x = eye(1,100);
%%Параллельная форма
[t s] = size(Ai);
oldx = 0;
oldy = zeros(1,2*t);
%Импульсная характеристика
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterParallel(x(temp));
end
figure(15);
subplot(3, 1, 1);
plot(nn,x,'r',nn,y,'g',nn,testImp,'k--');

%Реакция на синусоидальный сигнал в полосе пропускания
f = 300;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);
[t s] = size(Ai);
oldx = 0;
oldy = zeros(1,2*t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterParallel(x(temp));
end
%figure(16);
subplot(3, 1, 2);
plot(nn,x,'r',nn,y,'g',nn,testXPass,'k--');
% Единичный ступенчатый сигнал
x = ones(1,100);
[t s] = size(Ai);
oldx = 0;
oldy = zeros(1,2*t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterParallel(x(temp));
end
%figure(17);
subplot(3, 1, 3);
plot(nn,x,'r',nn,y,'g',nn,testStep,'k--');

max = 100;
nn=0:max-1;
x = eye(1,100);
%%Прямая форма
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
%импульсная хар-ка
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterDirect(x(temp));
end
figure(18);
subplot(3, 1, 1);
plot(nn,x,'r',nn,y,'g',nn,testImp,'k--');

%Реакция на синусоидальный сигнал в полосе пропускания
f = 300;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);

[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterDirect(x(temp));
end
%figure(19);
subplot(3, 1, 2);
plot(nn,x,'r',nn,y,'g',nn,testXPass,'k--');
% Единичный ступенчатый сигнал
x = ones(1,100);
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterDirect(x(temp));
end
%figure(20);
subplot(3, 1, 3);
plot(nn,x,'r',nn,y,'g',nn,testStep,'k--');

max = 100;
nn=0:max-1;


%testXStop = sin(2*pi*(700/Fd)*nn);
testSinPass = filter(b,a,testXPass);
%testSinStop = filter(b,a,testXStop);

%m=32;
m=1024
%m=65536;
sos = round(m*sos);
g = round(m*g);
Ai = round(m*Ai);
Bi = round(m*Bi);
k = round(m*k);
a = round(m*a);
b = round(m*b);


x = eye(1,100);
x_int=m*x;

% параллельная форма
[s t] = size(Ai);
oldx = 0;
oldy = zeros(1,2*s);
y = zeros(1,max);

for temp=1:max
y(temp) = myFilterParallelInt(x_int(temp));
end
figure(21);
subplot(3, 1, 1);
plot(nn,x_int,'r',nn,y,'g',nn,testImp*m,'k--');

%max = 100;
%nn=0:max-1;
% Синусоидальный сигнал (полоса пропускания)
f = 300;
x=sin(2*pi*(f/Fd)*nn);
x_int=round(m*x);
% параллельная форма
oldx = 0;
[s t] = size(Ai);
oldy = zeros(1,2*s);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterParallelInt(x_int(temp));
end
%figure(22);
subplot(3, 1, 2);
plot(nn,x_int,'r',nn,y,'g',nn,testSinPass*m,'k--');

% Синусоидальный сигнал (полоса непропускания)
f = 700;
x=sin(2*pi*(f/Fd)*nn);
x_int=round(m*x);
% параллельная форма
oldx = 0;
[s t] = size(Ai);
oldy = zeros(1,2*s);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterParallelInt(x_int(temp));
end
%figure(23);
%subplot(3, 1, 3);
%plot(nn,x_int,'r',nn,y,'g',nn,testSinStop*m,'b');

% Единичный ступенчатый сигнал
x = ones(1,100);
x_int = m*x;
% параллельная форма
oldx = 0;
[s t] = size(Ai);
oldy = zeros(1,2*s);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterParallelInt(x_int(temp));
end
%figure(24);
subplot(3, 1, 3);
plot(nn,x_int,'r',nn,y,'g',nn,testStep*m,'k--');

%последовательная форма
x = eye(1,100);	
x_int=m*x;
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterSerialInt(x_int(temp));
end
figure(25);
subplot(3, 1, 1);
plot(nn,x_int,'r',nn,y,'g',nn,testImp*m,'k--');
%Реакция на синусоидальный сигнал
f = 300;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);
x_int=round(x*m);
%Последовательная форма
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterSerialInt(x_int(temp));
end
%figure(26);
subplot(3, 1, 2);
plot(nn,x_int,'r',nn,y,'g',nn,testSinPass*m,'k--');

f = 700;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);
x_int=round(x*m);
%Последовательная форма
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterSerialInt(x_int(temp));
end
%figure(27);
%subplot(3, 1, 3);
%plot(nn,x_int,'r',nn,y,'g',nn,testSinStop*m,'b');

x = ones(1,100);
x_int=x*m;
%Последовательная форма
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterSerialInt(x(temp));
end
%figure(28);
subplot(3, 1, 3);
plot(nn,x_int,'r',nn,y,'g',nn,testStep*m,'k--');




%каноническая форма
x = eye(1,100);	
x_int=m*x;
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterCanonInt(x_int(temp));
end
figure(26);
subplot(3, 1, 1);
plot(nn,x_int,'r',nn,y,'g',nn,testImp*m,'k--');
%Реакция на синусоидальный сигнал
f = 300;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);
x_int=round(x*m);
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterCanonInt(x_int(temp));
end
%figure(26);
subplot(3, 1, 2);
plot(nn,x_int,'r',nn,y,'g',nn,testSinPass*m,'k--');

f = 700;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);
x_int=round(x*m);
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
%y = zeros(1,max);
%for temp=1:max
%y(temp) = myFilterCanonInt(x_int(temp));
%end
%figure(27);
%subplot(3, 1, 3);
%plot(nn,x_int,'r',nn,y,'g',nn,testSinStop*m,'b');

x = ones(1,100);
x_int=x*m;
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterCanonInt(x(temp));
end
subplot(3, 1, 3);
plot(nn,x_int,'r',nn,y,'g',nn,testStep*m,'k--');


%Прямая форма
x = eye(1,100);	
x_int=m*x;
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterDirectInt(x_int(temp));
end
figure(27);
subplot(3, 1, 1);
plot(nn,x_int,'r',nn,y,'g',nn,testImp*m,'k--');
%Реакция на синусоидальный сигнал
f = 300;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);
x_int=round(x*m);
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterDirectInt(x_int(temp));
end
%figure(26);
subplot(3, 1, 2);
plot(nn,x_int,'r',nn,y,'g',nn,testSinPass*m,'k--');

f = 700;
max = 100;
nn=0:max-1;
x=sin(2*pi*(f/Fd)*nn);
x_int=round(x*m);
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
%y = zeros(1,max);
%for temp=1:max
%y(temp) = myFilterCanonInt(x_int(temp));
%end
%figure(27);
%subplot(3, 1, 3);
%plot(nn,x_int,'r',nn,y,'g',nn,testSinStop*m,'b');

x = ones(1,100);
x_int=x*m;
[s t] = size(b);
oldx = zeros(1,t);
oldy = zeros(1,t);
y = zeros(1,max);
for temp=1:max
y(temp) = myFilterDirectInt(x(temp));
end
subplot(3, 1, 3);
plot(nn,x_int,'r',nn,y,'g',nn,testStep*m,'k--');