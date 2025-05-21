function y = myFilterCanon(x)
    global a;
    global b;
    global oldw;
    
    [s t] = size(b);%t=11
    w = x;
    
    % ��������� �������� ����� (�����������)
    for s = 2:t
        w = w - oldw(s) * a(s);
    end
    
    % ������ ����� (���������)
    y = 0;
    oldw(1) = w;
    
    for s = 1:min(t, length(b))
        y = y + oldw(s) * b(s);
    end
    
    % ���������� ���������
    for s = t:-1:2
        oldw(s) = oldw(s-1);
    end
end