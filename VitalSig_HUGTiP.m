% MAIN function for READING recorded data and optimized preprocessing
% workflow for HUGTiP validation and VITALSENSE applications by radar @UPC CommSensLab-UPC
% Copyright (C) 2026 Ruochen Wu AND Laura Miro

clear;
close all;

%------------------------------------------------PROCESSING CONFIGS-----------------------------------------------------
twoChannelMode = true;          % FALSE = ONLY radar channel, TRUE = 2 channels: CHA=radar channel + CHB=ECG channel;
% Search peak in chirp x:
searchInMeasure = 30; %

%--------------------------------------------------RADAR-Settings-------------------------------------------------------
Radar.f_0=122e9;                                  % Center freq: 122 GHz
Radar.c_0=3e8;                                    % Lightspeed (m/s)
Radar.lambda=Radar.c_0/Radar.f_0;                 % Wavelength (m)
% Measurement
T_frame=3e-3;                                     % 3ms
Radar.fs=1/T_frame;

% CHIRP
Radar.Tm=0.0015;                                  % Chirp slope time: 1.5ms
Radar.deltaf=3e9;                                 % Chirp slope bandwidth: 3 GHz
%------------------------------------------------Digitizer-Settings-----------------------------------------------------
Digitizer.decimation=2; % to configureBoard and 
Digitizer.long=round(2048/Digitizer.decimation);  % Length of Chirp in samples defined by DDS settings
% Sampling
Sampling.ZP=8;                                   % Zero-padding
Sampling.Fs=1.3672e+06/Digitizer.decimation;      % Sampling frequency CHANGED for new HW                 
Sampling.T=1/Sampling.Fs;                         % Sampling period (s)
Sampling.L=2048/Digitizer.decimation;             % Length of signal CHANGED was 256
t=(0:Sampling.L-1)*Sampling.T;                    % Time vector (s)


%% OPEN Measurement
[filename,pathname]=uigetfile('C:\CAPT\RADAR\*.bin','Select BIN file');
fitxer=strcat(pathname,filename); % concatenate strings horizontally
ff=fopen(fitxer,'rb');

chans=fread(ff,1,'uint32'); % Channels
long=fread(ff,1,'uint32'); % Trace long = record
recs=fread(ff,1,'uint32'); % records per buffer
buffs=fread(ff,1,'uint32'); % buffers

Digitizer.wfrm=recs*buffs;
data=fread(ff,chans*Digitizer.long*Digitizer.wfrm,'uint16')';

fclose(ff);

Ch=reshape(data,long,chans*Digitizer.wfrm);
Ch=Ch-2^15;

if twoChannelMode==true
    beatingTone_time=Ch(1:end,1:chans:end)*1/2^15; % 1 volt
    ECGSignal=Ch(1:end,2:chans:end)*5/2^15; % 5 volt
else
    beatingTone_time=Ch(1:end,1:chans:end)*1/2^15;
end

Digitizer.wfrm=size(beatingTone_time,2);
Radar.t_frame=(0:Digitizer.wfrm-1)*T_frame; % make time array for whole acquisition


%% PREPROCESSING: CALC FFT
%applying window and FFT with zero padding and make spectrum. Subtracting calibration
%data was not used last, due to no improvement 
f=waitbar(.1,'Calc FFT...');
tic

% settings
chirps_group=100;
selectedChirps=1:chirps_group:Digitizer.wfrm; % 1st chirp in each group

% Apply Window
win_r_z=window('hann',Digitizer.long); % hanning: smooth the signal and reduce the leakage of the signal in the frequency spectrum

% Create subset for spectrum analysis
% only process the selected data to identify the target
beatingTone_new=beatingTone_time(:,selectedChirps);
beatingTone_time_window=beatingTone_new.*win_r_z;

% FFT
Spectrum=fft(beatingTone_time_window,Digitizer.long*Sampling.ZP);

%-------------------------------------------------------------------
% Make spectrum
waitbar(.5,f,'Make Spectrum...');

Sampling.f=Sampling.Fs*(1:(Sampling.L*Sampling.ZP))/(Sampling.L*Sampling.ZP);
Spec_abs=abs(Spectrum);

