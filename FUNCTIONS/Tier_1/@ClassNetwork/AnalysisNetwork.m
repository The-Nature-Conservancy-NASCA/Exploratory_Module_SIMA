function [FuncNetwork, varargout] = AnalysisNetwork(Network, varargin)
% -------------------------------------------------------------------------
% Matlab Version - R2018b 
% -------------------------------------------------------------------------
%                              BASE DATA 
% -------------------------------------------------------------------------
% Author        : Jonathan Nogales Pimentel
% Email         : jonathan.nogales@tnc.org
% Occupation    : Hydrology Specialist
% Company       : The Nature Conservancy - TNC
% Date          : October, 2018
%
% -------------------------------------------------------------------------
% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation, either version 3 of the License, or option) any 
% later version. This program is distributed in the hope that it will be 
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
% ee the GNU General Public License for more details. You should have 
% received a copy of the GNU General Public License along with this program
% If not, see http://www.gnu.org/licenses/.
% -------------------------------------------------------------------------
%                               DESCRIPTION 
% -------------------------------------------------------------------------
% 
% -------------------------------------------------------------------------
% INPUTS DATA
% -------------------------------------------------------------------------
% Network [Struct]
%   .ArcID            [n,1] = ID of the River Sections (Ad)
%   .FromNode         [n,1] = Initial Node of the River Sections (Ad)
%   .ToNode           [n,1] = End Node of the River Sections (Ad)
%   .ArcID_RM         [1,1] = ArcID of the River Sections corresponding to 
%                             the River Mouth (Ad)
% ProVar              [n,w] = Varaibles to Progate
% AccumVar            [n,m] = Varaibles to Acumulated
% AccumClipVar        [n,h] = Varaibles to Accumulate with Clipping
% LossRateVar         [n,k] = Varaibles with Loss Rate (%)
% AccumLossVar        [n,h] = Varaibles to Accumulate with Losses
% AccumClipLossVar    [n,l] = Varaibles to Accumulate with Losses and Clipping
%
% -------------------------------------------------------------------------
%                              OUTPUT DATA 
% -------------------------------------------------------------------------
% FuncNetwork         [n,r] = ID of the Functional Network by Barrier. 
% ProVarOut           [n,w] = Propagated Variables
% AccumVarOut         [n,m] = Cumulative Variables
% AccumClipVarOut     [n,h] = Cumulative Variables With Clipping
% AccumLossVarOut     [n,k] = Cumulative Variables With Losses
% AccumClipLossVarOut [n,h] = Cumulative Variables With Losses and Clipping
% PoNet               [n,1] = Position of the Network in one River Sections 
%                             Special
%

%% Check Input Data
% Barrier
% -------------------------------------------------------------------------
if nargin >= 2
    Barrier = varargin{1}; 
    if ~isempty(Barrier)
        n = length(Barrier(:,1)) - length(Network.ID);
        if n ~= 0 
            error('The length of "Barrier" does not match the stretches of the topological network');
        end
    else
        Barrier = zeros(length(Network.ID), 1);
    end
    
else
    Barrier = zeros(length(Network.ID), 1);
end

% Variables to propagate
% -------------------------------------------------------------------------
if nargin >= 3
    ProVar = varargin{2}; 
    if ~isempty(ProVar)
        n = length(ProVar) - length(Network.ID);
        if n ~= 0 
            error('The length of "ProVar" does not match the stretches of the topological network');
        end
        ProVarOut_i = zeros( length(Network.ID), length(ProVar(1,:)), length(Network.RiverMouth));
    end
    
else
    ProVar = [];
end

% Variables to accumulate
% -------------------------------------------------------------------------
if nargin >= 4
    AccumVar = varargin{3};
    if ~isempty(AccumVar)
        n = length(AccumVar) - length(Network.ID);
        if n ~= 0 
            error('The length of "AccumVar" does not match the stretches of the topological network');
        end
        AccumVarOut_i = zeros( length(Network.ID), length(AccumVar(1,:)), length(Network.RiverMouth));
    end
    
else
    AccumVar = [];
end

