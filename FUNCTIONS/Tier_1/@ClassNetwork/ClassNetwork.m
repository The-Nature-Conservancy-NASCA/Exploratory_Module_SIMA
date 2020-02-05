classdef ClassNetwork
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
% This object represent a topological network 
%
%--------------------------------------------------------------------------
%                               INPUT DATA 
%--------------------------------------------------------------------------
%   n = it is the section number that haves the topological network
%
%   ID          [n,1] = ID of the River Sections (Ad)
%   FromNode    [n,1] = Initial Node of the River Sections (Ad)
%   ToNode      [n,1] = End Node of the River Sections (Ad)
%   RiverMouth  [1,1] = ID of the River Sections corresponding to the River 
%                       Mouth (Ad)                    
%
%--------------------------------------------------------------------------
%                              OUTPUT DATA 
%--------------------------------------------------------------------------
% ClassNetwork [Object] = This object contain a topological network 
%

    %% Properties
    % Properties of the topological network
    properties        
        % ID of the River Sections (Ad)
        ID(:,1) double
        % Initial Node of the River Sections (Ad)
        FromNode(:,1) double
        % End Node of the River Sections (Ad)
        ToNode(:,1) double
        % ArcID of the River Sections corresponding to the River Mouth (Ad)
        RiverMouth(:,1) double
    end
    
    %% Methods
    methods 
        %% Definition ClassNetwork
        function Network = ClassNetwork(ID, FromNode, ToNode,RiverMouth)
            Network.ID          = ID;
            Network.FromNode    = FromNode;
            Network.ToNode      = ToNode;
            Network.RiverMouth  = RiverMouth;
        end        
    end
    
    methods
        %% Analysis Network
        [FuncNetwork, varargout]    = AnalysisNetwork(obj, varargin);  
    end

end