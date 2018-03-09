temporal = readtable('temporalday5.txt')
temporal.Properties.VariableNames = {'time', 'Ci', 'Ngas', 'Ogas', 'Cfix', 'Nfix', 'ATP'};
temporal = temporal(:,[1 5 2 6 3 4 7])
temporal(:,[2:7])

temporal = table2array(temporal);
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'temporalGIF.gif';
for n = 1:4:1728
     if n > 468 & n < 864 | n > 1332
         stem(temporal(n,[2:7]),'b','filled','LineStyle','none')
            xticks([1:6])
            xticklabels({'Cfix','Ci', 'Nfix', 'Ngas', 'Ogas', 'ATP'})
            yticklabels('')
            ylim([0 60])
             drawnow 
     else
     stem(temporal(n,[2:7]),'r','filled','LineStyle','none')
     xticks([1:6])
     xticklabels({'Cfix','Ci', 'Nfix', 'Ngas', 'Ogas', 'ATP'})
     yticklabels('')
     ylim([0 60])
     drawnow 
     end

      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 

      % Write to the GIF File 
      if n == 1
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','DelayTime', 0.05, 'WriteMode','append'); 
      end 
  end