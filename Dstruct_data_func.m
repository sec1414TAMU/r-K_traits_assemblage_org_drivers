
% This function loads empiricle data from text files and formats the 
% matrices so that they start and end on the same dates. The data matrices 
% are then added to the to the structure "D".
% Programming by Sierra Cagle (2020-2021)and Joydeb Batachayya (2016-2017)


function D = Dstruct_data_func(P)

%----------------------------------------------------------------------
% LOAD FILES
%----------------------------------------------------------------------

% Daily avg. salinity (ppt) - This data comes from the TCEQ TxBLEND 
% model and the files loaded holds 9862 days of data
U_sal = load('Avg_Salinity_Upper_SABS.txt'); 
M_sal = load('Avg_Salinity_Middle_SABS.txt');
L_sal = load('Avg_Salinity_Lower_SABS.txt');  
% Files run from:31778-41609 (9832 days) max:30.43, min:13.44
Temp = load('SABS_DailyTemp_MCheck.txt'); 
% Data from TCEQ SWQMIS for site 12578 which is just below the
% confluence of the San Antonio and Guadalupe Rivers
T = readtable('SWQMIS_SABS_River.xlsx','Sheet','swqmispublicdata_12578');
% parameter codes for Chla = 70953 (flourometric) and 32211 (spectrophoto.)
T_Chla1 = T(T.ParameterCode == 32211,:);
T_Chla2 = T(T.ParameterCode == 70953,:);
T_Chla = [T_Chla1; T_Chla2];
T_Chla = T_Chla(:,{'Date','Value'});
River_Chla = cell2mat(table2cell(T_Chla));
% Raw data from Roelke Lab - pulled by SEC.  
% Station numbers refer to the original study's 1-8 SABS stations.
% Files run from days 38053 to 38954 (but, Chla start day = 38088)
% The River Chla/nuts are from station 8, below confluence of the
% Guadalupe and SanAntonio Rivers. 
River_Amm    = load('SABS_River_RoelkeLab_St8_Amm_uM.txt'); 
River_Nx     = load('SABS_River_RoelkeLab_St8_NOx_uM.txt'); 
River_SRP    = load('SABS_River_RoelkeLab_St8_SRP_uM.txt');
AdjBay2_Chla = load('SABS_EspirituBay_RoelkeLab_St1_Chla_ugL-1.txt');          
% Discharge data from Guadalupe and SA Rivers(upriver of Roelke St8).
% Files run from 38088 to 38932. 
River_Disch_1    = load('River_Discharge(L)_GuadalupeRiver.txt'); 
River_Disch_2    = load('River_Discharge(L)_SARiver.txt'); 
% Find total river discharge
River_Disch      = River_Disch_1(:,1); %dates
River_Disch(:,2) = River_Disch_1(:,2) + River_Disch_2(:,2);    
% Mesquite Bay concentrations, monthly avg. (uM aka u mol/Lt)
% Files run from 31778-41639
AdjBay1_Chla = load('MesquiteBay_TCEQ_DailyChla_ugL-1.txt');
AdjBay1_Amm  = load('Mesquite_NH4_MCheck.txt'); 
AdjBay1_Nx   = load('Mesquite_NOx_MCheck.txt'); 
AdjBay1_SRP  = load('Mesquite_SRP_MCheck.txt'); 
% Espiritu Bay concentrations (uM aka u mol/Lt)
% Files run from 38053-38932, data from Roelke Lab
% AdjBay2_Chla loaded above (grouped with Roelke Lab data)
AdjBay2_Amm  = load('Espiritu_NH4_MCheck.txt'); 
AdjBay2_Nx   = load('Espiritu_NOx_MCheck.txt'); 
AdjBay2_SRP  = load('Espiritu_SRP_MCheck.txt');           
% Roelke Lab data for model response comparisons 
% Station numbers refer to the original study's 1-8 SABS stations:
% USABS = St 7, MSABS = Avg 4,5,6, LSABS = Avg 2&3
% All files run from 37987-39082
% Chla data 
comp_UXABS_Chla = load('Scatter_USABS_Chla_array.txt'); 
comp_MXABS_Chla = load('Scatter_MSABS_Chla_array.txt'); 
comp_LXABS_Chla = load('Scatter_LSABS_Chla_array.txt');
% DO Data 
comp_UXABS_DO = load('Scatter_USABS_DO_array.txt'); 
comp_MXABS_DO = load('Scatter_MSABS_DO_array.txt'); 
comp_LXABS_DO = load('Scatter_LSABS_DO_array.txt'); 
% NH4 Data 
comp_UXABS_Amm = load('Scatter_USABS_NH4_array.txt'); 
comp_MXABS_Amm = load('Scatter_MSABS_NH4_array.txt'); 
comp_LXABS_Amm = load('Scatter_LSABS_NH4_array.txt');  
% NOx Data 
comp_UXABS_NOx = load('Scatter_USABS_NOx_array.txt'); 
comp_MXABS_NOx = load('Scatter_MSABS_NOx_array.txt'); 
comp_LXABS_NOx = load('Scatter_LSABS_NOx_array.txt'); 
% SRP Data 
comp_UXABS_SRP = load('Scatter_USABS_SRP_array.txt'); 
comp_MXABS_SRP = load('Scatter_MSABS_SRP_array.txt'); 
comp_LXABS_SRP = load('Scatter_LSABS_SRP_array.txt'); 

