
% This function called by the Master Program "TotalMasterProgram_SABS".   
% It contains the diff. equations and suporting mathmatical equations. 
% Notation: U for Upper, M for Middle, L for Lower SABS 
% Fr for Freswater, Est for Estuarine, Mar for Marine phyto populations


function zdot = DiffEq_func(t,z,P,D)

%--------------------------------------------------------------------------
% DEFINE INDEX BASED ON t
%--------------------------------------------------------------------------
    
if(t==0)
    t_i = 1;
else
    t_i = ceil(t); % This pushes up to next whole number (eg 2.2->3)
end

%--------------------------------------------------------------------------
% PARAMETERS PULLED FROM L, P, D STRUCTURES
%--------------------------------------------------------------------------
% Values defined in Master Program - called here to remove the "P." so
% that the variable is searchable.
y           = P.y;
k_I         = P.k_I;
ED          = P.ED;
g_max       = P.g_max;
m           = P.m;   
Kt          = P.K_t;
Ka          = P.K_a;
g_thresh    = P.g_thresh;  
u_g_slope   = P.u_g_slope;
Q_N_A       = P.Q_N_A;
Q_P_A       = P.Q_P_A;
Q_NP_Z      = P.Q_NP_Z;
E           = P.E;
K_N         = P.K_N;
K_P         = P.K_P; 
A_traits    = P.A_traits;
u_T_all     = D.u_T;    
Irrad       = P.Irrad;
depth_meas  = P.depth_meas;
depth_U     = P.U_depth;
depth_M     = P.M_depth;
depth_L     = P.L_depth;
vol_U       = P.U_vol;
vol_M       = P.M_vol;
vol_L       = P.L_vol;
int_UM_length = P.int_UM;            
int_ML_length = P.int_ML;            
int_L1_length = P.int_L1;             
int_L2_length = P.int_L2; 
C_cell      = P.C_cell;
epsilon     = P.epsilon;
D_U         = D.U_D(t_i);
D_M         = D.M_D(t_i);
D_L         = D.L_D(t_i);  
K_g         = P.K_g;       
sal_U       = D.U_sal(t_i); 
sal_M       = D.M_sal(t_i); 
sal_L       = D.L_sal(t_i); 
Max_sal_F   = P.Max_sal_F;
Min_sal_E   = P.Min_sal_E;
Opt_sal_E   = P.Opt_sal_E;
Max_sal_E   = P.Max_sal_E;
Min_sal_M   = P.Min_sal_M;
Max_sal_M   = P.Max_sal_M;
Chla_River  = D.River_Chla(t_i);
Amm_River   = D.River_Amm(t_i);
NN_River    = D.River_Nx(t_i);
P_River     = D.River_SRP(t_i);
Chla_Mes = D.AdjBay1_Chla(t_i);
Amm_Mes  = D.AdjBay1_Amm(t_i);
NN_Mes   = D.AdjBay1_Nx(t_i);
P_Mes    = D.AdjBay1_SRP(t_i);
Chla_Esp = D.AdjBay2_Chla(t_i);
Amm_Esp  = D.AdjBay2_Amm(t_i);
NN_Esp   = D.AdjBay2_Nx(t_i);
P_Esp    = D.AdjBay2_SRP(t_i);

%--------------------------------------------------------------------------
% SPLIT UP INCOMING INFORMATION
%--------------------------------------------------------------------------

A_U(1,:) = z(1:A_traits)';              % Upper region, Freshwater algea
A_U(2,:) = z(A_traits+1:A_traits*2)';   % Upper region, Estuarine algea
A_U(3,:) = z(A_traits*2+1:A_traits*3)'; % Upper region, Marine algea

A_M(1,:) = z(A_traits*3+1:A_traits*4)'; % Middle region, Freshwater algea
A_M(2,:) = z(A_traits*4+1:A_traits*5)'; % Middle region, Estuarine algea
A_M(3,:) = z(A_traits*5+1:A_traits*6)'; % Middle region, Marine algea