% Variables to accumulate with clipping 
% -------------------------------------------------------------------------
if nargin >= 5
    AccumClipVar = varargin{4}; 
    if ~isempty(AccumClipVar)
        n = length(AccumClipVar) - length(Network.ID);
        if n ~= 0 
            error('The length of "AccumClipVar" does not match the stretches of the topological network');
        end
        AccumClipVarOut_i = zeros( length(Network.ID), length(AccumClipVar(1,:)), length(Network.RiverMouth));
    end
    
else
    AccumClipVar = [];
end

if nargin == 6
    error('Are not find the LossRate variable ');
end

% Variables to accumulate with losses
% -------------------------------------------------------------------------
if nargin >= 7
    LossRate        = varargin{5}; 
    AccumLossVar    = varargin{6};
    if ~isempty(LossRate)
        n = length(LossRate) - length(Network.ID);
        if n ~= 0 
            error('The length of "LossRate" does not match the stretches of the topological network');
        end
        n = sum((LossRate > 100) & (LossRate < 1));
        if n ~= 0 
            error('LossRate greater than 0 and smaller than 100');
        end
    end
    if ~isempty(AccumLossVar)
        n = length(AccumLossVar) - length(Network.ID);
        if n ~= 0 
            error('The length of "AccumLossVar" does not match the stretches of the topological network');
        end
        AccumLossVarOut_i = zeros( length(Network.ID), length(AccumLossVar(1,:)), length(Network.RiverMouth));
    end
    
else
    LossRate        = []; 
    AccumLossVar    = [];
end

% Variables to accumulate with clipping and losses
% -------------------------------------------------------------------------
if nargin == 8
    LossRate            = varargin{5}; 
    AccumClipLossVar    = varargin{7};
    if ~isempty(LossRate)
        n = length(LossRate) - length(Network.ID);
        if n ~= 0 
            error('The length of "LossRate" does not match the stretches of the topological network');
        end
        n = sum((LossRate > 100) & (LossRate < 1));
        if n ~= 0 
            error('LossRate greater than 0 and smaller than 100');
        end
    end
    if ~isempty(AccumClipLossVar)
        n = length(AccumClipLossVar) - length(Network.ID);
        if n ~= 0 
            error('The length of "AccumClipLossVar" does not match the stretches of the topological network');
        end
        AccumClipLossVarOut_i = zeros( length(Network.ID), length(AccumClipLossVar(1,:)), length(Network.RiverMouth));
    end
    
else
    AccumClipLossVar    = [];
end

%% Parallel - Cores
% try
%     Cores   = parcluster('local'); 
%     CoreID  = strcmp(Cores.Jobs.State, 'running');
% catch
%     CoreID  = 0;
% end
if length(Network.RiverMouth) > 1
    CoreID = 1;
else
    CoreID = 0;
end

%% FunctionalBranch
% Currenct ID 
CurrID = zeros(1,length(Barrier(1,:)));

