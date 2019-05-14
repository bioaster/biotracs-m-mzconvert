% BIOASTER
%> @file		Controller.m
%> @class		biocode.ms.mzconvert.controller.Controller
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		Aug. 2014

classdef Controller < biotracs.core.mvc.controller.Controller
    
    properties(SetAccess = protected)
    end
    
    methods
        
        % Constructor
        function this = Controller( )
            this@biotracs.core.mvc.controller.Controller();
            
            %Create the workflow
            workflow = biotracs.core.mvc.model.Workflow();
            workflow.setLabel('MzConvert');
            workflow.setDescription('Workflow to convert mass spectrometry data');

            %Add FileImporter
            mzFileImporter = biotracs.core.adapter.model.FileImporter();
            workflow.addNode( mzFileImporter, 'MzFileImporter' );
            
            %Add MzConvert Experiment
            mzConverter = biotracs.mzconvert.model.Converter();
            workflow.addNode( mzConverter, 'MzConverter' );

            %Connect i/o ports
            mzFileImporter.getOutputPort('DataFileSet').connectTo( mzConverter.getInputPort('DataFileSet') );
            
            this.add(workflow, 'MzConvertWorkflow');
        end
        
        %-- C --
    end

    methods(Access = protected)

    end
end

