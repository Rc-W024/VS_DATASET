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
%------------------------------------------------Digitizer-Settings-----------------------------------------------------
Digitizer.decimation=4; % ???? GIVING it to the function??? to configureBoard and 
Digitizer.long=round(2048/Digitizer.decimation);  % Length of Chirp in samples defined by DDS settings
Digitizer.wfrm=8000; % 24s
% Sampling
Sampling.ZP=32;                                   % Zero-padding
Sampling.Fs=1.3672e+06/Digitizer.decimation;      % Sampling frequency CHANGED for new HW                 
Sampling.T=1/Sampling.Fs;                         % Sampling period (s)
Sampling.L=2048/Digitizer.decimation;             % Length of signal CHANGED was 256
t=(0:Sampling.L-1)*Sampling.T;                    % Time vector (s)
%------------------------------------------------Backup-Information-----------------------------------------------------


%% SIGNAL SEPARATION
% Vital signal filtering and extraction of heartbeat & respiration signal
% raw radar micro-motion signal
load('...YOUR PATH OF RADAR DATA...');

% FIR linear-phase filter
smp_f=1/T_frame; % sampling
cutoff_f=0.3; % cut-off frecuency
blp_r=fir1(300,cutoff_f/(smp_f/2),'low');
% filtering results
rsig_lp=filtfilt(blp_r,1,VitalSig);
hsig_lp=vitsig-rsig_lp;

% Plot data...
figure('Name','SEPARATION OF BREATHING & CARDIAC SIGNAL');
subplot(2,1,1)
plot(Radar.t_frame,VitalSig);
hold on
plot(Radar.t_frame,rsig_lp);
grid on
h1=legend('Vital signal','Respiratory signal');
%set(h1,'Orientation','horizon')
%legend('boxoff')
xlabel('Time (s)')
ylabel('Amplitude (mm)')
title('Extracted respiratory signal')
subplot(2,1,2)
plot(Radar.t_frame,hsig_lp);
grid on
xlabel('Time (s)')
ylabel('Amplitude (mm)')
title('Extracted cardiac signal')


