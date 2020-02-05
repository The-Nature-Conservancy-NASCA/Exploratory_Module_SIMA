function WriteResults(Network, Hp, AnalysisMode, Var, NameFile, NameFolder, varargin)    
% -------------------------------------------------------------------------
% /usr/bin/Matlab-R2018b
% -------------------------------------------------------------------------
% Example AnalysisNetwork
% -------------------------------------------------------------------------
% BASE DATA 
% -------------------------------------------------------------------------
% Author            : Jonathan Nogales Pimentel 
% Email             : Jonathan.nogales@tnc.org
% Company           : The Nature Conservancy - TNC
% 
% Please do not share without permision of the autor
% -------------------------------------------------------------------------
% License
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
%

mkdir(fullfile(NameFolder))
NameFile = fullfile(NameFolder,NameFile);

if (nargin == 6) || (nargin == 8)
    
    if AnalysisMode == 1

        Value = 'ID';
        for i = 1:length(Var(1,:))
            Value = [Value,',Trajectory_', num2str(i)];
        end
    else
        Tmp     = unique( Hp.Years );
        Years   = sort( Tmp( Tmp > 0) );

        Value = 'ID';
        for i = 1:length(Years)
            Value = [Value,',', num2str(Years(i))];
        end
    end

    ID_File  = fopen(NameFile,'w');

    fprintf(ID_File, '%s', Value);
    fprintf(ID_File, '\r\n');

    Value = '%u';
    for i = 1:length(Var(1,:))
        Value = [Value,',%.3f'];
    end
    Value = [Value,'\r\n'];

    fprintf(ID_File, Value, [Network.ID Var]');
    fclose(ID_File);
end

if nargin == 8
    
    PointsInt   = varargin{1};
    Frag        = varargin{2};
    
    mkdir(fullfile(NameFolder,'Fragmentation'))
    Tata = [0; PointsInt];
    
    if AnalysisMode == 1
    
        Value1 = 'ID';
        for i = 1:length(Var(1,:))
            Value1 = [Value1,',Trajectory_', num2str(i)];
        end
    else
        Tmp     = unique( Hp.Years );
        Years   = sort( Tmp( Tmp > 0) );

        Value1 = 'ID';
        for i = 1:length(Years)
            Value1 = [Value1,',', num2str(Years(i))];
        end
    end
    
    for j = 1:length(PointsInt) + 1
        
        ID_File  = fopen(fullfile(NameFolder,'Fragmentation',[num2str(Tata(j)),'.csv']),'w');

        fprintf(ID_File, '%s', Value1);
        fprintf(ID_File, '\r\n');
        
        eval(['Var = table2array(Frag.Table_',num2str(Tata(j)),');'])
        Value = '%u';
        for i = 2:length(Var(1,:))
            Value = [Value,',%.3f'];
        end
        Value = [Value,'\r\n'];

        fprintf(ID_File, Value, Var');
        fclose(ID_File);

%         writetable(eval(['Frag.Table_',num2str(Tata(j))]),fullfile(NameFolder,'Fragmentation',[num2str(Tata(j)),'.csv']),'Delimiter',',')
        
    end    
end

if nargin == 9
    
    Var = varargin{3};
    
    if AnalysisMode == 1

        Value = 'ID';
        for i = 1:length(Var(1,:))
            Value = [Value,',Trajectory_', num2str(i)];
        end
    else
        Tmp     = unique( Hp.Years );
        Years   = sort( Tmp( Tmp > 0) );

        Value = 'ID';
        for i = 1:length(Years)
            Value = [Value,',', num2str(Years(i))];
        end
    end

    ID_File  = fopen(NameFile,'w');

    fprintf(ID_File, '%s', Value);
    fprintf(ID_File, '\r\n');

    Value = '%u';
    for i = 1:length(Var(1,:))
        Value = [Value,',%u'];
    end
    Value = [Value,'\r\n'];

    fprintf(ID_File, Value, [Hp.ID Var]');
    fclose(ID_File);
    
end