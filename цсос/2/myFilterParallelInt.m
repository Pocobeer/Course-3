function y = myFilterParallelInt(x)
    global Ai Bi oldx oldy k m
    
    % Инициализация выхода
    y = round(k * x / m);
    
    % Проверка и получение количества секций
    [t s] = size(Ai);
    
    % Обработка каждой секции
    for s = t
        temp = round((x*Bi(s,1)+oldx*Bi(s,2)-Ai(s,2)*oldy(2*s-1) - Ai(s,3)*oldy(2*s))/m);
        oldy(2*s) = oldy(2*s-1);
        oldy(2*s-1) = temp;
        y = y+temp;
    end
    
    % Обновление предыдущего входного значения
    oldx = x;
end