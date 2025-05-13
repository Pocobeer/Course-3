function y = myFilterDirect(x);
global a;
global b;
global oldx;
global oldy;
[s t] = size(b);%t=11
y=x*b(1);
for s=2:t
    y = y + oldx(s-1)*b(s);
    y = y - oldy(s-1)*a(s);
end
for s=t-1:-1:2
    oldx(s)=oldx(s-1);
    oldy(s)=oldy(s-1);
end
oldx(1)=x;
oldy(1)=y;
