function y = myFilterSerial(x);
global oldx;
global oldy;
global sos;
global g;
y = g*x;
[t s] = size(sos);
for s = 1:t
    temp = y*sos(s,1)+oldx(2*s-1)*sos(s,2) + oldx(2*s)*sos(s,3)-sos(s,5)*oldy(2*s-1) - sos(s,6)*oldy(2*s);
    oldy(2*s) = oldy(2*s-1);
    oldy(2*s-1) = temp;
    oldx(2*s) = oldx(2*s-1);
    oldx(2*s-1) = y;
    y = temp;
end
