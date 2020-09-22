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

%% Preliminary
clear
clc
close

warning off

%% Packages
Models = PackageModelsTier1;

%% Parameters
NaNValue = -999;

%% Inputs Data
UserData.FileControlMATLAB      = 'Control_File_MATLAB.txt'; 
UserData.FileControlSIMA        = 'Control_File_SIMA.txt';
UserData.FileNetwork            = 'Topological_Network.csv';
UserData.FileProjects           = 'Projects.csv';
UserData.FileFootprint          = 'Footprint.csv';
UserData.R_FileErrors           = 'Errors.txt';
UserData.R_FileInstallPower     = 'InstallPower.csv';
UserData.R_FileScenarios        = 'AleatoryDefinition.csv';      
UserData.R_FileDOR              = 'DOR.csv';
UserData.R_FileDORw             = 'DORw.csv';
UserData.R_FileSAI              = 'SAI.csv';
UserData.R_FileFunNetwork       = 'FuncNetwork.csv';
UserData.R_FileFootprints       = 'Footprints.csv';
UserData.R_FileAreaVolumen      = 'Area_Volumen.csv';
UserData.R_FileDEM              = 'DEM.mat';
UserData.R_FileFlowDir          = 'FlowDir.mat';
UserData.R_FileFlowAccum        = 'FlowAccum.mat';
UserData.R_FileWaterMirror      = 'Watermirror.tif';

