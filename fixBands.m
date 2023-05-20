function [kx, f_fix] = fixBands(kx, f)
    %FixBands Corrects the raw COMSOL frequencies into their correct bands.
    %   Organizes data from COMSOL into correct bands by looking at 
    %   neighboring derivatives. Not very elegant, but does the job for a
    %   sufficient number of k-points. Struggles when two bands cross with 
    %   similar slope (increase k-points).
    %
    %   Note: This method needs at least 4 bands.
    % 
    %   Very cool note from Waleed: I coded this in the middle of the night 
    %   and was too busy troubleshooting to comment. I'll attempt to 
    %   decifer what I was thinking at the time if requested. There are 
    %   probably better ways to do this...
    %
    %   See also getBandgaps.
    arguments
        kx (1,:) {mustBeReal}   % Discrete k-points in a row
        f (:,:) {mustBeReal}    % Frequency per k point in a column, each mode in its own column
    end
    
    %% organizing bands
    Eigenfrequency_number = width(f);
    dk = 1/length(kx);
    
    f_fix = f;
    d = 3;
    
    for it = 1:10 % rerun band organizing (a little brute force)
    
        threshold = 0.0e9;
        s = -0;
        for band = Eigenfrequency_number:-1:1
            slope = (f_fix(d:end,:) - f_fix(d-1:end-1,:))./dk;
    
            i = 1;
            while i < size(slope,1) - 0      
                [~,mI] = min(abs(((f_fix(d+i-1,band)-f_fix(d+i-2,band))./(1*dk))-((f_fix(d+i,:)-f_fix(d+i-1,band))./(1*dk))));
    
                check = abs(((f_fix(d+i-1,band)-f_fix(d+i-2,band))./(1*dk))-((f_fix(d+i,band)-f_fix(d+i-1,band))./(1*dk)));
                check2 = abs(((f_fix(d+i-1,mI)-f_fix(d+i-2,mI))./(1*dk))-((f_fix(d+i,mI)-f_fix(d+i-1,mI))./(1*dk)));
                
                if (mI~=band) && (check>threshold) && (check2>threshold) && (((mI-band)>-10))
                    f_fix(d+i-s:end,[band mI]) = f_fix(d+i-s:end,[mI band]);
                    i=i+0;
                end
                i=i+1;
            end
        end
    
        s =  0;
        for band = 1:Eigenfrequency_number
            slope = (f_fix(d:end,:) - f_fix(d-1:end-1,:))./dk;
    
            i = 1;
            while i < size(slope,1)-0
                [~,mI] = min(abs(((f_fix(d+i-1,band)-f_fix(d+i-2,band))./(1*dk))-((f_fix(d+i,:)-f_fix(d+i-1,band))./(1*dk))));
                
                check = abs(((f_fix(d+i-1,band)-f_fix(d+i-2,band))./(1*dk))-((f_fix(d+i,band)-f_fix(d+i-1,band))./(1*dk)));
                check2 = abs(((f_fix(d+i-1,mI)-f_fix(d+i-2,mI))./(1*dk))-((f_fix(d+i,mI)-f_fix(d+i-1,mI))./(1*dk)));
    
                if (mI~=band) && (check>threshold) && (check2>threshold) && (((mI-band)<10))
                    f_fix(d+i-s:end,[band mI]) = f_fix(d+i-s:end,[mI band]);
                    i=i+0;
                end
                i=i+1;
            end
        end
    end
end