function y = vrem(A, N, INV)
global m;
global a;
M = nextpow2(N);

if INV == 0
    for I = 1:N
        A(I) = conj(A(I));
    end
end

NV2 = round(N/2);
NM1 = N-1;
J = 1;
for I = 1:NM1
    if I < J
        T = A(J);
        A(J) = A(I);
        A(I) = T;
    end
    K = NV2;
    while K < J
        J = J-K;
        K = round(K/2);
    end
    J = J+K;
end
    
for I = 1:120
    t = (2*pi)/120*(I-1);
    KOEF(I) = complex(cos(t),-sin(t));
end
    
DIND = round(N/2);
LE = 1;
for L = 1:M
    LE1 = LE;
    LE = LE*2;
    IND = 1;
    for J = 1:LE1
        I = J;
        INDM = round((IND-1)*120/N+1);
        while I <= N                
            IP = I+LE1;

            T = A(IP)*KOEF(INDM);
            m = m+1;
            A(IP) = A(I)-T;
            A(I) = A(I)+T;
            a = a+2;

            I = I+LE;
        end
        IND = IND+DIND;
    end
DIND = round(DIND/2);
end

if INV == 0
    for I = 1:N
        A(I) = conj(A(I));
        A(I) = A(I)/N;
    end
end

y = A;

end
