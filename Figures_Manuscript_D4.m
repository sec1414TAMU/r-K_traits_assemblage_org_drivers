% Coding by Sierra Cagle  2026
% NOTE: uses presaved variables!

clear

Figures_Manuscript_Calcs

%--------------------------------------------------------------------------
% Used for plotting and setting color schemes
%--------------------------------------------------------------------------

% Discharge fill
xx = [2,(2:1:tfinal-1),tfinal-1]';
yy = [2e-4;disch(2:end-1);2e-4];
grey = [0.5 0.5 0.5];%darkest
grey1 =  [0.7 0.7 0.7]; %medium
grey2 = [0.85 0.85 0.85];%lightest

% POP DYN and PEAKS-VALLEYS
cmap1 = jet(traits_10*2);
cmap2 = cmap1(1:2:19,:);

% 4-BOX SCATTER PLOTS & AWM-r strip
j = jet(1000);
bottom = j(99:615,:); %blue to yellow
top = j(615:850,:); % yellow to red
pull = round(linspace(1,215,91));
top(pull,:)=[];
jj = [bottom;top];

% Transition indicators fill
marker_U=[locs_p_U;locs_v_U];
marker_M=[locs_p_M;locs_v_M];
marker_L=[locs_p_L;locs_v_L];
% for i = 1:length(marker_U)
%     target = marker_U(1);
%     target/
% end

% AWM-r color strip
min_all = min([U_rAVG_10;M_rAVG_10;L_rAVG_10]);
max_all = max([U_rAVG_10;M_rAVG_10;L_rAVG_10]);
jj_proxy = (1:1:size(jj,1));
x1 = min_all;
y1 = jj_proxy(1);
x2 = max_all;
y2 = jj_proxy(end);
b = (x1*y2-x2*y1)/(x1-x2);
m = (y1-b)/x1;
%
min_U = min(U_rAVG_10);
min_M = min(M_rAVG_10);
min_L = min(L_rAVG_10);
max_U = max(U_rAVG_10);
max_M = max(M_rAVG_10);
max_L = max(L_rAVG_10);
jj_min_U = round(m*min_U + b);
jj_min_M = round(m*min_M + b);
jj_min_L = round(m*min_L + b);
jj_max_U = round(m*max_U + b);
jj_max_M = round(m*max_M + b);
jj_max_L = round(m*max_L + b);

% RUE_Biomass_P *OPTION 2 CALC
xxx = (1:1:846);
yyy = ones(846,1);

%--------------------------------------------------------------------------
% Set up axes
% -------------------------------------------------------------------------

start_year = 2004;
end_year = 2006;
start_month = 4;
end_month = 8;
numyears = end_year - start_year + 1;
% nummonths = 12-start_month+1 + (numyears-2)*12 + end_month;
months = (1:1:12);
% Works for: P.Input_Data == 0 || P.Input_Data == 2
build_label1 = months(start_month:end);
build_label2 = repmat(months, 1, numyears-2);
build_label3 = months(1:end_month);
raw_xtick_labels = [build_label1, build_label2, build_label3];
raw_labels = length(raw_xtick_labels);
num_labels_wanted = 15;
interval = round(raw_labels/num_labels_wanted);
overage = interval*num_labels_wanted-1 - raw_labels;
xtick_labels = raw_xtick_labels(1:interval:(raw_labels-overage));
tick_space_interval = numdays/(length(xtick_labels)-1);

%--------------------------------------------------------------------------
% Nutrient Loading & Discharge
% Manuscript Figure 2A
%--------------------------------------------------------------------------

figure
ax = axes;
ax.YAxis(1).Color = [0 0 0];
plot(log10(SRP_load),'r','LineWidth',1.2)
hold on
plot(log10(Amm_load),'-k','LineWidth',1.2)
plot(log10(Nx_load),'-k','LineWidth',1.7)
set(ax,'FontSize',11)
yyaxis right
ax.YAxis(2).Color = [0 0 0];
plot(log10(disch),'b','LineWidth',1.2)
xlim([0 tfinal]);
xticks(0:tick_space_interval:numdays);
set(ax,'xticklabel',xtick_labels)     
set(ax,'FontSize',11)
box on
legend('SRP','NH_4','NO_2+NO_3','Discharge','Location','Southwest')

% ------------------------------------------------------------------------
% Abundance-weighted Assemblage-Average r 
% Manuscript Figures 2B-D
%--------------------------------------------------------------------------

