
function Interpolated_Data = Data_Interp(I,P)

if P.System == 0

     River_Chla = I.River_Chla;
     River_Amm = I.River_Amm;
     River_Nx = I.River_Nx;
     River_SRP = I.River_SRP;
     EspBay_Chla = I.AdjBay2_Chla;
    % Interpolate daily data points for Chla 
    day_first = River_Chla(1,1); 
    day_last = River_Chla(end,1); 
    day_total = day_last - day_first;
    % Create an empty maxtrix to hold existing and interpolated data
    River_Interp_Chla = zeros(day_total,2);
    % Adds existing data to empty matrix
    for i=1:length(River_Chla)
        % Converts first row date to a day (ex: 38088 to 1)
        date_to_day_Chla = River_Chla(i,1)-day_first+1; 
        % Puts dates in corrects column of new matrix
        River_Interp_Chla(date_to_day_Chla,1)= River_Chla(i,1);
        % Puts data in correct column of new matrix
        River_Interp_Chla(date_to_day_Chla,2)= River_Chla(i,2);
    end
    
    % Saved for figure creation to check interpolation
    River_Chla_Record = River_Interp_Chla(:,2);
        for i=1:length(River_Chla_Record)
            if River_Chla_Record(i)== 0
               River_Chla_Record(i)= NaN; 
            end
        end
        
    % Adds interpolated data to matrix
    for i=1:length(River_Chla)-1
        % Shifts the two sampling points that we need to determine the slope
        % between so that the first point is located at(0,0)
        x2 = River_Chla(i+1,1) - River_Chla(i,1);
        y2 = River_Chla(i+1,2) - River_Chla(i,2);
        slope = y2/x2; % (rise/run)
        % Fills in the daily data between two points using the created function 
        for j=1:River_Chla(i+1) - River_Chla(i) % Days between sample points
            location = River_Chla(i)-River_Chla(1)+1; % row to start filling
            River_Interp_Chla(location+j,2) = River_Chla(i,2)+j*slope;
        end
    end
    
    % Interpolate daily data points for Amm 
    day_first = River_Amm(1,1); 
    day_last = River_Amm(end,1); 
    day_total = day_last - day_first;
    River_Interp_Amm = zeros(day_total,2);
    for i=1:length(River_Amm)
        date_to_day_Amm = River_Amm(i,1)-day_first+1;
        River_Interp_Amm(date_to_day_Amm,1)= River_Amm(i,1);
        River_Interp_Amm(date_to_day_Amm,2)= River_Amm(i,2);
    end
    for i=1:length(River_Amm)-1
        x2 = River_Amm(i+1,1) - River_Amm(i,1);
        y2 = River_Amm(i+1,2) - River_Amm(i,2);
        slope = y2/x2;
        for j=1:River_Amm(i+1) - River_Amm(i)
            location = River_Amm(i)-River_Amm(1)+1;
            River_Interp_Amm(location+j,2) = River_Amm(i,2)+j*slope;
        end
    end
    
    % Interpolate daily data points for Nx 
    day_first = River_Nx(1,1); 
    day_last = River_Nx(end,1);
    day_total = day_last - day_first;
    River_Interp_Nx = zeros(day_total,2);
    for i=1:length(River_Nx)
        date_to_day_Nx = River_Nx(i,1)-day_first+1;
        River_Interp_Nx(date_to_day_Nx,1)= River_Nx(i,1);
        River_Interp_Nx(date_to_day_Nx,2)= River_Nx(i,2);
    end
    for i=1:length(River_Nx)-1
        % x1 and y1 are (0,0)
        x2 = River_Nx(i+1,1) - River_Nx(i,1);
        y2 = River_Nx(i+1,2) - River_Nx(i,2);
        slope = y2/x2;
        for j=1:River_Nx(i+1) - River_Nx(i)
            location = River_Nx(i)-River_Nx(1)+1;
            River_Interp_Nx(location+j,2) = River_Nx(i,2)+j*slope;
        end
    end
       
    % Interpolate daily data points for SRP 
    day_first = River_SRP(1,1); 
    day_last = River_SRP(end,1); 
    day_total = day_last - day_first;
    River_Interp_SRP = zeros(day_total,2);
    for i=1:length(River_SRP)
        date_to_day_SRP = River_SRP(i,1)-day_first+1;
        River_Interp_SRP(date_to_day_SRP,1)= River_SRP(i,1);
        River_Interp_SRP(date_to_day_SRP,2)= River_SRP(i,2);
    end
    for i=1:length(River_SRP)-1
        x2 = River_SRP(i+1,1) - River_SRP(i,1);
        y2 = River_SRP(i+1,2) - River_SRP(i,2);
        slope = y2/x2; 
        for j=1:River_SRP(i+1) - River_SRP(i) 
            location = River_SRP(i)-River_SRP(1)+1; 
            River_Interp_SRP(location+j,2) = River_SRP(i,2)+j*slope;
        end
    end

    % Interpolate daily data points for Espiritu Chla 
    day_first = EspBay_Chla(1,1); 
    day_last = EspBay_Chla(end,1); 
    day_total = day_last - day_first;
    % Create an empty maxtrix to hold existing and interpolated data
    EspBay_Interp_Chla = zeros(day_total,2);
    % Adds existing data to empty matrix
    for i=1:length(EspBay_Chla)
        % Converts first row date to a day (ex: 38088 to 1)
        date_to_day_Chla = EspBay_Chla(i,1)-day_first+1; 
        % Puts dates in corrects column of new matrix
        EspBay_Interp_Chla(date_to_day_Chla,1)= EspBay_Chla(i,1);
        % Puts data in correct column of new matrix
        EspBay_Interp_Chla(date_to_day_Chla,2)= EspBay_Chla(i,2);
    end
    for i=1:length(EspBay_Chla)-1
        x2 = EspBay_Chla(i+1,1) - EspBay_Chla(i,1);
        y2 = EspBay_Chla(i+1,2) - EspBay_Chla(i,2);
        slope = y2/x2; 
        location = EspBay_Chla(i)-EspBay_Chla(1)+1; 
        for j=1:EspBay_Chla(i+1) - EspBay_Chla(i) 
            EspBay_Interp_Chla(location+j,2) = EspBay_Chla(i,2)+j*slope;
        end
    end
    
    % The final interpolated data sets are put in a cell array - each cell 
    % holds a vector of type double - and handed back to the Dstruct function
    Interpolated_Data{1} = River_Interp_Chla;
    Interpolated_Data{2} = River_Interp_Amm;
    Interpolated_Data{3} = River_Interp_Nx;
    Interpolated_Data{4} = River_Interp_SRP;
    Interpolated_Data{5} = EspBay_Interp_Chla;
    Interpolated_Data{6} = River_Chla_Record;