A_L(1,:) = z(A_traits*6+1:A_traits*7)'; % Lower region, Freshwater algea
A_L(2,:) = z(A_traits*7+1:A_traits*8)'; % Lower region, Estuarine algea
A_L(3,:) = z(A_traits*8+1:A_traits*9)'; % Lower region, Marine algea

R_U	= z(A_traits*9+1:A_traits*9+3)';    % Resources in Upper SABS
R_M	= z(A_traits*9+4:A_traits*9+6)';    % Resources in Middle SABS
R_L	= z(A_traits*9+7:A_traits*9+9)';    % Resources in Lower SABS

Z_U = z(A_traits*9+16)';                % Zoopl in Upper SABS
Z_M = z(A_traits*9+17)';                % Zoopl in Middle SABS
Z_L = z(A_traits*9+18)';                % Zoopl in Lower SABS

%--------------------------------------------------------------------------
% NUMERICAL TRICK   Keep this control check, sometimes Monod overshoots
%--------------------------------------------------------------------------

for i=1:length(R_U)   
    R_U(i) = max(R_U(i), 1E-6);
	R_M(i) = max(R_M(i), 1E-6);
	R_L(i) = max(R_L(i), 1E-6);
end

[l,w] = size(A_U);
for i=1:l*w  
    A_U(i) = max(A_U(i), 1E-6);
    A_M(i) = max(A_M(i), 1E-6);
    A_L(i) = max(A_L(i), 1E-6);  
end

Z_U    = max(Z_U, 0.000000001);
Z_M    = max(Z_M, 0.000000001);
Z_L    = max(Z_L, 0.000000001);


%--------------------------------------------------------------------------
% CALCULATE Chla/Cell 
%--------------------------------------------------------------------------
    
% Value from MUMPS.v1 (ug/ug)
Chla_C_U = 0.012;   
Chla_C_M = 0.012;  
Chla_C_L = 0.012;   
% (ug-Chla/ug-C)*(ugC/10^6cells) = ug-Chla/10^6cells
Chla_cell_U = Chla_C_U * C_cell; 
Chla_cell_M = Chla_C_M * C_cell;
Chla_cell_L = Chla_C_L * C_cell;

%--------------------------------------------------------------------------
% Convert Incomming Chla to Cells
%--------------------------------------------------------------------------

Cell_River = ones(1,P.A_traits).*Chla_River/Chla_cell_U/P.A_traits; % All Fresh
Cell_Mes   = ones(1,P.A_traits).*Chla_Mes/Chla_cell_L/P.A_traits*2; % Estuarine & Marine
Cell_Esp   = ones(1,P.A_traits).*Chla_Esp/Chla_cell_L/P.A_traits*2; % Estuarine & Marine

%--------------------------------------------------------------------------
% LIGHT AT MID-DEPTH 
%--------------------------------------------------------------------------

if(t == 0)    
    I0 = Irrad(1);   
else 
    % Converts t to an hour in the simulation
    hours = floor(t)*24+ceil((t-floor(t))*24);
    % Finds value in "Irrad" vector for the correct hour
    I0 = Irrad(hours);    
end

% Sums algae populations in each bay region
A_sum_U = sum(sum(A_U));
A_sum_M = sum(sum(A_M));
A_sum_L = sum(sum(A_L));

% Calculate light attenuation based on algae in each bay region
Ka_U = Chla_cell_U.*A_sum_U.*Ka;
Ka_M = Chla_cell_M.*A_sum_M.*Ka;
Ka_L = Chla_cell_L.*A_sum_L.*Ka;

% Calculate light attenuation based on CDOM concentration 
% Set to ZERO here
if P.Ext == 0
    Kc_U = 0;
    Kc_M = 0;
    Kc_L = 0;
end

% Calculate light in each bay region
light_U = I0.*exp(-(depth_U/depth_meas)*(Ka_U+Kt+Kc_U)); 
light_M = I0*exp(-(depth_M/depth_meas)*(Ka_M+Kt+Kc_M));
light_L = I0*exp(-(depth_L/depth_meas)*(Ka_L+Kt+Kc_L));

