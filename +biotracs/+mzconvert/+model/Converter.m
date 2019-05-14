% BIOASTER
%> @file		Converter.m
%> @class		biotracs.mzconvert.model.Converter
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		Oct 2014

classdef Converter < biotracs.core.shell.model.Shell
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Converter()
            this@biotracs.core.shell.model.Shell();
            this.configType = 'biotracs.mzconvert.model.ConverterConfig';
            
            % enhance inputs specs
            this.addInputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                )...
                });

            % enhance outputs specs
            this.addOutputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                )...
                });
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function doBeforeRun( this )
            %set output extension
            ext = this.config.getParamValue('OutputFormat');
            if this.config.getParamValue('CompressOutputFiles')
                ext = [ext,'.gz'];
            end
            this.config.updateParamValue( 'OutputFileExtension', ext );
            this.doBeforeRun@biotracs.core.shell.model.Shell();
        end

        function doAfterRun( this )
            this.doAfterRun@biotracs.core.shell.model.Shell();
            
            % when input files have extension .mzXML.gz,
            % output file extension have extension .mzXML.mzXML
            % replace by a single extension.
            result = this.getOutputPortData('DataFileSet');
            for i=1:result.getLength()
                dataFile = result.getAt(i);
                [~, extList] = dataFile.getExtension();
                if length(extList) > 1 && strcmpi(extList{1}, extList{2})
                    path = fullfile([ dataFile.getDirPath(), '/',dataFile.getName() ]);
                    dataFile.setRepository(path);
                end
            end
        end
        
    end

end
