function drawActiveDarts( cm, marked_darts, img, neighborhood )
%DRAWACTIVEDARTS draws the combinatorial map with all darts and labels them
%with the id of the dart
% INPUT:
%   img ... the image (will be plottet in the background
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

    if ~isempty(img)
        rgb(:,:,1) = uint8(img);
        rgb(:,:,2) = uint8(img);
        rgb(:,:,3) = uint8(img);
        image(rgb);
    end
    hold on;
    plot_darts(cm.active, 2);
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
        
        if emph_darts == 2
            no_text = 1;
            line_spec = '-w';
            line_width = 3;
        elseif emph_darts == 1
            no_text = 0;
            line_spec = '-r';
            background_color = [1 0 0];
            line_width = 2;
            font_size = 10;
        else
            no_text = 0;
            line_spec = '-k';
            background_color = [1 1 1];
            line_width = 2;
            font_size = 10;
        end
        
        % plot the darts
        q = quiver(x,y,vec_x,vec_y, ...
            0,line_spec);
        set(q, 'MaxHeadSize', 0.1, ...
            'LineWidth' , line_width);

        if ~no_text
            % text plotting:
            x_text = x + vec_x*3/4;
            y_text = y + vec_y*3/4;
            txt = cellstr(num2str(darts));
            t = text(x_text,y_text,txt);
            set(t,'FontSize', font_size, ...
                'BackgroundColor', background_color, ...
                'Margin', 1 );
        end
    end
end
