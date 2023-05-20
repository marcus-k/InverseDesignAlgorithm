function [kx, f, Eigenfrequency_number, kx_steps, dk] = fixBandData(fTable)
    %fixBandData Organizes the raw COMSOL results into a nicer format.
    %   Sorts the COMSOL raw output into an array of frequency bands for
    %   the associated output of wavenumbers.
    %
    %   See also getResults.
    arguments
        fTable  % Raw COMSOL output from getResults.
    end
    
    data = [fTable(:,1),fTable(:,3)];
    size(data);
    
    % Calculating the number of Different Eigen frequencies in the simulation
    Eigenfrequency_number = length(find(data(: , 1) == 0));
    
    % Calculating the number of steps in parameter sweep of kx
    kx_steps = ceil(length(data(:,1))/Eigenfrequency_number); 
    dk = 1/kx_steps;
    
    % Creating the x axis of the plot from [0, 1] (kx)
    kx = linspace(0,1,kx_steps); 
    
    % This matrix contains the values of each Eigenfrequency in each row 
    Eigenfrequency = zeros(Eigenfrequency_number,kx_steps); 
    
    % With this for we decompose the data file to matrix form which is better
    % for plotting
    for i = 1 : Eigenfrequency_number
        Eigenfrequency(i,:) = data(i:Eigenfrequency_number:length(data(:,2)), 2);
    end
    
    mode_numbers = Eigenfrequency_number;
    f = transpose(Eigenfrequency(1:mode_numbers,:));
end