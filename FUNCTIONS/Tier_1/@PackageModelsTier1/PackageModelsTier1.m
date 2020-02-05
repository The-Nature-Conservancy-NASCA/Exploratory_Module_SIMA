classdef PackageModelsTier1
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
% Package the Models 
%
%--------------------------------------------------------------------------
%                               DESCRIPTION 
%--------------------------------------------------------------------------
% Tier-1 = This algoritm estimate the Dregrees Regulation, Fragmentation, 
%          Footprint and Sediment Alteration Index.
% Footprint = 
    
    %% Properties
    % Properties of the operation
    properties
        Paralleling logical = 1;
    end 
    
    properties
        CoresNumber {mustBeInteger,mustBePositive} = 4;
    end
    
    %% Methods
    methods
        
        %% Paralleling
        function obj = set.CoresNumber(obj,Value)
            obj.CoresNumber = Value;
        end
        
        function ActivateParalleling(obj)
            
            if obj.Paralleling == 1
                if obj.CoresNumber == 1
                    obj.CoresNumber = feature('numcores') * 2;
                end
                
                try
                   myCluster                = parcluster('local');
                   myCluster.NumWorkers     = obj.CoresNumber;
                   saveProfile(myCluster);
                   parpool;
                catch
                end
            end
            
        end
        
        function Value = get.Paralleling(obj)
            Value = obj.Paralleling;
        end
        
        %% Tier-1
        [Scenarios, FuncNetwork, varargout] = Tier1(obj, ParallelMode, Network, Hp, AnalysisType, Mode1, varargin)
        
        %% FootPrint 
        [Vol, varargout] = Footprint(obj, Mode, Hp, DEM, varargin)
        
        %% Resamplig Rasters With DEM 
        [ErrosFootprints, Areas] = Resampling(obj, DEM, varargin)
        
    end

end