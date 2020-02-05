function [ErrorNumber, Scenarios, FuncNetwork, varargout] = Tier1(obj, ParallelMode, Network, Hp, AnalysisType, AnalysisMode, varargin)
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
% This function estimate the Dregrees of Regulation, Fragmentation, and
% Sediment Alteration Index.
%
%--------------------------------------------------------------------------
%                               INPUT DATA 
%--------------------------------------------------------------------------
%   Network         [ClassNetwork]              = Tological Network
%
%   Hp              [ClassHydroelectricProject] = Hydropower Development plan
%
%   PointsInt       [z,1]                       = ID of the Interest points 
%                                                 regional
%
%   AnalysisType    [Integer]                   = 1. DOR
%                                                 2. SAI
%                                                 3. DOR + SAI
%                                                 4. Fragmentation
%                                                 5. Fragmentation + DOR
%                                                 6. Fragmentation + SAI
%                                                 7. Fragmentation + DOR + SAI
%
%   AnalysisMode    [Integer]                   = 1. Scenario 
%                                                 2. Base Line (Operation Years)
%
%--------------------------------------------------------------------------
%                              OUTPUT DATA 
%--------------------------------------------------------------------------
% w = it is the number brach of the topological network; 
% z = it is the number interest points   
% m = it is number scenarios
% n = it is the number project
%
%   Scenario    [n,m]    = Scenarios array analysed. Where  
%   FuncNetwork [w,z,m]  = topological network fragmentation with the 
%                          projects analysed in every scenario. 
%   Frag        [Struct] = Length of fragmented rivers for every project 
%                          analysed.
%   DOR         [w,m]    = Degrees of Regulation Index for every seccion 
%                          of the Topological Network. 
%   DORw        [w,m]    = Degrees of Regulation Index for every seccion 
%                          of the Topological Network. 
%   SAI         [w,m]    = Sediment Alteration Index. 
%
%--------------------------------------------------------------------------
%                              REFERENCES
%--------------------------------------------------------------------------
% - https://www.nature.org/media/freshwater/power-of-rivers-report.pdf
% - https://www.seforall.org/sites/default/files/powerofriversreport_final1.pdf
% - Héctor Angarita, Albertus J. Wickel, Jack Sieber, John Chavarro, Javier 
%   A. Maldonado-Ocampo, Guido A. Herrera-R, Juliana Delgado and David Purkey, 
%   "Basin-scale impacts of hydropower development on the Mompós Depression 
%   wetlands, Colombia," Hydrology and Earth System Sciences, 
%   doi:10.5194/hess-22-2839-2018, May 2018.
% 

ErrorNumber      = -1;
varargout{1}    = NaN;
varargout{2}    = NaN;
varargout{3}    = NaN;
varargout{4}    = NaN;
varargout{5}    = NaN;
        
%% Check Input
if(AnalysisMode ~= 1) && (sum(Hp.Years ~= 0) == 0)
    ErrorNumber = 0; 
    disp(['The "baseline" analysis mode can not be executed. The projects ',...
        'entered does not contain years of installation']);     
    return
end

% Interest points
PointsInt = varargin{1};

% River Length
if AnalysisType >= 4
    LenRiver = varargin{2};
    n = length(LenRiver) - length(Network.ID);
    if n ~= 0 
        ErrorNumber = 1;        
        disp('The length of "LenRiver" does not match the stretches of the topological network');        
    end
end

% Streamflow
if (AnalysisType == 1) || (AnalysisType == 3) || (AnalysisType == 5) || (AnalysisType == 7)
    if AnalysisType < 5
        Streamflow = varargin{2};
    else
        Streamflow = varargin{3};
    end
    n = length(Streamflow) - length(Network.ID);
    if n ~= 0 
        ErrorNumber = 2;
        disp('The length of "Streamflow" does not match the stretches of the topological network');
    end
end

% Sediment
if (AnalysisType == 2) || (AnalysisType == 3) || (AnalysisType == 6) || (AnalysisType == 7)
    if (AnalysisType == 3) || (AnalysisType == 6)
        Sediment = varargin{3};
    elseif (AnalysisType == 7)
        Sediment = varargin{4};
    else
        Sediment = varargin{2};
    end
    n = length(Sediment) - length(Network.ID);
    if n ~= 0 
        ErrorNumber = 3;
        disp('The length of "Sediment" does not match the stretches of the topological network');
    end
