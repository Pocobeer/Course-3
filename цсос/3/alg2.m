function Y = alg2(X,N1,N2)
global a;
global m;

N = N1*N2;

Y = zeros(N1, N2);
    % Отобразим двойную последовательность в двумерную таблицу
for i = 1 : N1
    for j = 1 : N2
        Y(i, j) = X((i - 1) * N2 + j);
    end
end

% Вычислим ДПФ для 5
for j = 1 : N2
    Y(:, j) = opred(Y(:, j),N1); 
end

% Поэлементное умножение всех элементов таблицы на поворачивающий множитель
% (N умножений)
for i = 1 : N1
     for j = 1 : N2
        Y(i, j) = Y(i, j) * exp(-1i * 2 * pi * (i - 1) * (j - 1) / N);
        m = m + 1;
     end
end

%ДПФ каждой строки по 3
for i = 1 : N1
    Y(i, :) = opred(Y(i, :),N2);
end

X = zeros(1, N);
for i = 1 : N2
     for j = 1 : N1
        X((i - 1) * N1 + j) = Y(j, i);
     end
end

Y = X;
end