if CoreID
    PoNet       = zeros( length(Network.ID), length(Network.RiverMouth));
    PoNet_i     = Network.ID*0;
    FuncNetwork = zeros( length(Network.ID), length(Barrier(1,:)), length(Network.RiverMouth));
    
    parfor i = 1:length(Network.RiverMouth)
        [FuncNetwork(:,:,i),...
         O1,O2,O3,O4,O5,...
         PoNet(:,i)] = FunctionalBranch_V2( Network.ID,...
                                            Network.FromNode, Network.ToNode,...
                                            Network.RiverMouth(i),...
                                            ProVar, ProVar, ... 
                                            AccumVar, AccumVar,...
                                            AccumClipVar, AccumClipVar,...
                                            AccumLossVar, AccumLossVar,...
                                            AccumClipLossVar, AccumClipLossVar,...
                                            Barrier, CurrID, ...
                                            LossRate, Network.RiverMouth(i), PoNet_i);

        if ~isempty(ProVar)
            ProVarOut_i(:,:,i)          = O1;
        end
        
        if ~isempty(AccumVar)
            AccumVarOut_i(:,:,i)        = O2;
        end
        
        if ~isempty(AccumClipVar)
            AccumClipVarOut_i(:,:,i)    = O3;
        end
        
        if ~isempty(AccumLossVar)
            AccumLossVarOut_i(:,:,i)    = O4;
        end
        
        if ~isempty(AccumClipLossVar)
            AccumClipLossVarOut_i(:,:,i)= O5;
        end

    end
    
    if ~isempty(ProVar)
        ProVarOut          = ProVar*0;
    end
    if ~isempty(AccumVar)
        AccumVarOut        = AccumVar*0;
    end
    if ~isempty(AccumClipVar)
        AccumClipVarOut    = AccumClipVar*0;
    end
    if ~isempty(AccumLossVar)
        AccumLossVarOut    = AccumLossVar*0;
    end
    if ~isempty(AccumClipLossVar)
        AccumClipLossVarOut= AccumClipLossVar*0;
    end
    
    FuncNetwork = sum(FuncNetwork,3);
    PoNet       = logical(PoNet);
    for i = 1:length(Network.RiverMouth)
        if ~isempty(ProVar)
            ProVarOut(PoNet(:,i),:)             = ProVarOut_i(PoNet(:,i),:,i);
        end
        if ~isempty(AccumVar)
            AccumVarOut(PoNet(:,i),:)           = AccumVarOut_i(PoNet(:,i),:,i);
        end
        if ~isempty(AccumClipVar)
            AccumClipVarOut(PoNet(:,i),:)       = AccumClipVarOut_i(PoNet(:,i),:,i);
        end
        if ~isempty(AccumLossVar)
            AccumLossVarOut(PoNet(:,i),:)       = AccumLossVarOut_i(PoNet(:,i),:,i);
        end
        if ~isempty(AccumClipLossVar)
            AccumClipLossVarOut(PoNet(:,i),:)   = AccumClipLossVarOut_i(PoNet(:,i),:,i);
        end
    end
    
else
    
    PoNet       = Network.ID*0;
    FuncNetwork = Barrier*0;
    for i = 1:length(Network.RiverMouth)
        [FuncNetwork_i,O1,O2,O3,O4,O5,O6] = FunctionalBranch_V2( Network.ID,...
                                            Network.FromNode, Network.ToNode,...
                                            Network.RiverMouth(i),...
                                            ProVar, ProVar, ... 
                                            AccumVar, AccumVar,...
                                            AccumClipVar, AccumClipVar,...
                                            AccumLossVar, AccumLossVar,...
                                            AccumClipLossVar, AccumClipLossVar,...
                                            Barrier, CurrID, ...
                                            LossRate, Network.RiverMouth(i), PoNet);


        FuncNetwork      = FuncNetwork + FuncNetwork_i;
        ProVar           = O1;
        AccumVar         = O2;
        AccumClipVar     = O3;
        AccumLossVar     = O4;
        AccumClipLossVar = O5;
        PoNet            = PoNet + O6;
    end    
    
end

%% OUTPUT DATA
% ProVarOut
if ~isempty(ProVar)
    if ~CoreID
        varargout{1} = ProVar;
    else
        varargout{1} = ProVarOut;
    end
else
    varargout{1} = [];
end

% AccumVarOut
if ~isempty(AccumVar)
    if ~CoreID
        varargout{2} = AccumVar;
    else
        varargout{2} = AccumVarOut;
    end
else
    varargout{2} = [];
end

% AccumClipVarOut
if ~isempty(AccumClipVar)
    if ~CoreID
        varargout{3} = AccumClipVar;
    else
        varargout{3} = AccumClipVarOut;
    end
else
    varargout{3} = [];
end

% AccumLossVarOut
if ~isempty(AccumLossVar)
    if ~CoreID
        varargout{4} = AccumLossVar;
    else
        varargout{4} = AccumLossVarOut;
    end
else
    varargout{4} = [];
end

% AccumClipLossVarOut
if ~isempty(AccumClipLossVar)
    if ~CoreID
        varargout{5} = AccumClipLossVar;  
    else
        varargout{5} = AccumClipLossVarOut;  
    end
else
    varargout{5} = [];
end

% AccumClipLossVarOut
varargout{6} = PoNet;

end


