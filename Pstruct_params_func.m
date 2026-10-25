
% This function adds additional parameters to the to the structure "P".
% These are parameters that are not editable in the application.
% Programming by Sierra Cagle (2020-2021)and Joydeb Batachayya (2016-2017)

function P = Pstruct_params_func(P)


%--------------------------------------------------------------------------
%  DEFINE LOOPS 
%--------------------------------------------------------------------------
    
P.Flow_mult_min = 1;     % Mininum multiplier of the flow regime
P.Flow_mult_max = 1;     % Maximum multiplier of the flow regime
P.Flow_incs     = 1;     % Number of loop increments

P.Nut_mult_min = 1;      % Mininum multiplier of the nutrient regime
P.Nut_mult_max = 1;      % Maximum multiplier of the nutrient regime
P.Nut_incs     = 1;      % Number of loop increments


%--------------------------------------------------------------------------
% Date Standardization & Number of Days for Run
%--------------------------------------------------------------------------

% Determine how many days the sim runs for
P.Cycles           = 1; 
P.Num_days_sim     = 845;

%--------------------------------------------------------------------------
% Misc. Parameter Values 
%--------------------------------------------------------------------------

P.depth_meas = 2;     % light is calculated at bay region average depth 
                      % divided by this value

%--------------------------------------------------------------------------
% CALIBRATED PARAMETER VALUES                        
%--------------------------------------------------------------------------

if P.Traits == 0   
    cal = [8.00E14, 0.55, 0.3, 0.1, 0.6, 0.5];   % Top middle
else  
    cal = [8.00E14, 0.5, 0.4, 0.1, 0.2, 0.8, 0.3, 2]; % Top middle
end
P.k_I       = cal(1); % Half-saturation coefficient for light limited growth (quanta cm-2 s-1).    
P.g_max     = cal(2); % Max grazing rate (10^6 cells/ind/d) - Kiorboe et al. 1985, 
P.u_g_slope = cal(3); % Growth-ingestion efficiency 
P.m         = cal(4); % Mortality rate (/d)
if P.Traits == 0
    % only parameterized for single trait group model
    P.E = cal(5);
    P.r = cal(6); 
else
    E_min = cal(5); % Population specific min of edibilty
    E_max = cal(6); % Population specific max of edibilty
    r_min = cal(7); % Population specific min. of max. growth rate
    r_max = cal(8); % Population specific max. of max. growth rate
end

%--------------------------------------------------------------------------
%  ALGAE
%--------------------------------------------------------------------------

P.sal_groups = 3;
if P.Traits == 1
    P.A_traits = 10;
else
    P.A_traits = 1;
end
P.NoA        = P.sal_groups*P.A_traits;

pi           = 3.1416;        
P.Cell_vol     = 64*pi/3;                     % (um)^3/cell  
P.C_cell     = P.Cell_vol^(0.76)/(10^(0.29)); % pg-C/cell (12.5291) 
                                            %  ^ = ug-C/10^6 cells   
P.Chla_C  = 1/83.14;                        % 0.012 (Chla/carbon)
P.Chla_cell  = P.Chla_C*P.C_cell;           % ug-chla/10^6 cells (0.1507)
P.C_cell_1   = P.C_cell/12.0107;            % umol-C/10^6 cells (1.0432)
P.Q_N_A      = 16*P.C_cell_1/(106);         % umol-N/10^6 cells (0.1575)
P.Q_P_A      = P.C_cell_1/(106);            % umol-P/10^6 cells (0.0098)
P.y   = 0.7;    % Preference: ammonium vs nitrate+nitrite    
P.Q10 = 1.47;   % Q-10 coef. (Sherman et al. 2016)

K_N_min    = 0.5;        % half sat. coef. N (uM)
K_N_max    = 3.0;        % half sat. coef. N (uM)
K_P_min    = 0.5;        % half sat. coef. P (uM)
K_P_max    = 3;          % half sat. coef. P (uM)      

% Genenerates the trait gradients for the many growth types sim   
if P.Traits == 1
    r1          = [r_min ,r_max];
    P.K_N1         = [K_N_min, K_N_max]; 
    P.K_P1         = [K_P_min, K_P_max]; 
    E1          = [E_min, E_max];
    % "polyfit" function enter (x,y,1). x&y = vectors.
    % "polyfit" returns: (1) slope and (2) x-intercept for linear fit 
    coef_K_N    = polyfit(r1,P.K_N1,1); 
    coef_K_P    = polyfit(r1,P.K_P1,1);
    coef_E      = polyfit(r1,E1,1);
    % Genenerates trait values based on the above function coefs and the
    % input r vector
    P.r      = linspace(r1(1),r1(2),P.A_traits);
    P.K_N    = coef_K_N(1)*P.r + coef_K_N(2);
    P.K_P    = coef_K_P(1)*P.r + coef_K_P(2);
    P.E      = coef_E(1)*P.r + coef_E(2); 
else
    P.K_N      = (K_N_max-K_N_min)/2;      
    P.K_P      = (K_P_max-K_P_min)/2;    
end

P.epsilon = 0.0000000001; % Numerical adjustment 

% Salinity Threshold Parameters for Phytoplankton
% Freshwater - growth decreases with increasing salinity
P.Max_sal_F = 1; 
% Estuarine - unimodal growth-salinity relationship
P.Min_sal_E = 2; 
P.Opt_sal_E = 19;
P.Max_sal_E = 20;
% Marine  - growth increases with salinity up to the maximum level
P.Min_sal_M = 20;
P.Max_sal_M = 35;

