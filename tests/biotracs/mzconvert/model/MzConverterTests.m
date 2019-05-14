classdef MzConverterTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir(), '/mzconvert/MzConverterTests');
    end

    methods (Test)
        
        function testWithLocalFiles(testCase)
            dataFile = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzXML/QEX20141008-001.mzXML'] );
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile);
            process = biotracs.mzconvert.model.Converter();
            process.setInputPortData('DataFileSet', ds);
            c = process.getConfig();
            c.updateParamValue('OutputFormat', 'mzXML');
            c.updateParamValue('CompressOutputFiles', true);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = {...
                fullfile([ testCase.workingDir, '/QEX20141008-001.mzXML.gz']), ...
                };
            expectedLogFilePath = fullfile( [testCase.workingDir, '/QEX20141008-001.mzXML.log'] );

            testCase.verifyEqual( exist(expectedOutputFilePaths{1}, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );            
            testCase.verifyEqual( results.getLength(), 1 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths{1} );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
  
    end
end