% Tracks light
z36dot = [light_U/10E16, light_M/10E16, light_L/10E16, I0/10E16];
% I0 is divided by 10e16 to keep the model from blowing up when it can't
% meet error tolerances due to surface irradience.

%--------------------------------------------------------------------------
% ALGAE GROWTH RATE - Determines temp limited growth rate
%--------------------------------------------------------------------------

% Pull the temp limited growth rates for a given day
u_T = u_T_all(t_i,:);

%--------------------------------------------------------------------------
% ALGAE GROWTH RATE - Determines nutrient (N&P) limited growth rates 
%--------------------------------------------------------------------------

% Note: growth rates for different species are held in columns and the 
% different resource are seperated by rows in below

% Determines NH4 and NOx limited growth with prefrence (Y) considered.
N_monod_U = (y.*R_U(1)+(1-y).*R_U(2))./(K_N+y.*R_U(1)+(1-y).*R_U(2));       
N_monod_M = (y.*R_M(1)+(1-y).*R_M(2))./(K_N+y.*R_M(1)+(1-y).*R_M(2));         
N_monod_L = (y.*R_L(1)+(1-y).*R_L(2))./(K_N+y.*R_L(1)+(1-y).*R_L(2)); 

% Stores all the N limited growth rates in row 1 of u_TRL
u_TRL_U(1,:) = u_T.*N_monod_U;   
u_TRL_M(1,:) = u_T.*N_monod_M;       
u_TRL_L(1,:) = u_T.*N_monod_L;

% Determines the P limited growth rate
P_monod_U = R_U(3)./(K_P+R_U(3)); 
P_monod_M = R_M(3)./(K_P+R_M(3)); 
P_monod_L = R_L(3)./(K_P+R_L(3)); 

% Stores all the P limited growth rates in row 2 of u_TRL
u_TRL_U(2,:) = u_T.*P_monod_U;   
u_TRL_M(2,:) = u_T.*P_monod_M;       
u_TRL_L(2,:) = u_T.*P_monod_L;

%--------------------------------------------------------------------------
% ALGAE GROWTH RATE - Determines light limited growth rate 
%--------------------------------------------------------------------------

% Stores all the light limited growth rates in row 3 of u_TRL
u_TRL_U(3,:) = u_T.*(light_U./(epsilon+k_I+light_U));
u_TRL_M(3,:) = u_T.*(light_M./(epsilon+k_I+light_M));
u_TRL_L(3,:) = u_T.*(light_L./(epsilon+k_I+light_L));

%--------------------------------------------------------------------------
% ALGAE GROWTH RATE - Chooses min of nutrient vs light limited growth rates 
%--------------------------------------------------------------------------

% Note: returns the min for each column
umin_U = min(u_TRL_U);
umin_M = min(u_TRL_M);
umin_L = min(u_TRL_L);

% Creates a matrix that stores growthrates and reports them in the z matix
% light and min of nutrients and light
% There are 10 populations in each variable (60 total) or 1 each (6 total)
z31dot = [u_TRL_U(3,:), u_TRL_M(3,:), u_TRL_L(3,:),...
          umin_U, umin_M, umin_L];

%--------------------------------------------------------------------------
% ALGAE GROWTH RATE - Determines salinity limited growth rate
%--------------------------------------------------------------------------

sal_all = [sal_U, sal_M, sal_L];
umin_all = [umin_U;
            umin_M;
            umin_L];
% Freshwater species
for i = 1:3
    if sal_all(i) <= Max_sal_F
        u_Fr(i,:) = umin_all(i,:).*((sal_all(i)-Max_sal_F)/Max_sal_F)^2 ;
    else
        u_Fr(i,:) = umin_all(i,:).*0;
    end
