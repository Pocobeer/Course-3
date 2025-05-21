f1 = 300;
f2 = 308;
k0 = 1.21; % Коэффициент для прямоугольного окна
df = 8;
fd = 4096;
T = 8;
N = fd * T; % Количество отсчётов
M = 2^ceil(log2(fd/df * k0)); % Число отсчётов в окне
Sdvig = floor(M - 0.75*M); % Сдвиг между отрезками
V = floor((N - M)/Sdvig); % Количество отрезков
%V = 123;
E = sqrt(1/V) * 100; % Нормированная случайная ошибка
disp(['Нормированная случайная ошибка E = ', num2str(E), '%']);

Td = 1/fd;
t = (0:N-1)*Td;
x = sin(2*pi*f1*t) + sin(2*pi*f2*t) + randn(1,N);
n = 0:N-1;
figure(1);
plot(n, x);
title('Исходный сигнал');

total_mult = V * M; % 1. Умножение на окно

logM = log2(M);
% 2. БПФ:
total_add = 2 * V * M * logM + 2 * V * (M/2) * logM; % Сложения
total_mult = total_mult + 4 * V * (M/2) * logM;      % Умножения

% 3. Квадрат модуля:
total_add = total_add + V * M;    % Сложения
total_mult = total_mult + V * 2*M; % Умножения

% 4. Суммирование:
total_add = total_add + V * (M-1);

% 5. Нормировка:
total_mult = total_mult + M;


% Вычисление периодограммы Уэлча
Pw = zeros(1, M);
xp = zeros(1, M);
w = rectwin(M); % Прямоугольное окно

for p = 1:V
    % Умножение на окно
    for n = 1:M
        xp(n) = w(n) * x((p-1)*Sdvig + n);
        
    end
    
    Pw = Pw + abs(fft(xp)).^2;
end

Pw = Pw / (V * M);

m = 0:M-1;
f = (m/M) * fd;

figure(2);
plot(f, Pw);
xlabel('Частота, Гц');
ylabel('Мощность, дБ');
title('Периодограмма Уэлча (прямоугольное окно, перекрытие 74.8%)');
grid on;

% Вывод информации об операциях
disp(['Общее количество вещественных умножений: ', num2str(total_mult)]);
disp(['Общее количество вещественных сложений: ', num2str(total_add)]);
disp(['Общее количество операций: ', num2str(total_mult + total_add)]);