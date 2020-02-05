%% FUNTIONS
function WriteResults_Power(Hp, AnalysisMode, Var,NameFile,NameFolder, varargin)    

mkdir(fullfile(NameFolder))
NameFile = fullfile(NameFolder,NameFile);
if AnalysisMode == 1
    
    Value = ['Trajectory_', num2str(1)];
    for i = 2:length(Var(1,:))  
        Value = [Value,',Trajectory_', num2str(i)];
    end
else
    Tmp     = unique( Hp.Years );
    Years   = sort( Tmp( Tmp > 0) );
    
    Value = [num2str(Years(1))];
    for i = 2:length(Years)
        Value = [Value,',', num2str(Years(i))];
    end
end

ID_File  = fopen(NameFile,'w');

fprintf(ID_File, '%s', Value);
fprintf(ID_File, '\r\n');

Value = '%.3f';
for i = 2:length(Var(1,:))
    Value = [Value,',%.3f'];
end
Value = [Value,'\r\n'];

fprintf(ID_File, Value, Var');
fclose(ID_File);