end
% Estuarine species
for i = 1:3
    if sal_all(i) > Min_sal_E  &&  sal_all(i) < Opt_sal_E
        u_Est(i,:) = umin_all(i,:).*sqrt((sal_all(i)-Min_sal_E)/(Opt_sal_E-Min_sal_E)) ;
    elseif sal_all(i) > Opt_sal_E  &&  sal_all(i)<Max_sal_E
        u_Est(i,:) = umin_all(i,:).*sqrt((Max_sal_E-sal_all(i))/(Max_sal_E-Opt_sal_E)) ;
    else
        u_Est(i,:) = umin_all(i,:).*0;
    end
end
% Marine species
for i = 1:3
    if sal_all(i) <= Max_sal_M  &&  sal_all(i) >= Min_sal_M
        u_Mar(i,:) = umin_all(i,:).*sqrt((sal_all(i)-Min_sal_M)/(Max_sal_M-Min_sal_M)) ;
    else
        u_Mar(i,:) = umin_all(i,:).*0;
    end
end

u_U(1,:) = u_Fr(1,:);
u_U(2,:) = u_Est(1,:);
u_U(3,:) = u_Mar(1,:);
u_M(1,:) = u_Fr(2,:);
u_M(2,:) = u_Est(2,:);
u_M(3,:) = u_Mar(2,:);
u_L(1,:) = u_Fr(3,:);
u_L(2,:) = u_Est(3,:);
u_L(3,:) = u_Mar(3,:);

% There are 10 populations in each variable (90 total) or 1 each (9 total)
z32dot = [u_Fr(1,:),u_Est(1,:),u_Mar(1,:),u_Fr(2,:),u_Est(2,:),...
            u_Mar(2,:),u_Fr(3,:),u_Est(3,:),u_Mar(3,:)];

%--------------------------------------------------------------------------
% Zooplankton Growth Rate
%--------------------------------------------------------------------------
        
% Proportion each phyto. pop. makes up of total density 
% Total algae density "A_sum" is calculated above
A_prop_U = A_U./A_sum_U;    
A_prop_M = A_M./A_sum_M;     
A_prop_L = A_L./A_sum_L;  

% This determines if it is day or night and sets the max grazing rate
% to zero if it is day (surface irradience(IO) > 1e5)
if I0<1e5 %This is what Dan used in his code for Roelke(2002) 
    g_max_I0 = g_max; % Grazing ON
    loss_coef = 1;    % Dilution/diffusion losses ON
else
    g_max_I0 = 0; % Grazing OFF
    loss_coef = 1; % Dilution/diffusion losses ON
end

% Potential grazing on each phyto. pop.(10^6cells/indv/day)
g_pot_U = g_max_I0*((A_sum_U-g_thresh)/(K_g+A_sum_U));
g_pot_M = g_max_I0*((A_sum_M-g_thresh)/(K_g+A_sum_M));
g_pot_L = g_max_I0*((A_sum_L-g_thresh)/(K_g+A_sum_L));

% Species specific grazing rate (10^6cells/indv/day)
g_spec_U = E.*g_pot_U.*A_prop_U; 
g_spec_M = E.*g_pot_M.*A_prop_M; 
g_spec_L = E.*g_pot_L.*A_prop_L;

% Zooplankton rate of N ingestion (umol indv-1 day-1)
slop = 0;
Ingest_U(1) = sum(sum(g_spec_U.*Q_N_A))*(1-slop);            
Ingest_M(1) = sum(sum(g_spec_M.*Q_N_A))*(1-slop); 
Ingest_L(1) = sum(sum(g_spec_L.*Q_N_A))*(1-slop); 

% Zooplankton rate of P ingestion (umol indv-1 day-1)
Ingest_U(1,2) = sum(sum(g_spec_U.*Q_P_A))*(1-slop);
Ingest_M(1,2) = sum(sum(g_spec_M.*Q_P_A))*(1-slop);            
Ingest_L(1,2) = sum(sum(g_spec_L.*Q_P_A))*(1-slop);            

% rate of N&P converted to zoopl. biomass (d-1)
u_Z_U_NP = Ingest_U./Q_NP_Z*u_g_slope;                    
u_Z_M_NP = Ingest_M./Q_NP_Z*u_g_slope;                    
u_Z_L_NP = Ingest_L./Q_NP_Z*u_g_slope; 