%--------------------------------------------------------------------------
% Data Sample Date Standardizing 
% Note: here a smaller number = earlier date
%--------------------------------------------------------------------------

% Finds and stores the earliest date in each matrix
% Note: here a smaller number = earlier date
firstday = [Temp(1,1), AdjBay1_Chla(1,1),...
            AdjBay2_Chla(1,1), River_Disch(1,1), River_Amm(1,1),...
            River_Nx(1,1), River_SRP(1,1), AdjBay1_Amm(1,1),...
            AdjBay1_Nx(1,1), AdjBay1_SRP(1,1),...
            AdjBay2_Amm(1,1), AdjBay2_Nx(1,1), AdjBay2_SRP(1,1),...
            U_sal(1,1), M_sal(1,1), L_sal(1,1)];   
latest_firstday = max(firstday);                 
% Finds and stores the latest date in each matrix
lastday = [Temp(end,1), AdjBay1_Chla(end,1),...
           AdjBay2_Chla(end,1), River_Disch(end,1), River_Amm(end,1),...
           River_Nx(end,1), River_SRP(end,1), AdjBay1_Amm(end,1),...
           AdjBay1_Nx(end,1), AdjBay1_SRP(end,1),...
           AdjBay2_Amm(end,1), AdjBay2_Nx(end,1),...
           AdjBay2_SRP(end,1), U_sal(end,1), M_sal(end,1), L_sal(end,1)];  
earliest_lastday = min(lastday);    
% Puts all data matrices into a cell array (each matrix is put in a cell)
% This will allow us to call a data set in a "for" loop later
All_Data = {Temp, AdjBay1_Chla, AdjBay2_Chla, River_Disch,...
            River_Amm, River_Nx, River_SRP,...
            AdjBay1_Amm, AdjBay1_Nx, AdjBay1_SRP,... 
            AdjBay2_Amm, AdjBay2_Nx, AdjBay2_SRP,...
            U_sal, M_sal, L_sal};

% Stores first day of each data set
firstday_add = [River_Chla(1,1), comp_UXABS_Chla(1,1),...
                comp_MXABS_Chla(1,1), comp_LXABS_Chla(1,1),...
                comp_UXABS_DO(1,1), comp_MXABS_DO(1,1),...
                comp_LXABS_DO(1,1),comp_UXABS_Amm(1,1),...
                comp_MXABS_Amm(1,1), comp_LXABS_Amm(1,1),...
                comp_UXABS_NOx(1,1), comp_MXABS_NOx(1,1),...
                comp_LXABS_NOx(1,1), comp_UXABS_SRP(1,1),...
                comp_MXABS_SRP(1,1), comp_LXABS_SRP(1,1)];
