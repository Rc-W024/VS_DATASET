%% Validation of radar and reference signals
%% used for the synchronization study shown in the Paper
% Copyright (C) 2025 WU Ruochen

clear;
close all;

% synchronization validation based on respiratory signals
load('...YOUR PATH OF RADAR DATA...');
load('...YOUR PATH OF REF DATA...');

% cross-correlation
[c,lags]=xcorr(respiration,VitalSig);
lag_max=lags(find(c==max(c)));

figure;
plot(lags*0.5e-3,c);
hold on
plot(lag_max*0.5e-3,max(c),'ro');
text(lag_max*0.5e-3+5,max(c),num2str(lag_max*0.5e-3));
xlabel('Time Lag (s)');
ylabel('Coefficient');

