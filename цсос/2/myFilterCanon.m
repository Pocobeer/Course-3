function y = myFilterCanon(x);
global a;
global b;
global oldw;
[s t] = size(b);
w=x;
for s=2:t
w = w - oldw(s-1)*a(s);
end
for s=t:-1:2
oldw(s)=oldw(s-1);
end
oldw(1)=w;
y=0;
for s=1:t
y = y + oldw(s)*b(s);
end
end
