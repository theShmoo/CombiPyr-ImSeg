function [h] = drawActiveDarts( cm, marked_darts, img, neighborhood )
%DRAWACTIVEDARTS draws the combinatorial map with all darts and labels them
%with the id of the dart
% INPUT:
%   image ... the image (will be plottet in the background
%   cm ... the combinatorial map
%   marked_darts ... (n x 1 int16) 
%           darts thate are a subset of cm.active that will be marked red
%   neighborhood ... the neighborhood. Currently only 4 is supported
% AUTHOR:
%   David Pfahler´
    switch nargin
        case 4
            % everything is fine
        case 3
            neighborhood = 4;
        case 2
            % no image
            neighborhood = 4;
            img = [];
        case 1
            % no marked darts
            marked_darts = [];
            % no image
            img = [];
        otherwise
            error('Invalid number of arguments');
    end
    assertNeighborhood(neighborhood);

    h = figure;
    if ~isempty(img)
        rgb(:,:,1) = uint8(img);
        rgb(:,:,2) = uint8(img);
        rgb(:,:,3) = uint8(img);
        image(rgb);
    end
    hold on;
    plot_darts(cm.active, 0);
    if ~isempty(marked_darts)
        plot_darts(marked_darts, 1);
    end
    hold off;
    
    function plot_darts(darts, emph_darts)
        inv_darts = cm.involution(darts);
        y = cm.y(inv_darts);
        x = cm.x(inv_darts);
        vec_y = cm.y(darts)-y;
        vec_x = cm.x(darts)-x;
        
        if emph_darts
            line_spec = '-r';
            text_color = [1 0 0];
        else
            line_spec = '-k';
            text_color = [0 0 0];
        end
        
        % plot the darts
        q = quiver(x,y,vec_x,vec_y, ...
            0,line_spec, 'MaxHeadSize',0.1, ...
            'MarkerSize',10, ...
            'MarkerEdgeColor','w');

        % text plotting:
        x_text = x + vec_x*3/4;
        y_text = y + vec_y*3/4;
        txt = cellstr(num2str(darts));
        t = text(x_text,y_text,txt);
        set(t,'Color',text_color);
        set(gca,'ytick',0:max(y+vec_y));
        set(gca,'xtick',0:max(x+vec_x));
    end
end
