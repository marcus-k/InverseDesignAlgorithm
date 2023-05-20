function [gap, gapFloor] = locateBandgaps(kx, f)
    %locateBandgaps Locates bandgaps given the frequency modes.
    %   Given the set of wavenumbers and associated frequency modes from a
    %   COMSOL study, this locates any bandgaps and returns the bandgap
    %   width and the bandgap lower bound. Likely you want to use <a href="matlab:help getBandgaps -displayBanner">getBandgaps</a>
    %   instead which creates valid wavenumber and frequency arrays to use
    %   for this method.
    % 
    %   See also getBandgaps, fixBands, prepOptBands.
    arguments
        kx (1,:) {mustBeReal}   % Discrete k-points in a row
        f (:,:) {mustBeReal}    % Frequency per k point in a column, each mode in its own column
    end

    i=width(f);
    gap = [];
    gapFloor = [];
    
    while i > 1
        minA = min(f(:,i));
        maxB = max(f(:,i-1));
        minB = min(f(:,i-1));
        
        gtemp=0;
        ftemp=0;
        skip=0;
        
        %% working algorithm
        %if two bands intersect but selected band is inbetween the other
        if (minA < maxB) && (minA > minB)
            gtemp = 0;
            ftemp = 0;
        %selected band either above next band or passes it completely
        else
            %Preliminary looping params
            if i > 3
                lj=i-3;
            else
                lj=i-2;
            end 
            
            %default bandgap calculation
            gtemp = minA-maxB;
            ftemp = maxB;
            
            %limit for lower intersecting bands
            minCtemp = inf;
            minBtemp = inf;
            
            % looping through lower curves to find how many bands it crosses,
            % and finds bandgaps due to intersecting bands
            for j = 1:lj
                % Finding min and max of three lower curves
                minB = min(f(:,i-j));
                maxB = max(f(:,i-j));
                minC = min(f(:,i-j-1));
                maxC = max(f(:,i-j-1));
                if (i-j-2) > 0
                    maxD = max(f(:,i-j-2));
                    minD = min(f(:,i-j-2));
                else
                    maxD = 0;
                    minD = 0;
                end
    
                %setting a lower thehold for when selected band stops
                %intersecting
                if (minA < maxB) && (minB < minBtemp) && (minA > maxC)% && (minB < maxC)
                    minCtemp = minC;
                    minBtemp = minB;
                end
                
                % If selected band intersects lower band completeply
                if (minA < minB) 
                    skip=skip+1; %skip evaluation of next band
                    if (minA > maxC) && (maxC > maxD)
                        gtemp = minA-maxC;
                        ftemp = maxC;
                    end
                end
                
                % When it finds a band it doesn't intersect
                if (minA > maxB)
                    %skip=skip+1;
                    % Makes sure there is a gap between current band and the
                    % one we're looking at (band C)
                    if (minA > maxC) && (maxC > maxB) && (maxC < minBtemp)
                        minBtemp;
                        maxD;
                        gtemp = minA-maxC;
                        ftemp = maxC;
                    end
                end
            end
        end
        
        %final bandgaps and edges
        if (gtemp > 0) && (ftemp > 0)
            gap = [gtemp, gap]; %puts bandgaps in order (lowest first)
            gapFloor = [ftemp, gapFloor]; %bottom edge of bandgap
        end
        i = i-1-skip; %skips band
    end
    
    %% print the gaps
    % if isempty(gap)
    %     disp('No bandgap found.')
    % else
    %     for i = 1:length(gap)
    % %         plot([kx(1) kx(end)],[gapFloor(i),gapFloor(i)],'--','color',plotColor(i,:))  
    % %         plot([kx(1) kx(end)],[gapFloor(i)+gap(i),gapFloor(i)+gap(i)],'--','color',plotColor(i,:)) 
    %         fprintf('<strong> Center: </strong> %.2f', (gapFloor(i) + 0.5*gap(i))*1e-9)
    %         fprintf(' GHz')
    %         fprintf(' <strong> Bandgap: </strong> %.2f', gap(i)*1e-9)
    %         fprintf(' GHz \n')
    %     end  
    %     fprintf('\n')
    % end

end     
    