end

%% Consistency Check
% ArcID Interes Points
if ~isempty(PointsInt)
    [id,~] = ismember(PointsInt, Network.ID);
    if sum(id) ~= length(PointsInt)
        PointsInt = PointsInt(id == 0);
        Name = ' ';
        for i = 1:PointsInt
            Name = [Name,num2str(PointsInt(i)),' '];
        end        
        ErrorNumber = 4;
        disp(['The ID of the interest points ',Name,'do not exist in the Topological Network'])
    end
end

% ArcID Projects 
[id,~] = ismember(Hp.ArcID, Network.ID);
if sum(id) ~= length(Hp.ID)
    Tmp = Hp.ID(id == 0);
    Name = ' ';
    for i = 1:Tmp
        Name = [Name , num2str(Hp.ID(i)),' '];
    end
    ErrorNumber = 5;
    disp(['The ID of the project ',Name,'do not exist in the Topological Network'])
end

%% Create Scenarios
% ------------------------------------------------------------------------------------------
BaseLine = Hp.Years ~= 0;
if AnalysisMode == 1

    % If it is not ramdon
    if Hp.StatusRan == 0
        % Name Scenario
        Scenarios           = Hp.Scenario;
        if (sum(BaseLine) > 0)
            Scenarios(BaseLine,:) = true;
        end
    else % If it is ramdon

        % Status check [on and off]
        if (sum(BaseLine) > 0)
            Hp.Scenario( BaseLine ) = false ;
        end
        ProjectID   = Hp.ID( Hp.Scenario );
        
        if isempty( ProjectID )
            ErrorNumber = 6;
            disp('Not exist projects for analysis')
        end
        
        % Create Combination of project 
        Tmp         = Hp.RandomScenarios;

        % check of exist baseline
        Tmp1        = repmat( BaseLine , 1, length(Tmp(1,:)));

        % Create combination
        for j = 1:length(Tmp(1,:))
            id = ismember(Hp.ID, ProjectID(Tmp(:,j)));
            Tmp1(id, j) = 1; 
        end

        % Active project in the scenario 
        Scenarios = Tmp1;
    end
    
else
    
    % History
    Tmp     = unique( Hp.Years );
    Years   = sort( Tmp( Tmp > 0) );
    
    Scenarios = zeros( length(Hp.Years), length(Years) );
    if ~isempty(Years)
        for i = 1:length(Years)
            Scenarios(:,i)   = (Hp.Years <= Years(i) & Hp.Years ~= 0);
        end
    end    
end 
Scenarios = logical(Scenarios);

%% Asignation Barriers
% ------------------------------------------------------------------------------------------
if ~isempty(PointsInt)
    Barrier = zeros( length(Network.ID), length(PointsInt) + 1);
    for i = 2:length(PointsInt) + 1
        id = Network.ID == PointsInt(i - 1);
        Barrier(id,i) = 1;
    end
else
    Barrier = zeros( length(Network.ID), 1);
end

% Regional 
if length(Barrier(1,:)) > 1
    FuncReg = BashTier1(Network, Hp,[],4, Barrier);
    FuncReg = FuncReg(:,2:end);
    Barrier = Barrier(:,1);
end

%% Tier 1
if (AnalysisType == 4)
    % Fragmentation
    FuncNetwork     = zeros(length(Network.ID), length(Scenarios(1,:)));
    if ParallelMode
        parfor j = 1:length(Scenarios(1,:))
            FuncNetwork(:,j)    = BashTier1(Network, Hp,Scenarios(:,j), AnalysisType, Barrier);
        end
    else
        for j = 1:length(Scenarios(1,:))
            FuncNetwork(:,j)    = BashTier1(Network, Hp,Scenarios(:,j), AnalysisType, Barrier);
        end
    end
    