firstday = [firstday, firstday_add];
latest_firstday = max(firstday);    
% Stores last day of each data set
lastday_add = [River_Chla(end,1), comp_UXABS_Chla(end,1),...
               comp_MXABS_Chla(end,1), comp_LXABS_Chla(end,1),...
               comp_UXABS_DO(end,1), comp_MXABS_DO(end,1),...
               comp_LXABS_DO(end,1),comp_UXABS_Amm(end,1),...
               comp_MXABS_Amm(end,1), comp_LXABS_Amm(end,1),...
               comp_UXABS_NOx(end,1), comp_MXABS_NOx(end,1),...
               comp_LXABS_NOx(end,1), comp_UXABS_SRP(end,1),...
               comp_MXABS_SRP(end,1), comp_LXABS_SRP(end,1)];
lastday = [lastday, lastday_add];
earliest_lastday = min(lastday);  
% Adds data sets to data array
All_Data_add = {River_Chla, comp_UXABS_Chla,...
        comp_MXABS_Chla, comp_LXABS_Chla, comp_UXABS_DO,... 
        comp_MXABS_DO, comp_LXABS_DO, comp_UXABS_Amm,... 
        comp_MXABS_Amm, comp_LXABS_Amm, comp_UXABS_NOx,... 
        comp_MXABS_NOx, comp_LXABS_NOx, comp_UXABS_SRP,... 
        comp_MXABS_SRP, comp_LXABS_SRP};
All_Data = [All_Data,All_Data_add]; 
   

% Finds and deletes cells that fall BEFORE the latest first day in each
% data set held in the cell array
for i = 1:length(firstday)
    % if i==14 
    % end
    if firstday(i) < latest_firstday % (ex: FD=38053 and LFD=38088)
        % Pulls one of the data sets from the cell array and converts 
        % it to type mat 
        delete_from = All_Data{i};  
        % Finds the row number of the targeted first day (latest_first_day)
        % in the selected data set
        deletion_marker = find(delete_from(:,1) == latest_firstday);
        if isempty(deletion_marker)
            for j=1:length(delete_from)
                check = delete_from(j,1);
                if check > latest_firstday
                    deletion_marker = find(delete_from(:,1) == check);
                    break
                end
            end
        end        
    
        % This uses the marker created to delete the cells that are before
        % the targeted date (latest first date)
        delete_from(1:(deletion_marker-1),:) = [];
        % This puts the edited matrix back in the cell array with other
        % data matrices
        All_Data{i} = delete_from;    
    end
end

% Finds and deletes cells that fall AFTER the earliest last day
% The loop works similarly to the one above
for i = 1:length(lastday)
    if lastday(i) > earliest_lastday
        delete_from = All_Data{i};
        deletion_marker = find(delete_from(:,1) == earliest_lastday);   
        if isempty(deletion_marker)
            for j=1:length(delete_from)
                check = delete_from(j,1);
                if check > earliest_lastday
                    deletion_marker = find(delete_from(:,1) == check)-1;
                    break
                end
            end
        end
        delete_from((deletion_marker+1):end,:) = [];
        All_Data{i} = delete_from; 
    end
end

% Puts standardized date data back into number format
Temp          = All_Data{1};
AdjBay1_Chla  = All_Data{2};
AdjBay2_Chla  = All_Data{3};
River_Chla1   = All_Data{17};
River_Chla    = [River_Chla1;River_Chla(160,:)];
River_Disch   = All_Data{4};
River_Amm     = All_Data{5};
River_Nx      = All_Data{6};
River_SRP     = All_Data{7};
AdjBay1_Amm   = All_Data{8};
AdjBay1_Nx    = All_Data{9};
AdjBay1_SRP   = All_Data{10};
AdjBay2_Amm   = All_Data{11};
AdjBay2_Nx    = All_Data{12};
AdjBay2_SRP   = All_Data{13};
U_sal         = All_Data{14};
M_sal         = All_Data{15};
L_sal         = All_Data{16};