try 
    %% Load Control File MATLAB
    try
        ID_File     = fopen( UserData.FileControlMATLAB ,'r');

        Po = 1;
        LineFile = fgetl(ID_File);
        while ischar(LineFile)

            Tmp = strfind(LineFile, '*');
            if ~isempty(Tmp)
                LineFile = strrep(LineFile,'*','');
                LineFile = strrep(LineFile,' ','');
                if Po == 1
                    UserData.MainPath       = LineFile;
                elseif Po == 2
                    UserData.DEMPath        = LineFile;
                elseif Po == 3
                    UserData.FootprintPath  = LineFile;
                elseif Po == 4
                    UserData.MatlabPath     = LineFile;
                elseif Po == 5
                    ThresholdAccum          = str2double(LineFile);
                end
                Po = Po + 1;
            end

            LineFile = fgetl(ID_File);

        end

        % Check Folder 
        if ~exist(UserData.MainPath, 'dir')
            % errordlg(['The folder ',UserData.MainPath, 'No exist'])   
            ErrorNumber = -100;
            WriteError(UserData, ErrorNumber)
            return
        elseif ~exist(UserData.DEMPath, 'file')
            %errordlg(['The folder ',UserData.DEMPath, 'No exist'])
            ErrorNumber = -101;
            WriteError(UserData, ErrorNumber)
            return
        elseif ~exist(UserData.FootprintPath, 'dir')
            %errordlg(['The folder ',UserData.FootprintPath, 'No exist'])
            ErrorNumber = -102;
            WriteError(UserData, ErrorNumber)
            return
        elseif ~exist(UserData.MatlabPath, 'dir')
            %errordlg(['The folder ',UserData.MatlabPath, 'No exist'])
            ErrorNumber = -103;
            WriteError(UserData, ErrorNumber)
            return
        end

    catch    
    end
    
    %% Disp UserData
    disp(UserData)
    
    %% Load Control File SIMA
    ID_File     = fopen(fullfile(UserData.MainPath, UserData.FileControlSIMA),'r');
    Po = 1;
    LineFile = fgetl(ID_File);
    while ischar(LineFile)

        Tmp = strfind(LineFile, '*');
        if ~isempty(Tmp)
            LineFile = strrep(LineFile,'*','');
            LineFile = strrep(LineFile,' ','');
            if Po == 1
                UserData.UserName           = LineFile;
            elseif Po == 2
                UserData.ExeNumber          = LineFile;
            elseif Po == 3
                UserData.AnalysisCode       = str2double(LineFile);
            elseif Po == 4
                UserData.FootprintStatus    = logical(str2double(LineFile));
            elseif Po == 5
                UserData.ExplorerStatus     = str2double(LineFile);
            end
            Po = Po + 1;
        end

        LineFile = fgetl(ID_File);

    end
    fclose(ID_File);
    
    %% Create Folders 
    mkdir(fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber))
    
    %% Footprint
    if UserData.FootprintStatus || (UserData.ExplorerStatus ~= 0)
        
        % Areas 
        mkdir(fullfile(UserData.MatlabPath,'Area_matlab'))
        ID_File     = fopen(fullfile(UserData.MainPath,UserData.UserName,'Inputs',UserData.ExeNumber,UserData.FileFootprint),'r');
        NameAreas   = textscan(ID_File,'%s%f','Delimiter',',');
        fclose(ID_File);
        StatusAreas = logical(NameAreas{2});
        NameAreas   = NameAreas{1};
        
        if (sum(StatusAreas) > 0)
            cont = 1;
            for i = 1:length(NameAreas)
                if StatusAreas(i)
                    try
                        load(fullfile(UserData.MatlabPath,'Area_matlab',[NameAreas{i},'.mat']))
                    catch
                        Area = GRIDobj( fullfile(UserData.FootprintPath,[NameAreas{i},'.tiff']));
                        save(fullfile(UserData.MatlabPath,'Area_matlab',[NameAreas{i},'.mat']),'Area')
                    end
                    eval(['Areas.A',num2str(cont),' = [find(~isnan(Area.Z)), Area.Z(~isnan(Area.Z))];'])
                    cont = cont + 1;
                end
            end
            St_Area = true;
        else
            St_Area = false;
        end
        
        try
            load(fullfile(UserData.MatlabPath,'DEM',UserData.R_FileDEM))
            load(fullfile(UserData.MatlabPath,'FlowDir',UserData.R_FileFlowDir))
            load(fullfile(UserData.MatlabPath,'FlowAccum',UserData.R_FileFlowAccum))

        catch
            mkdir(fullfile(UserData.MatlabPath,'FlowDir'))
            mkdir(fullfile(UserData.MatlabPath,'FlowAccum'))
            mkdir(fullfile(UserData.MatlabPath,'DEM'))

            DEM         = GRIDobj( UserData.DEMPath );
            DEM_Fill    = DEM.fillsinks; 

            % Get FLowDir 
            FlowDir     = FLOWobj(DEM_Fill);

            % Get FlowAccumUserData.FileNetwork
            FlowAccum   = FlowDir.flowacc; 

            save(fullfile(UserData.MatlabPath,'DEM',UserData.R_FileDEM),'DEM')
            save(fullfile(UserData.MatlabPath,'FlowDir',UserData.R_FileFlowDir),'FlowDir')
            save(fullfile(UserData.MatlabPath,'FlowAccum',UserData.R_FileFlowAccum),'FlowAccum')

        end


    end
    
    %% Disp UserData
    disp(UserData)
    
    %% Input Data Network
    % Load Data Network
    ID_File = fopen(fullfile(UserData.MainPath,UserData.UserName,'Inputs',UserData.ExeNumber,UserData.FileNetwork),'r');
    Tmp     = textscan(ID_File,'%s',13,'Delimiter',',');
    Tmp     = textscan(ID_File,'%f','Delimiter',',');
    Tmp     = reshape(cell2mat(Tmp),13,[])';
    Tmp(Tmp == NaNValue) = NaN;
    fclose(ID_File);

    Network     = ClassNetwork(Tmp(:,1),Tmp(:,2), Tmp(:,3),Tmp((Tmp(:,4) == 1), 1));
    LenRiver    = Tmp(:,5);
    PointsInt   = Network.ID((Tmp(:,8) > 0));
    if UserData.ExplorerStatus == 0
        BasinArea   = Tmp(:,6)*(1E6);
        FactorFlow  = Tmp(:,7);    
        Pcp         = Tmp(:,9);
        T           = Tmp(:,10);
        ETR         = Tmp(:,11);
        Streamflow  = Tmp(:,12);
        Sediment    = Tmp(:,13);
    end

    clearvars Tmp

    %% Input Data Projects
    % Load Data project
    ID_File = fopen(fullfile(UserData.MainPath,UserData.UserName,'Inputs',UserData.ExeNumber,UserData.FileProjects),'r');
    Tmp     = fgetl(ID_File);
    N       = length( strsplit(Tmp, ','));
    fclose(ID_File);

    ID_File = fopen(fullfile(UserData.MainPath,UserData.UserName,'Inputs',UserData.ExeNumber,UserData.FileProjects),'r');
    Tmp     = textscan(ID_File,'%s',9,'Delimiter',',');
    Tmp     = textscan(ID_File,'%s',N - 9,'Delimiter',',');

    StatusRan   = zeros(length(Tmp{1,1}),1);
    NumRand     = StatusRan;
    NameFolderNarra = cell(length(Tmp{1,1}),1);
    for i = 1:length(Tmp{1,1})
        o = Tmp{1,1}{i};
        o = strsplit(o,'|');
        NameFolderNarra{i} = [o{1},'_',o{2}];
        StatusRan(i)    = logical(str2double(o{3}));
        NumRand(i)      = str2double(o{4});
    end

    Tmp    = textscan(ID_File,'%f','Delimiter',',');
    Tmp    = reshape(cell2mat(Tmp),N,[])';
    Scenarios = Tmp(:,10:N);
    fclose(ID_File);

    Tmp(Tmp == NaNValue) = NaN;
    if UserData.ExplorerStatus == 1
        Tmp(isnan(Tmp)) = 0; 
    end
    
    %% Ojooooo !!!!! Control de ArcID Repetidos
    Store_Posi = {};
    for i = 10:length(Tmp(1,:))
        Store_Posi{i - 9} = Tmp(logical(Tmp(:,i)),1);
    end
    [id, posi] = ismember(unique(Tmp(:,1)),  Tmp(:,1));
    Tmp = Tmp(posi,:);
    Tmp(:,10:end) = 0;
    for i = 1:length(Store_Posi)
        [id, posi] = ismember(Tmp(:,1), Store_Posi{i});
        Tmp(:,9+i) = id;
    end
    
    % Create Hydroelectric Project Object
    Hp              = ClassHydroelectricProject(Tmp(:,1));
    Hp.Coor_X       = Tmp(:,2);
    Hp.Coor_Y       = Tmp(:,3);
    Hp.ArcID        = Tmp(:,4);
    Hp.InstallPower = Tmp(:,5);
    Hp.Volumen      = Tmp(:,6);
    Hp.Height       = Tmp(:,7);
    Hp.LossRate     = Tmp(:,8);
    Hp.Years        = Tmp(:,9);
    Hp.Scenario     = (Tmp(:,1)*0);
    Hp.StatusRan    = 0;
    Hp.NumRand      = 0;
    Hp.Qmed         = (Tmp(:,1)*0);    
    
    %% Check -> Hydropower Variables
    NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', num2str(UserData.ExeNumber),'StatusError.txt');
    ID_File     = fopen(NameFile,'w');
    
    % DOR and DORw check
    JoJo = Hp.Volumen == 0;
    if sum(JoJo) > 0
        ValueError = Hp.ID(JoJo);
        fprintf(ID_File,'- En los modelos de DOR y DORw los siguientes proyectos identificados con los cÃ³digos ');
        fprintf(ID_File,num2str(ValueError(1)));        
        for i = 2:length(ValueError)
            fprintf(ID_File,[', ',num2str(ValueError(i))]);
        end
        fprintf(ID_File,'  no fueron considerados dado que presentan valores de cero [0] en el volumen embalsado');
        fprintf(ID_File,'\n');
    else
        fprintf(ID_File,'- En los modelos de DOR y DORw todos los proyectos fueron considerados.');
        fprintf(ID_File,'\n');
    end 
    
    % SAI
    JoJo = Hp.LossRate == 0;
    if sum(JoJo) > 0
        ValueError = Hp.ID(JoJo);
        fprintf(ID_File,'- En el modelo de SAI los siguientes proyectos identificados con los cÃ³digos ');
        fprintf(ID_File,num2str(ValueError(1)));        
        for i = 2:length(ValueError)
            fprintf(ID_File,[', ',num2str(ValueError(i))]);
        end
        fprintf(ID_File,'  no fueron considerados dado que presentan valores de cero [0] en el porcentaje de retenciÃ³n de sedimentos.');
        fprintf(ID_File,'\n');
    else
        fprintf(ID_File,'- En el modelo de SAI todos los proyectos fueron considerados.');
        fprintf(ID_File,'\n');
    end
    
    % Huella
    JoJo = Hp.Height == 0;
    if sum(JoJo) > 0
        ValueError = Hp.ID(JoJo);
        fprintf(ID_File,'- En el modelo de Huella los siguientes proyectos identificados con los cÃ³digos ');
        fprintf(ID_File,num2str(ValueError(1)));        
        for i = 2:length(ValueError)
            fprintf(ID_File,[', ',num2str(ValueError(i))]);
        end
        fprintf(ID_File,'  no fueron considerados dado que presentan valores de cero [0] en el porcentaje de retenciÃ³n de sedimentos.');
    else
        fprintf(ID_File,'- En el modelo de Huella todos los proyectos fueron considerados.');
    end
    fclose(ID_File);   
    
    if UserData.ExplorerStatus == 0
        %% Streamflow
        if sum(isnan(Streamflow)) == 0
            % streamflow Asigantion 
            [~, posi]  = ismember(Hp.ArcID, Network.ID);
            Hp.Qmed    = Streamflow(posi);

        elseif sum(isnan(T)) >= 1
            % Calculate Streamflow (m3/seg)
            Qsim = BasinArea.*(((Pcp - ETR))./(1000*3600*24*365));

            % Acumulated Streanflow (m3/seg)
            [~,~,Streamflow] = Network.AnalysisNetwork([],[],Qsim);

            [~, posi]  = ismember(Hp.ArcID, Network.ID);
            Hp.Qmed    = Streamflow(posi);

        elseif sum(isnan(ETR)) >= 1
            % Calculate Evapotranspiration (mm)
            L       = 300 + (25 * T) + (0.05 * (T.^3));
            id      = ((Pcp./L) > 0.316);
            ETR(id) = (Pcp(id))./sqrt( 0.9 + ((Pcp(id).^2)./(L(id).^2)) );
            id      = ((Pcp./L) <= 0.316);
            if sum(id) > 0
                ETR(id) = Pcp(id);    
            end
            ETRc    = ETR .* FactorFlow;

            % Calculate Streamflow (m3/seg)
            Qsim    = BasinArea.*(((Pcp - ETRc))./(1000*3600*24*365));

            % Acumulated Streanflow (m3/seg)
            [~,~,Streamflow] = Network.AnalysisNetwork([],[],Qsim);

            [~, posi]  = ismember(Hp.ArcID, Network.ID);
            Hp.Qmed    = Streamflow(posi);
        end

        %% Sediment completation
        if (UserData.AnalysisCode ~= 4) && (UserData.AnalysisCode ~= 5)
            LossR = Hp.SedimentDendy;
            Hp.LossRate(isnan(Hp.LossRate)) = LossR(isnan(Hp.LossRate));
        end
    end

    % Footprints
    if UserData.ExplorerStatus == 0

        %% TIER - 1
        AnalysisMode    = 2;

        if  (sum(Hp.Years ~= 0) > 0)        

            mkdir( fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber, 'BaseLine') )
            NameFolder = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber, 'BaseLine');

            if UserData.AnalysisCode == 1
                % 1. DOR
                [ErrorNumber, Scenario, ~, DOR, DORw]                       = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode, PointsInt, Streamflow, Sediment);

            elseif UserData.AnalysisCode == 2
                % 2. SAI
                [ErrorNumber, Scenario, ~, SAI]                             = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, Sediment);

            elseif UserData.AnalysisCode == 3
                % 3. DOR + SAI
                [ErrorNumber, Scenario, ~, DOR, DORw, SAI]                  = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, Streamflow, Sediment);

            elseif UserData.AnalysisCode == 4
                % 4. Fragmentation
                [ErrorNumber, Scenario, FuncNetwork, Frag]                  = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, LenRiver);

            elseif UserData.AnalysisCode == 5
                % 5. Fragmentation + DOR
                [ErrorNumber, Scenario, FuncNetwork, Frag, DOR, DORw]       = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, LenRiver, Streamflow);

            elseif UserData.AnalysisCode == 6
                % 6. Fragmentation + SAI
                [ErrorNumber, Scenario, FuncNetwork, Frag, SAI]             = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, LenRiver, Sediment);

            elseif UserData.AnalysisCode == 7
                % 7. Fragmentation + DOR + SAI
                [ErrorNumber, Scenario, FuncNetwork, Frag, DOR, DORw, SAI]  = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, LenRiver, Streamflow, Sediment);
            end            
            
            % ----------------------------------            
            if ErrorNumber ~= -1
                WriteError(UserData, ErrorNumber)
                return
            end
            % ----------------------------------

            % Save Results
            Power = NaN(1, length(Scenario(1,:)));
            for k = 1:length(Scenario(1,:))
                Power(k) = sum( Hp.InstallPower(Scenario(:,k)), 'omitnan');
            end
            
            WriteResults_Power( Hp, AnalysisMode, Power, UserData.R_FileInstallPower, NameFolder) 
            
            WriteResults(Network, Hp, AnalysisMode, [], UserData.R_FileScenarios,NameFolder, [], [], Scenario) 
            
            if exist('DOR','var')
                WriteResults(Network, Hp, AnalysisMode, DOR, UserData.R_FileDOR, NameFolder) 
                WriteResults(Network, Hp, AnalysisMode, DORw, UserData.R_FileDORw, NameFolder)
            end
            if exist('SAI','var')
                WriteResults(Network, Hp, AnalysisMode, SAI, UserData.R_FileSAI,NameFolder) 
            end
            if exist('Frag','var')
                WriteResults(Network, Hp, AnalysisMode, FuncNetwork, UserData.R_FileFunNetwork,NameFolder, PointsInt, Frag) 
            end  
            clearvars DOR DORw SAI Scenario Frag InstallPower Scenario FuncNetwork
            
            %% Footprint BaseLine
            if UserData.FootprintStatus

                mkdir(fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,'BaseLine','Footprints'))
                ModeA = false;
                Hp.StatusRan    = 0;
                Hp.NumRand      = 0;
                Hp.Scenario     = (Hp.Years > 0);
                AnalysisMode    = 1;
                [ErrorNumber, Scenario, FuncNetwork, Frag] = Models.Tier1( 0, Network, Hp, 4, AnalysisMode,PointsInt, LenRiver);
                                
                % ----------------------------------
