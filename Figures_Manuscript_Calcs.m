
% Coding by Sierra Cagle  2026
% NOTE: uses presaved variables!

% Dummys entered to allow P struct to be created
P.System = 0;
P.Input_Data = 0;
P.Traits = 1; %This does need to be 1 for calcs
P.Ext = 0;

P = Pstruct_params_func(P);

D = Dstruct_data_func(P);

t0          = 0;  
tfinal      = P.Num_days_sim;       
P.tspan     = (t0:tfinal);

%--------------------------------------------------------------------------
% These use model responses from both modules 1 and 2 that were previously
% saved from simulations run for each model.
%--------------------------------------------------------------------------

load('1_A.mat'); % A
load('1_Z.mat'); % Z
load('1_N.mat'); % N
load('1_uA.mat'); % uA
load('1_I.mat'); % I
load('1_prodZ.mat'); % Zprod
A_1 = A;
Z_1 = Z;
N_1 = N;
uA_1 = uA;
I_1 = I;
Zprod_1 = Zprod;

load('10_A.mat'); % A
load('10_Z.mat'); % Z
load('10_N.mat'); % N
load('10_uA.mat'); % uA
load('10_I.mat'); % I
load('10_prodZ.mat'); % Zprod
A_10 = A;
Z_10 = Z;
N_10= N;
uA_10 = uA;
I_10 = I;
Zprod_10 = Zprod;

numdays = length(P.tspan);
regions = 3;
traits_1 = 1;
traits_10 = 10;
NoA_1 = 3;
NoA_10 = 30;

%--------------------------------------------------------------------------
% Calculated with loaded data 
%--------------------------------------------------------------------------

% Calculate the specific growth rates from the z matrix
for i = 1:numdays
    if i==1
        u_track_1(i,:) = uA_1(1,:);
        u_track_10(i,:) = uA_10(1,:);
    else
        u_track_1(i,:) = uA_1(i,:)-uA_1(i-1,:);
        u_track_10(i,:) = uA_10(i,:)-uA_10(i-1,:);
    end
end

% u_track column order:
% light-lim-U (10), light-lim-M (10), light-lim-L (10), 
% NPL-min-U (10), NPL-min-M (10), NPL-min-L (10), Sal-F-U (10), Sal-M-U (10),
% Sal-M-U (10), Sal-F-M (10), Sal-M-M (10), Sal-M-M (10), Sal-F-L (10), 
% Sal-M-L (10), Sal-M-L (10)

% Temp and Light limited (TL) 10/region
u_TL_1   = u_track_1(:,1:regions*traits_1);
u_TL_U_1 = u_TL_1(:,1:traits_1);
u_TL_M_1 = u_TL_1(:,traits_1+1:traits_1*2);
u_TL_L_1 = u_TL_1(:,traits_1*2+1:traits_1*3);
%
u_TL_10   = u_track_10(:,1:regions*traits_10);
u_TL_U_10 = u_TL_10(:,1:traits_10);
u_TL_M_10 = u_TL_10(:,traits_10+1:traits_10*2);
u_TL_L_10 = u_TL_10(:,traits_10*2+1:traits_10*3);

% TL and Resource limited (TLR) 10/region
u_TLR_1   = u_track_1(:,regions*traits_1+1:regions*traits_1*2);
u_TLR_U_1 = u_TLR_1(:,1:traits_1);
u_TLR_M_1 = u_TLR_1(:,traits_1+1:traits_1*2);
u_TLR_L_1 = u_TLR_1(:,traits_1*2+1:traits_1*3);
%
u_TLR_10   = u_track_10(:,regions*traits_10+1:regions*traits_10*2);
u_TLR_U_10 = u_TLR_10(:,1:traits_10);
u_TLR_M_10 = u_TLR_10(:,traits_10+1:traits_10*2);
u_TLR_L_10 = u_TLR_10(:,traits_10*2+1:traits_10*3);