elseif (AnalysisType == 1) || (AnalysisType == 5)
    % DOR and DORq
    FuncNetwork = zeros(length(Network.ID), length(Scenarios(1,:)));
    DOR         = zeros(length(Network.ID), length(Scenarios(1,:)));
    DORw        = zeros(length(Network.ID), length(Scenarios(1,:)));
    
    if ParallelMode
        parfor j = 1:length(Scenarios(1,:))
            [FuncNetwork(:,j), DOR(:,j), DORw(:,j)] = BashTier1(Network, Hp, Scenarios(:,j), AnalysisType, Barrier, Streamflow);
        end
    else
        for j = 1:length(Scenarios(1,:))
            [FuncNetwork(:,j), DOR(:,j), DORw(:,j)] = BashTier1(Network, Hp, Scenarios(:,j), AnalysisType, Barrier, Streamflow);
        end
    end
    
elseif (AnalysisType == 2) || (AnalysisType == 6)
    % Alteration Sediment index
    FuncNetwork = zeros(length(Network.ID), length(Scenarios(1,:)));
    SAI         = zeros(length(Network.ID), length(Scenarios(1,:)));
    
    if ParallelMode
        parfor j = 1:length(Scenarios(1,:))
            [FuncNetwork(:,j), SAI(:,j)] = BashTier1(Network, Hp, Scenarios(:,j), AnalysisType, Barrier, Sediment);
        end
    else
        for j = 1:length(Scenarios(1,:))
            [FuncNetwork(:,j), SAI(:,j)] = BashTier1(Network, Hp, Scenarios(:,j), AnalysisType, Barrier, Sediment);
        end
    end
    
elseif (AnalysisType == 3) || (AnalysisType == 7)
    % Total Tier 1
    FuncNetwork = zeros(length(Network.ID), length(Scenarios(1,:)));
    DOR         = zeros(length(Network.ID), length(Scenarios(1,:)));
    DORw        = zeros(length(Network.ID), length(Scenarios(1,:)));
    SAI         = zeros(length(Network.ID), length(Scenarios(1,:)));
    
    if ParallelMode
        parfor j = 1:length(Scenarios(1,:))
            [FuncNetwork(:,j), DOR(:,j), DORw(:,j), SAI(:,j)] = BashTier1( Network, Hp, Scenarios(:,j), AnalysisType, Barrier, Streamflow, Sediment);
        end
    else
        for j = 1:length(Scenarios(1,:))
            [FuncNetwork(:,j), DOR(:,j), DORw(:,j), SAI(:,j)] = BashTier1( Network, Hp, Scenarios(:,j), AnalysisType, Barrier, Streamflow, Sediment);
        end
    end
end

% Correct Barrier in interest points
if ~isempty(PointsInt)
    for i = 1:length(PointsInt)
        Tmp             = Network.ID == PointsInt(i);
        FuncReg(Tmp,i)  = 1;  
    end
end

%% Fragmentation
% Table Results 
if AnalysisMode == 1
    NameSce     = cell(1,1 + length(Scenarios(1,:)));
    NameSce{1}  = 'ID';
    for i = 1:length(Scenarios(1,:))
        NameSce{i + 1}  = ['Trajectory_',num2str(i)];
    end
else
    NameSce     = cell(1,1 + length( Years ));
    NameSce{1}  = 'ID';
    for i = 1:length( Years )
        NameSce{i + 1} = ['Year_',num2str(Years(i))];
    end
end
    
if (AnalysisType >= 4)
    Arc     = [0; PointsInt];
    eval('Proj    = [0; Hp.ID];')
    Frag    = struct;
    for i = 1:length( Arc )
        eval( ['Frag.Table_',num2str(Arc(i)),' = array2table([Proj (repmat(Proj*0,1,length( Scenarios(1,:) )) - 999)],"VariableNames",NameSce);']);
    end

    for j = 1:length( Arc )
        for i = 1:length( Scenarios(1,:) )
            if j == 1
                ID_Uni = unique( FuncNetwork(:,i) );
                for k = 1:length(ID_Uni)
                    eval( ['Frag.Table_',num2str(Arc(j)),'.',NameSce{i + 1},'(Proj == ID_Uni(k) ) = sum( LenRiver(FuncNetwork(:,i) == ID_Uni(k)) ); '])
                end
            else    
                if ~isempty(PointsInt)
                    FuncNetwork_i   = FuncNetwork(FuncReg(:,j-1) == 1,i);
                    ID_Uni          = unique( FuncNetwork_i );
                    if sum(ID_Uni == 0) == 0
                        CodePointInt = FuncNetwork( Network.ID == Arc(j), i);
                        FuncNetwork_i( FuncNetwork_i == CodePointInt) = 0;
                        ID_Uni = unique( FuncNetwork_i );
                    end
                    eval('Net_Length      = LenRiver(  FuncReg(:,j-1) == 1 );')
                    for k = 1:length(ID_Uni)
                        eval( ['Frag.Table_',num2str(Arc(j)),'.',NameSce{i + 1},'(Proj == ID_Uni(k) ) = sum( Net_Length(FuncNetwork_i == ID_Uni(k)) ); '])
                    end 
                end
            end
        end    
    end
