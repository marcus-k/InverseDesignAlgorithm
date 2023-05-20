function [SSR, values] = lossFunction(model, study, tar_names, tar_values, param)
    %lossFunction Calcuate the sum of the normalized square residuals.
    %   Given a COMSOL model, study type, desired parameters to optimize,
    %   and geometric parameters, the COMSOL model is run with the
    %   specified geometry and the output is compared to the desired
    %   optimization parameters to calculate the sum of the square
    %   residuals.
    %
    %   See also runStudy, getResults, getBandgaps.
    arguments
        model (1,1)             % COMSOL model
        study (1,1) StudyType   % Type of nanobeam study (Mechanical, Optical)
    end

    % List of desired target parameters.
    arguments (Repeating)
        tar_names (1,:) {mustBeNonzeroLengthText}    % List of target variables in cells
        tar_values (1,:) {mustBeReal}   % List of target values in cells
    end
    
    % List of possible optimizable parameters.
    % An initial guess is passed in for these values.
    arguments
        param.h (1,1) {mustBePositive} = 530e-9 % Beam vertical (z-direction) [m]
        param.w (1,1) {mustBePositive} = 560e-9 % Beam width (y-direction) [m]
        param.a (1,1) {mustBePositive} = 591e-9 % Lattice constant [m]
        param.dk (1,1) {mustBePositive} = 0.1   % Wavenumber spacing [pi/a]
        param.n (1,1) {mustBePositive,mustBeInteger} = 3    % Number of modes
        param.f (1,1) {mustBeReal} = 0          % Frequency to search around
        param.l (1,1) {mustBeReal} = 1162.5e-9  % Wavelength to search around
        param.hx (1,1) {mustBePositive} = 319.14e-9 % x-diameter of hole
        param.hy (1,1) {mustBePositive} = 319.14e-9 % y-diameter of hole
        param.showProgress = false  % Whether to show progress window or not
    end

    setModelParameters(...
        model, study, ...
        h = param.h, ...
        w = param.w, ...
        a = param.a, ...
        dk = param.dk, ...
        n = param.n, ...
        l = param.l, ...
        hx = param.hx, ...
        hy = param.hy ...
    )
    
    % Run Study
    runStudy(model, study, showProgress=param.showProgress);

    % Get Results
    fTable = getResults(model, study);
    [kx, f] = fixBandData(fTable);

    % Get Bandgaps
    [gaps, gapFloors] = getBandgaps(study, kx, f, param.a);
    gapCenters = gapFloors + 0.5*gaps;

    % Pick the first bandgap from the list of bandgaps
    bg = gaps(1);
    bg_cen = gapCenters(1);

    % Initial output values
    SSR = 0;
    values = zeros(size(tar_names));

    % Find and add up all the normalized square residuals
    for i = 1:length(tar_names)
        tar_val = cell2mat(tar_values(i));
        switch char(tar_names(i))
            case "bg_cen"
                values(i) = bg_cen;
                SSR = SSR + ((bg_cen - tar_val) / tar_val)^2;
            case "bg"
                values(i) = bg;
                SSR = SSR + ((bg - tar_val) / tar_val)^2;
            otherwise
                error("Error. lossFunction. Invalid target name.")
        end
    end
end