%                 WriteError(UserData, ErrorNumber)
                if ErrorNumber ~= -1
                    WriteError(UserData, ErrorNumber)
                    return
                end
                % ----------------------------------
                
                if St_Area
                    [ErrorNumber, Factor, Area_Hp, Volumen_Hp, WaterMirror, Footprint_Hp] = ...
                        Models.Footprint( Hp, DEM, ThresholdAccum, Network, FuncNetwork, ModeA, FlowDir, FlowAccum, Areas);
                else
                    [ErrorNumber, Factor, Area_Hp, Volumen_Hp, WaterMirror, Footprint_Hp] = ...
                        Models.Footprint( Hp, DEM, ThresholdAccum, Network, FuncNetwork, ModeA, FlowDir, FlowAccum);
                end
                
                clearvars Frag Scenario FuncNetwork

                % ----------------------------------
%                 WriteError(UserData, ErrorNumber)
                if ErrorNumber ~= -1
                    WriteError(UserData, ErrorNumber)
                    return
                end
                % ----------------------------------
                
                [Fil, col, fondo] =  size(Footprint_Hp);
                if fondo == 1
                    Footprint_Hp = Footprint_Hp';
                else
                    Footprint_Hp = permute(Footprint_Hp,[2 3 1]);
                end

                %% Save Results 
                NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,'BaseLine','Footprints',UserData.R_FileAreaVolumen);
                ID_File     = fopen(NameFile,'w');

                fprintf(ID_File, '%s', 'ID,Area (m2),Volumen (m3), ');
                fprintf(ID_File, '\r\n');

                fprintf(ID_File, '%u,%.3f,%.3f\r\n', [Hp.ID(Hp.Scenario)'; Area_Hp; Volumen_Hp]);
                fclose(ID_File);
                
                if St_Area
                    NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,'BaseLine','Footprints',UserData.R_FileFootprints);
                    ID_File   = fopen(NameFile,'w');

                    Value = 'ID';
                    for i = 1:length(NameAreas)
                        if StatusAreas(i)
                            Value = [Value,',',NameAreas{i}];
                        end
                    end

                    fprintf(ID_File, '%s', Value);
                    fprintf(ID_File, '\r\n');

                    Value = '%u';
                    for i = 1:length(Footprint_Hp(1,:))
                        Value = [Value,',%.3f'];
                    end
                    Value = [Value,'\r\n'];

                    fprintf(ID_File, Value, [Hp.ID(Hp.Scenario)'; Footprint_Hp']);
                    fclose(ID_File);
                end
                NW = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,'BaseLine','Footprints',UserData.R_FileWaterMirror);
                WaterMirror.GRIDobj2geotiff(NW)
                movefile(NW, [NW,'f'])
                
            end
        end

        AnalysisMode = 1; 
        for i = 1:length(StatusRan)

            Hp.StatusRan    = StatusRan(i);
            Hp.NumRand      = NumRand(i);
            Hp.Scenario     = Scenarios(:,i);
            Hp.Scenario(Hp.Years > 0) = 0;
            
