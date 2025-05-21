f1 = 300;
f2 = 308;
k0 = 1.21; % ����������� ��� �������������� ����
df = 8;
fd = 4096;
T = 8;
N = fd * T; % ���������� ��������
M = 2^ceil(log2(fd/df * k0)); % ����� �������� � ����
Sdvig = floor(M - 0.75*M); % ����� ����� ���������
V = floor((N - M)/Sdvig); % ���������� ��������
%V = 123;
E = sqrt(1/V) * 100; % ������������� ��������� ������
disp(['������������� ��������� ������ E = ', num2str(E), '%']);

Td = 1/fd;
t = (0:N-1)*Td;
x = sin(2*pi*f1*t) + sin(2*pi*f2*t) + randn(1,N);
n = 0:N-1;
figure(1);
plot(n, x);
title('�������� ������');

total_mult = V * M; % 1. ��������� �� ����

logM = log2(M);
% 2. ���:
total_add = 2 * V * M * logM + 2 * V * (M/2) * logM; % ��������
total_mult = total_mult + 4 * V * (M/2) * logM;      % ���������

% 3. ������� ������:
total_add = total_add + V * M;    % ��������
total_mult = total_mult + V * 2*M; % ���������

% 4. ������������:
total_add = total_add + V * (M-1);

% 5. ����������:
total_mult = total_mult + M;


% ���������� ������������� �����
Pw = zeros(1, M);
xp = zeros(1, M);
w = rectwin(M); % ������������� ����

for p = 1:V
    % ��������� �� ����
    for n = 1:M
        xp(n) = w(n) * x((p-1)*Sdvig + n);
        
    end
    
    Pw = Pw + abs(fft(xp)).^2;
end

Pw = Pw / (V * M);

m = 0:M-1;
f = (m/M) * fd;

figure(2);
plot(f, Pw);
xlabel('�������, ��');
ylabel('��������, ��');
title('������������� ����� (������������� ����, ���������� 74.8%)');
grid on;

% ����� ���������� �� ���������
disp(['����� ���������� ������������ ���������: ', num2str(total_mult)]);
disp(['����� ���������� ������������ ��������: ', num2str(total_add)]);
disp(['����� ���������� ��������: ', num2str(total_mult + total_add)]);