% TLR and Salinity limited (TLRS) 30/region
u_TLRS_1   = u_track_1(:,regions*traits_1*2+1:end);
u_TLRS_U_1 = u_TLRS_1(:,1:NoA_1);
u_TLRS_M_1 = u_TLRS_1(:,NoA_1+1:NoA_1*2);
u_TLRS_L_1 = u_TLRS_1(:,NoA_1*2+1:NoA_1*3);
%
u_TLRS_10   = u_track_10(:,regions*traits_10*2+1:end);
u_TLRS_U_10 = u_TLRS_10(:,1:NoA_10);
u_TLRS_M_10 = u_TLRS_10(:,NoA_10+1:NoA_10*2);
u_TLRS_L_10 = u_TLRS_10(:,NoA_10*2+1:NoA_10*3);

% Assemblage average SPECIFIC growth rates (avg u) 
avg_u_U_10 = mean(u_TLRS_U_10,2);
avg_u_M_10 = mean(u_TLRS_M_10,2);
avg_u_L_10 = mean(u_TLRS_L_10,2);
% 
avg_u_U_1 = mean(u_TLRS_U_1,2);
avg_u_M_1 = mean(u_TLRS_M_1,2);
avg_u_L_1 = mean(u_TLRS_L_1,2);

% Pull out cell density data for each region and convert to Chla
cells_U_1 = A_1(:,1:NoA_1);
cells_M_1 = A_1(:,NoA_1+1:2*NoA_1);
cells_L_1 = A_1(:,2*NoA_1+1:3*NoA_1);
Chla_U_1 = cells_U_1.*P.C_cell.*P.Chla_C;
Chla_M_1 = cells_M_1.*P.C_cell.*P.Chla_C;
Chla_L_1 = cells_L_1.*P.C_cell.*P.Chla_C;
%
cells_U_10 = A_10(:,1:NoA_10);
cells_M_10 = A_10(:,NoA_10+1:2*NoA_10);
cells_L_10 = A_10(:,2*NoA_10+1:3*NoA_10);
Chla_U_10 = cells_U_10.*P.C_cell.*P.Chla_C;
Chla_M_10 = cells_M_10.*P.C_cell.*P.Chla_C;
Chla_L_10 = cells_L_10.*P.C_cell.*P.Chla_C;

% Calculate the average assemblage MAXIMUM growth rate (avg r)
r10 = P.r;
r30 = [r10,r10,r10];
U_rAVG_10 = sum(cells_U_10.*r30./sum(cells_U_10,2),2);
M_rAVG_10 = sum(cells_M_10.*r30./sum(cells_M_10,2),2);
L_rAVG_10 = sum(cells_L_10.*r30./sum(cells_L_10,2),2);
%
r1 = 0.5;
U_rAVG_1 = ones(1,numdays).*r1;
M_rAVG_1 = ones(1,numdays).*r1;
L_rAVG_1 = ones(1,numdays).*r1;

% Calculate the average assemblage E
E10 = P.E;
E30 = [E10,E10,E10];
E_AVG_U_10 = sum(cells_U_10.*E30./sum(cells_U_10,2),2);
E_AVG_M_10 = sum(cells_M_10.*E30./sum(cells_M_10,2),2);
E_rAVG_L_10 = sum(cells_L_10.*E30./sum(cells_L_10,2),2);
%
E1 = 0.6;
E_AVG_U_1 = ones(1,numdays).*E1;
E_AVG_M_1 = ones(1,numdays).*E1;
E_AVG_L_1 = ones(1,numdays).*E1;

