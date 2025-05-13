function y = myFilterParallel(x)
    global Ai;
    global Bi;
    global oldx;
    global oldy;
    global k;
    
    % �������� � ������������� �������������
    if isempty(k)
        k = 0;
    end
    y = k * x;
    
    % ����������� ���������� ������
    [num_sections, ~] = size(Ai);
    
    % ��������� ������ ������
    for s = 1:num_sections
        % �������� ������� ������������ ���������� �������������
        if size(Bi, 2) >= 2 && size(Ai, 2) >= 3
            temp = x * Bi(s, 1) + oldx * Bi(s, 2) - Ai(s, 2) * oldy(2*s-1) - Ai(s, 3) * oldy(2*s);
            
            % ���������� ���������
            if 2*s <= length(oldy)
                oldy(2*s) = oldy(2*s-1);
                oldy(2*s-1) = temp;
                y = y + temp;
            end
        end
    end
    
    oldx = x;
end