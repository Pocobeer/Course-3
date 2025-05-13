function y = myFilterParallelInt(x)
    global Ai Bi oldx oldy k m
    
    % ������������� ������
    y = round(k * x / m);
    
    % �������� � ��������� ���������� ������
    num_sections = size(Ai, 1);
    if num_sections < 1
        return;
    end
    
    % ��������� ������ ������
    for s = 1:num_sections
        % �������� ����������� ��������� � Bi � Ai
        if size(Bi, 2) >= 2 && size(Ai, 2) >= 3 && (2*s) <= length(oldy)
            % ������ ���������� �������� � �����������
            temp = round((x * Bi(s,1) + oldx * Bi(s,2) - ...
                        Ai(s,2) * oldy(2*s-1) - Ai(s,3) * oldy(2*s)) / m);
            
            % ���������� ���������
            oldy(2*s) = oldy(2*s-1);
            oldy(2*s-1) = temp;
            y = y + temp;
        end
    end
    
    % ���������� ����������� �������� ��������
    oldx = x;
end