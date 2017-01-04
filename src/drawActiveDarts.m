function drawActiveDarts( cm, marked_darts, neighborhood )
%DRAWACTIVEDARTS draws the combinatorial map with all darts and labels them
%with the id of the dart
% INPUT:
%   cm ... the combinatorial map: 
%       cm.values (num_darts x 1 int16)
%           contains the dart values
%       cm.involution (num_darts x 1 uint32) 
%           column the involution dart index 
%       cm.next column (num_darts x 1 uint32)
%           contains the index of the next dart in the map 
%       cm.prev column (num_darts x 1 uint32)
%           contains the index of the previous dart in the map 
%       cm.num_darts (1 x 1 uint32) 
%           contains the number of darts in the map
%   marked_darts ... (n x 1 int16) 
%           darts thate are a subset of cm.active that will be marked red
%   neighborhood ... the neighborhood. Currently only 4 is supported
% AUTHOR:
%   David Pfahler´
    switch nargin
        case 3
            % everything is fine
        case 2
            %no marked darts
            neighborhood = 4;
        case 1
            neighborhood = 4;
            marked_darts = [];
        otherwise
            error('Invalid number of arguments');
    end
    assertNeighborhood(neighborhood);

    figure;
    hold on;
    plot_darts(cm.active, 1, '-k');
    if ~isempty(marked_darts)
        plot_darts(marked_darts, 0, 'o-r');
    end
    hold off;
    
    function plot_darts(darts, plot_text, line_spec)
        inv_darts = cm.involution(darts);
        y = cm.y(inv_darts);
        x = cm.x(inv_darts);
        vec_y = cm.y(darts)-y;
        vec_x = cm.x(darts)-x;
        % plot the darts
        quiver(x,y,vec_x,vec_y, ...
            0,line_spec, ...
            'MaxHeadSize',0.1, ...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor','r',...
            'MarkerSize',10);

        if plot_text
            % text plotting:
            x_text = x + vec_x*3/4;
            y_text = y + vec_y*3/4;
            txt = cellstr(num2str(darts));
            text(x_text,y_text,txt);
            
            set(gca,'ytick',0:max(y+vec_y))
            set(gca,'xtick',0:max(x+vec_x))
        end
    end
end
