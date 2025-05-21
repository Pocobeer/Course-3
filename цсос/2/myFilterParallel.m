function y = myFilterParallel(x)
    global Ai;
    global Bi;
    global oldx;
    global oldy;
    global k;
    
    y = k * x;
    
    % Определение количества секций
    [t s] = size(Ai); %t=5
    
    % Обработка каждой секции
    for s = 1:t
       temp = x*Bi(s,1)+oldx*Bi(s,2)-Ai(s,2)*oldy(2*s-1) - Ai(s,3)*oldy(2*s);
        oldy(2*s) = oldy(2*s-1);
        oldy(2*s-1) = temp;
        y = y+temp;
    end
    
    oldx = x;
end