% POP DYN and PEAKS-VALLEYS
% Manuscript Figure 2B
figure;
SP1 = subplot(3,1,1);
set(SP1,'defaultAxesColorOrder',[[0,0,0];[0,0,0]]);
colororder(cmap2);
SP1.NextPlot = 'replacechildren';
plot(Chla_U_10(:,1:10), 'LineWidth',0.75)
hold on
plot(Chla_U_10(:,11:20), 'LineWidth',0.75)
plot(Chla_U_10(:,21:30), 'LineWidth',0.75)
ylim([0 6]);
yyaxis right
SP1.YAxis(2).Color = [0 0 0];
plot(U_rAVG_10, 'k', 'LineWidth',1.5)
hold on
plot((1:1:tfinal),(1.15.*ones(1,tfinal)),':k')
scatter([locs_p_U;locs_v_U], [pks_U+0.1;-vls_U+0.1],'kv')
xlim([0 tfinal]);
ylim([0 1.5]);
xticks(0:tick_space_interval:numdays);
set(SP1,'xticklabel',xtick_labels)     
set(SP1,'FontSize',11)
box on
%
SP2 = subplot(3,1,2);
colororder(cmap2);
plot(Chla_M_10(:,1:10), 'LineWidth',0.75)
hold on
plot(Chla_M_10(:,11:20), 'LineWidth',0.75)
plot(Chla_M_10(:,21:30), 'LineWidth',0.75)
ylim([0 6]);
yyaxis right
SP2.YAxis(2).Color = [0 0 0];
plot(M_rAVG_10, 'k', 'LineWidth',1.5)
hold on
plot((1:1:tfinal),(1.15.*ones(1,tfinal)),':k')
plot(locs_p_M, pks_M+0.1, 'kv')
plot(locs_v_M, -vls_M+0.1, 'kv')
xlim([0 tfinal]);
ylim([0 1.5]);
xticks(0:tick_space_interval:numdays);
set(SP2,'xticklabel',xtick_labels)     
set(SP2,'FontSize',11)
box on
%
SP3 = subplot(3,1,3);
colororder(cmap2);
plot(Chla_L_10(:,1:10), 'LineWidth',0.75)
hold on
plot(Chla_L_10(:,11:20), 'LineWidth',0.75)
plot(Chla_L_10(:,21:30), 'LineWidth',0.75)
ylim([0 8]);
yyaxis right
SP3.YAxis(2).Color = [0 0 0];
plot(L_rAVG_10, 'k', 'LineWidth',1.5)
hold on
plot((1:1:tfinal),(1.15.*ones(1,tfinal)),':k')
plot(locs_p_L, pks_L+0.1, 'kv')
plot(locs_v_L, -vls_L+0.1, 'kv')
xlim([0 tfinal]);
ylim([0 1.5]);
xticks(0:tick_space_interval:numdays);
set(SP3,'xticklabel',xtick_labels)     
set(SP3,'FontSize',11)
box on
%---------------------------------------------------
c = colorbar;
colormap(c, cmap2);
c.Position = [0.98,0.259,0.02,0.6]; % [left, bottom, width, height]
c.TickLabels = [];
c.Ticks = [];


