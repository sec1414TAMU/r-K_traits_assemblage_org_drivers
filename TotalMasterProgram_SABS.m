
% Master Program: The program runs multiple functions that 1) defines and 
% saves variables in structures for use by the diff. equation solver,
% 2) loads data required by model for simulation, 3) solves the defined 
% series of differential equations and returns a matrix (z) of daily 
% average solutions for each of the equations. 
% Coding by Sierra Cagle  2026

%--------------------------------------------------------------------------
% *USER* DEFINED     
%--------------------------------------------------------------------------

% PHYTO ASSEMBLAGE
% 0 = single trait based group
% 1 = 10 trait based groups
P.Traits = 0;

% NOTE: These are used in later model versions but left in place here to 
% reduce the necessity of code modification.
P.System = 0;
P.Input_Data = 0;
SimType = 0;
P.Ext = 0;

%--------------------------------------------------------------------------
% DEFINE ADDITIONAL PARAMETERS 
%--------------------------------------------------------------------------

% The function adds additional parameters that the model requires 
% to the stucture "P". These are parameters that are not editable in the 
% application.

P = Pstruct_params_func(P);

%--------------------------------------------------------------------------
% DEFINE DATA INPUTS (from text files) 
%--------------------------------------------------------------------------

% The function adds additional data from text files that the model requires 
% to the stucture "D".

D = Dstruct_data_func(P);

%--------------------------------------------------------------------------
% SET UP TO RUN SIMULATION           
%--------------------------------------------------------------------------

% Differential Eq. solver parameters
t0          = 0;  % time start
tfinal      = P.Num_days_sim;       
P.tspan     = (t0:tfinal);
% P.zin is set up in the P_struct 

%--------------------------------------------------------------------------
% RUN SIMULATION           
%--------------------------------------------------------------------------
            
zin   = P.zin;
tspan = P.tspan;
X     = 0;  % This is a dummy
[t,z] = ode45(@(t,z)DiffEq_func(t,z,P,D),tspan,zin);
      
%--------------------------------------------------------------------------
% INDEX each set of state variables and tracking variables
P.no_reg = 3;
P.index1 = (1:P.NoA*P.no_reg); % first:last phytoplankton column
P.index2 = (P.index1(end)+1:P.index1(end)+3*P.no_reg); % first:last nutrient col.
P.index3 = (P.index2(end)+1:P.index2(end)+3); % first:last Z col
if P.Traits == 1
    add = 150;
else
    add = 15; 
end
P.index7 = (P.index3(end)+1:P.index3(end)+add);% u-track columns for phyto
P.index8 = (P.index7(end)+1:P.index7(end)+3);% u-track columns for Z
P.index9 = (P.index8(end)+1:P.index8(end)+4);% tracking columns for Light
P.index10 = (P.index9(end)+1:P.index9(end)+6);% tracking columns for Z prod.

%--------------------------------------------------------------------------
% Pull VARIABLES NEEDED FOR FIGURES
A = z(:,P.index1);
Z = z(:,P.index3);
N = z(:,P.index2);
uA = z(:,P.index7);
I = z(:,P.index9);
Zprod = z(:,P.index10);
%--------------------------------------------------------------------------