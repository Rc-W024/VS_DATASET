% MAIN function for PROCESSING recorded data by radar @UPC CommSensLab
% FYI: RESPIRATORY & CARDIAC signal separation and plot
% Copyright (C) 2025 WU Ruochen

clear;
close all;

%--------------------------------------------------RADAR-Settings-------------------------------------------------------
Radar.f_0=122e9;                                  % Center freq: 122 GHz
Radar.c_0=3e8;                                    % Lightspeed (m/s)
Radar.lambda=Radar.c_0/Radar.f_0;                 % Wavelength (m)
% Measurement
L_samplesDwell=512;                               % Pause samples between chirps
T_frame=3e-3;                                     % T*(L+L_samplesDwell); 3ms

% CHIRP
Radar.Tm=0.0015;                                  % Chirp slope time: 1.5ms
Radar.deltaf=3e9;                                 % Chirp slope bandwidth: 3 GHz
%------------------------------------------------Backup-Information-----------------------------------------------------

%% Configuration
%%%% Path to dataset
dataPath='D:\UPC\THzRadar\DATASET\DATA FINAL\'; 

%%%% Subject ID 
subjID='VS05'; % VSXX - choose numbers from 01 to 24

%%%% Scnerio 
% Available scenarios are {'Resting' 'Apnea'}
scenario='Resting';

%% Read file...
radarFile=fullfile(dataPath,subjID,[subjID '_' scenario '.mat']);
refFile=fullfile(dataPath,subjID,[subjID '_' scenario '_Mindray.mat']);
% load data
radarData=load(radarFile);
refData=load(refFile);

%% SIGNAL SEPARATION
% Vital signal filtering and extraction of heartbeat & respiration signal
% necessary variable extraction
VitalSig=radarData.VitalSig; % radar vital signal
T_frame=radarData.T_frame;
Radar.t_frame=radarData.Radar.t_frame;
ECGSig=refData.ecg_lead2; % ECG signal: lead II
Fs_ecg=refData.Fs_ecg;
ECG.t_frame=1/Fs_ecg:1/Fs_ecg:length(ECGSig)/Fs_ecg;

% FIR linear-phase filter
smp_f=1/T_frame; % sampling
cutoff_f=0.3; % cut-off frecuency
blp_r=fir1(300,cutoff_f/(smp_f/2),'low');
% filtering results
rsig_lp=filtfilt(blp_r,1,VitalSig);
hsig_lp=VitalSig-rsig_lp;


%% Plot data...
% signal separation
figure('Name','SEPARATION OF BREATHING & CARDIAC SIGNAL');
ax1=subplot(2,1,1);
plot(Radar.t_frame,VitalSig);
hold on
plot(Radar.t_frame,rsig_lp);
grid on
legend('Vital signal','Respiratory signal');
xlabel('Time (s)')
ylabel('Amplitude (mm)')
title('Extracted respiratory signal')
ax2=subplot(2,1,2);
plot(Radar.t_frame,hsig_lp);
grid on
xlabel('Time (s)')
ylabel('Amplitude (mm)')
title('Extracted cardiac signal')

linkaxes([ax1,ax2],'x')

% cardiac signal & reference ECG signal
figure('Name','RADAR & ECG SIGNALS');
yyaxis left
plot(Radar.t_frame,hsig_lp)
ylabel('Cardiac Amplitude (mm)')
yyaxis right
plot(ECG.t_frame,ECGSig,'g');
grid on
xlabel('Time (s)')
ylabel('ECG Amplitude')