% Use 'Law of Minimum' (d-1)
u_Z_U = min(u_Z_U_NP);     
u_Z_M = min(u_Z_M_NP);     
u_Z_L = min(u_Z_L_NP); 

% For tracking the growth rate
z33dot = [u_Z_U, u_Z_M, u_Z_L];

% Term for algal losses in differential equations (10^6 cells d-1 L-1)
g_loss_U = g_spec_U.*Z_U; 
g_loss_M = g_spec_M.*Z_M;
g_loss_L = g_spec_L.*Z_L;

% Tracking for zooplankton production
z37dot = [u_Z_U*Z_U, u_Z_M*Z_M, u_Z_L*Z_L, sum(sum(A_U.*u_U)), sum(sum(A_M.*u_M)), sum(sum(A_L.*u_L))];

%--------------------------------------------------------------------------
% Zooplankton Egestion
%--------------------------------------------------------------------------

% Calculates nutrients ingested that are in excess of zooplankton body 
% composition (umol L-1 day-1). "Cycle_back(1)" goes into the NH4 pool
% and "Cycle_back(2)" goes into the SRP pool. 

% Upper Region
if u_Z_U_NP(1) > u_Z_U_NP(2) %Case when N is in excess                     
    Cycle_back_U(1)= Z_U*(Ingest_U(1) - (Ingest_U(2)*(Q_NP_Z(1)/Q_NP_Z(2))));
    Cycle_back_U(2)= 0;
else %Case when P is in excess
    Cycle_back_U(1)= 0;  
    Cycle_back_U(2)= Z_U*(Ingest_U(2) - (Ingest_U(1)*(Q_NP_Z(2)/Q_NP_Z(1))));
end
% Middle Region
if u_Z_M_NP(1) > u_Z_M_NP(2)  %Case when N is in excess                       
    Cycle_back_M(1)= Z_M*(Ingest_M(1) - (Ingest_M(2)*(Q_NP_Z(1)/Q_NP_Z(2))));
    Cycle_back_M(2)= 0;
else %Case when P is in excess
    Cycle_back_M(1)= 0;
    Cycle_back_M(2)= Z_M*(Ingest_M(2) - (Ingest_M(1)*(Q_NP_Z(2)/Q_NP_Z(1))));
end
% Lower Region
if u_Z_L_NP(1) > u_Z_L_NP(2)   %Case when N is in excess                     
    Cycle_back_L(1)= Z_L*(Ingest_L(1) - (Ingest_L(2)*(Q_NP_Z(1)/Q_NP_Z(2))));
    Cycle_back_L(2)= 0;
else %Case when P is in excess
    Cycle_back_L(1)= 0;
    Cycle_back_L(2)= Z_L*(Ingest_L(2) - (Ingest_L(1)*(Q_NP_Z(2)/Q_NP_Z(1))));
end

%--------------------------------------------------------------------------
% Eddy Diffusion Terms for Differential Equations
%--------------------------------------------------------------------------
int_UM_area = (depth_U+depth_M)/2*int_UM_length; 
int_ML_area = (depth_M+depth_L)/2*int_ML_length; 
int_L1_area = depth_L*int_L1_length;
int_L2_area = depth_L*int_L2_length;

% ED (USER DEFINED, 1/d) = velocity (m/d) * interface (m2) / vol_U (m3)
ED_UX_U = ED; 
% assume velocity (m/d) is the same at all interfaces in a system!
v = ED_UX_U*vol_U/int_UM_area;     
ED_UM_M = ED_UX_U*vol_U/vol_M;  % Between U & M, effecting M

ED_ML_M = v*int_ML_area/vol_M; % Between M & L, effecting M
ED_ML_L = v*int_ML_area/vol_L; % Between M & L, effecting L
ED_L1_L = v*int_L1_area/vol_L; % Between L & adjbay1, effecting L
ED_L2_L = v*int_L2_area/vol_L; % Between L & adjbay2, effecting L

