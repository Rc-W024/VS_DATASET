%% Exemplary plots generation of selected subject with DATASET records
% Copyright (C) 2025 WU Ruochen

clear;
close all;

%% Prepare data
% set path to dataset
load('...YOUR PATH OF RADAR DATA...');
load('...YOUR PATH OF REF DATA...');

% time vectors
%T_frame=0.003;
%Radar.fs=1/T_frame;
%Radar.t_frame=1/Radar.fs:1/Radar.fs:length(VitalSig)/Radar.fs;
ECGt_frame=1/Fs_ecg:1/Fs_ecg:length(ecg_lead2)/Fs_ecg;
Respt_frame=1/Fs_resp:1/Fs_resp:length(respiration)/Fs_resp;
pletht_frame=1/Fs_pleth:1/Fs_pleth:length(pleth)/Fs_pleth;


%% Visualization
% offset coeff
offset_step=5; % customize

%%%%%% IMPORTANT %%%%%%
% To visualize the entire data (both radar and reference signals) on one figure
% it is necessary to normalize the amplitude of each signal and ignore the y-axis

% Coefficients of normalization and offset can be ajusted manually as in the following code:
% %SIGNAL*amplitude normalization coeff% AND %OFFSET*ajusted coeff%
% If you want to plot the separate signals (obtained by VS_Validation.m)
% you can do so in the same way like the commented handles

% Try modifying the coeff to plot the entire data in your way
%%%%%%%%%%%%%%%%%%%%%%%

% plot data...
figure; 
hold on;
plot(Radar.t_frame,VitalSig*1.5+3.5*offset_step,'k');
%plot(Radar.t_frame,RespiratorySig*XX+XX*offset_step,'Color','#4DBEEE');
plot(Respt_frame,respiration*0.02+2.3*offset_step,'Color','#0072BD');
%plot(Radar.t_frame,CardiacSig*XX+XX*offset_step,'Color','#D95319');
plot(pletht_frame,pleth*0.02+1.4*offset_step,'Color','#FF00FF');
plot(ECGt_frame,ecg_lead2*0.003+0.5*offsset_step,'Color','#7E2F8E');
plot(ECGt_frame,ecg_lead3*0.003-0.31*offset_step,'Color','#A2142F');
plot(ECGt_frame,ecg_leadv1*0.004-0.96*offset_step,'Color','#EDB120');
hold off;
xlabel('Time (s)');
yticks([])
%xlim([0 30])
%ylim([-8 20])
box on