end 

% OUTPUT DATA
% -------------------------------------------------------------
% Functional Network
% FuncNetwork     = array2table([Network.ID FuncNetwork],'VariableNames',NameSce);
    
% Table Results 
if (AnalysisType >= 4)
    % Fragmentation
    varargout{1} = Frag;
end

if (AnalysisType == 1) || (AnalysisType == 3)
    % DORh
    varargout{1} = DOR;
    % DORw
    varargout{2} = DORw;
elseif (AnalysisType == 5) || (AnalysisType == 7)
    % DORh
    varargout{2} = DOR;
    % DORw
    varargout{3} = DORw;
end

if (AnalysisType == 2)
    % Sediment
    varargout{1} = SAI;
elseif (AnalysisType == 3)
    % Sediment
    varargout{3} = SAI;
elseif (AnalysisType == 6)
    % Sediment
    varargout{2} = SAI;
elseif (AnalysisType == 7)
    % Sediment
    varargout{4} = SAI;
end

if ~isempty(PointsInt)
    NamePoint     = cell(1,length(PointsInt));
    for i = 1:length(PointsInt)
        NamePoint{i}  = ['Points_',num2str(PointsInt(i))];
    end
    varargout{5}    = array2table(FuncReg,'VariableNames',NamePoint);
end

end


% -------------------------------------------------------------------------
% Bash Tier-1
% -------------------------------------------------------------------------
function [FuncNetwork, varargout] = BashTier1(Network, Hp, ScePar, AnalysisType, Barrier, varargin)
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
% This function estimate the Dregrees of Regulation, Fragmentation, and
% Sediment Alteration Index.
%
%--------------------------------------------------------------------------
%                               INPUT DATA 
%--------------------------------------------------------------------------
%   Network   [ClassNetwork]              = Tological Network
%   Hp        [ClassHydroelectricProject] = Hydropower Development plan
%   PointsInt [z,1]                       = ID of the Interest points 
%                                           regional
%   AnalysisType      [Integer]           = 1. Fragmentation
%                                           2. Fragmentation + DOR
%                                           3. Fragmentation + SAI
%                                           4. Fragmentation + DOR + SAI
%
%--------------------------------------------------------------------------
%                              OUTPUT DATA 
%--------------------------------------------------------------------------
%   Scenario    [n,m]    = Scenarios array analysed
%   FuncNetwork [w,z,m]  = topological network fragmentation with the 
%                          projects analysed in every scenario
%   Frag        [Struct] = Length of fragmented rivers for every project 
%                          analysed
%   DOR         [w,m]    = Degrees of Regulation Index for every seccion 
%                          of the Topological Network
%   DORw        [w,m]    = Degrees of Regulation Index for every seccion 
%                          of the Topological Network
%   SAI         [w,m]    = Sediment Alteration Index
%
%--------------------------------------------------------------------------
%                              REFERENCES
%--------------------------------------------------------------------------
% - Authors of base Code : Carlos Andres Rogeliz Prada
%                          Hector Angarita
% - https://www.nature.org/media/freshwater/power-of-rivers-report.pdf
% - https://www.seforall.org/sites/default/files/powerofriversreport_final1.pdf
% - Héctor Angarita, Albertus J. Wickel, Jack Sieber, John Chavarro, Javier 
%   A. Maldonado-Ocampo, Guido A. Herrera-R, Juliana Delgado and David Purkey, 
%   "Basin-scale impacts of hydropower development on the Mompós Depression 
%   wetlands, Colombia," Hydrology and Earth System Sciences, 
%   doi:10.5194/hess-22-2839-2018, May 2018.
% 

% Assignation Scenario
Hp.Scenario = ScePar;

%% Check Inputs
% streamflow
if (AnalysisType == 1) || (AnalysisType == 3) || (AnalysisType == 5) || (AnalysisType == 7)
    Streamflow = varargin{1};
