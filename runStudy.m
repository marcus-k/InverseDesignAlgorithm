function runStudy(model, study, param)
    %runStudy Run the specified study on the given COMSOL model.
    %   Given a COMSOL model and a study type, a study is run on and, if 
    %   desired, a progress window is shown during the duration of the 
    %   study.
    arguments
        model (1,1)                 % COMSOL model
        study (1,1) StudyType       % Type of nanobeam study (Mechanical, Optical)
        param.showProgress = false  % Whether to show progress window or not
    end
    import com.comsol.model.util.ModelUtil;

    switch(study)
        case StudyType.Mechanical
            std = model.study('std1');

        case StudyType.Optical
            std = model.study('std2'); 

        otherwise
            error('Error. StudyType not supported.')
    end
    
    % Run the study
    if param.showProgress == true
        ModelUtil.showProgress(true);
        std.run;
        ModelUtil.showProgress(false);
    else
        std.run;
    end
end