% Each region Chla broken by salinity group
Chla_U_1_F = sum(Chla_U_1(:,1),2);
Chla_U_1_E = sum(Chla_U_1(:,2),2);
Chla_U_1_M = sum(Chla_U_1(:,3),2);
Chla_M_1_F = sum(Chla_M_1(:,1),2);
Chla_M_1_E = sum(Chla_M_1(:,2),2);
Chla_M_1_M = sum(Chla_M_1(:,3),2);
Chla_L_1_F = sum(Chla_L_1(:,1),2);
Chla_L_1_E = sum(Chla_L_1(:,2),2);
Chla_L_1_M = sum(Chla_L_1(:,3),2);
%
Chla_U_10_F = sum(Chla_U_10(:,1:traits_10),2);
Chla_U_10_E = sum(Chla_U_10(:,traits_10+1:traits_10*2),2);
Chla_U_10_M = sum(Chla_U_10(:,traits_10*2+1:traits_10*3),2);
Chla_M_10_F = sum(Chla_M_10(:,1:traits_10),2);
Chla_M_10_E = sum(Chla_M_10(:,traits_10+1:traits_10*2),2);
Chla_M_10_M = sum(Chla_M_10(:,traits_10*2+1:traits_10*3),2);
Chla_L_10_F = sum(Chla_L_10(:,1:traits_10),2);
Chla_L_10_E = sum(Chla_L_10(:,traits_10+1:traits_10*2),2);
Chla_L_10_M = sum(Chla_L_10(:,traits_10*2+1:traits_10*3),2);

% Empiricle data renamed and dates formatted to as 1...n
comp_UXABS_Chla = D.comp_UXABS_Chla;
comp_MXABS_Chla = D.comp_MXABS_Chla;
comp_LXABS_Chla = D.comp_LXABS_Chla;
comp_UXABS_Chla(:,1) = comp_UXABS_Chla(:,1)-comp_UXABS_Chla(1,1);
comp_MXABS_Chla(:,1) = comp_MXABS_Chla(:,1)-comp_MXABS_Chla(1,1);
comp_LXABS_Chla(:,1) = comp_LXABS_Chla(:,1)-comp_LXABS_Chla(1,1);

% Model Chla averaged around empiricle data points
finder = ~isnan(comp_LXABS_Chla(:,2));
targets = comp_LXABS_Chla(finder,1)+1;
win = [-3,-2,-1,0,1,2,3];
CT_U_10 = sum(Chla_U_10,2);
CT_U_1 = sum(Chla_U_1,2);
CT_M_10 = sum(Chla_M_10,2);
CT_M_1 = sum(Chla_M_1,2);
CT_L_10 = sum(Chla_L_10,2);
CT_L_1 = sum(Chla_L_1,2);
for i = 1:length(targets)
    target = targets(i);
    if target == 1
        target1 = win(4:end)+target; 
    elseif target > numdays-3
        target0 = numdays-target; 
        finder1 = find(win == target0);
        win1 = win(1:finder1);
        target1 = win1+target; 
    else
        target1 = win+target; 
    end
    M_U_10(i) = mean(CT_U_10(target1));
    M_U_1(i) = mean(CT_U_1(target1));
    M_M_10(i) = mean(CT_M_10(target1));
    M_M_1(i) = mean(CT_M_1(target1));
    M_L_10(i) = mean(CT_L_10(target1));
    M_L_1(i) = mean(CT_L_1(target1));
end

% Pull out zooplankton density for each region
Z_U_1 = Z_1(:,1);
Z_M_1 = Z_1(:,2);
Z_L_1 = Z_1(:,3);
%
Z_U_10 = Z_10(:,1);
Z_M_10 = Z_10(:,2);
Z_L_10 = Z_10(:,3);

%Nutrient Loading
%Nutrient Loading
disch = (D.River_Disch);
Amm_load = D.River_Amm.*disch;
Nx_load = D.River_Nx.*disch;
SRP_load = D.River_SRP.*disch;

% % Locate Peaks in Discharge
% figure
% findpeaks(disch, MinPeakProminence = 0.1e11);%,Annotate="extents",WidthReference="halfheight")

