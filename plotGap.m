function plotGap(kx, f, gF, gap, highlight, a, plotType, bandColor, pm, kx_c, f_c)
    %plotGap Plots band diagrams.
    %   Takes output from getBands to plot band structure
    %   it's quite messy, needs some work
    %   highlight selects cavity mode (usually = 2 for mechanical breathing mode)
    %   input a = 0 for mechanical band structure
    
    %% shading colors
    gapColor = [0.2 0.4470 0.7410]; %shade color of band gaps
    gapShade = 0.1; %transperancy of gap shading (0 = clear)
    
    llColor = [0.8 0.8 0.8]; %shade color above lightline
    llShade = 1; %transperancy of shading above lightline (0 = clear)
    
    %% select plot type (mech or opt)
    optPlot = 0; %mechanical band structure by default.
    scale = 1e-9; %frequency conversion (Hz to GHz)
    
    if plotType == "opt" % if optical band structure
        optPlot = 1;
        scale = 1e-12; %frequency conversion (Hz to THz)
        gapColor = [0.2 0.4470 0.7410]; %shade color of band gaps
    end
    
    %% plot bands
    % plots cavity band structure if data is inputed
    try
        cav=plot(kx_c,f_c*scale,'--','linewidth',1,'color',bandColor);
        %highlight selected band band
        if highlight(1)>0
            hl=plot(kx_c,f_c(:,highlight(1))*scale,'k-.','linewidth',2);
            hl=plot(kx_c,f_c(:,highlight(2))*scale,'k-.','linewidth',2);
        end
    catch
    end
    
    %set(gca,'ColorOrderIndex',1) %reset plotting color order
    
    %plot mirror bands
    mir=plot(kx,f*scale,'-','linewidth',2,'color',pm);
    
    %% plot band gaps
    if isempty(gap)
        disp('No bandgap found.')
    else
        for i = 1:length(gap)
            x=[kx(1),kx(end)];
            gb = [gF(i)*scale,gF(i)*scale];
            gt = [gF(i)*scale+gap(i)*scale,gF(i)*scale+gap(i)*scale];
            patch([x fliplr(x)], [gb fliplr(gt)], gapColor, 'EdgeColor','none',...
                'FaceAlpha',gapShade) % Shades the band red
    
            %plot([kx(1) kx(end)],[gF(i)*1e-9,gF(i)*1e-9],'--','color',plotColor(i,:))  
            %plot([kx(1) kx(end)],[gF(i)*1e-9+gap(i)*1e-9,gF(i)*1e-9+gap(i)*1e-9],'--','color',plotColor(i,:)) 
        end  
    end
    
    if optPlot == 1
        scale = 1e-12;
        ll = kx.*(3e8)*scale./(2*a);
        plot(kx,ll,'k--')
        
        % draw and shade light line
        x=[kx(1),kx(end)];
        gb = [ll(1),ll(end)];
        gt = [max(ll)*1.5,max(ll)*1.5];
        patch([x fliplr(x)], [gb fliplr(gt)], llColor, 'EdgeColor','none',...
            'FaceAlpha',llShade,'FaceColor',llColor);
        
        % set plot limits
        ymin = (f(end,1))*scale*0.8;
        ylim([ymin max(ll)*1.05]);
        [~,li] = min(abs(ll-ymin));
        xlim([kx(li) kx(end)])
    end
    
    %% legends
    try
        legend([cav(1),mir(1)],'Defect','Mirror lattice','location','best')
    catch
    end
    try
        %legend([cav(1),mir(1)],'All modes','$Y$ and $Z$ symmetric modes','location','best')
        legend([cav(1),mir(1),hl(1)],'Defect lattice','Nomial lattice','Cavity mode','location','best')
    catch
    end
    
    %% labels
    xlabel('$$ k_{x} \,\, [\pi/a] $$', 'interpreter', 'latex')
    
    if optPlot == 1
        title('Optical')
        ylabel('Frequency (THz)')
    else 
        title('Mechanical')
        ylabel('Frequency (GHz)')
    end
end