function y = myFilterCanonInt(x);

global a;
global b;
global oldx;
global oldy;
global oldw;
global m;

[s t] = size(b);%t=12

w=x;
for s=2:t
    w = w - round(oldw(s)*a(s)/m);
end
oldw(1)=w;
y=0;
for s=1:t
    y = y + round(oldw(s)*b(s)/m);
end

%oldx(1)=x;
%oldy(1)=y;
for s=t:-1:2
    %oldx(s)=oldx(s-1);
    %oldy(s)=oldy(s-1);
    oldw(s)=oldw(s-1);
end