% Convert to magnitude
theMaxOfMatrix=max(Spec_abs(:));
Spec_abs2=Spec_abs./theMaxOfMatrix;

% to dB: relative strength of the signal
Spec_abs_dB=mag2db(Spec_abs2);


%% SEARCH PEAKS & LOCATE TARGET
% Find Maxima in Frequency Diagram
% until now it searches Max in the spectrum of one chirp and maintain this
% Max Sample for whole phase calculation
waitbar(.67,f,'Find Peaks...');

% find the most frequent peak index across the subset
[~,pks_idx]=max(Spec_abs(1:ceil(end/2),:)); % search in positive freq
target_idx=max(pks_idx); % find the most repeated index as the target
figure('Name','TARGET PEAK INDEX');
plot(pks_idx);

fprintf('Target locked at index: <strong>%d</strong>. Phase of Frequency: <strong>%.2f</strong> Hz @ <strong>%.4f</strong> m.\n',target_idx,Sampling.f(target_idx),(Radar.Tm*Radar.c_0*Sampling.f(target_idx))/(2*Radar.deltaf));

% save location info for compatibility with later code
LocFinder.pks=Spec_abs_dB(target_idx,1);
LocFinder.locs=Sampling.f(target_idx);
LocFinder.locs_positive=LocFinder.locs;


%% PRINT FIGURES
% Prints every 100th chirp of the acquisiton in time domain or frequency
% domain as a spectrum depending on the range
%close all;
waitbar(.95,f,'Create Figures...');

freqPlots=figure('Name','Time and Frequency Domain');
subplot(2,1,1); 
plot(t,beatingTone_time(:,1:4000:end)); 
title('Time Domain of Chirps');
xlabel('Time (s)');
ylabel('Amplitude');
grid on

distanceOfObject=(Radar.Tm*Radar.c_0.*Sampling.f)/(2*Radar.deltaf);

subplot(2,1,2); 
% spectrum
distanceOfObjectShift=distanceOfObject-(max(distanceOfObject)/2);
plot(distanceOfObjectShift,fftshift(Spec_abs_dB)); 
title('Spectrum');
xlabel('Range (m)');
ylabel('Magnitude (dB)');
xlim([0 1.5]);
ylim([-25 2]);
grid on
hold on
% range-magni & find peak
plot((Radar.Tm*Radar.c_0.*Sampling.f(target_idx))/(2*Radar.deltaf),max(Spec_abs_dB(target_idx,:)),'gd','LineWidth',2);


%% Micro-motion signal extraction (OPTIMIZED)
waitbar(1,f,'Extract Phase...');
% OPTIMIZATION: single-bin DFT
% instead of fft on the whole matrix, we calculate only the specific
% row corresponding to 'target_idx' for the FULL data by
% X[k]=sum(x[n]*w[n]*exp(-j*2*pi*k*n/N))

% DFT vector for the specific target frequency bin
kk=target_idx-1; % 0-based index for formula
n=(0:Digitizer.long-1)';
% Combined vector: Window * Basis Function
dft_data=win_r_z.*exp(-1j*2*pi*kk*n/(Digitizer.long*Sampling.ZP));

% calc the specific freq row for ALL chirps via Matrix Multiplication
Spectrum_def=dft_data.'*beatingTone_time;

% Radar micro-motion signal extraction
vitsig=1000*(Radar.lambda/(4*pi))*unwrap(angle(Spectrum_def)-angle(Spectrum_def(1)));

toc
close(f)


%% SIGNALS EXTRACTION
% Data visualization for VITAL signal & ECG signal
Fs=Radar.fs;

figure;
plot(Radar.t_frame,vitsig);
xlabel('Time (s)')
ylabel('Amplitude (mm)')

% ECG signal
if twoChannelMode==true
    decimatedECGSignal=ECGSignal(1:Digitizer.long:end);

    figure;
    plot(Radar.t_frame,decimatedECGSignal,'g');
    xlabel('Time (s)')
    ylabel('Amplitude (mV)')
end