% Upper Region 
ED_z123 = ED_UX_U.*(A_M - A_U);  
ED_z10  = ED_UX_U.*(R_M(1) - R_U(1));      
ED_z11  = ED_UX_U.*(R_M(2) - R_U(2));
ED_z12  = ED_UX_U.*(R_M(3) - R_U(3)); 
ED_z25  = ED_UX_U*loss_coef*(Z_M - Z_U);

% Middle Region  
ED_z456 = ED_UM_M.*(A_U-A_M) + ED_ML_M.*(A_L-A_M);  
ED_z13  = ED_UM_M*(R_U(1)-R_M(1)) + ED_ML_M*(R_L(1)-R_M(1));  
ED_z14  = ED_UM_M*(R_U(2)-R_M(2)) + ED_ML_M*(R_L(2)-R_M(2));  
ED_z15  = ED_UM_M*(R_U(3)-R_M(3)) + ED_ML_M*(R_L(3)-R_M(3));  
ED_z26  = ED_UM_M*loss_coef*(Z_U-Z_M) + ED_ML_M*loss_coef*(Z_L-Z_M);  
D_z456  = D_M.*(A_U-A_M);
D_z13   = D_M*(R_U(1)-R_M(1)); 
D_z14   = D_M*(R_U(2)-R_M(2)); 
D_z15   = D_M*(R_U(3)-R_M(3));  
D_z26   = D_M*loss_coef*(Z_U-Z_M);

% Lower Region  
ED_z7  = ED_ML_L.*(A_M-A_L);
ED_z89 = ED_ML_L.*(A_M-A_L) + ED_L1_L.*(Cell_Mes-A_L) + ED_L2_L.*(Cell_Esp-A_L);  
ED_z16 = ED_ML_L*(R_M(1)-R_L(1)) + ED_L1_L*(Amm_Mes-R_L(1)) + ED_L2_L*(Amm_Esp-R_L(1)); 
ED_z17 = ED_ML_L*(R_M(2)-R_L(2)) + ED_L1_L*(NN_Mes-R_L(2)) + ED_L2_L*(NN_Esp-R_L(2)); 
ED_z18 = ED_ML_L*(R_M(3)-R_L(3)) + ED_L1_L*(P_Mes-R_L(3)) + ED_L2_L*(P_Esp-R_L(3)); 
ED_z27 = ED_ML_L*loss_coef*(Z_M-Z_L); 
D_z789 = D_L.*(A_M-A_L);
D_z16  = D_L*(R_M(1)-R_L(1)); 
D_z17  = D_L*(R_M(2)-R_L(2)); 
D_z18  = D_L*(R_M(3)-R_L(3));  
D_z27  = D_L*loss_coef*(Z_M-Z_L);

%--------------------------------------------------------------------------
% DIFFERENTIAL EQUATIONS  - core equations that are same for all systems
%--------------------------------------------------------------------------

