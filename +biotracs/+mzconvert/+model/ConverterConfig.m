% BIOASTER
%> @file		ConverterConfig.m
%> @class		biotracs.mzconvert.model.ConverterConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		02 Fev 2015


classdef ConverterConfig < biotracs.core.shell.model.ShellConfig
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        %> @param[in] iInstrument The instrument of which this configuration is addressed
        function this = ConverterConfig( )
            this@biotracs.core.shell.model.ShellConfig( );
            this.updateParamValue('ExecutableFilePath', biotracs.core.env.Env.vars('MzConvertFilePath'));
            this.createParam('CompressOutputFiles', false, 'Constraint', biotracs.core.constraint.IsBoolean());
            this.createParam('OutputFormat','mzXML', 'Constraint', biotracs.core.constraint.IsInSet({'mzXML', 'mzML', 'mgf', 'ms2', 'ms1'}));
            this.createParam('OutputFileName','', 'Constraint', biotracs.core.constraint.IsText());
            %                 this.createParam('PeackPicking', true, 'Constraint', biotracs.core.constraint.IsBoolean());
            this.createParam('PeackPicking', 'vendor', 'Constraint', biotracs.core.constraint.IsInSet({'vendor', 'cwt'}));
            this.createParam('IntensityThreshold', 100, 'Constraint', biotracs.core.constraint.IsGreaterThan(0));
            this.createParam('RemoveExtra', true, 'Constraint', biotracs.core.constraint.IsBoolean());
            this.createParam('ScanRange', []);
            this.createParam('MzRange', []);
            this.createParam('TimeRange', []);
            this.createParam('MSLevel');
            this.createParam('PrecursorRecalculation', false, 'Constraint', biotracs.core.constraint.IsBoolean());
            this.createParam('BinaryPrecision', 32, 'Constraint', biotracs.core.constraint.IsInSet({32,64}));
            
            rangeSetFormatCallback = @(x)(this.doFormatPwizRangeSet(x));
            rangeFormatCallback = @(x)(this.doFormatPwizRange(x));
            %                                     'PeackPicking',         biotracs.core.shell.model.Option('--filter "peakPicking %s"', 'RemoveWhenMatch', false, 'FormatFunction', @(x)doFormatBoolean(this,x)), ...
            this.optionSet.addElements(...
                'InputFilePath',        biotracs.core.shell.model.Option('"%s"'), ...
                'WorkingDirectory',     biotracs.core.shell.model.Option('-o "%s"'), ...
                'OutputFileName', biotracs.core.shell.model.Option('--outfile "%s"'), ...
                'CompressOutputFiles',  biotracs.core.shell.model.Option('--gzip', 'RemoveWhenMatch', false), ...
                'OutputFormat',         biotracs.core.shell.model.Option('--%s'), ...
                'PeackPicking',         biotracs.core.shell.model.Option('--filter "peakPicking %s"'), ...
                'IntensityThreshold',   biotracs.core.shell.model.Option('--filter  "threshold absolute %d most-intense"', 'RemoveWhenMatch', 0), ...
                'ScanRange',            biotracs.core.shell.model.Option('--filter "scanNumber %s"', 'FormatFunction', rangeSetFormatCallback), ...
                'MzRange',              biotracs.core.shell.model.Option('--filter "mzWindow %s"', 'FormatFunction', rangeFormatCallback), ...
                'TimeRange',            biotracs.core.shell.model.Option('--filter "scanTime %s"', 'FormatFunction', rangeFormatCallback), ...
                'MSLevel',              biotracs.core.shell.model.Option('--filter "msLevel %s"', 'FormatFunction', rangeSetFormatCallback), ...
                'PrecursorRecalculation', biotracs.core.shell.model.Option('--filter "precursorRecalculation"', 'RemoveWhenMatch', false), ...
                'RemoveExtra',          biotracs.core.shell.model.Option('--filter "zeroSamples removeExtra"', 'RemoveWhenMatch', false), ...
                'BinaryPrecision',      biotracs.core.shell.model.Option('--%d') ...
                );
            
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function strRange = doFormatPwizRange( this, iRange, iSep )
            if nargin < 3, iSep = ','; end
            if isempty(iRange) || isnan(iRange)
                strRange = '[]';
            else
                strRange = this.doFormatPwizRangeSet( {iRange}, iSep);
                strRange = [ '[', strRange, ']' ];
            end
        end
        
        function strRange = doFormatPwizRangeSet( ~, iRangeList, iSep )
            disp(iRangeList)
            
            if nargin < 3, iSep = '-'; end
            strRange = '';
            for i=1:length(iRangeList)
                range = iRangeList{i};
                if range(1) == range(end)
                    strRange = [...
                        strRange, ' ',...
                        strcat('', num2str(range(1)), ' ')...
                        ]; %#ok<AGROW>
                else
                    strRange = [...
                        strRange, ' ',...
                        strcat('', num2str(range(1)), iSep, num2str(range(end)), ' ')...
                        ]; %#ok<AGROW>
                end
            end
            strRange = strtrim(strRange);
        end
        
    end
    
end
