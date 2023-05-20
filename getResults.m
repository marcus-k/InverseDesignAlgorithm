function fTable = getResults(model, study)
    %getResults Get and return the COMSOL model results after a study.
    %   Once a study has been run, the model can be passed into this
    %   function to return the results needed to calculate things like the
    %   bandgap locations.
    %
    %   See also fixBandData.
    arguments
        model (1,1)             % COMSOL model
        study (1,1) StudyType   % Type of nanobeam study (Mechanical, Optical)
    end

    switch(study)
        case StudyType.Mechanical
            model.result.evaluationGroup('std1EvgFrq').run
            fTable = model.result.evaluationGroup('std1EvgFrq').getReal;

        case StudyType.Optical
            n = str2double(model.param('default').get('n_opt'));
            solnum = transpose(1:(n));
            model.result.evaluationGroup('std1EvgFrq1').set('solnumindices', solnum);
            model.result.evaluationGroup('std1EvgFrq1').run
            fTable = model.result.evaluationGroup('std1EvgFrq1').getReal;

        otherwise
            error('Error. StudyType not supported.')
    end
end