% Upper Region 
% Growth equation of Algae (z1dot has # elements equal to # species)
z1dot = D_U.*(Cell_River-A_U(1,:)) + A_U(1,:).*u_U(1,:) - g_loss_U(1,:) + ED_z123(1,:); 
z2dot = -D_U.*A_U(2,:) + A_U(2,:).*u_U(2,:) - g_loss_U(2,:) + ED_z123(2,:); 
z3dot = -D_U.*A_U(3,:) + A_U(3,:).*u_U(3,:) - g_loss_U(3,:) + ED_z123(3,:); 
% Ammonium-equation 
z10dot = D_U*(Amm_River-R_U(1)) + Cycle_back_U(1) - R_U(1)./(epsilon+R_U(1)+R_U(2))*y*sum(Q_N_A.*sum(u_U.*A_U)) + ED_z10;      
% Nitrate-Nitrite equation 
z11dot = D_U*(NN_River-R_U(2)) - R_U(2)./(epsilon+R_U(1)+R_U(2))*(1-y)*sum(Q_N_A.*sum(u_U.*A_U)) + ED_z11; 
% SRP-equation
z12dot = D_U*(P_River-R_U(3)) + Cycle_back_U(2) - sum(Q_P_A.*sum(u_U.*A_U)) + ED_z12;         
% Growth equation of Zooplankton
z25dot = Z_U*(u_Z_U-m-loss_coef*D_U)  +  ED_z25; 

% Middle Region 
% Growth equation of Algae (z2dot has # elements equal to # species)
z4dot = A_M(1,:).*u_M(1,:) - g_loss_M(1,:) + ED_z456(1,:) + D_z456(1,:);
z5dot = A_M(2,:).*u_M(2,:) - g_loss_M(2,:) + ED_z456(2,:) + D_z456(2,:);
z6dot = A_M(3,:).*u_M(3,:) - g_loss_M(3,:) + ED_z456(3,:) + D_z456(3,:);
% Ammonium-equation 
z13dot = Cycle_back_M(1) - R_M(1)./(epsilon+R_M(1)+R_M(2))*y*sum(Q_N_A.*sum(u_M.*A_M)) + ED_z13 + D_z13;     
% Nitrate-Nitrite equation 
z14dot = -R_M(2)./(epsilon+R_M(1)+R_M(2))*(1-y)*sum(Q_N_A.*sum(u_M.*A_M)) + ED_z14 + D_z14; 
% SRP-equation
z15dot = Cycle_back_M(2) - sum(Q_P_A.*sum(u_M.*A_M)) + ED_z15 + D_z15;        
% Growth equation of Zooplankton
z26dot = Z_M*(u_Z_M-m) + ED_z26 + D_z26; 

% Lower Region ---------------------------
% Growth equation of Algae (z3dot has # elements equal to # species)
z7dot = A_L(1,:).*u_L(1,:) - g_loss_L(1,:) + ED_z7(1,:) + D_z789(1,:);
z8dot = A_L(2,:).*u_L(2,:) - g_loss_L(2,:) + ED_z89(2,:) + D_z789(2,:);
z9dot = A_L(3,:).*u_L(3,:) - g_loss_L(3,:) + ED_z89(3,:) + D_z789(3,:);
% Ammonium-equation 
z16dot = Cycle_back_L(1) - R_L(1)./(epsilon+R_L(1)+R_L(2))*y*sum(Q_N_A.*sum(u_L.*A_L))+ ED_z16 + D_z16;
% Nitrate-Nitrite equation 
z17dot = -R_L(2)./(epsilon+R_L(1)+R_L(2))*(1-y)*sum(Q_N_A.*sum(u_L.*A_L))+ ED_z17 + D_z17;
% SRP-equation 
z18dot = Cycle_back_L(2) - sum(Q_P_A.*sum(u_L.*A_L)) + ED_z18 + D_z18;      
% Growth equation of Zooplankton
z27dot = Z_L*(u_Z_L-m) + ED_z27 + D_z27;

zdot=[z1dot,z2dot,z3dot,z4dot,z5dot,z6dot,z7dot,z8dot,z9dot,z10dot,...
      z11dot,z12dot,z13dot,z14dot,z15dot,z16dot,z17dot,z18dot,...
      z25dot,z26dot,z27dot,...
      z31dot,z32dot,z33dot, z36dot, z37dot]';  
end

% Notes:

% Upper SABS = z1, z2, z3, z10, z11, z12, z25
% Middle SABS = z4, z5, z6, z13, z14, z15, z26
% Lower SABS = z7, z8, z9, z16, z17, z18, z27

% Tracking growth rates - phyto = z31, z32
% Tracking growth rates - zoopl = z33
% Tracking Light = z36
% Tracking transfer efficiency = z37

% z1:z9 = all phyto, each z holds fresh, estuarine, and marine species
% z10, z13, z16 = Ammonium
% z11, z14, z17 = Nitrate/Nitrite
% z12, z15, z18 = Phosphate
% z25, z26, z27 = zooplankton pops 
% z31 = growth rate tracking
% z32 = growth rate tracking