% Locate Peaks in Density-weighted assemblage-avgerage r
[pks_U,locs_p_U,w_U,p_U] = findpeaks(U_rAVG_10,MinPeakHeight=1.16, MinPeakProminence=.02);
[pks_M,locs_p_M,w_M,p_M] = findpeaks(M_rAVG_10,MinPeakHeight=1.16, MinPeakProminence=.01);
[pks_L,locs_p_L,w_L,p_L] = findpeaks(L_rAVG_10,MinPeakHeight=1.16, MinPeakProminence=.01);
% Locate Valleys in Density-weighted assemblage-avgerage r
[vls1_U,locs_v1_U,w1_U,p1_U] = findpeaks(-U_rAVG_10,MinPeakHeight=-1.13, MinPeakProminence=.03,MinPeakDistance=21);
[vls1_M,locs_v1_M,w1_M,p1_M] = findpeaks(-M_rAVG_10,MinPeakHeight=-1.13, MinPeakProminence=.03);
[vls1_L,locs_v1_L,w1_L,p1_L] = findpeaks(-L_rAVG_10,MinPeakHeight=-1.13, MinPeakProminence=.03);

% Add event at end that function couldnt find
locs_v_U = [locs_v1_U;numdays-1]; 
locs_v_M = [locs_v1_M;numdays-1]; 
locs_v_L = [locs_v1_L;numdays-1]; 
vls_U = [vls1_U;-U_rAVG_10(numdays-1)];
vls_M = [vls1_M;-M_rAVG_10(numdays-1)];
vls_L = [vls1_L;-L_rAVG_10(numdays-1)];

% Combine and sort events in chronological order
events_U = sort([locs_p_U;locs_v_U])';
events_M = sort([locs_p_M;locs_v_M])';
events_L = sort([locs_p_L;locs_v_L])';

% Add average r at the time of event
events_U(2,:) = U_rAVG_10(events_U(1,:));
events_M(2,:) = M_rAVG_10(events_M(1,:));
events_L(2,:) = L_rAVG_10(events_L(1,:));

cum = 28;
% Calculate cumulative discharge prior to event
for i = 1:length(events_U)
    events_U(3,i) = sum(disch(events_U(1,i)-cum:events_U(1,i)));
end
for i = 1:length(events_M)
    events_M(3,i) =sum(disch(events_M(1,i)-cum:events_M(1,i)));
end
for i = 1:length(events_L)
    events_L(3,i) = sum(disch(events_L(1,i)-cum:events_L(1,i)));
end
% Calculate cumulative SRP load prior to event
for i = 1:length(events_U)
    events_U(4,i) = sum(SRP_load(events_U(1,i)-cum:events_U(1,i)));
end
for i = 1:length(events_M)
    events_M(4,i) =sum(SRP_load(events_M(1,i)-cum:events_M(1,i)));
end
for i = 1:length(events_L)
    events_L(4,i) = sum(SRP_load(events_L(1,i)-cum:events_L(1,i)));
end
% Calculate average zooplankton density prior to event and convert to um3
for i = 1:length(events_U)
    Zm_U = mean(Z_U_10(events_U(1,i)-cum:events_U(1,i)));
    events_U(5,i) = Zm_U.*P.z_vol;
end
for i = 1:length(events_M)
    Zm_M = mean(Z_M_10(events_M(1,i)-cum:events_M(1,i)));
    events_M(5,i) = Zm_M.*P.z_vol;
end
for i = 1:length(events_L)
    Zm_L = mean(Z_L_10(events_L(1,i)-cum:events_L(1,i)));
    events_L(5,i) = Zm_L.*P.z_vol;
end

% Nutrients
Am_10 = N_10(:,[1,4,7]);
Am_U_10 = Am_10(:,1);
Am_M_10 = Am_10(:,2); 
Am_L_10 = Am_10(:,3); 
NN_10 = N_10(:,[2,5,8]);
NN_U_10 = NN_10(:,1);
NN_M_10 = NN_10(:,2); 
NN_L_10 = NN_10(:,3); 
P_10 = N_10(:,[3,6,9]);
P_U_10 = P_10(:,1);
P_M_10 = P_10(:,2); 
P_L_10 = P_10(:,3); 
%
Am_1 = N_1(:,[1,4,7]);
Am_U_1 = Am_1(:,1);
Am_M_1 = Am_1(:,2); 
Am_L_1 = Am_1(:,3); 
NN_1 = N_1(:,[2,5,8]);
NN_U_1 = NN_1(:,1);
NN_M_1 = NN_1(:,2); 
NN_L_1 = NN_1(:,3); 
P_1 = N_1(:,[3,6,9]);
P_U_1 = P_1(:,1);
P_M_1 = P_1(:,2); 
P_L_1 = P_1(:,3); 