%             mkdir(fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber, ['Narrative-',num2str(i)]))
%             NameFolder      = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber, ['Narrative-',num2str(i)]);
            
            mkdir(fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber, NameFolderNarra{i}))
            NameFolder      = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber, NameFolderNarra{i});
            
            if UserData.AnalysisCode == 1
                % 1. DOR
                [ErrorNumber, Scenario, ~, DOR, DORw]                       = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode, PointsInt, Streamflow, Sediment);

            elseif UserData.AnalysisCode == 2
                % 2. SAI
                [ErrorNumber, Scenario, ~, SAI]                             = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, Sediment);

            elseif UserData.AnalysisCode == 3
                % 3. DOR + SAI
                [ErrorNumber, Scenario, ~, DOR, DORw, SAI]                  = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, Streamflow, Sediment);

            elseif UserData.AnalysisCode == 4
                % 4. Fragmentation
                [ErrorNumber, Scenario, FuncNetwork, Frag]                  = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, LenRiver);

            elseif UserData.AnalysisCode == 5
                % 5. Fragmentation + DOR
                [ErrorNumber, Scenario, FuncNetwork, Frag, DOR, DORw]       = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, LenRiver, Streamflow);

            elseif UserData.AnalysisCode == 6
                % 6. Fragmentation + SAI
                [ErrorNumber, Scenario, FuncNetwork, Frag, SAI]             = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, LenRiver, Sediment);

            elseif UserData.AnalysisCode == 7
                % 7. Fragmentation + DOR + SAI
                [ErrorNumber, Scenario, FuncNetwork, Frag, DOR, DORw, SAI]  = Models.Tier1( 0, Network, Hp, UserData.AnalysisCode, AnalysisMode,PointsInt, LenRiver, Streamflow, Sediment);
            end

            % ----------------------------------
