function setModelParameters(model, study, param)
    %setModelParameters Set geometric and study parameters for the given COMSOL model.
    %   Given a COMSOL model and a study type, this sets the required
    %   parameters in the COMSOL model and prepares it to be run.
    arguments
        model (1,1)             % COMSOL model
        study (1,1) StudyType   % Type of nanobeam study (Mechanical, Optical)
        param.h (1,1) {mustBePositive} = 530e-9 % Beam vertical (z-direction) [m]
        param.w (1,1) {mustBePositive} = 560e-9 % Beam width (y-direction) [m]
        param.a (1,1) {mustBePositive} = 591e-9 % Lattice constant [m]
        param.dk (1,1) {mustBePositive} = 0.1   % Wavenumber spacing [pi/a]
        param.n (1,1) {mustBePositive,mustBeInteger} = 3    % Number of modes
        param.f (1,1) {mustBeReal} = 0          % Frequency to search around
        param.l (1,1) {mustBeReal} = 1162.5e-9  % Wavelength to search around
        param.hx (1,1) {mustBePositive} = 319.14e-9 % x-diameter of hole
        param.hy (1,1) {mustBePositive} = 319.14e-9 % y-diameter of hole
    end

    model.param('default').set('beam_h', param.h);
    model.param('default').set('beam_w', param.w);

    model.param('par2').set('a_temp', param.a);
    model.param('par2').set('hx_temp', param.hx);
    model.param('par2').set('hy_temp', param.hy);

    switch study
        case StudyType.Mechanical
            model.param('default').set('n_mech', param.n);
            model.param('default').set('freq_mech', param.f);
            model.param('default').set('k_step_mech', param.dk);

        case StudyType.Optical
            model.param('default').set('n_opt', param.n);
            model.param('default').set('lamdba_0', param.l);
            model.param('default').set('k_step_opt', param.dk);
            
        otherwise
            error('Error. StudyType not supported.')
    end

    % Build COMSOL geometry
    model.geom('geom1').run()
end