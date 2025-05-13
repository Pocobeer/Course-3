function y = myFilterParallelInt(x)
    global Ai Bi oldx oldy k m
    
    % Инициализация выхода
    y = round(k * x / m);
    
    % Проверка и получение количества секций
    num_sections = size(Ai, 1);
    if num_sections < 1
        return;
    end
    
    % Обработка каждой секции
    for s = 1:num_sections
        % Проверка доступности элементов в Bi и Ai
        if size(Bi, 2) >= 2 && size(Ai, 2) >= 3 && (2*s) <= length(oldy)
            % Расчет временного значения с округлением
            temp = round((x * Bi(s,1) + oldx * Bi(s,2) - ...
                        Ai(s,2) * oldy(2*s-1) - Ai(s,3) * oldy(2*s)) / m);
            
            % Обновление состояний
            oldy(2*s) = oldy(2*s-1);
            oldy(2*s-1) = temp;
            y = y + temp;
        end
    end
    
    % Обновление предыдущего входного значения
    oldx = x;
end