%% Functional Branch
function [  FuncNetwork,...
            ProVarOut,...
            AccumVarOut,...
            AccumClipVarOut,...
            AccumLossVarOut,...
            AccumClipLossVarOut,...
            PoNet] = ...
            FunctionalBranch_V2(    ArcID, FromNode, ToNode, ArcID_RM,...
                                    ProVar, ProVarTmp, ... 
                                    AccumVar, AccumVarTmp,...
                                    AccumClipVar, AccumClipVarTmp,...
                                    AccumLossVar, AccumLossVarTmp,...
                                    AccumClipLossVar, AccumClipLossVarTmp,...
                                    ArcBarrier, CurrID,...
                                    LossRate, ArcID_RM_i, PoNet )
% -------------------------------------------------------------------------
% /usr/bin/Matlab-R2018b
% -------------------------------------------------------------------------
%                               BASE DATA 
% -------------------------------------------------------------------------
% Author        : Jonathan Nogales Pimentel
% Email         : jonathannogales02@gmail.com
% Occupation    : Hydrology Specialist
% Company       : The Nature Conservancy - TNC
% Date          : October, 2018
% 
% -------------------------------------------------------------------------
% This program is free software: you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation, either version 3 of the License, or option) any 
% later version. This program is distributed in the hope that it will be 
% useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
% ee the GNU General Public License for more details. You should have 
% received a copy of the GNU General Public License along with this program.  
% If not, see http://www.gnu.org/licenses/.
% -------------------------------------------------------------------------
%                              DESCRIPTION
% -------------------------------------------------------------------------
% Function that calculates: Fragmentation, Accumulation and Propagation of a 
% topological fluvial network. These analyzes allow us to characterize the 
% fluvial network, to later evaluate the cumulative impacts of a set of 
% infrastructure works such as reservoirs, dams, etc., located in a fluvial 
% network, in terms of loss of Free Rivers, effects downstream by modification 
% of the regime of flows and sediments, among others.
%
% -------------------------------------------------------------------------
% INPUTS DATA
% -------------------------------------------------------------------------
% Network [Struct]
%   .ArcID              [n,1] = ID of the River Sections (Ad)
%   .FromNode           [n,1] = Initial Node of the River Sections (Ad)
%   .ToNode             [n,1] = End Node of the River Sections (Ad)
%   .ArcID_RM           [1,1] = ArcID of the River Sections corresponding to 
%                               the River Mouth (Ad)
%   .ProVar             [n,w] = Variables to Propagate
%   .AccumVar           [n,m] = Variables to Accumulate
%   .AccumClipVar       [n,k] = Variables to Accumulate with Clipping
%   .AccumLossVar       [n,h] = Variables to Accumulate with Losses
%   .AccumClipLossVar   [n,l] = Variables to Accumulate with Losses and Clipping
%   .ArcBarrier         [n,1] = ArcID of the River Sections with Barriers (Ad)
%   .CurrID             [1,1] = ID of the Functional Network.                                      
%   .LossRate           [n,1] = Loss Rate (%)
%
% -------------------------------------------------------------------------
% OUTPUTS DATA
% -------------------------------------------------------------------------
%   FuncNetwork         [n,1] = ID of the Functional Network by Barrier. 
%   ProVarOut           [n,w] = Propagated Variables
%   AccumVarOut         [n,m] = Cumulative Variables
%   AccumClipVarOut     [n,h] = Cumulative Variables With Clipping
%   AccumLossVarOut     [n,k] = Cumulative Variables With Losses
%   AccumClipLossVarOut [n,h] = Cumulative Variables With Losses and Clipping
%   PoNet               [n,1] = Position of the Network in one River Sections 
%                               Special
%
%--------------------------------------------------------------------------
%                              REFERENCES
%--------------------------------------------------------------------------
% - Authors of base Code : Hector Angarita
% 
%--------------------------------------------------------------------------