end

% Sediment
if (AnalysisType == 2) || (AnalysisType == 3) || (AnalysisType == 6) || (AnalysisType == 7)
    if (AnalysisType == 2) || (AnalysisType == 6)
        Sediment = varargin{1};
    else
        Sediment = varargin{2};
    end
end

%% Processing
% Ignore projects that not find in the topological Network
Esc_ArcID   = Hp.ArcID( logical(Hp.Scenario) );
[id, ~]     = ismember(Hp.ArcID, Esc_ArcID);
[~, posi]   = ismember(Hp.ArcID, Network.ID);
Tmp         = posi(id);
Esc_ArcID   = Network.ID(Tmp(Tmp > 0));
[id, ~]     = ismember(Hp.ArcID, Esc_ArcID);
[~, posi]   = ismember(Hp.ArcID, Network.ID);

AccumVar = zeros( length(Network.ID), 2);

%% Input Data by DOR and DORw in the Analysis Network Function 
if (AnalysisType == 1) || (AnalysisType == 3) || (AnalysisType == 5) || (AnalysisType == 7) 
    % Volumens
    AccumVar(posi(id),1)    = Hp.Volumen(id);

    % Runoff of each River Seccion with dam
    ProVar                  = zeros( length(Network.ID), 1);
    ProVar(posi(id))        = Hp.Qmed(id);
end

%% Input Data by Sediment Alteration Index in the Analysis Network Function 
if (AnalysisType == 2) || (AnalysisType == 3) || (AnalysisType == 6) || (AnalysisType == 7) 
    % Contribution of Sediments (Ton/Years) - Scenario basic 
    AccumVar(:,2)           = Sediment;

    AccumLossVar            = zeros( length(Network.ID), 1);
    AccumLossVar(:,1)       = Sediment;

    % Loss rate
    LossRate                = zeros( length(Network.ID), 1);
    LossRate(posi(id))      = Hp.LossRate(id);
end

% Barrier
Barrier(posi(id),1) = Hp.ID(id);

% Maximum value of recursion 
set(0,'RecursionLimit',5000)

%% Analysis Network
if (AnalysisType == 4)
    [FuncNetwork] = AnalysisNetwork(Network, Barrier);
elseif (AnalysisType == 1) || (AnalysisType == 5)
    [FuncNetwork,ProVarOut,AccumVarOut] = AnalysisNetwork(Network, Barrier, ProVar, AccumVar);
elseif (AnalysisType == 2) || (AnalysisType == 6)
    [FuncNetwork,~,AccumVarOut,~,AccumLossVarOut] = AnalysisNetwork(Network, Barrier,[], AccumVar, [], LossRate,AccumLossVar);
elseif (AnalysisType == 3) || (AnalysisType == 7)
    [FuncNetwork,ProVarOut,AccumVarOut,~,AccumLossVarOut] = AnalysisNetwork(Network, Barrier, ProVar, AccumVar, [], LossRate,AccumLossVar);
end

%% DOR (Degree Of Regulation)
if (AnalysisType == 1) || (AnalysisType == 3) || (AnalysisType == 5) || (AnalysisType == 7)
    % Factor : m3/(seg*year) -> m3
    Factor      = 86400 * 365;            
    DOR         = ( AccumVarOut(:,1)./(Streamflow * Factor) ).* 100;
    DORw        = DOR .* (ProVarOut ./ Streamflow);
end

%% SAI (Sediments Alteration Index)
if (AnalysisType == 2) || (AnalysisType == 3) || (AnalysisType == 6) || (AnalysisType == 7)
    SAI    = ( 1 - (AccumLossVarOut./AccumVarOut(:,2)) ).*100;
end

%% OUTPUT DATA
if (AnalysisType == 1) || (AnalysisType == 5)
    % DOR-h
    varargout{1} = DOR;
    % DOR-w
    varargout{2} = DORw;
elseif (AnalysisType == 2) || (AnalysisType == 6)
    % Sediment
    varargout{1} = SAI;
elseif (AnalysisType == 3) || (AnalysisType == 7)
    % DOR-h
    varargout{1} = DOR;
    % DOR-w
    varargout{2} = DORw;
    % Sediment
    varargout{3} = SAI;
end

end
