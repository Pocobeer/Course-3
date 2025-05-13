clc
global a;
global m;
a = 0;
m = 0;
N = 960;
N1 = 32;
N2 = 30;
Y  = zeros(N1, N2);
f = 100;
Fd = 1000;
n=0:N-1;

X = sin(2*pi*f*n/Fd);

figure(1)
plot(n, X,'r');
title('Исходный сигнал');
grid on;

% прямое БПФ
figure(2);
%Y1 = kt(X, N1, N2);
Y1 = fft(X);
plot( n, abs(Y1), 'b');
grid on;
title('Прямое БПФ');
% обратное БПФ
figure(3);
Y2 = ifft(Y1);
plot( n, Y2, 'b');
grid on;
title('Обратное БПФ');
%Проверка ДПФ

figure(4);

Fin = alg(X, N1, N2);

plot(n, abs(Fin), 'b', n, abs(Y1), 'r--');
title("ДПФ и Кули-Тьюки");
grid on;

disp('Комплексных сложений:'); a
disp('Комплексных умножений:'); m