%             WriteError(UserData, ErrorNumber)
            if ErrorNumber ~= -1
                WriteError(UserData, ErrorNumber)
                return
            end
            % ----------------------------------
            
            %%
            Power = NaN(1, length(Scenario(1,:)));
            for k = 1:length(Scenario(1,:))
                Power(k) = sum( Hp.InstallPower(Scenario(:,k)), 'omitnan');
            end

            WriteResults_Power( Hp, AnalysisMode, Power, UserData.R_FileInstallPower, NameFolder) 
            
            WriteResults(Network, Hp, AnalysisMode, [], UserData.R_FileScenarios,NameFolder, [], [], Scenario) 
            
            if exist('DOR','var')
                WriteResults(Network, Hp, AnalysisMode, DOR, UserData.R_FileDOR, NameFolder) 
                WriteResults(Network, Hp, AnalysisMode, DORw, UserData.R_FileDORw, NameFolder)
            end
            if exist('SAI','var')
                WriteResults(Network, Hp, AnalysisMode, SAI, UserData.R_FileSAI,NameFolder) 
            end
            if exist('Frag','var')
                WriteResults(Network, Hp, AnalysisMode, FuncNetwork, UserData.R_FileFunNetwork, NameFolder, PointsInt, Frag) 
            end
            clearvars DOR DORw SAI Scenario Frag InstallPower Scenario FuncNetwork
            
            %% Footprint Random
            if UserData.FootprintStatus

