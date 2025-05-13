function y = myFilterDirectInt(x);

global a;
global b;
global oldx;
global oldy;
global m;


[s t] = size(b);

y=round(x*b(1)/m);
for s=2:t
    y = y + round(oldx(s)*b(s)/m);
    y = y - round(oldy(s)*a(s)/m);
end

oldx(1)=x;
oldy(1)=y;

for s=t:-1:2
    oldx(s)=oldx(s-1);
    oldy(s)=oldy(s-1);
end