%--------------------------------------------------------------------------
%  GRAZER 
%--------------------------------------------------------------------------

P.K_g       = 6.3;     % 10^6 cells/L - derived from Kiorboe et al. 1985  
P.g_thresh  = 0.1;     % Grazing threshold (10^6 cells/L)
P.Q_NP_Z(1) = 0.0535;  % Fixed body comp. N (umole/indv)
P.Q_NP_Z(2) = 0.0018;  % Fixed body comp. P (umole/indv)            
P.z_vol     = 2.98e7;  % Zoopl biovol (um3, Kiorboe et al. 1985)

%--------------------------------------------------------------------------
%  Light 
%--------------------------------------------------------------------------

P.K_a = 0.0024; % Light attenuation by Chla (dcm^2/ugChla)
                % 0.024 m^2/mgChla    
P.K_t = 0.2;    % Background turbidity (dcm^-1)(pure water and tripton)   

I.pi      = pi;
I.K_a     = P.K_a;              % Light attenuation by Chla
I.depth   = 1;			        % Depth in meters
I.cloud   = 0.1;		        % Mean percent cloud cover (decimal)
Lat_d     = 30;		            % Latitude (degrees)
I.Lat_r   = Lat_d*pi/180;	    % Latitude (radians)
mean_Io   = 4.871E+6;           % Yearly mean solar constant (Joules/m2/hr)
I.mIo     = mean_Io*8.3932e+10; % convert units (quanta/cm2/s)
                 
% Calls the function "lightfunc2" which expects time to be in hours
% "L" is a structure holding the parameters needed for "lightfunc2"
Sim_hrs   = 24*(P.Num_days_sim);    % 20280 hours
for n = 1:Sim_hrs
  t = n;   
  % "P. Irrad(n)" holds hourly irradience, units are quanta/cm2/s
  % "lightfunc2" expects time in hours.
  P.Irrad(n) = lightfunc2(t,I);                                                               
end

%--------------------------------------------------------------------------
% Eddy Diffusion Rate 
%--------------------------------------------------------------------------

P.ED = 0.1; % Eddy diffusion rate at Upper-SABS 

% 1 m = 10 dcm and 1 m^2 = 100dcm^2
% 1m^3 = 1000Lt

% SABS measures
U_area        = 998489379.1;        % USABS area(dcm^2)
P.U_depth     = 10;                 % average depth(dcm)
M_area        = 18600791996.1;      % MSABS area(dcm^2)
P.M_depth     = 20;                 % Average depth(dcm)
L_area        = 14381830176.8;      % LSABS area(dcm^2)
P.L_depth     = 20;                 % Average depth(dcm)
P.int_UM      = 2000*10;            % Interface Upper-Middle (dcm)
P.int_ML      = 13100*10;           % Interface Middle-Lower (dcm)
P.int_L1      = 3000*10;            % Interface Lower- Adj Bay 1- Mes.(dcm)
P.int_L2      = 4300*10;            % Interface Lower- Adj Bay 2- Esp.(dcm)

P.U_vol   = U_area*P.U_depth;       % UXABS Vol = 9.9849e+09 (Lt)
P.M_vol   = M_area*P.M_depth;       % MXABS Vol = 3.7202e+11 (Lt)
P.L_vol   = L_area*P.L_depth;       % LXABS Vol = 2.8764e+11 (Lt)


%--------------------------------------------------------------------------
% INITIAL CONDITIONS
%--------------------------------------------------------------------------

% Initial algal concentration, x10^6 cells liter-1
U_chla_tot  = 10;   
M_chla_tot  = 40;
L_chla_tot  = 10;

U_default_tot  = U_chla_tot/P.Chla_cell;  
M_default_tot  = M_chla_tot/P.Chla_cell;
L_default_tot  = L_chla_tot/P.Chla_cell;

U_default  = U_default_tot/P.NoA;      
M_default  = M_default_tot/P.NoA;
L_default  = L_default_tot/P.NoA;

Ain_Upper = ones(1, P.NoA).*U_default;
Ain_Middle = ones(1, P.NoA).*M_default;
Ain_Lower = ones(1, P.NoA).*L_default;

P.Ain  = [Ain_Upper, Ain_Middle, Ain_Lower];

% Initial nutrient concentration for all nutrients, µM
R1in = [1,1,1];%[5.5, 90, 6.5];
R2in = [1,1,1];%[10, 50, 2];  
R3in = [1,1,1];%[0.75, 6, 0.5]; 

P.Rin = [R1in, R2in, R3in];

% Initial grazer concentration 
P.Zooin = [1,1,1];

% Initial condition for growth rate tracking (zdot31 and zdot32)
bay_regions = 3;
rates_tracked = 2;  
P.u_trk_31 = zeros(1,P.A_traits*bay_regions*rates_tracked);
P.u_trk_32 = zeros(1,P.NoA*bay_regions);

% Initial condition for Zoopl growth tracker (zdot33)
P.Z_trk = [0,0,0]; 
% Initial condition for light tracker (zdot36)
P.I_trk = zeros(1,4);
% Initial condition for trophic transfer tracker (zdot37)
P.T_trk = zeros(1,6); 


P.zin       = [P.Ain, P.Rin, P.Zooin,...
              P.u_trk_31, P.u_trk_32, P.Z_trk, P.I_trk, P.T_trk];  

%--------------------------------------------------------------------------

end



