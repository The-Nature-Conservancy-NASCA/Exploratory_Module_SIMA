function Scenarios = RandomScenarios(Hp)
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
% Function for Generation of Project Combinations
% Make all possible combinations of Projects if the maximum defined parameter 
% is not exceeded, otherwise, select the scenario projects with random 
% selection in a uniform way in all combination ranges
%
% -------------------------------------------------------------------------
%                               INPUTS DATA
% -------------------------------------------------------------------------
% Hp [ClassHydroelectricProject]
% Hp.ProjectID      Vector of n rows with the ID of the projects to combine
% Hp.ThresholdComb  Maximum number of combinations to be made
%
% -------------------------------------------------------------------------
% OUTPUTS DATA
% -------------------------------------------------------------------------
% Scenarios [n,m] = Combination of scenarios. where "n" is the project number
%                   and "m" is combination number 
%
%--------------------------------------------------------------------------
%                              REFERENCES
%--------------------------------------------------------------------------
% - Authors of base Code : Carlos Andres Rogeliz Prada
%

ProjectID       = Hp.ID( Hp.Scenario );
ThresholdComb   = Hp.NumRand;

NumProj = length(ProjectID);
NumComb = zeros(NumProj,1);

for k = 1:length(ProjectID)
    NumComb(k) = factorial(NumProj) / (factorial(k)*factorial(NumProj-k));
end

TotalComb = sum(NumComb(isnan(NumComb)==0));
% Generacion de Combinacion de proyectos para Escenario

Cont = 1;
if (TotalComb < ThresholdComb)
    
    % Configura todas las combinaciones de proyectos posibles sin repetici�n
    Scenarios      = zeros(NumProj, TotalComb + 1);
    
    for i = 1:length(ProjectID)
        
        Selection = nchoosek(ProjectID, i);
        
        for w = 1:size(Selection,1)
            for z = 1:size(Selection,2)
                Scenarios( (ProjectID == Selection(w,z)) ,Cont) = 1;
            end
            Cont = Cont + 1;
        end
    end
    
else
    
    MissingComb     = ThresholdComb;
    Scenarios       = zeros(NumProj, ThresholdComb + 1);
    NumSceProj      = length(ProjectID); 
    Cont            = 1; 
    
    while (MissingComb > 0)
        % Generación aleatoria
        SeedRandom  = rand();
        PreRandom   = rand(NumSceProj,1);
        ProjRandom  = zeros(NumSceProj,1);
        
        for i = 1:length(PreRandom)
            if PreRandom(i) > SeedRandom
                ProjRandom(i) = 1;
            end
        end
        
        %verifica si la generaci�n aleatoria ya se encuentra
        %como escenario. Evita repetir Scenarios!
        check1  = 0;
        [~,Col] = size(Scenarios);
        
        for w = 1:Col
            if (length(find(Scenarios(:,w) == ProjRandom)) == NumSceProj)
                check1 = 1;
                break
            end
        end
        
        if (check1 == 0)
            Scenarios(:,Cont) = ProjRandom;
            Cont     = Cont + 1;
            MissingComb = MissingComb - 1;
        end
        
    end
end

Scenarios = logical( Scenarios);

end