% NH4 Data 
comp_U_Am = D.comp_UXABS_Amm; 
comp_M_Am = D.comp_MXABS_Amm;
comp_L_Am = D.comp_LXABS_Amm;  
% NOx Data 
comp_U_NN = D.comp_UXABS_NOx;
comp_M_NN = D.comp_MXABS_NOx; 
comp_L_NN = D.comp_LXABS_NOx; 
% SRP Data 
comp_U_SRP = D.comp_UXABS_SRP;
comp_M_SRP = D.comp_MXABS_SRP;
comp_L_SRP = D.comp_LXABS_SRP;
% Formatting: this gives the date (ex:38088) as a simulated day (ex:1)
comp_U_Am(:,1) = comp_U_Am(:,1)-comp_U_Am(1,1);
comp_M_Am(:,1) = comp_M_Am(:,1)-comp_M_Am(1,1);
comp_L_Am(:,1) = comp_L_Am(:,1)-comp_L_Am(1,1);
comp_U_NN(:,1) = comp_U_NN(:,1)-comp_U_NN(1,1);
comp_M_NN(:,1) = comp_M_NN(:,1)-comp_M_NN(1,1);
comp_L_NN(:,1) = comp_L_NN(:,1)-comp_L_NN(1,1);
comp_U_SRP(:,1) = comp_U_SRP(:,1)-comp_U_SRP(1,1);
comp_M_SRP(:,1) = comp_M_SRP(:,1)-comp_M_SRP(1,1);
comp_L_SRP(:,1) = comp_L_SRP(:,1)-comp_L_SRP(1,1);

% Resource Use Efficiency 
Q_P_A = P.Q_P_A;  % 0.0098 uM P / 10^6 cells
CC = P.C_cell;  % 12.5291 ug-Carbon/cells*10e6 

% Calculate RUE_Biomass_P 
RUE2_U_P_10 = log(sum(cells_U_10,2).*CC./(sum(cells_U_10,2).*Q_P_A+P_U_10));
RUE2_M_P_10 = log(sum(cells_M_10,2).*CC./(sum(cells_M_10,2).*Q_P_A+P_M_10));
RUE2_L_P_10 = log(sum(cells_L_10,2).*CC./(sum(cells_L_10,2).*Q_P_A+P_L_10));
RUE2_U_P_1 = log(sum(cells_U_1,2).*CC./(sum(cells_U_1,2).*Q_P_A+P_U_1));
RUE2_M_P_1 = log(sum(cells_M_1,2).*CC./(sum(cells_M_1,2).*Q_P_A+P_M_1));
RUE2_L_P_1 = log(sum(cells_L_1,2).*CC./(sum(cells_L_1,2).*Q_P_A+P_L_1));

% Trophic Transfer Efficiency
% Zooplankton converted to vol (um3)
Zv_U_1 = Z_U_1.*P.z_vol;
Zv_M_1 = Z_M_1.*P.z_vol;
Zv_L_1 = Z_L_1.*P.z_vol;
%
Zv_U_10 = Z_U_10.*P.z_vol;
Zv_M_10 = Z_M_10.*P.z_vol;
Zv_L_10 = Z_L_10.*P.z_vol;

% Z biovol/Cells biovol
TE_U_10 = log(Zv_U_10./sum(cells_U_10,2).*P.Cell_vol);
TE_M_10 = log(Zv_M_10./sum(cells_M_10,2).*P.Cell_vol);
TE_L_10 = log(Zv_L_10./sum(cells_L_10,2).*P.Cell_vol);
TE_U_1 = log(Zv_U_1./sum(cells_U_1,2).*P.Cell_vol);
TE_M_1 = log(Zv_M_1./sum(cells_M_1,2).*P.Cell_vol);
TE_L_1 = log(Zv_L_1./sum(cells_L_1,2).*P.Cell_vol);