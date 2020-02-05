classdef ClassHydroelectricProject
% -------------------------------------------------------------------------
% Matlab Version - R2018b 
% -------------------------------------------------------------------------
%                              BASE DATA 
%--------------------------------------------------------------------------
% Author        : Jonathan Nogales Pimentel
% Email         : jonathannogales02@gmail.com
% Occupation    : Hydrology Specialist
% Company       : The Nature Conservancy - TNC
% Date          : October, 2018
%
%--------------------------------------------------------------------------
% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation, either version 3 of the License, or option) any 
% later version. This program is distributed in the hope that it will be 
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
% ee the GNU General Public License for more details. You should have 
% received a copy of the GNU General Public License along with this program
% If not, see http://www.gnu.org/licenses/.
%--------------------------------------------------------------------------
%                               DESCRIPTION 
%--------------------------------------------------------------------------
% This object represent a development plan current or future.
% 
%--------------------------------------------------------------------------
%                               INPUT DATA 
%--------------------------------------------------------------------------
% n = it is the number of projects
%
% ID            [n,1] = It is a array of positive integer number that 
%                       represent unique identification by every project. 
% Coor_Y; CoorX [n,1] = It is a array of floating number that represent the 
%                       position in the world in a flat coordinate system 
%                       by every project.
% ArcID         [n,1] = It is a array of positive integer number that 
%                       represent the ID of the topological network in the 
%                       which is located by every project.
% Volumen       [n,1] = It is a array of floating number that represent the
%                       amount of water that each project is capable of 
%                       storing in cubic meter. If its value is not known,
%                       to place "-1".
% InstallPower  [n,1] = It is a array of floating number that represent the
%                       installed capacity (MW). If its value is not known, 
%                       to place -1.
% Height        [n,1] = It is a array of floating number that represent the 
%                       height of dam of  each project in meter.
% Qmed          [n,1] = It is a array of floating number that represent the 
%                       streamflow that is capacity of regulate each project
%                       in cubic meter by seconds. If its value is not known, 
%                       to place -1.
% LossRate      [n,1] = It is a array of floating number between 0 and 100
%                       that represent the amount of sediment that is capacity 
%                       of regulate each project in percentage. If its value
%                       is not known, to place -1.
% Years         [n,1] = It is a array of positive integer number that 
%                       represent year in that the project inputted in 
%                       operation. If its value is not known, to place 0.                      
% Scenario      [n,1] = it is a array of the boolean number that represent
%                       if the project are active or not.
% StatusRan     [1,1] = it is an boolean number that represent if you want 
%                       perform combination of the project.
% NumRand       [1,1] = It is an positive integer number that represent the
%                       number of combination to perfom.
%
%--------------------------------------------------------------------------
%                              OUTPUT DATA
%--------------------------------------------------------------------------
%
% ClassHydroelectricProject = it is an object that contains an existing or 
%                             future hydroenergetic development plan.
%

    %% Properties  
    % Project Status
    properties
        % Status of the project [On or Off]
        Scenario(:,1) logical
        % Status of the component random
        StatusRan(1,1) logical
        % Combination number
        NumRand(1,1) double
    end
    
    % Dam Properties 
    properties
        % Unique identification number by every project
        ID(:,1) double {mustBeFinite(ID)}
        % Name Project 
        Name(:,1) cell
        % Coordinate in X
        Coor_X(:,1) double
        % Coordinate in Y
        Coor_Y(:,1) double
        % ID_HSU where the Hydroelectric Project is located
        ArcID(:,1) double
        % Total Volumen of the Hydroelectric Project 
        Volumen(:,1) double
        % Install Power of the Hydroelectric Project 
        InstallPower(:,1) double {mustBeGreaterThanOrEqual(InstallPower,0)}
        % Higth Dam of the Hydroelectric Project 
        Height(:,1) double %{mustBeGreaterThanOrEqual(Height,0)}
        % Streamflow that regulate of the Hydroelectric Project 
        Qmed(:,1) double
        % Soil Streamflow that regulate of the Hydrolectric Project
        LossRate(:,1) double {mustBeGreaterThanOrEqual(LossRate,0), mustBeLessThanOrEqual(LossRate,100)}
        % year in that the project inputted in operation [zero for proposed projects]
        Years(:,1) double
    end
    
    %% Methods
    methods
        %% Definition ClassHydroelectricProject
        function Hp  = ClassHydroelectricProject(ID)
            Tmp = abs( length( unique(ID) ) - length( ID ) );
            if Tmp == 0
                Hp.ID = ID;
            else
                error('Exist Equal Codes')
            end
        end
        
        %% Generation of Random Scenarios
        SceRamdon  = RandomScenarios(obj);
        
        %% Complementation of Sediment Loss Rate
        function LossR = SedimentDendy(obj)
            Tmp     = log10(obj.Volumen./(obj.Qmed.*86400.*365));
            LossR   = 100.*((0.97.^(0.19.^Tmp)));
            LossR(LossR>100)    = 0;
            LossR(LossR<0)      = 0;
            LossR(isnan(LossR)) = 0;
        end        
        
    end
    
end