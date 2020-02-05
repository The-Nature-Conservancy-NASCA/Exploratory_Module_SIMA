function WriteError(UserData, ErrorNumber)

% ----------------------------------
NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', num2str(UserData.ExeNumber),UserData.R_FileErrors);
ID_File   = fopen(NameFile,'w');
fprintf(ID_File, '%d', ErrorNumber);
fclose(ID_File);
% ----------------------------------