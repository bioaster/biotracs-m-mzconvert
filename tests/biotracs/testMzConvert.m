%"""
%Unit tests for biotracs.mzconvert.*
%* License: BIOASTER License
%* Created: 02 Fev 2015
%Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""

function testMzConvert( cleanAll )
    if nargin == 0 || cleanAll
        clc; close all force;
        restoredefaultpath();
    end
    
    addpath('../');
    autoload( ...
        'PkgPaths', {fullfile(pwd, '../../../')}, ...
        'Dependencies', {...
            'biotracs-m-mzconvert', ...
        }, ...
        'Variables',  struct(...
             'MzConvertFilePath', 'C:\Program Files\ProteoWizard\ProteoWizard 3.0.9992\msconvert.exe' ...
        ) ...
    );

    %% Tests
    import matlab.unittest.TestSuite;
    Tests = TestSuite.fromFolder('./', 'IncludingSubfolders', true);
    %Tests = TestSuite.fromFile('./bioapps/mzconvert/model/MzConverterTests.m');
    %Tests = TestSuite.fromFile('./bioapps/mzconvert/controller/MzConvertControllerTests.m');
    Tests.run;
end