function [kx, f_final, n_had_max] = prepOptBands(kx, f, a)
    %prepOptBands Flattens optical bands for any k-points in the light
    %cone to find bandgaps later.
    %   Given a set of discrete k values, its associated optical frequency 
    %   modes, and the lattice constant, this corrects the optical modes
    %   taking into account the light cone. 
    %
    %   See also getBandgaps.
    arguments
        kx (1,:) {mustBeReal}   % Discrete k-points in a row
        f (:,:) {mustBeReal}    % Frequency per k point in a column, each mode in its own column
        a (1, 1) {mustBeNonnegative} = 0  % Lattice constant
    end
    
    for i=1:length(kx)
        n_low_freq(i) = length(find(f(i,:) < 1e12));
    end
    
    n_had_max=max(n_low_freq);
    
    if n_had_max > 0
        for i = 1:max(n_had_max)
            %n_idx = (n_low_freq==i) + (n_low_freq>i);
            n_idx = (n_low_freq>=i);
            f((n_idx==1),1:end-1) =...
                f((n_idx==1),2:end);
            f = f(:,1:end-1);
        end
        %f = f(:,1:end-max(n_had_max));
    end
    
    ll = kx.*(3e8)./(2*a); % light line
    
    for i = 1:width(f)
    %     x = InterX([kx;f_nz(:,i)'],[kx;ll]);
        [~,idx]=min(abs(ll'-f(:,i)));
        f(1:idx,i) = ones(length(f(1:idx,i)),1).*f(idx,i);
    end
    
    f_final = f;
end
