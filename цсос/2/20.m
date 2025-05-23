% Задаём характеристики фильтра
% Частота дискретизации
Fd = 2000;

% Величины затуханий;
Rp = 1.2;     % неравномерность в полосе пропускания (дБ)
Rs = 75;       % затухание в полосе заграждения (дБ)

% Границы полосы заграждения (режекторный фильтр)
fp_low = 600;    % Нижняя граница нижней полосы пропускания
fp_high = 850;   % Верхняя граница верхней полосы пропускания
fs_low = 650;    % Нижняя граница полосы заграждения
fs_high = 800;   % Верхняя граница полосы заграждения

% Нормируем частоты
fd2 = Fd / 2;
Wp = [fp_low fp_high] / fd2;  % Полосы пропускания
Ws = [fs_low fs_high] / fd2;  % Полоса заграждения

% Расчёт фильтра
% Вычисляем порядок фильтра и частоту среза
[n, Wn] = ellipord(Wp, Ws, Rp, Rs);
global a;
global b;
[b, a] = ellip(n, Rp, Rs, Wn, 'stop');
disp('Коэф b:'); b
disp('Коэф a:'); a

[h,w] = freqz(b,a);
ff = w/pi*fd2;

% Получаем коэффициенты для разных форм реализации
disp('Коэффициенты последовательной формы:');
global sos
global g
[sos, g] = tf2sos(b, a)

disp('Коэффициенты параллельной формы:');
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

% Тестовые сигналы
max = 100;
nn = 0:max-1;

%% 1. Каноническая форма (прямая форма II)
figure(1);
sgtitle('Каноническая форма (прямая форма II)');

% Импульсная характеристика
subplot(3,1,1);
x = eye(1,max);
y = zeros(1,max);
oldw = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterCanon(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Импульсная характеристика');

% Синус 300 Гц (полоса пропускания)
subplot(3,1,2);
f = 300;
x = sin(2*pi*(f/Fd)*nn);
y = zeros(1,max);
oldw = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterCanon(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Синус 300 Гц (полоса пропускания)');

% Ступенчатый сигнал
subplot(3,1,3);
x = ones(1,max);
y = zeros(1,max);
oldw = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterCanon(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Ступенчатый сигнал');

%% 2. Последовательная форма (SOS)
figure(2);
sgtitle('Последовательная форма (SOS)');

% Импульсная характеристика
subplot(3,1,1);
x = eye(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterSerial(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Импульсная характеристика');

% Синус 300 Гц (полоса пропускания)
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
legend('Вход', 'Выход');
title('Синус 300 Гц (полоса пропускания)');

% Ступенчатый сигнал
subplot(3,1,3);
x = ones(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterSerial(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Ступенчатый сигнал');

%% 3. Параллельная форма
figure(3);
sgtitle('Параллельная форма');
[t, s] = size(Ai);

% Импульсная характеристика
subplot(3,1,1);
x = eye(1,max);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallel(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Импульсная характеристика');

% Синус 300 Гц (полоса пропускания)
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
legend('Вход', 'Выход');
title('Синус 300 Гц (полоса пропускания)');

% Ступенчатый сигнал
subplot(3,1,3);
x = ones(1,max);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallel(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Ступенчатый сигнал');

%% 4. Прямая форма I
figure(4);
sgtitle('Прямая форма I');

% Импульсная характеристика
subplot(3,1,1);
x = eye(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterDirect(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Импульсная характеристика');

% Синус 300 Гц (полоса пропускания)
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
legend('Вход', 'Выход');
title('Синус 300 Гц (полоса пропускания)');

% Ступенчатый сигнал
subplot(3,1,3);
x = ones(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b));
oldy = zeros(1, length(b));
for temp = 1:max
    y(temp) = myFilterDirect(x(temp));
end
plot(nn, x, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Ступенчатый сигнал');

%% Целочисленные реализации
m = 1024;
sos_int = round(m*sos);
g_int = round(m*g);
Ai_int = round(m*Ai);
Bi_int = round(m*Bi);
k_int = round(m*k);
a_int = round(m*a);
b_int = round(m*b);

%% 5. Последовательная форма (целочисленная)
figure(5);
sgtitle('Последовательная форма (целочисленная, m=1024)');

% Импульсная характеристика
subplot(3,1,1);
x_int = m * eye(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b_int));
oldy = zeros(1, length(b_int));
for temp = 1:max
    y(temp) = myFilterSerialInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Импульсная характеристика');

% Синус 300 Гц (полоса пропускания)
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
legend('Вход', 'Выход');
title('Синус 300 Гц (полоса пропускания)');

% Ступенчатый сигнал
subplot(3,1,3);
x_int = m * ones(1,max);
y = zeros(1,max);
oldx = zeros(1, length(b_int));
oldy = zeros(1, length(b_int));
for temp = 1:max
    y(temp) = myFilterSerialInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Ступенчатый сигнал');

%% 6. Параллельная форма (целочисленная)
figure(6);
sgtitle('Параллельная форма (целочисленная, m=1024)');
[t, s] = size(Ai_int);

% Импульсная характеристика
subplot(3,1,1);
x_int = m * eye(1,max);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallelInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Импульсная характеристика');

% Синус 300 Гц (полоса пропускания)
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
legend('Вход', 'Выход');
title('Синус 300 Гц (полоса пропускания)');

% Ступенчатый сигнал
subplot(3,1,3);
x_int = m * ones(1,max);
y = zeros(1,max);
oldx = 0;
oldy = zeros(1, 2*t);
for temp = 1:max
    y(temp) = myFilterParallelInt(x_int(temp));
end
plot(nn, x_int, 'r', nn, y, 'g');
legend('Вход', 'Выход');
title('Ступенчатый сигнал');