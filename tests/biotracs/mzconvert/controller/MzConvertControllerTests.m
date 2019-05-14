classdef MzConvertControllerTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/mzconvert/MzConvertControllerTests');
    end

    methods (Test)
        
        function testWithLocalFiles(testCase)
            ctrl = biotracs.mzconvert.controller.Controller();
            workflow = ctrl.get('MzConvertWorkflow');
            workflow.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir,'/WithoutZippedFile/'] );
            inputAdpter = workflow.getNode('MzFileImporter');
            inputAdpter.addInputFilePath( [pwd, '/../../../testdata/mzXML/QEX20141008-001.mzXML'] );
            mzConvert = workflow.getNode('MzConverter'); 
            mzConvert.getConfig()...
                .updateParamValue('MSLevel', {2});
            
            workflow.run(); 
            results = workflow.getNode('MzConverter').getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 1 );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
     

        function testWithZippedLocalFolder(testCase)
            ctrl = biotracs.mzconvert.controller.Controller();
            workflow = ctrl.get('MzConvertWorkflow');
            workflow.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir,'/WithZippedFiled/'] );
            inputAdpter = workflow.getNode('MzFileImporter');
            inputAdpter.addInputFilePath( [pwd, '/../../../testdata/mzXML/'] );
            workflow.run();
            results = workflow.getNode('MzConverter').getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 3 );
            testCase.verifyEqual( results.getAt(1).exist(), false );
            testCase.verifyEqual( results.getAt(2).exist(), true );
            testCase.verifyEqual( results.getAt(3).exist(), false );
        end
        
        function testWithLocalFolder(testCase)
            ctrl = biotracs.mzconvert.controller.Controller();
            workflow = ctrl.get('MzConvertWorkflow');
            workflow.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir,'/WithoutZippedFile/'] );
            inputAdpter = workflow.getNode('MzFileImporter');
            inputAdpter.addInputFilePath( [pwd, '/../../../testdata/mzXML'] );
            workflow.run();
            results = workflow.getNode('MzConverter').getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 3 );
            testCase.verifyEqual( results.getAt(1).exist(), false );
            testCase.verifyEqual( results.getAt(2).exist(), true );
            testCase.verifyEqual( results.getAt(3).exist(), false );
        end
        
        function testWithLocalFolderNewOutputName(testCase)
            ctrl = biotracs.mzconvert.controller.Controller();
            workflow = ctrl.get('MzConvertWorkflow');
            workflow.getConfig()...
                .updateParamValue( 'WorkingDirectory', [testCase.workingDir,'/WithoutZippedFileNewOutFileName/'] );
            inputAdpter = workflow.getNode('MzFileImporter');
            inputAdpter.addInputFilePath( [pwd, '/../../../testdata/mzXML'] );
            mzConvert = workflow.getNode('MzConverter'); 
            mzConvert.getConfig()...
                .updateParamValue('OutputFileName', 'test')...
                .updateParamValue('OutputFormat','ms2');
            workflow.run();
            results = workflow.getNode('MzConverter').getOutputPortData('DataFileSet');
            testCase.verifyEqual( results.getLength(), 3 );
            expectedOutFileName = fullfile([testCase.workingDir, '/WithoutZippedFileNewOutFileName/002-MzConverter/test.ms2']);
            testCase.verifyEqual( exist(expectedOutFileName, 'file'), 2 );

            testCase.verifyEqual( results.getAt(1).exist(), false );
            testCase.verifyEqual( results.getAt(2).exist(), false );
            testCase.verifyEqual( results.getAt(3).exist(),  false  );
        end
    end
end