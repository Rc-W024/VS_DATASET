%% Technical Validation of radar and reference signals
%% used for the synchronization study shown in the Paper
% Copyright (C) 2025 WU Ruochen

clear;
close all;


%% Configuration
dataPath='...YOUR PATH TO DATASET FOLDER...'; % Set your dataset root path
numSubjects=24;
scenarios={'Resting','Apnea'};


%% Initialize result storage
totalRecords=numSubjects*length(scenarios);
results=struct();
results.subjectID=cell(totalRecords,1);
results.scenario=cell(totalRecords,1);
results.timeLag_s=nan(totalRecords,1);
results.timeLag_ms=nan(totalRecords,1);
results.maxCorr=nan(totalRecords,1);
results.status=cell(totalRecords,1); % success or error

%% Main processing
fprintf('Processing synchronization validation...\n');

idx=1;
for subj=1:numSubjects
    subjID=sprintf('VS%02d',subj);
    fprintf('Processing %s...\n',subjID);
    
    for s=1:length(scenarios)
        scenario=scenarios{s};        
        % file paths
        radarFile=fullfile(dataPath,subjID,[subjID '_' scenario '.mat']);
        refFile=fullfile(dataPath,subjID,[subjID '_' scenario '_Mindray.mat']);        
        try
            % load data
            radarData=load(radarFile);
            refData=load(refFile);           
            % signals extraction
            respiration=refData.respiration;
            vitalsig=radarData.VitalSig;
            Radar.fs=radarData.Radar.fs;
            
            % resampling to 2000 Hz
            % refecence respiratory signal resampling
            respiration_re=resample(respiration,2000,refData.Fs_resp);
            % radar vital signal resampling
            [P,Q]=rat(2000/Radar.fs);
            vitsig_re=resample(vitalsig,P,Q);
            
            % cross-correlation
            [c,lags]=xcorr(respiration_re,vitsig_re);
            lag_max=lags(find(c==max(c)));
            
            % time lag
            lag_s=lag_max*0.5e-3; % in s
            lag_ms=lag_s*1000; % in ms
            
            % save results
            results.subjectID{idx}=subjID;
            results.scenario{idx}=scenario;
            results.timeLag_s(idx)=lag_s;
            results.timeLag_ms(idx)=lag_ms;
            results.maxCorr(idx)=lag_max;
            results.status{idx}='Success';
            
            fprintf('%s: Lag = %.4f ms\n',scenario,lag_ms);
            
        catch ME
            % handle errors gracefully
            results.subjectID{idx}=subjID;
            results.scenario{idx}=scenario;
            results.timeLag_s(idx)=NaN;
            results.timeLag_ms(idx)=NaN;
            results.maxCorr(idx)=NaN;
            results.status{idx}=ME.message;
            
            fprintf('%s: ERROR - %s\n',scenario,ME.message);
        end        
        idx=idx+1;
    end
end

fprintf('Processing complete!\n\n');


%% Make results table
resultsTable=table(results.subjectID,results.scenario,results.timeLag_s,results.timeLag_ms,results.maxCorr,results.status,'VariableNames',{'subjectID','scenario','timeLag_s','timeLag_ms','maxCorr','status'});

% separate by scenario
restingData=resultsTable(strcmp(resultsTable.scenario,'Resting'),:);
apneaData=resultsTable(strcmp(resultsTable.scenario,'Apnea'),:);


%% Statistical summary
fprintf('Statistical Summary:\n');

for s=1:length(scenarios)
    scenarioData=resultsTable(strcmp(resultsTable.scenario,scenarios{s}),:);
    validData=scenarioData.timeLag_ms(~isnan(scenarioData.timeLag_ms));
    validCorr=scenarioData.maxCorr(~isnan(scenarioData.maxCorr));
    
    fprintf('%s Scenario:\n', scenarios{s});
    fprintf('Time Lag (ms): Mean=%.2f, Std=%.2f, Range=[%.2f, %.2f]\n',mean(validData),std(validData),min(validData),max(validData));
    fprintf('Max Correlation: Mean=%.4f, Std=%.4f, Range=[%.4f, %.4f]\n',mean(validCorr),std(validCorr),min(validCorr),max(validCorr));
    fprintf('Valid samples: %d/%d\n\n',length(validData),height(scenarioData));
end


%% Technical validation plot
% time lag distribution
figure('Name','Cross-correlation of Synchronization Signals');
restingLags=restingData.timeLag_ms(~isnan(restingData.timeLag_ms));
apneaLags=apneaData.timeLag_ms(~isnan(apneaData.timeLag_ms));
% box plot
boxData=[restingLags; apneaLags];
groupData=[ones(size(restingLags));2*ones(size(apneaLags))];
boxplot(boxData,groupData,'Labels',{'Resting','Apnea'},'Symbol','');
hold on
% overlay individual points with jitter
jitterAmount=0.15;
x1=ones(size(restingLags))+jitterAmount*(rand(size(restingLags))-0.5);
x2=2*ones(size(apneaLags))+jitterAmount*(rand(size(apneaLags))-0.5);
scatter(x1,restingLags,30,'filled','MarkerFaceColor','#0072BD','MarkerFaceAlpha',0.6);
scatter(x2,apneaLags,30,'filled','MarkerFaceColor','#A2142F','MarkerFaceAlpha',0.6);
ylabel('Time Lag (ms)');
grid on;
%set(gca,'LineWidth',1.2);