%                 mkdir(fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,['Narrative-',num2str(i)],'Footprints'))
                mkdir(fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,NameFolderNarra{i},'Footprints'))
                
                ModeA = false;
                Hp.StatusRan    = 0;
                Hp.NumRand      = 0;

                [ErrorNumber, Scenario, FuncNetwork, Frag] = Models.Tier1( 0, Network, Hp, 4, AnalysisMode,PointsInt, LenRiver);

                % ----------------------------------
%                 WriteError(UserData, ErrorNumber)
                if ErrorNumber ~= -1
                    WriteError(UserData, ErrorNumber)
                    return
                end
                % ----------------------------------
                
                if St_Area                    
                    [ErrorNumber, Factor, Area_Hp, Volumen_Hp, WaterMirror, Footprint_Hp] = ...
                        Models.Footprint( Hp, DEM, ThresholdAccum, Network, FuncNetwork, ModeA, FlowDir, FlowAccum, Areas);
                else
                    [ErrorNumber, Factor, Area_Hp, Volumen_Hp, WaterMirror, Footprint_Hp] = ...
                        Models.Footprint( Hp, DEM, ThresholdAccum, Network, FuncNetwork, ModeA, FlowDir, FlowAccum);
                end

                clearvars Frag Scenario FuncNetwork

                % ----------------------------------