FuncNetwork         = 0 * ArcBarrier;
% Variables to Propagated
ProVarOut           = ProVarTmp;
% Variables to Accumulate
AccumVarOut         = AccumVarTmp; 
% Variables to Propagate
AccumClipVarOut     = AccumClipVarTmp;
% Variables to Degration
AccumLossVarOut     = AccumLossVarTmp;
% Variables to Propagate and Degration
AccumClipLossVarOut = AccumClipLossVarTmp;
% Current ArcID
CurrentID           = ArcID_RM;
% Position of the Current ArcID
Posi                = find(ArcID == CurrentID);
% Position Network
PoNet(Posi)         = 1;
% Branch Number
NumBranch           = 1;
% Other Posi
PosiUni             = [];

while (NumBranch == 1)
    
    FuncNetwork(Posi,:) = CurrID;
    CurrIDOut           = CurrID;
    
    if sum(ArcBarrier(Posi,:) > 0) > 0                     
        % a barrier was found, a new functional network must be assigned to upstream reaches:
        CurrIDOut(ArcBarrier(Posi,:) > 0)  = ArcBarrier(Posi, ArcBarrier(Posi,:) > 0);
        PosiUni = Posi;
    end

    Npre = Posi;
    
    % keeps going upstream
    Posi = find(ToNode == FromNode(Posi)); 
  
    try
        Posi1   = find(ToNode == FromNode(Posi));
        Posi2   = find(ToNode == FromNode(Posi1));
    catch
        Posi1 = [0 1 0 1];
        Posi2 = [0 1 0 1];
    end
    
    NumBranch   = length(Posi);
    
    if length(Posi) == 1 && isempty(Posi2)
        if sum(ArcBarrier(Posi,:) > 0) > 0                      
            % a barrier was found, a new functional network must be assigned to upstream reaches:
            CurrIDOut(ArcBarrier(Posi,:) > 0)  = ArcBarrier(Posi, ArcBarrier(Posi,:) > 0);      
        end
    end
        
    if NumBranch == 0
        Posi1 = [];
    end
    
    if (NumBranch == 1  && isempty(Posi1))
        
        % Position Network
        % -------------------------------------------------------------------------
        PoNet(Posi)       = 1;

        % Functional Network
        % -------------------------------------------------------------------------
        FuncNetwork(Posi,:) = ArcBarrier(Posi,:);
        
        % Variables to Propagated
        % -------------------------------------------------------------------------
        if ~isempty(ProVarTmp)
            ProVarOut                   = ProVarTmp;
            ProVarOut(Npre,:)           = ProVarOut(Npre,:) + ProVarTmp(Posi,:);  
        end

        % Variables to Accumulate
        % -------------------------------------------------------------------------
        if ~isempty(AccumVarTmp)
            AccumVarOut                 = AccumVarTmp;
            AccumVarOut(Npre,:)         = AccumVarOut(Npre,:) + AccumVarTmp(Posi,:);
        end

        % Variables to Accumulate With Clipping
        % -------------------------------------------------------------------------
        if ~isempty(AccumClipVarTmp)
            AccumClipVarOut             = AccumClipVarTmp;
            AccumClipVarOut(Npre,:)     = AccumClipVarOut(Npre,:) + AccumClipVarTmp(Posi,:);
        end

        % Variables to Accumulate With Losses
        % -------------------------------------------------------------------------
        if ~isempty(AccumLossVarTmp)
            AccumLossVarOut             = AccumLossVarTmp;
            AccumLossVarOut(Npre,:)     = (AccumLossVarOut(Npre,:) + AccumLossVarTmp(Posi,:));
        end

        % Variables to Accumulate With Clipping and Losses
        % -------------------------------------------------------------------------
        if ~isempty(AccumClipLossVarTmp)
            AccumClipLossVarOut         = AccumClipLossVarTmp;
            AccumClipLossVarOut(Npre,:) = (AccumClipLossVarOut(Npre,:) + AccumClipLossVarTmp(Posi,:));
        end
        
        % Branch Number
        NumBranch = 0;
        
    elseif (NumBranch > 1  || ~isempty(Posi1)) || (NumBranch == 1  || isempty(Posi1))
        for i = 1:NumBranch 
            
            New_ArcID_RM = ArcID(Posi(i));
            
            %% Functional Branch
            [FuncNetwork_i,...
            ProVar_i,...
            AccumVar_i,...
            AccumClipVar_i,...
            AccumLossVar_i,...
            AccumClipLossVar_i,...
            PoNet] = ...
            FunctionalBranch_V2(  ArcID, FromNode, ToNode, New_ArcID_RM,...                         
                                 ProVar, ProVarOut, ...
                                 AccumVar, AccumVarOut, ... 
                                 AccumClipVar, AccumClipVarOut,...
                                 AccumLossVar, AccumLossVarOut,...
                                 AccumClipLossVar, AccumClipLossVarOut,...
                                 ArcBarrier, CurrIDOut,... 
                                 LossRate, ArcID_RM_i, PoNet);
            
            % Functional Network
            % -------------------------------------------------------------------------
            FuncNetwork                     = FuncNetwork + FuncNetwork_i;
            
            % Variables to Propagated
            % -------------------------------------------------------------------------
            if ~isempty(ProVar_i)
                ProVarOut                   = ProVar_i;
                ProVarOut(Npre,:)           = ProVarOut(Npre,:) + ProVar_i(Posi(i),:);  
            end
            
            % Variables to Accumulate
            % -------------------------------------------------------------------------
            if ~isempty(AccumVar_i)
                AccumVarOut                 = AccumVar_i;
                AccumVarOut(Npre,:)         = AccumVarOut(Npre,:) + AccumVar_i(Posi(i),:);
            end
            
            % Variables to Accumulate With Clipping
            % -------------------------------------------------------------------------
            if ~isempty(AccumClipVar_i)
                AccumClipVarOut             = AccumClipVar_i;
                AccumClipVarOut(Npre,:)     = AccumClipVarOut(Npre,:) + AccumClipVar_i(Posi(i),:);
            end
            
            % Variables to Accumulate With Losses
            % -------------------------------------------------------------------------
            if ~isempty(AccumLossVar_i)
                AccumLossVarOut             = AccumLossVar_i;
                AccumLossVarOut(Npre,:)     = (AccumLossVarOut(Npre,:) + AccumLossVar_i(Posi(i),:));
            end
            
            % Variables to Accumulate With Clipping and Losses
            % -------------------------------------------------------------------------
            if ~isempty(AccumClipLossVar_i)
                AccumClipLossVarOut         = AccumClipLossVar_i;
                AccumClipLossVarOut(Npre,:) = (AccumClipLossVarOut(Npre,:) + AccumClipLossVar_i(Posi(i),:));
            end
            
            % Branch Number
            if NumBranch == 1
                NumBranch = 0;
            end
        end
    end
    
    % Functional Network
    % -------------------------------------------------------------------------
    if isempty(ArcBarrier(Posi,:)) && (NumBranch == 0) && ~isempty(PosiUni)
        FuncNetwork(PosiUni,:) = CurrIDOut;
    end
    
    % Variables to Accumulate With Losses
    % -------------------------------------------------------------------------
    if ~isempty(AccumLossVarOut)
        AccumLossVarOut(Npre,:) = AccumLossVarOut(Npre,:) * (1 - (LossRate(Npre)/100));
    end
    
    % Variables to Accumulate With Clipping
    % -------------------------------------------------------------------------
    if ~isempty(AccumClipVar)
        if (ArcBarrier(Npre,1) > 0)                      
            % a barrier was found, resets river network accumulation:
            AccumClipVarOut(Npre,:) = AccumClipVar(Npre,:);
        end
    end
    
    % Variables to Accumulate With Clipping and Losses
    % ------------------------------------------------------------------------
    if ~isempty(AccumClipLossVar)
        AccumClipLossVarOut(Npre,:) = AccumClipLossVarOut(Npre,:) * (1 - (LossRate(Npre)/100));
        if (ArcBarrier(Npre,1) > 0) 
            AccumClipLossVarOut(Npre,:) = AccumClipLossVar(Npre,:);
        end
    end
    
    % Variables to Propagated
    % -------------------------------------------------------------------------
    if ~isempty(ProVar)
        if (ProVar(Npre) > 0)
            ProVarOut(Npre) = ProVar(Npre);
        end
    end
    
    % Break While
    % -------------------------------------------------------------------------
    if Npre == ArcID_RM_i
        break
    end
    
end 

end

