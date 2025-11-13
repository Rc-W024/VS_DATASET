%% Experiment for radar @UPC CommSensLab sub-millimeter
%% displacement sensing validation with speaker
% Copyright (C) 2025 WU Ruochen

clear;
close all;

%------------------------------------------------PROCESSING CONFIGS-----------------------------------------------------
% Search peak in chirp x:
searchInMeasure=30; %
%--------------------------------------------------RADAR-Settings-------------------------------------------------------
Radar.f_0=122e9;                                  % Center freq: 122 GHz
Radar.c_0=3e8;                                    % Lightspeed (m/s)
Radar.lambda=Radar.c_0/Radar.f_0;                 % Wavelength (m)
% Measurement
T_frame=3e-3;                                     % 3ms
Radar.fs=1/T_frame;

% CHIRP
Radar.Tm=0.0015;                                  % Chirp slope time: 1.5 ms
Radar.deltaf=3e9;                                 % Chirp slope bandwidth: 3 GHz
%------------------------------------------------Digitizer-Settings-----------------------------------------------------
Digitizer.decimation=2; % ???? GIVING it to the function??? to configureBoard and 
Digitizer.long=round(2048/Digitizer.decimation);  % Length of Chirp in samples defined by DDS settings
% Sampling
Sampling.ZP=16;                                   % Zero-padding
Sampling.Fs=1.3672e+06/Digitizer.decimation;      % Sampling frequency CHANGED for new HW                 
Sampling.T=1/Sampling.Fs;                         % Sampling period (s)
Sampling.L=2048/Digitizer.decimation;             % Length of signal CHANGED was 256
t=(0:Sampling.L-1)*Sampling.T;                    % Time vector (s)


%% OPEN Measurement
[filename,pathname]=uigetfile('...\*.bin','Select BIN file');
fitxer=strcat(pathname,filename); % concatenate strings horizontally
ff=fopen(fitxer,'rb');

chans=fread(ff,1,'uint32'); % Channels
long=fread(ff,1,'uint32'); % Trace long=record
recs=fread(ff,1,'uint32'); % records per buffer
buffs=fread(ff,1,'uint32'); % buffers

Digitizer.wfrm=recs*buffs;
data=fread(ff,chans*Digitizer.long*Digitizer.wfrm,'uint16')';

fclose(ff);

Ch=reshape(data,long,chans*Digitizer.wfrm);
Ch=Ch-2^15;

beatingTone_time=Ch(1:end,1:chans:end)*1/2^15;

Digitizer.wfrm=size(beatingTone_time,2);
Radar.t_frame=(0:Digitizer.wfrm-1)*T_frame; % make time array for whole acquisition


%% PREPROCESSING: CALC FFT
% applying window and FFT with zero padding and make spectrum. Subtracting calibration
% data was not used last, due to no improvement 
f=waitbar(.1,'Calc FFT...');
% Apply Window
win_r_z=window('hann',Digitizer.long); % hanning: smooth the signal and reduce the leakage of the signal in the frequency spectrum
beatingTone_time_window=zeros(Digitizer.long,Digitizer.wfrm);
% increase the resolution of the spectrum
for k=1:Digitizer.wfrm
    beatingTone_time_window(:,k)=beatingTone_time(:,k).*win_r_z;
end

% FFT with ZP
Spectrum=fft(beatingTone_time_window,Digitizer.long*Sampling.ZP);

% Make spectrum
Sampling.f=Sampling.Fs*(1:(Sampling.L*Sampling.ZP))/(Sampling.L*Sampling.ZP);
Spec_abs=abs(Spectrum);
% Convert to magnitude
theMaxOfMatrix=max(Spec_abs);
theMaxOfMatrix=max(theMaxOfMatrix);
for k=1:length(Spec_abs(1,:))
    Spec_abs2(:,k)=Spec_abs(:,k)./theMaxOfMatrix;
end
% to dB: relative strength of the signal
Spec_abs_dB=mag2db(Spec_abs2);


%% SEARCH PEAKS
% Find Maxima in Frequency Diagram
% until now it searches Max in the spectrum of one chirp and maintain this
% Max Sample for whole phase calculation
waitbar(.67,f,'Search Peaks ...');

[LocFinder.pks,LocFinder.locs]=findpeaks(Spec_abs_dB(:,searchInMeasure),Sampling.f,'SortStr','descend','MinPeakDistance',5,'MinPeakHeight',-35,'NPeaks',2);
LocFinder.locs_positive=LocFinder.locs(LocFinder.locs>0 & LocFinder.locs<=5e4);
text(LocFinder.locs+.02,LocFinder.pks,num2str((1:numel(LocFinder.pks))'))


%% PRINT FIGURES
% Prints every 10th chirp of the acquisiton in time domain or frequency
% domain as a spectrum depending on the range
close all;
waitbar(1,f,'Create Figures ...');
freqPlots=figure('Name','Time and Frequency Domain','NumberTitle','off');

subplot(2,1,1); % for beating tones in time domain
plot(t,beatingTone_time(:,1:size(beatingTone_time,2)/10:size(beatingTone_time,2)));
title('Time Domain of Chirps');
xlabel('Time (s)')
ylabel('Amplitude')
grid on

distanceOfObject=(Radar.Tm*Radar.c_0 .*Sampling.f)/(2*Radar.deltaf);

subplot(2,1,2); % spectrum depending on range
distanceOfObjectShift=distanceOfObject-(max(distanceOfObject)/2);
plot(distanceOfObjectShift,fftshift(Spec_abs_dB(:,1:size(Spec_abs_dB,2)/10:size(Spec_abs_dB,2))));
title('Spectrum');
xlabel('Range (m)')
ylabel('Magnitude (dB)')
xlim([0 5])
ylim([-25 2])
grid on
hold on
% range-magni & find peak
plot((Radar.Tm*Radar.c_0.*LocFinder.locs(1,1))/(2*Radar.deltaf),LocFinder.pks,'gd','LineWidth',2);

% Make mean for all chirps
RMS_Amplitude=zeros(Digitizer.wfrm,1);
for k=1:Digitizer.wfrm
    RMS_Amplitude(k)=sqrt(mean(beatingTone_time(:,k).^2));
end

% Unwrap plot
NowrapUncorrected=plotPhasewu(Radar,Digitizer,Sampling,LocFinder,Spectrum,RMS_Amplitude,false,'STANDARD');
UnwrapUncorrected=plotPhasewu(Radar,Digitizer,Sampling,LocFinder,Spectrum,RMS_Amplitude,true,'UNWRAP');

close(f)


%% CARDIAC SIGNAL FILTERING
% Vital signal filtering and extraction of heartbeat & respiration signal
% original radar micro-motion signal extraction
for i=1:length(LocFinder.locs_positive)
    lineWithPeak=find(Sampling.f==LocFinder.locs_positive(i));
    VitSig=1000*(Radar.lambda/(4*pi))*unwrap(angle(Spectrum(lineWithPeak,1:Digitizer.wfrm))-angle(Spectrum(lineWithPeak,1)));
end

% Vital (displacement) signal plot
figure('Name','MICRO-MOTION SIGNAL');
plot(Radar.t_frame,VitSig);
grid on
xlabel('Time (s)')
ylabel('Amplitude (mm)')


