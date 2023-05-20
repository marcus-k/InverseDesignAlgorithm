function [gap, gapFloors] = getBandgaps(study, kx, f, a)
    %getBandgaps Find the bandgaps given the output of running the COMSOL model.
    %   Once desired COMSOL study has been run, the results can be passed 
    %   to this function to obtain the bandgap widths and lower bounds.
    %   Wrapper and helper function for <a href="matlab:help locateBandgaps -displayBanner">locateBandgaps</a>.
    %
    %   See also runStudy, getResults, fixBandData.
    arguments
        study (1,1) StudyType   % Type of nanobeam study (Mechanical, Optical)
        kx (1,:) {mustBeReal}   % Discrete k-points in a row
        f (:,:) {mustBeReal}    % Frequency per k point in a column, each mode in its own column
        a (1, 1) {mustBeNonnegative} = 0  % Lattice constant
    end

    % Fix optical bands for the light cone
    if study == StudyType.Optical
        if a == 0
            error("If (study == StudyType.Optical), then ('a' != 0) must be provided.")
        end

        [kx, f] = prepOptBands(kx, f, a);
    end

    % Organize the bands into their correct modes
    [kx, f] = fixBands(kx, f);

    % Find the bandgaps
    [gap, gapFloors] = locateBandgaps(kx, f);
end
