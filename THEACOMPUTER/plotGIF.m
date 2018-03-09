h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'CfixNoCCMGIF.gif';
for n = 2:10:865
    surf(spatial_Cfix(1:(n),:))
    shading interp
    colormap parula
    xticklabels('manual')
    xticks([1:12])
    xticklabels([1:12])
    xlabel('cell no CCM')
    ylim([0 865])
    yticks([1 235 433 667 865])
    yticklabels(ylab)
    ylabel('sun')
    zlabel('fixed C')
    drawnow 

      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 

      % Write to the GIF File 
      if n == 2
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','DelayTime', 0.05, 'WriteMode','append'); 
      end 
  end