%                 WriteError(UserData, ErrorNumber)
                if ErrorNumber ~= -1
                    WriteError(UserData, ErrorNumber)
                    return
                end
                % ----------------------------------

                [Fil, col, fondo] =  size(Footprint_Hp);
                if fondo == 1
                    Footprint_Hp = Footprint_Hp';
                else
                    Footprint_Hp = permute(Footprint_Hp,[2 3 1]);
                end

                %% Save Results 
%                 NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,['Narrative-',num2str(i)],'Footprints',UserData.R_FileAreaVolumen);
                NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,NameFolderNarra{i},'Footprints',UserData.R_FileAreaVolumen);
                ID_File     = fopen(NameFile,'w');

                fprintf(ID_File, '%s', 'ID,Area (m2),Volumen (m3), ');
                fprintf(ID_File, '\r\n');

                fprintf(ID_File, '%u,%.3f,%.3f\r\n', [Hp.ID(Hp.Scenario)'; Area_Hp; Volumen_Hp]);
                fclose(ID_File);
                
                if St_Area
%                     NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,['Narrative-',num2str(i)],'Footprints',UserData.R_FileFootprints);
                    NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,NameFolderNarra{i},'Footprints',UserData.R_FileFootprints);
                    ID_File   = fopen(NameFile,'w');

                    Value = 'ID';
                    for w = 1:length(NameAreas)
                        if StatusAreas(w)
                            Value = [Value,',',NameAreas{w}];
                        end
                    end

                    fprintf(ID_File, '%s', Value);
                    fprintf(ID_File, '\r\n');

                    Value = '%u';
                    for w = 1:length(Footprint_Hp(1,:))
                        Value = [Value,',%.3f'];
                    end
                    Value = [Value,'\r\n'];

                    fprintf(ID_File, Value, [Hp.ID(Hp.Scenario)'; Footprint_Hp']);
                    fclose(ID_File);
                end
                