else %CABS SYSTEM ---------------------------------------------------------
 
     if P.Input_Data == 0 || 2

        comp_UXABS_Chla = I.comp_UXABS_Chla;    
        comp_UXABS_DO   = I.comp_UXABS_DO;
        comp_UXABS_Amm  = I.comp_UXABS_Amm;
        comp_UXABS_NOx  = I.comp_UXABS_NOx;
        comp_UXABS_SRP  = I.comp_UXABS_SRP;
   
        % Interpolate daily data points for Chla 
        day_first = comp_UXABS_Chla(1,1); 
        day_last = comp_UXABS_Chla(end,1); 
        day_total = day_last - day_first;
        % Create an empty maxtrix to hold existing and interpolated data
        comp_UXABS_Interp_Chla = zeros(day_total,2);
        comp_UXABS_Interp_Chla(:,2) = comp_UXABS_Interp_Chla(:,2).*nan;
        % Adds existing data to empty matrix 
        for i=1:length(comp_UXABS_Chla)
            % Converts first row date to a day (ex: 38088 to 1)
            date_to_day_Chla = comp_UXABS_Chla(i,1)-day_first+1; 
            % Puts dates in corrects column of new matrix
            comp_UXABS_Interp_Chla(date_to_day_Chla,1)= comp_UXABS_Chla(i,1);
            % Puts data in correct column of new matrix
            comp_UXABS_Interp_Chla(date_to_day_Chla,2)= comp_UXABS_Chla(i,2);
        end 
        days = [day_first:1:day_last]';
        comp_UXABS_Interp_Chla = [days,comp_UXABS_Interp_Chla(:,2)];
     
    
        % Interpolate daily data points for DO 
        day_first = comp_UXABS_DO(1,1); 
        day_last = comp_UXABS_DO(end,1); 
        day_total = day_last - day_first;
        % Create an empty maxtrix to hold existing and interpolated data
        comp_UXABS_Interp_DO = zeros(day_total,2);
        comp_UXABS_Interp_DO(:,2) = comp_UXABS_Interp_DO(:,2).*nan;
        % Adds existing data to empty matrix
        for i=1:length(comp_UXABS_DO)
            % Converts first row date to a day (ex: 38088 to 1)
            date_to_day_DO = comp_UXABS_DO(i,1)-day_first+1; 
            % Puts dates in corrects column of new matrix
            comp_UXABS_Interp_DO(date_to_day_DO,1)= comp_UXABS_DO(i,1);
            % Puts data in correct column of new matrix
            comp_UXABS_Interp_DO(date_to_day_DO,2)= comp_UXABS_DO(i,2);
        end
        days = [day_first:1:day_last]';
        comp_UXABS_Interp_DO = [days,comp_UXABS_Interp_DO(:,2)];

        % Interpolate daily data points for NH4 (Amm) 
        day_first = comp_UXABS_Amm(1,1); 
        day_last = comp_UXABS_Amm(end,1); 
        day_total = day_last - day_first;
        % Create an empty maxtrix to hold existing and interpolated data
        comp_UXABS_Interp_Amm = zeros(day_total,2);
        comp_UXABS_Interp_Amm(:,2) = comp_UXABS_Interp_Amm(:,2).*nan;
        % Adds existing data to empty matrix
        for i=1:length(comp_UXABS_Amm)
            % Converts first row date to a day (ex: 38088 to 1)
            date_to_day_Amm = comp_UXABS_Amm(i,1)-day_first+1; 
            % Puts dates in corrects column of new matrix
            comp_UXABS_Interp_Amm(date_to_day_Amm,1)= comp_UXABS_Amm(i,1);
            % Puts data in correct column of new matrix
            comp_UXABS_Interp_Amm(date_to_day_Amm,2)= comp_UXABS_Amm(i,2);
        end
        days = [day_first:1:day_last]';
        comp_UXABS_Interp_Amm = [days,comp_UXABS_Interp_Amm(:,2)];

        % Interpolate daily data points for NOx 
        day_first = comp_UXABS_NOx(1,1); 
        day_last = comp_UXABS_NOx(end,1); 
        day_total = day_last - day_first;
        % Create an empty maxtrix to hold existing and interpolated data
        comp_UXABS_Interp_NOx = zeros(day_total,2);
        comp_UXABS_Interp_NOx(:,2) = comp_UXABS_Interp_NOx(:,2).*nan;
        % Adds existing data to empty matrix
        for i=1:length(comp_UXABS_NOx)
            % Converts first row date to a day (ex: 38088 to 1)
            date_to_day_NOx = comp_UXABS_NOx(i,1)-day_first+1; 
            % Puts dates in corrects column of new matrix
            comp_UXABS_Interp_NOx(date_to_day_NOx,1)= comp_UXABS_NOx(i,1);
            % Puts data in correct column of new matrix
            comp_UXABS_Interp_NOx(date_to_day_NOx,2)= comp_UXABS_NOx(i,2);
        end
        days = [day_first:1:day_last]';
        comp_UXABS_Interp_NOx = [days,comp_UXABS_Interp_NOx(:,2)];

        % Interpolate daily data points for SRP 
        day_first = comp_UXABS_SRP(1,1); 
        day_last = comp_UXABS_SRP(end,1); 
        day_total = day_last - day_first;
        % Create an empty maxtrix to hold existing and interpolated data
        comp_UXABS_Interp_SRP = zeros(day_total,2);
        comp_UXABS_Interp_SRP(:,2) = comp_UXABS_Interp_SRP(:,2).*nan;
        % Adds existing data to empty matrix
        for i=1:length(comp_UXABS_SRP)
            % Converts first row date to a day (ex: 38088 to 1)
            date_to_day_SRP = comp_UXABS_SRP(i,1)-day_first+1; 
            % Puts dates in corrects column of new matrix
            comp_UXABS_Interp_SRP(date_to_day_SRP,1)= comp_UXABS_SRP(i,1);
            % Puts data in correct column of new matrix
            comp_UXABS_Interp_SRP(date_to_day_SRP,2)= comp_UXABS_SRP(i,2);
        end
        days = [day_first:1:day_last]';
        comp_UXABS_Interp_SRP = [days,comp_UXABS_Interp_SRP(:,2)];

     end

    % The final interpolated data sets are put in a cell array - each cell 
    % holds a vector of type double - and handed back to the Dstruct function
    Interpolated_Data{1} = comp_UXABS_Interp_Chla;
    Interpolated_Data{2} = comp_UXABS_Interp_DO;
    Interpolated_Data{3} = comp_UXABS_Interp_Amm;
    Interpolated_Data{4} = comp_UXABS_Interp_NOx;
    Interpolated_Data{5} = comp_UXABS_Interp_SRP;
    
end

end