% 4-BOX SCATTER PLOTS
% Manuscript Figure 2C1-4
% events = locations, avg r, cum disch, cum SRP load, avg. zoopl (all 28 days)
figure('Position', [391,267,602,527]); % [left, bottom, width, height]
colormap(jj)
mkr = 60;
SP2 = subplot(2,2,1); % cum disch vs. avg r
target = 3; %disch
scatter(events_U(target,:),events_U(2,:),[],events_U(2,:),'o','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
hold on
scatter(events_M(target,:),events_M(2,:),[],events_M(2,:),'diamond','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
scatter(events_L(target,:),events_L(2,:),[],events_L(2,:),'square','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
box on
set(SP2,'FontSize',11)
ylim([0.5,1.4])
%
SP3 = subplot(2,2,2); % cum SRP load vs. avg r
target = 4; %SRP
scatter(events_U(target,:),events_U(2,:),[],events_U(2,:),'o','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
hold on
scatter(events_M(target,:),events_M(2,:),[],events_M(2,:),'diamond','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
scatter(events_L(target,:),events_L(2,:),[],events_L(2,:),'square','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
box on
set(SP3,'FontSize',11)
ylim([0.5,1.4])
%
SP1 = subplot(2,2,3); % cum disch vs. SRP
target1 = 3; %disch
target2 = 4; %SRP
scatter(events_U(target1,:),events_U(target2,:),[],events_U(2,:),'o','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
hold on
scatter(events_M(target1,:),events_M(target2,:),[],events_M(2,:),'diamond','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
scatter(events_L(target1,:),events_L(target2,:),[],events_L(2,:),'square','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
box on
set(SP1,'FontSize',11)
%
SP4 = subplot(2,2,4); % avg zoopl vs. avg r
target = 5;
scatter(events_U(target,:),events_U(2,:),[],events_U(2,:),'o','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
hold on
scatter(events_M(target,:),events_M(2,:),[],events_M(2,:),'diamond','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
scatter(events_L(target,:),events_L(2,:),[],events_L(2,:),'square','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
box on
set(SP4,'FontSize',11)
legend('U','M','L')
%
% colorbar;
% clim([0.3 2])
c = colorbar;
colormap(c, jj);
c.Position = [0.93,0.259,0.02,0.6]; % [left, bottom, width, height]


% 3D SCATTER PLOT (cum. P load, Avg. Zoopl, Avg r)
% Manuscript Figure 2D
figure 
mkr = 80;
colormap(jj)
stem3(events_U(4,:),events_U(5,:),events_U(2,:),'k')
hold on
scatter3(events_U(4,:),events_U(5,:),events_U(2,:),[],events_U(2,:),'o','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
stem3(events_M(4,:),events_M(5,:),events_M(2,:),'k')
scatter3(events_M(4,:),events_M(5,:),events_M(2,:),[],events_M(2,:),'diamond','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
stem3(events_L(4,:),events_L(5,:),events_L(2,:),'k')
scatter3(events_L(4,:),events_L(5,:),events_L(2,:),[],events_L(2,:),'square','filled',SizeData=mkr, MarkerEdgeColor=[0,0,0])
xlabel('P Loading')
ylabel('Zooplankton')
zlabel('Weighted Avg. r')
set(gca,'FontSize',11)
box on

% ------------------------------------------------------------------------
% Total Chla in each region & Empiricle data 
% Manuscript Figure 3
%-------------------------------------------------------------------------

disch = SRP_load;
disch2 = D.River_Disch;
xx = [2,(2:1:tfinal-1),tfinal-1]';
yy = [2e-4;disch(2:end-1);2e-4];
xx2 = [2,(2:1:tfinal-1),tfinal-1]';
yy2 = [2e-4;disch2(2:end-1);2e-4];

f = figure; 
f.Position = [463,285,825,593];
SP1 = subplot(3,1,1);
SP1.Position = [0.13,0.689713322091062,0.775,0.219718717057108];
plot(CT_U_1,'k','LineWidth',1.5)
hold on
plot(CT_U_10,'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_UXABS_Chla(:,1), comp_UXABS_Chla(:,2),'*','r')
colormap(jj(jj_min_U:jj_max_U,:))
markers = U_rAVG_10([locs_p_U;locs_v_U]);
scatter([locs_p_U;locs_v_U], [CT_U_10(locs_p_U);CT_U_10(locs_v_U)]+5,[],markers, 'v', 'filled','MarkerEdgeColor','k')
% colormap(SP1,jj(jj_min_U:jj_max_U,:))
% scatter(xxx,yyy.*0,[],U_rAVG_10,'o','filled',SizeData=15)
ylim([0 75]);
set(gca, 'Layer', 'top')
yyaxis right
fill(xx,yy,grey2,'EdgeColor','none');
hold on
fill(xx2,yy2,grey,'EdgeColor','none');
set(gca,'YColor','k')
set(gca, 'SortMethod', 'depth')
ylim([0 4e11]);
xlim([0 numdays]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
set(gca,'FontSize',11)
legend('v.poor', 'v.rich', 'Empirical', 'AWM-\itr','SRP Load','Discharge',...
    'Location','northeast','FontSize', 8)%, 'Empiricle-Adj.');
%--------------------
SP2 = subplot(3,1,2);
SP2.Position = [0.13,0.389544688026981,0.775,0.219718717057108];
plot(CT_M_1,'k','LineWidth',1.5)
hold on
plot(CT_M_10,'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_MXABS_Chla(:,1), comp_MXABS_Chla(:,2),'*','r')
colormap(jj(jj_min_M:jj_max_M,:))
markers = M_rAVG_10([locs_p_M;locs_v_M]);
scatter([locs_p_M;locs_v_M], [CT_M_10(locs_p_M);CT_M_10(locs_v_M)]+5,[],markers, 'v', 'filled','MarkerEdgeColor','k')
ylim([0 75]);
set(gca, 'Layer', 'top')
yyaxis right
fill(xx,yy,grey2,'EdgeColor','none');
hold on
fill(xx2,yy2,grey,'EdgeColor','none');
set(gca,'YColor','k')
set(gca, 'SortMethod', 'depth')
ylim([0 4e11]);
xlim([0 numdays]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
set(gca,'FontSize',11)
%--------------------
SP3 = subplot(3,1,3);
SP3.Position = [0.13,0.084317032040472,0.775,0.219718717057108];
plot(CT_L_1,'k','LineWidth',1.5)
hold on
plot(CT_L_10,'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_LXABS_Chla(:,1), comp_LXABS_Chla(:,2),'*','r')
colormap(jj(jj_min_L:jj_max_L,:))
markers = L_rAVG_10([locs_p_L;locs_v_L]);
scatter([locs_p_L;locs_v_L], [CT_L_10(locs_p_L);CT_L_10(locs_v_L)]+5,[],markers, 'v', 'filled','MarkerEdgeColor','k')
ylim([0 75]);
set(gca, 'Layer', 'top')
yyaxis right
fill(xx,yy,grey2,'EdgeColor','none');
hold on
fill(xx2,yy2,grey,'EdgeColor','none');
set(gca,'YColor','k')
set(gca, 'SortMethod', 'depth')
ylim([0 4e11]);
xlim([0 numdays]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels) 
set(gca,'FontSize',11)
%--------------------
% sgtitle('Chla (mg/L) in USABS, MSABS, LSABS');


% SCATTER FIGURES (Model Chla vs Empiricle)
f = figure('Position',[680,648,261,230]);
scatter(comp_UXABS_Chla(targets,2),M_U_10,'Color',[0.0745 0.6235 1.0000])
hold on
scatter(comp_UXABS_Chla(targets,2),M_U_1,'k')
max_U = max([max(comp_UXABS_Chla(targets,2)), max(M_U_10), max(M_U_1)]);
max_U1 = round(max_U)+1;
plot((0:1:max_U1),(0:1:max_U1),'k')
xlim([0,max_U1])
ylim([0,max_U1])
set(gca,'FontSize',11)
box on
%
f = figure('Position',[680,648,261,230]);
scatter(comp_MXABS_Chla(targets,2),M_M_10,'Color',[0.0745 0.6235 1.0000])
hold on
scatter(comp_MXABS_Chla(targets,2),M_M_1,'k')
max_M = max([max(comp_MXABS_Chla(targets,2)), max(M_M_10), max(M_M_1)]);
max_M1 = round(max_M)+1;
plot((0:1:max_M1),(0:1:max_M1),'k')
xlim([0,max_M1])
ylim([0,max_M1])
set(gca,'FontSize',11)
box on
%
f = figure('Position',[680,648,261,230]);
scatter(comp_LXABS_Chla(targets,2),M_L_10,'Color',[0.0745 0.6235 1.0000])
hold on
scatter(comp_LXABS_Chla(targets,2),M_L_1,'k')
max_L = max([max(comp_LXABS_Chla(targets,2)), max(M_L_10), max(M_L_1)]);
max_L1 = round(max_L)+1;
plot((0:1:max_L1),(0:1:max_L1),'k')
xlim([0,max_L1])
ylim([0,max_L1])
set(gca,'FontSize',11)
box on

% -------------------------------------------------------------------------
% Resource use efficiency
% Manuscript Figure 3B
%--------------------------------------------------------------------------

% RUE_Biomass_P *OPTION 2 CALC
f = figure('Position',[680,435,359,443]);
SP1 = subplot(3,1,1); % Upper 
SP1.Position = [0.13,0.709264705882353,0.775,0.193779795067416];
plot(RUE2_U_P_1,'-k','LineWidth',1)
hold on
plot(RUE2_U_P_10, 'LineWidth',1, 'Color',[0.0745 0.6235 1.0000])
colormap(SP1, jj(jj_min_U:jj_max_U,:))
scatter(xxx,yyy.*0,[],U_rAVG_10,'o','filled',SizeData=15)
ylim([0,8])
xlim([0,845])
set(gca,'FontSize',11)
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
%
SP2 = subplot(3,1,2); % Middle 
SP2.Position = [0.13,0.409632352941176,0.775,0.193779795067416];
plot(RUE2_M_P_1,'-k','LineWidth',1)
hold on
plot(RUE2_M_P_10,'LineWidth',1, 'Color',[0.0745 0.6235 1.0000])
colormap(SP2, jj(jj_min_M:jj_max_M,:))
scatter(xxx,yyy.*0,[],M_rAVG_10,'o','filled',SizeData=15)
ylim([0,8])
xlim([0,845])
set(gca,'FontSize',11)
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
%
SP3 = subplot(3,1,3); % Lower P 
SP3.Position = [0.13,0.11,0.775,0.193779795067416];
plot(RUE2_L_P_1,'-k','LineWidth',1)
hold on
plot(RUE2_L_P_10,'LineWidth',1, 'Color',[0.0745 0.6235 1.0000])
colormap(SP3, jj(jj_min_L:jj_max_L,:))
scatter(xxx,yyy.*0,[],L_rAVG_10,'o','filled',SizeData=15)
ylim([0,8])
xlim([0,845])
set(gca,'FontSize',11)
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   

% ------------------------------------------------------------------------
% Zooplankton in each region
% Manuscript Figure 3C
% -------------------------------------------------------------------------

f = figure('Position',[680,435,359,443]);
%-----------------------
SP1 = subplot(3,1,1);
colororder({'k','k'})
plot(Zv_U_1,'k','LineWidth',1.5)
hold on;
plot(Zv_U_10,'Color',[0.0745 0.6235 1.0000],'LineWidth',1.5)
colormap(SP1, jj(jj_min_U:jj_max_U,:))
scatter(xxx,yyy.*-0.75e8,[],U_rAVG_10,'o','filled',SizeData=15)
xlim([0 numdays]);
xticks(0:tick_space_interval:numdays);
set(SP1,'xticklabel',xtick_labels) 
set(SP1,'FontSize',11)
box on
%------------------------------------------------------------
SP2 = subplot(3,1,2);
colororder({'k','k'})
plot(Zv_M_1,'k','LineWidth',1.5)
hold on;
plot(Zv_M_10,'Color',[0.0745 0.6235 1.0000],'LineWidth',1.5)
colormap(SP2, jj(jj_min_M:jj_max_M,:))
scatter(xxx,yyy.*-0.75e8,[],M_rAVG_10,'o','filled',SizeData=15)
xlim([0 numdays]);
xticks(0:tick_space_interval:numdays);
set(SP2,'xticklabel',xtick_labels)  
set(SP2,'FontSize',11)
box on
%------------------------------------------------------------
SP3 = subplot(3,1,3);
colororder({'k','k'})
plot(Zv_L_1,'k','LineWidth',1.5)
hold on;
plot(Zv_L_10,'Color',[0.0745 0.6235 1.0000],'LineWidth',1.5)
colormap(SP3, jj(jj_min_L:jj_max_L,:))
scatter(xxx,yyy.*-0.75e8,[],L_rAVG_10,'o','filled',SizeData=15)
xlim([0 numdays]);
xticks(0:tick_space_interval:numdays);
set(SP3,'xticklabel',xtick_labels)   
set(SP3,'FontSize',11)
 box on
% legend('Module 1, Zoopl.', 'Module 2, Zoopl.','Module 1, Phytopl.', 'Module 2, Phytopl.','Location','eastoutside')

% ------------------------------------------------------------------------
% Trophic transfer efficiency 
% Manuscript Figure 3D
% ------------------------------------------------------------------------

LW = 1.2;
%
f = figure('Position',[680,435,359,443]);
SP1 = subplot(3,1,1);
SP1.Position = [0.13,0.709264705882353,0.775,0.193779795067416];
colororder({'k','k'})
plot(TE_U_1,'k','LineWidth',LW)
hold on;
plot(TE_U_10,'LineWidth',LW, 'Color',[0.0745 0.6235 1.0000])
colormap(SP1, jj(jj_min_U:jj_max_U,:))
scatter(xxx,yyy.*10,[],U_rAVG_10,'o','filled',SizeData=15)
xlim([0 numdays]);
ylim([10 28]);
ax1 = gca;
xticks(0:tick_space_interval:numdays);
set(ax1,'xticklabel',xtick_labels) 
set(ax1,'FontSize',11) 
%--------------------
SP2 = subplot(3,1,2);
SP2.Position = [0.13,0.409632352941176,0.775,0.193779795067416];
colororder({'k','k'})
plot(TE_M_1,'k','LineWidth',LW)
hold on;
plot(TE_M_10,'LineWidth',LW, 'Color',[0.0745 0.6235 1.0000])
colormap(SP2, jj(jj_min_M:jj_max_M,:))
scatter(xxx,yyy.*10,[],M_rAVG_10,'o','filled',SizeData=15)
xlim([0 numdays]);
ylim([10 28]);
ax1 = gca;
xticks(0:tick_space_interval:numdays);
set(ax1,'xticklabel',xtick_labels) 
set(ax1,'FontSize',11)
%--------------------
SP3 = subplot(3,1,3);
SP3.Position = [0.13,0.11,0.775,0.193779795067416];
colororder({'k','k'})
plot(TE_L_1,'k','LineWidth',LW)
hold on;
plot(TE_L_10,'LineWidth',LW, 'Color',[0.0745 0.6235 1.0000])
colormap(SP3, jj(jj_min_L:jj_max_L,:))
scatter(xxx,yyy.*10,[],L_rAVG_10,'o','filled',SizeData=15)
xlim([0 numdays]);
ylim([10 28]);
ax1 = gca;
xticks(0:tick_space_interval:numdays);
set(ax1,'xticklabel',xtick_labels)    
set(ax1,'FontSize',11)
% legend('Module 1', 'Module 2', 'Location','eastoutside')

%--------------------------------------------------------------------------
% Salinity & River discharge 
% Manuscript Figure S1
%--------------------------------------------------------------------------

figure 
ax = axes;
yyaxis('left');
ax.YAxis(1).Color = [0 0 0];
fill(xx,yy,grey,'EdgeColor','none');
set(ax,'FontSize',11)
yyaxis('right');
plot(D.U_sal,'k','LineWidth', 1.5)
hold on
plot(D.M_sal,':k','LineWidth', 1.5)
plot(D.L_sal,'--k','LineWidth', 1.5)
xlim([0 tfinal]);
ylim([0 30]);
xticks(0:tick_space_interval:numdays);
set(ax,'xticklabel',xtick_labels)   
legend('Disch.','U-SABS', 'M-SABS', 'L-SABS','Location', 'northwest','FontSize',9)
ax.YAxis(2).Color = [0 0 0];
set(ax,'FontSize',11)

% --------------------------------------------------------------------------
% Phytoplankton Growth Rates 
% Manuscript Figure S2
% --------------------------------------------------------------------------

disch = (D.River_Disch/1e9);
xx = [2,(2:1:tfinal-1),tfinal-1]';
yy = [2e-4;disch(2:end-1);2e-4];

SP = figure;
SP.Position = [64,300,1000,500 ];
x = 0.07;
y = 0.7;
a = 0.03;
b = 0.06;
L = 0.2;
H = 0.25;
% USABS --------------------------------------------------------------
SP1 = subplot(3,4,1); 
SP1.Position = [x,y,L,H];
SP1.Box = 1;
SP1.ColorOrder = cmap2; 
SP1.NextPlot = 'replacechildren';
fill(xx,(yy.*0.002),grey,'EdgeColor',grey);
hold on
plot(u_TL_U_10, 'LineWidth',1.5) % Temp&Light limted u for 10 pops
plot(u_TLR_U_10,':k', 'LineWidth',1) % Temp,light&nutrient limited u for 10 pops
xlim([0 tfinal]);
%legend('T&L', 'T,L&R')
set(SP1, 'FontSize',10)
ylim([0 1.2]); % 1 Trait Sims
xticks(0:tick_space_interval:numdays);
set(SP1,'xticklabel',xtick_labels)  
set(SP1,'FontSize',11)
% FR_U --------------------------------------------
SP12 = subplot(3,4,2); 
SP12.Position = [x+L+a,y,L,H];
SP12.Box = 1;
SP12.ColorOrder = cmap2; 
SP12.NextPlot = 'replacechildren';
plot(u_TLRS_U_10(:,1:traits_10), 'LineWidth',0.75)
hold on
plot(avg_u_U_10,'k', 'Linewidth', 1.2)
xlim([0 tfinal]);
set(SP12, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP12,'xticklabel',xtick_labels)  
ylim([0 0.6]); % 1 Trait Sims
set(SP12,'FontSize',11)
% EST_U -------------------------------------------
SP13 = subplot(3,4,3); 
SP13.Position = [x+2*L+2*a,y,L,H];
SP13.Box = 1;
SP13.ColorOrder = cmap2; 
SP13.NextPlot = 'replacechildren';
plot(u_TLRS_U_10(:,traits_10+1:traits_10*2), 'LineWidth',0.75)
hold on
plot(avg_u_U_10,'k', 'Linewidth', 1.2)
xlim([0 tfinal]);
set(SP13, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP13,'xticklabel',xtick_labels)   
ylim([0 0.6]); % 1 Trait Sims
set(SP13,'FontSize',11)
% MAR_U---------------------------------------------
SP14 = subplot(3,4,4); 
SP14.Position = [x+3*L+3*a,y,L,H];
SP14.Box = 1;
SP14.ColorOrder = cmap2; 
SP14.NextPlot = 'replacechildren';
plot(u_TLRS_U_10(:,traits_10*2+1:traits_10*3), 'LineWidth',0.75)
hold on
plot(avg_u_U_10,'k', 'Linewidth', 1.2)
xlim([0 tfinal]);
set(SP14, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP14,'xticklabel',xtick_labels) 
ylim([0 0.6]);
set(SP14,'FontSize',11)
% MSABS ----------------------------------------------------------------
SP2 = subplot(3,4,5); 
SP2.Position = [x,y-b-H,L,H];
SP2.Box = 1;
SP2.ColorOrder = cmap2; 
SP2.NextPlot = 'replacechildren';
fill(xx,(yy.*0.002),grey,'EdgeColor',grey);
hold on
plot(u_TL_M_10, 'LineWidth',1.5) % Temp&Light limted u for 10 pops
plot(u_TLR_M_10,':k', 'LineWidth',1) % Temp,light&nutrient limited u for 10 pops
xlim([0 tfinal]);
ylim([0 1.2]); % 1 Trait Sims
set(SP2, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP2,'xticklabel',xtick_labels)  
set(SP2,'FontSize',11)
% FR_M -----------------------------------------
SP22 = subplot(3,4,6); 
SP22.Position = [x+L+a,y-b-H,L,H];
SP22.Box = 1;
SP22.ColorOrder = cmap2; 
SP22.NextPlot = 'replacechildren';
plot(u_TLRS_M_10(:,1:traits_10), 'LineWidth',0.75)
hold on
plot(avg_u_M_10,'k', 'Linewidth', 1.2)
xlim([0 tfinal]);
set(SP22, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP22,'xticklabel',xtick_labels) 
ylim([0 0.35]); % 1 Trait Sims
set(SP22,'FontSize',11)
% EST_M ----------------------------------------
SP23 = subplot(3,4,7); 
SP23.Position = [x+2*L+2*a,y-b-H,L,H];
SP23.Box = 1;
SP23.ColorOrder = cmap2; 
SP23.NextPlot = 'replacechildren';
plot(u_TLRS_M_10(:,traits_10+1:traits_10*2), 'LineWidth',0.75)
hold on
plot(avg_u_M_10,'k', 'Linewidth', 1.2)
xlim([0 tfinal]);
set(SP23, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP23,'xticklabel',xtick_labels) 
ylim([0 0.35]); % 1 Trait Sims
set(SP23,'FontSize',11)
 % MAR_M ---------------------------------------
SP24 = subplot(3,4,8);
SP24.Position = [x+3*L+3*a,y-b-H,L,H];
SP24.Box = 1;
SP24.ColorOrder = cmap2; 
SP24.NextPlot = 'replacechildren';
plot(u_TLRS_M_10(:,traits_10*2+1:traits_10*3), 'LineWidth',0.75)
hold on
plot(avg_u_M_10,'k', 'Linewidth', 1.2)
xlim([0 tfinal]);
set(SP24, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP24,'xticklabel',xtick_labels) 
ylim([0 0.35]); % 1 Trait Sims
set(SP24,'FontSize',11)
% LSABS --------------------------------------------------------------
SP3 = subplot(3,4,9); 
SP3.Position = [x,y-2*b-2*H,L,H];
SP3.Box = 1;
SP3.ColorOrder = cmap2; 
SP3.NextPlot = 'replacechildren';
fill(xx,(yy.*0.002),grey,'EdgeColor',grey);
hold on
plot(u_TL_L_10, 'LineWidth',1.5) % Temp&Light limted u for 10 pops
plot(u_TLR_L_10,':k', 'LineWidth',1) % Temp,light&nutrient limited u for 10 pops
xlim([0 tfinal]);
ylim([0 1.2]); % 1 Trait Sims
set(SP3, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP3,'xticklabel',xtick_labels) 
set(SP3,'FontSize',11)
% FR_L -----------------------------------------------
SP32 = subplot(3,4,10); 
SP32.Position = [x+L+a,y-2*b-2*H,L,H];
SP32.Box = 1;
SP32.ColorOrder = cmap2; 
SP32.NextPlot = 'replacechildren';
plot(u_TLRS_L_10(:,1:traits_10), 'LineWidth',0.75)
hold on
plot(avg_u_L_10,'k', 'Linewidth', 1.2)
xlim([0 tfinal]);
set(SP32, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP32,'xticklabel',xtick_labels)  
ylim([0 0.35]); % 1 Trait Sims
set(SP32,'FontSize',11)
% EST_L ----------------------------------------------
SP33 = subplot(3,4,11); 
SP33.Position = [x+2*L+2*a,y-2*b-2*H,L,H];
SP33.Box = 1;
SP33.ColorOrder = cmap2; 
SP33.NextPlot = 'replacechildren';
plot(u_TLRS_L_10(:,traits_10+1:traits_10*2), 'LineWidth',0.75)
hold on
plot(avg_u_L_10,'k', 'Linewidth', 1.2)
xlim([0 tfinal]);
set(SP33, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP33,'xticklabel',xtick_labels)  
ylim([0 0.35]); % 1 Trait Sims
set(SP33,'FontSize',11)
% MAR_L ----------------------------------------------
SP34 = subplot(3,4,12); 
SP34.Position = [x+3*L+3*a,y-2*b-2*H,L,H];
SP34.Box = 1;
SP34.ColorOrder = cmap2; 
SP34.NextPlot = 'replacechildren';
plot(u_TLRS_L_10(:,traits_10*2+1:traits_10*3), 'LineWidth',0.75)
hold on
plot(avg_u_L_10,'k', 'Linewidth', 1.2)
xlim([0 tfinal]);
set(SP34, 'FontSize',10)
xticks(0:tick_space_interval:numdays);
set(SP34,'xticklabel',xtick_labels)  
ylim([0 0.35]); % 1 Trait Sims
set(SP34,'FontSize',11)


% -------------------------------------------------------------------------
% Nutrients in each region vs. Empiricle data 
% Manuscript Figure S3
%--------------------------------------------------------------------------

% AMMONIUM
figure  
subplot(3,1,1);
plot(sum(Am_U_1,2),'k','LineWidth',1.5)
hold on
plot(sum(Am_U_10,2),'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_U_Am(:,1), comp_U_Am(:,2),'*','r')
xlim([0 numdays]);
ylim([0 10]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
set(gca,'FontSize',11)
%--------------------
subplot(3,1,2)
plot(sum(Am_M_1,2),'k','LineWidth',1.5)
hold on
plot(sum(Am_M_10,2),'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_M_Am(:,1), comp_M_Am(:,2),'*','r')
xlim([0 numdays]);
ylim([0 10]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
set(gca,'FontSize',11)
%--------------------
subplot(3,1,3)
plot(sum(Am_L_1,2),'k','LineWidth',1.5)
hold on
plot(sum(Am_L_10,2),'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_L_Am(:,1), comp_L_Am(:,2),'*','r')
xlim([0 numdays]);
ylim([0 10]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels) 
set(gca,'FontSize',11)
legend('v.poor', 'v.rich', 'Empirical',...
    'Location','northeast','FontSize', 8)%, 'Empiricle-Adj.');
%--------------------
% sgtitle('NH4');

% Nitrate+Nitrite
figure  
subplot(3,1,1);
plot(sum(NN_U_1,2),'k','LineWidth',1.5)
hold on
plot(sum(NN_U_10,2),'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_U_NN(:,1), comp_U_NN(:,2),'*','r')
xlim([0 numdays]);
ylim([0 200]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
set(gca,'FontSize',11)
% legend('v.poor', 'v.rich', 'Empirical',...
%     'Location','northeast','FontSize', 8)%, 'Empiricle-Adj.');
%--------------------
subplot(3,1,2)
plot(sum(NN_M_1,2),'k','LineWidth',1.5)
hold on
plot(sum(NN_M_10,2),'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_M_NN(:,1), comp_M_NN(:,2),'*','r')
xlim([0 numdays]);
ylim([0 200]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
set(gca,'FontSize',11)
%--------------------
subplot(3,1,3)
plot(sum(NN_L_1,2),'k','LineWidth',1.5)
hold on
plot(sum(NN_L_10,2),'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_M_NN(:,1), comp_M_NN(:,2),'*','r')
xlim([0 numdays]);
ylim([0 200]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels) 
set(gca,'FontSize',11)
%--------------------
% sgtitle('NN');

% SRP
figure  
subplot(3,1,1);
plot(sum(P_U_1,2),'k','LineWidth',1.5)
hold on
plot(sum(P_U_10,2),'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_U_SRP(:,1), comp_U_SRP(:,2),'*','r')
xlim([0 numdays]);
ylim([0 7]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
set(gca,'FontSize',11)
% legend('v.poor', 'v.rich', 'Empirical',...
%     'Location','northeast','FontSize', 8)%, 'Empiricle-Adj.');
%--------------------
subplot(3,1,2)
plot(sum(P_M_1,2),'k','LineWidth',1.5)
hold on
plot(sum(P_M_10,2),'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_M_SRP(:,1), comp_M_SRP(:,2),'*','r')
xlim([0 numdays]);
ylim([0 7]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels)   
set(gca,'FontSize',11)
%--------------------
subplot(3,1,3)
plot(sum(P_L_1,2),'k','LineWidth',1.5)
hold on
plot(sum(P_L_10,2),'LineWidth',1.5, 'Color',[0.0745 0.6235 1.0000])
scatter(comp_M_SRP(:,1), comp_M_SRP(:,2),'*','r')
xlim([0 numdays]);
ylim([0 7]);
xticks(0:tick_space_interval:numdays);
set(gca,'xticklabel',xtick_labels) 
set(gca,'FontSize',11)
%--------------------
% sgtitle('SRP');








