% ��������� �������
fd = 2000; rp = 1.2; rs = 75;
fp = [600, 850]; fs = [650, 800];

% 1. ������ ������������� (������������� �����������)
[n, Wn] = ellipord(fp/(fd/2), fs/(fd/2), rp, rs);
[b, a] = ellip(n, rp, rs, Wn, 'stop');

% 2. ������������� ����� (16 ���)
scale = 2^14;
b_fix = double(int16(b * scale))/scale; % ����������� ������� � double
a_fix = double(int16(a * scale))/scale;

% 3. ����� ����������
% ������/������������ - ���������� ������������
[sos, ~] = tf2sos(b, a); % ����������������
sos_fix = tf2sos(b_fix, a_fix); % ������ ��������, �.�. double

% ������������
[r, p, ~] = residuez(b, a);
[r_fix, p_fix, ~] = residuez(b_fix, a_fix);

% 4. ������� ��� �������
N = 100; t = (0:N-1)/fd;
sig = struct('impulse', [1 zeros(1,N-1)], ...
             'step', ones(1,N), ...
             'sine', sin(2*pi*700*t));

%% 1. ������ �����
figure('Name','������ �����','Position',[100 100 800 600]);
plot_comparison(1:N, filter(b,a,sig.impulse), filter(b_fix,a_fix,sig.impulse), '�������');
plot_comparison(1:N, filter(b,a,sig.step), filter(b_fix,a_fix,sig.step), '�������');
plot_comparison(t, filter(b,a,sig.sine), filter(b_fix,a_fix,sig.sine), '�����', true);

%% 2. ������������ ����� (���������� ������)
figure('Name','������������ �����','Position',[150 150 800 600]);
plot_comparison(1:N, filter(b,a,sig.impulse), filter(b_fix,a_fix,sig.impulse), '�������');
plot_comparison(1:N, filter(b,a,sig.step), filter(b_fix,a_fix,sig.step), '�������');
plot_comparison(t, filter(b,a,sig.sine), filter(b_fix,a_fix,sig.sine), '�����', true);

%% 3. ���������������� �����
figure('Name','���������������� �����','Position',[200 200 800 600]);
plot_comparison(1:N, sosfilt(sos,sig.impulse), sosfilt(sos_fix,sig.impulse), '�������');
plot_comparison(1:N, sosfilt(sos,sig.step), sosfilt(sos_fix,sig.step), '�������');
plot_comparison(t, sosfilt(sos,sig.sine), sosfilt(sos_fix,sig.sine), '�����', true);

%% 4. ������������ �����
figure('Name','������������ �����','Position',[250 250 800 600]);

% ��� ��������� �����
[Br,Ar] = residuez(r(1:2:end),p(1:2:end),[]);
y_imp = process_parallel(Br,Ar,sig.impulse);
y_step = process_parallel(Br,Ar,sig.step);
y_sine = process_parallel(Br,Ar,sig.sine);

% ��� ������������� �����
[Br_fix,Ar_fix] = residuez(r_fix(1:2:end),p_fix(1:2:end),[]);
y_imp_fix = process_parallel(Br_fix,Ar_fix,sig.impulse);
y_step_fix = process_parallel(Br_fix,Ar_fix,sig.step);
y_sine_fix = process_parallel(Br_fix,Ar_fix,sig.sine);

plot_comparison(1:N, y_imp, y_imp_fix, '�������');
plot_comparison(1:N, y_step, y_step_fix, '�������');
plot_comparison(t, y_sine, y_sine_fix, '�����', true);

%% ������� (������ ���� � ����� �����)
function plot_comparison(t, y_float, y_fix, title_str, is_time)
    if nargin < 5, is_time = false; end
    
    subplot(3,1,find(strcmp(title_str,{'�������','�������','�����'})));
    if contains(title_str, {'�������'})
        stem(t, y_float, 'b'); hold on;
        stem(t, y_fix, 'r--'); hold off;
    else
        if is_time
            plot(t, y_float, 'b', t, y_fix, 'r--');
        else
            plot(y_float, 'b'); hold on;
            plot(y_fix, 'r--'); hold off;
        end
    end
    title([title_str ' (����� - float, ������� - fix)']);
    grid on;
end

function y = process_parallel(b,a,x)
    y = sum(cell2mat(...
        arrayfun(@(i) filter(b(i,:),a(i,:),x), ...
        1:size(b,1), 'UniformOutput',false)), 1);
end