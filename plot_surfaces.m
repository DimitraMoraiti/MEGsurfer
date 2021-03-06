function ax=plot_surfaces(gs, surface_alphas, specular_strengths, ...
    ambient_strengths, diffuse_strengths, face_lightings, face_colors,...
    varargin)
% PLOT_SURFACE  Plots surface meshes
% 
% Use as
%   ax=plot_surface(g)
%   plot_surfaces([pial,lh_thal,rh_thal],[0.25,1.0,1.0],[0,0,0],[.75,.75,.75],[1,1,1],{'phong','phong','phong'},[0.5 0.5 0.5;0 0 1;0 0 1]);
% where the first argument is the surface gifti object. Returns handle to the axis plotted on
%
%   plot_surface(...,'param','value','param','value'...) allows
%    additional param/value pairs to be used. Allowed parameters:
%    * output_file - '' (default) or string - name of the file to write the figure
%        to. Only writes if specified
%    * output_format -'png' (default) or string - file format to write to
%    * ax - 0 (default) or handle - handle to the axis to plot on. Creates a new
%        figure if equal to 0
%    * title - '' (default) or string - Plot title
%    * surface_alpha - 1.0 (default) or double - surface alpha value. Passed as FaceAlpha
%        to patch
%    * specular_strength - 0.0 (default) - light specular strength
%    * ambient_strength - 0.75 (default) - light ambient strength
%    * diffuse_strength - 1.0 (default) - light diffuse strength
%    * face_lighting - phong (default) - face lighting

% Parse inputs
defaults = struct('output_file','','output_format','png','ax',0,'title','');  %define default values
params = struct(varargin{:});
for f = fieldnames(defaults)',
    if ~isfield(params, f{1}),
        params.(f{1}) = defaults.(f{1});
    end
end

% Create figure and axis if not specified
if params.ax==0
    fig=figure('Renderer','OpenGL', 'Color',[1 1 1]);
    params.ax = axes('Parent', fig);
end
set(params.ax,'Visible','off');
set(params.ax,'Projection','perspective');
set(params.ax,'PlotBoxAspectRatio',[1.268 1 1.129]);
set(params.ax,'DataAspectRatio',[1 1 1]);

for i=1:length(gs)
    % Plot surface
    hp = patch('vertices', gs(i).vertices, 'faces', gs(i).faces,...
        'EdgeColor', 'none', 'Parent', params.ax, 'FaceColor',face_colors(i,:),...
        'FaceAlpha', surface_alphas(i), 'linestyle','none',...
        'AmbientStrength',ambient_strengths(i),...,
        'DiffuseStrength', diffuse_strengths(i),...
        'SpecularStrength',specular_strengths(i));
    set(hp, 'FaceLighting', face_lightings{i});
end

% Create light
light('Parent',params.ax,'Style','local','Position',[749 868.1 1263]);
 
% Create light
light('Parent',params.ax,'Style','local','Position',[-1611 -265.3 288.5]);
 
% Create light
light('Visible','off','Parent',params.ax,'Style','local','Position',[776.2 899.5 1309]);

axes(params.ax);
cameramenu;

if length(params.title)
    annotation(fig,'textbox',[0.15 0.85 0.2 .15],'String',{params.title},'FitBoxToText','on');
end

% Save plot to file
if length(params.output_file)>0
    if params.output_format=='eps'
        figure2eps(fig, params.output_file, 10, '-opengl');
    else
        saveas(fig, params.output_file, params.output_format);
    end
end

ax=params.ax;
