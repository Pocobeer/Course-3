function y = myFilterCanon(x)
    global a;
    global b;
    global oldw;
    
    [~, t] = size(b); % Получаем размер коэффициентов
    w = x;
    
    % Обработка обратной связи (знаменатель)
    for s = 2:t
        if s <= length(oldw) && s <= length(a)
            w = w - oldw(s) * a(s);
        end
    end
    
    % Прямая часть (числитель)
    y = 0;
    oldw(1) = w;
    
    for s = 1:min(t, length(b))
        if s <= length(oldw)
            y = y + oldw(s) * b(s);
        end
    end
    
    % Обновление состояний
    for s = t:-1:2
        if (s-1) <= length(oldw)
            oldw(s) = oldw(s-1);
        end
    end
end