% Additional data needed for comparison graphs
D.comp_UXABS_Chla = All_Data{18};
D.comp_MXABS_Chla = All_Data{19};
D.comp_LXABS_Chla = All_Data{20};
D.comp_UXABS_DO   = All_Data{21};
D.comp_MXABS_DO   = All_Data{22};
D.comp_LXABS_DO   = All_Data{23}; 
D.comp_UXABS_Amm  = All_Data{24};
D.comp_MXABS_Amm  = All_Data{25};
D.comp_LXABS_Amm  = All_Data{26}; 
D.comp_UXABS_NOx  = All_Data{27};
D.comp_MXABS_NOx  = All_Data{28};
D.comp_LXABS_NOx  = All_Data{29}; 
D.comp_UXABS_SRP  = All_Data{30};
D.comp_MXABS_SRP  = All_Data{31};
D.comp_LXABS_SRP  = All_Data{32}; 


%--------------------------------------------------------------------------
% Manipulate Raw Data Sets (applies to only some of these loaded data sets)
%-------------------------------------------------------------------------- 

% Data that needs daily values interpolated gets placed in a structure
% and then passed to the function below
I.River_Chla       = River_Chla;
I.River_Amm        = River_Amm;
I.River_Nx         = River_Nx;
I.River_SRP        = River_SRP;
I.AdjBay2_Chla     = AdjBay2_Chla;        
% Function interpolates data points between sampling dates using a 
% linear function between contigous sample points.
% Output: Is a cell array - each cell holds and a data set array 
% {1}River Chla, {2}Amm, {3}Nx, {4}SRP, and {5} Espiritu Bay Chla
D.Interpolated_Data = Data_Interp(I, P);          
River_Chla   = D.Interpolated_Data{1};
River_Amm    = D.Interpolated_Data{2};
River_Nx     = D.Interpolated_Data{3};
River_SRP    = D.Interpolated_Data{4};
AdjBay2_Chla = D.Interpolated_Data{5};
  
%--------------------------------------------------------------------------
% Final Data Set Formatting 
%--------------------------------------------------------------------------   

% Removes the first column (date) from the standardized arrays 
D.Temp         = Temp(:,2); 
D.River_Chla   = River_Chla(:,2); 
D.River_Amm    = River_Amm(:,2);
D.River_Nx     = River_Nx(:,2);
D.River_SRP    = River_SRP(:,2);
D.AdjBay1_Chla = AdjBay1_Chla(:,2); 
D.AdjBay1_Amm  = AdjBay1_Amm(:,2);
D.AdjBay1_Nx   = AdjBay1_Nx(:,2);
D.AdjBay1_SRP  = AdjBay1_SRP(:,2);
D.AdjBay2_Chla = AdjBay2_Chla(:,2);
D.AdjBay2_Amm  = AdjBay2_Amm(:,2);
D.AdjBay2_Nx   = AdjBay2_Nx(:,2);
D.AdjBay2_SRP  = AdjBay2_SRP(:,2);
D.River_Disch  = River_Disch(:,2);
D.U_sal        = U_sal(:,2);
D.M_sal        = M_sal(:,2);
D.L_sal        = L_sal(:,2);

%--------------------------------------------------------------------------
%  Temp and Discharge Related
%--------------------------------------------------------------------------

% Calculates the temperature based algae growth rate
opt_temp = 30.5; % Assume the phyto reach their max growth rate at max 
                        % temp for this data (30.43)
for i=1:length(D.Temp)
    c = (D.Temp(i)-opt_temp)/10;
    D.u_T(i,:) = P.r.*(P.Q10^c);
end

% Units are 1/day (River discharge(L/day)/USBAS vol(L))
D.U_D = D.River_Disch / P.U_vol; 
D.M_D = D.River_Disch / P.M_vol;
D.L_D = D.River_Disch / P.L_vol;

end