%                 WaterMirror.GRIDobj2geotiff(fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,['Narrative-',num2str(i)],'Footprints',UserData.R_FileWaterMirror))
                NW = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,NameFolderNarra{i},'Footprints',UserData.R_FileWaterMirror);
                WaterMirror.GRIDobj2geotiff(NW)
                movefile(NW, [NW,'f'])
                
            end
            
        end        

    else

        ModeA           = true;
        AnalysisMode    = 1;
        Hp.StatusRan    = 0;
        Hp.NumRand      = 0;
        Hp.Scenario     = 1;

        [ErrorNumber, Scenario, FuncNetwork, Frag] = Models.Tier1( 0, Network, Hp, 4, AnalysisMode,PointsInt, LenRiver);

        % ----------------------------------
        if ErrorNumber ~= -1
            WriteError(UserData, ErrorNumber)
            return
        end
        % ----------------------------------

        if St_Area
            [ErrorNumber, Factor, Area_Hp, Volumen_Hp, WaterMirror, Footprint_Hp] = ...
                Models.Footprint( Hp, DEM, ThresholdAccum, Network, FuncNetwork, ModeA, FlowDir, FlowAccum, Areas);
        else
            [ErrorNumber, Factor, Area_Hp, Volumen_Hp, WaterMirror, Footprint_Hp] = ...
                Models.Footprint( Hp, DEM, ThresholdAccum, Network, FuncNetwork, ModeA, FlowDir, FlowAccum);
        end

        % ----------------------------------
%         WriteError(UserData, ErrorNumber)
        if ErrorNumber ~= -1
            WriteError(UserData, ErrorNumber)
            return
        end
        % ----------------------------------

        Footprint_Hp = permute(Footprint_Hp,[1 3 2]);
        
        %% Save Results 
        mkdir(fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,'Explore'))
        NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,'Explore',UserData.R_FileAreaVolumen);
        ID_File     = fopen(NameFile,'w');

        fprintf(ID_File, '%s','Height,Factor,Area (m2),Volumen (m3), ');
        fprintf(ID_File, '\r\n');

        fprintf(ID_File, '%.3f,%.3f,%.3f,%.3f\r\n', [Factor*Hp.Height; Factor; Area_Hp'; Volumen_Hp']);
        fclose(ID_File);
        
        if St_Area
            NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,'Explore',UserData.R_FileFootprints);
            ID_File   = fopen(NameFile,'w');

            Value = 'Height,Factor';
            for i = 1:length(NameAreas)
                if StatusAreas(i)
                    Value = [Value,',',NameAreas{i}];
                end
            end

            fprintf(ID_File, '%s', Value);
            fprintf(ID_File, '\r\n');

            Value = '%.3f,%.3f';
            for i = 1:length(Footprint_Hp(1,:))
                Value = [Value,',%.3f'];
            end
            Value = [Value,'\r\n'];

            fprintf(ID_File, Value, [Factor*Hp.Height; Factor; Footprint_Hp']);
            fclose(ID_File);
        end
        NW = fullfile(UserData.MainPath, UserData.UserName,'Outputs', UserData.ExeNumber,'Explore',UserData.R_FileWaterMirror);
        WaterMirror.GRIDobj2geotiff(NW)
        movefile(NW, [NW,'f'])
        
    end
    
    % save final error
    WriteError(UserData, ErrorNumber)
catch ME
   
    errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);   
    
    disp(errorMessage)
    
    % ----------------------------------
    NameFile  = fullfile(UserData.MainPath, UserData.UserName,'Outputs', num2str(UserData.ExeNumber),'ErrorMessage.txt');
    ID_File     = fopen(NameFile,'w');
    fprintf(ID_File, '%s', errorMessage);
    fclose(ID_File);
    % ----------------------------------
    
    ErrorNumber = -2;
    
    % ----------------------------------
    WriteError(UserData, ErrorNumber)
    % ----------------------------------
end