figure('Name','Correlation Quality');
% correlation coefficient distribution
restingCorr=restingData.maxCorr(~isnan(restingData.maxCorr));
apneaCorr=apneaData.maxCorr(~isnan(apneaData.maxCorr));
boxData2=[restingCorr;apneaCorr];
groupData2=[ones(size(restingCorr));2*ones(size(apneaCorr))];
boxplot(boxData2, groupData2,'Labels',{'Resting','Apnea'},'Symbol','');
hold on;
x1=ones(size(restingCorr))+jitterAmount*(rand(size(restingCorr))-0.5);
x2=2*ones(size(apneaCorr))+jitterAmount*(rand(size(apneaCorr))-0.5);
scatter(x1,restingCorr,30,'filled','MarkerFaceColor','#0072BD','MarkerFaceAlpha',0.6);
scatter(x2,apneaCorr,30,'filled','MarkerFaceColor','#A2142F','MarkerFaceAlpha',0.6);
ylabel('Maximum correlation coefficient');
grid on;

% subject-wise time lag comparison
figure('Name','Subject-Wise Synchronization Time Lag');
subjectNums=1:numSubjects;
restingLagsAll=nan(1,numSubjects);
apneaLagsAll=nan(1,numSubjects);

for i=1:numSubjects
    subjID=sprintf('VS%02d',i);
    restingIdx=strcmp(resultsTable.subjectID,subjID) & strcmp(resultsTable.scenario,'Resting');
    apneaIdx=strcmp(resultsTable.subjectID,subjID) & strcmp(resultsTable.scenario,'Apnea');
    
    if any(restingIdx)
        restingLagsAll(i)=resultsTable.timeLag_ms(restingIdx);
    end
    if any(apneaIdx)
        apneaLagsAll(i)=resultsTable.timeLag_ms(apneaIdx);
    end
end

plot(subjectNums,restingLagsAll,'o-','Color',[0 0.447 0.741],'LineWidth',1,'MarkerSize',5,'MarkerFaceColor',[0 0.447 0.741]);
hold on;
plot(subjectNums,apneaLagsAll,'diamond-','Color',[0.85 0.325 0.098],'LineWidth',1,'MarkerSize',5,'MarkerFaceColor',[0.85 0.325 0.098]);
% mean lines
yline(mean(abs(restingLags)),'--','Color',[0 0.447 0.741],'LineWidth',1);
yline(mean(abs(apneaLags)),'--','Color',[0.85 0.325 0.098],'LineWidth',1);

ylims=ylim;
xlims=xlim;
textY=ylims(2)-0.02*range(ylims);
text(xlims(1)+0.02*range(xlims),textY,sprintf('Mean Lag: %.4f ms',mean(abs(restingLags))),'Color',[0 0.447 0.741],'VerticalAlignment','top','Margin',2);
text(xlims(1)+0.02*range(xlims),textY-0.06*range(ylims),sprintf('Mean Lag: %.4f ms',mean(abs(apneaLags))),'Color',[0.85 0.325 0.098],'VerticalAlignment','top','Margin',2);
xlabel('Subject ID (VS)');
ylabel('Time lag (ms)');
xticks(1:numSubjects);
ylim([-40 30])
legend('Resting','Apnea','Mean lag for Resting','Mean lag for Apnea');
grid on;


%% Save results
save('Technical_validation_results.mat','results','resultsTable');
writetable(resultsTable,'Technical_validation_results.csv');

fprintf('\nAll results saved successfully!\n');
fprintf('Generated files:\n');
fprintf('- synchronization_validation_results.mat\n');
fprintf('- synchronization_validation_results.csv\n');


%% Display final table
fprintf('\n');
disp('Summary Statistics Table for VitalSense Dataset:');
summaryStats=table();
summaryStats.Scenario=scenarios';
summaryStats.N=[sum(~isnan(restingLags));sum(~isnan(apneaLags))];
summaryStats.TimeLag_Mean_ms=[mean(abs(restingLags));mean(abs(apneaLags))];
summaryStats.TimeLag_Std_ms=[std(restingLags);std(apneaLags)];
summaryStats.MaxCorr_Mean=[mean(restingCorr);mean(apneaCorr)];
summaryStats.MaxCorr_Std=[std(restingCorr);std(apneaCorr)];
disp(summaryStats);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% If you just want to plot the cross-correlation lag of a single case,
%%% you can manually load the radar and reference data and output it via:

% [c,lags]=xcorr(respiration_re,vitsig_re);
% lag_max=lags(find(c==max(c)));

% figure;
% plot(lags*0.5e-3,c);
% hold on
% plot(lag_max*0.5e-3,max(c),'ro');
% text(lag_max*0.5e-3+5,max(c),num2str(lag_max*0.5e-3));
% xlabel('Time Lag (s)');
% ylabel('Coefficient');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%