function [] = path_anim(env,path,actions,params)
% path_anim.m
% path_anim(env,path,actions,params)
%
% caller responsible for clf/hold off
%
% Input:
%   env = struct
%     .graph_sz
%     .obst_pose
%     .obst_sz
%     .goal_pose
%   path: size(2,path_len)
%   actions: size(2,path_len-1)
%   params = struct
%     .f_num
%     .speed
%     .goal_type
%     .goal_text
%     .goal_sz
%     .goal_color
%     .agent_type
%     .agent_text
%     .agent_sz
%     .agent_color
%     .agent_trail
%     .agent_trail_sz
%     .agent_trail_color
%     


if nargin < 2
  % must input at least 'env' and 'path' for default options
  error('path_anim nargin');
end

if ~exist('actions','var')
  actions = [];
end

if ~exist('params','var')
  params = [];
end


%% constants for display
obst_x_offset_const = .5;
obst_y_offset_const = .5;
params.obst_x_offset = [0 0 -1 -1] + obst_x_offset_const*[-1 -1 1 1];
params.obst_y_offset = [0 -1 -1 0] + obst_y_offset_const*[-1 1 1 -1];
params.path_x_offset = 0;
params.path_y_offset = 0;
params.goal_x_offset = 0;
params.goal_y_offset = 0;
params.box_offset = .5;
params.box_width = .5;
params.move_x_offset = .05;
params.move_y_offset = .05;
% FIXME: figures
%params.move_x_offset = .1;
%params.move_y_offset = .1;




%% check env

if ~isfield(env,'obst_pose')
  env.obst_pose = [];
  env.obst_sz = [];
end

if ~isfield(env,'goal_pose')
  env.goal_pose = [];
end

if isnumeric(env.goal_pose)
  env.goal_pose = mat2cell(env.goal_pose,size(env.goal_pose,1),ones(1,size(env.goal_pose,2)));
end

if ~isfield(env,'goal_space')
  env.goal_space = [];
end

if ~isfield(env,'fov')
  env.fov = [];
end

path_length = size(path,2);
n_goal = length(env.goal_pose);
n_goal_space = size(env.goal_space,2);


%% check agent path

% check datatype: must be 'double'
if ~isa(path,'double')
  path = double(path);
end

% check in bounds
if any(any(path > repmat(env.graph_sz,1,path_length)))
  error('path_anim out of bounds');
end

% check actions length
if ~isempty(actions) && size(actions,2) ~= (path_length-1)
  error('path_anim actions path_length mismatch');
end


%% check params

if ~isfield(params,'f_num')
  params.f_num = gcf;
end

if ~isfield(params,'agent_type')
  % default
  params.agent_type = 1;
  params.agent_text = 'A';
  params.agent_img = [];
  params.agent_sz = 12;
  params.agent_color = [0 0 0];
  params.agent_trail = false;
  params.agent_trail_sz = [];
  params.agent_trail_color = [];
end

if ~isfield(params,'goal_type')
  % default
  params.goal_type = ones(1,n_goal);
  params.goal_text = num2cell(sprintf('%d',1:n_goal));
  params.goal_img = cell(1,n_goal);
  params.goal_sz = num2cell(repmat(12,1,n_goal));
  params.goal_color = mat2cell(repmat([0 0 0],1,n_goal),1,repmat(3,n_goal,1));
end

if ~isfield(params,'goal_space_color')
  params.goal_space_color = repmat([.95 .95 0],n_goal_space,1);
end

if ~isfield(params,'goal_space_linewidth')
  params.goal_space_linewidth = repmat(0.5,1,n_goal_space);
end

if ~isfield(params,'goal_space_edgecolor')
  params.goal_space_edgecolor = repmat([0 0 0],n_goal_space,1);
end

if ~isfield(params,'action_len')
  params.action_len = 1;
end

if ~isfield(params,'animate')
  params.animate = false;
end

if params.animate
  path_ind_1 = 1;
else
  path_ind_1 = path_length;
end

if ~isfield(params,'speed')
  params.speed = 2;
end

if ~isfield(params,'delay')
  params.delay = 0;
end

if ~isfield(params,'special_delay')
  params.special_delay = false;
end

if ~isfield(params,'isovist')
  params.isovist = false;
end

if ~isfield(params,'view_opt')
  params.view_opt = 1;
end

if ~isfield(params,'box_on')
  params.box_on = false;
end

if ~isfield(params,'title')
  params.window_title = '';
end

if ~isfield(params,'click_advance')
  params.click_advance = false;
end

if ~isfield(params,'clear_frame')
  params.clear_frame = false;
end

if ~isfield(params,'save_frame')
  params.save_frame = false;
end

if params.save_frame
  t = fix(clock);
  t_str = sprintf('%04g-%02g-%02g-%02g-%02g',t(1),t(2),t(3),t(4),t(5));
end


%set(params.f_num,'renderer','opengl','doublebuffer','on');

%% delay: show box with objects in initial locations to achieve fixation before animation starts

if params.delay
    
  frame = 1;
  render_frame(frame,env,path,actions,action_len,params);

  if params.special_delay
    pause(params.delay);
    render_frame(frame,env,path,[],[],params);
  
    pause(.25);
    render_frame(frame,env,path,actions,action_len, params);
  end

  pause(params.delay)

end


if params.click_advance
  f_pos = get(params.f_num, 'position');
  f_height = f_pos(3);
  f_width = f_pos(4);
  label_width = 350;
  label_height = 30;
  label_pos = [(f_height-label_width)/2 10 label_width label_height];
end


p = path_ind_1;
while p<=path_length

  % display attempted action and actual move
  render_frame(p,env,path,{},0,params);

  if params.save_frame
%     saveas(params.f_num, sprintf('results/figs/%s_frame%02d',t_str,p), 'fig')
    f = getframe;
    [im,map] = rgb2ind(f.cdata,256,'nodither');
    imwrite(im,map,sprintf('results/figs/%s_frame%02d.tiff',t_str,p));
  end
  
  if p<path_length
    if params.click_advance
      label = uicontrol('Parent', params.f_num, ...
        'style','text', ...
        'HorizontalAlignment', 'Center', ...
        'FontSize', 20, ...
        'BackgroundColor',get(params.f_num,'Color'), ...
        'ForegroundColor', [0 0.8 0], ...
        'position',label_pos, ...
        'string','Play: click to see next step');
      
      waitforbuttonpress;
      
    elseif params.animate
      if params.speed>0
        pause(1/params.speed);
      end
      
    end
  end
  
  p=p+1;

end % while p<=path_length


if params.click_advance
  label = uicontrol('Parent', params.f_num, ...
    'style','text', ...
    'HorizontalAlignment', 'Center', ...
    'FontSize', 20, ...
    'BackgroundColor',get(params.f_num,'Color'), ...
    'ForegroundColor', [1.0 0.0 0], ...
    'position',label_pos, ...
    'string','Pause');
end



function [] = render_frame(frame,env,path,actions,action_len,params)

figure(params.f_num);
if params.clear_frame
  clf(params.f_num);
end

f_axis = gca(params.f_num);
%alpha('scaled');

axis(f_axis,[0 env.graph_sz(1)+params.box_offset+params.box_width 0 env.graph_sz(2)+params.box_offset+params.box_width],'off');

% initialize z-depth
depth=1;

hold(f_axis,'off');
depth = draw_box(f_axis,env.graph_sz,params.box_width,params.box_offset,depth);
hold on;

% plot goal spaces
n_goal_space = size(env.goal_space,2);
if n_goal_space
  depth=depth+1;
  plot_obst(f_axis,env.goal_space,repmat([1;1],1,n_goal_space), ...
    params.obst_x_offset,params.obst_y_offset,params.goal_space_color, ...
    params.goal_space_linewidth,params.goal_space_edgecolor,depth);

end


% plot goal markers
n_goal = length(env.goal_pose);
for gi=1:n_goal
  if ~isempty(env.goal_pose{gi})
    if params.goal_type(gi) == 1 % text
      depth=depth+1;
      text(env.goal_pose{gi}(1)+params.goal_x_offset, ...
        env.goal_pose{gi}(2)+params.goal_y_offset,depth,params.goal_text{gi}, ...
        'FontSize',params.goal_sz{gi},'FontWeight','bold','Color',params.goal_color{gi}, ...
        'horizontalalignment','center','parent',f_axis);
      
    elseif params.goal_type(gi) == 2 % marker
      depth = depth+1;
      plot3(f_axis,env.goal_pose{gi}(1)+params.goal_x_offset, ...
        env.goal_pose{gi}(2)+params.goal_y_offset,params.goal_text{gi},depth, ...
        'MarkerSize',params.goal_sz{gi},'Color',params.goal_color{gi}, ...
        'MarkerFaceColor',params.goal_color{gi});
      
    elseif params.goal_type(gi) == 3 % image
      depth=depth+1;
      draw_entity(f_axis,params.goal_img{gi},env.goal_pose{gi},params.goal_sz{gi},depth);

    end % if params.goal_type(gi) == ?
    
  end % if ~isempty(env.goal_pose{gi})

end % for gi=1:n_goal


% plot obstacles
n_obst = size(env.obst_pose,2);
if n_obst
  obst_color = repmat([0 0 0],n_obst,1);
  obst_linewidth = repmat(0.5,1,n_obst);
  obst_edgecolor = obst_color;
  depth=depth+1;
  plot_obst(f_axis,env.obst_pose,env.obst_sz,params.obst_x_offset, ...
    params.obst_y_offset,obst_color,obst_linewidth,obst_edgecolor,depth);
end


% plot trails
if params.agent_trail == 1
  % dotted trail
  depth=depth+1;
  plot3(f_axis,path(1,1:frame)+params.path_x_offset, ...
    path(2,1:frame)+params.path_y_offset,depth,'.', ...
    'LineWidth',params.agent_trail_sz,'markersize',params.agent_trail_sz, ...
    'Color',params.agent_trail_color);

elseif params.agent_trail == 2
  % numbered trail
  depth=depth+1;
  for p=1:frame
    text(path(1,p)+params.path_x_offset,path(2,p)+params.path_y_offset, ...
      depth,sprintf('%d',p),'FontSize',params.agent_trail_sz, ...
      'Color',params.agent_trail_color,'horizontalalignment','center', ...
      'parent',f_axis);
  end

elseif params.agent_trail == 3
  % directional trail

  if frame>1
    trail = path(:,1:frame);
    
    path_diff = diff(path(:,1:frame),1,2);
    
    prev_move = 0;
    prev_offset = [0;0];
    
    asz=.5;
    alength=14*asz;
    awidth=10*asz;
    astart=0.15*asz;
    astop=0.15*asz;

    depth=depth+1;
    for p=1:(frame-1)
      if all(path_diff(:,p)==[0;0])
        new_move = 1;
        new_offset = prev_offset;
        trail(:,p) = trail(:,p) + new_offset;
        
      elseif all(path_diff(:,p)==[-1;0])
        new_move = 2;
        new_offset = [0;-params.move_y_offset];
        if new_move==prev_move
          trail(:,p) = trail(:,p) + new_offset;
        else
          trail(:,p) = trail(:,p) + prev_offset + new_offset;
        end
        %plot3(f_axis,trail(1,p)+params.path_x_offset,trail(2,p)+params.path_y_offset,depth,'<', ...
        %  'LineWidth',params.agent_trail_sz,'markersize',params.agent_trail_sz,'Color',params.agent_trail_color);
        h=arrow([trail(1,p)+params.path_x_offset+astart,trail(2,p)+params.path_y_offset,depth], ...
                [trail(1,p)+params.path_x_offset-astop,trail(2,p)+params.path_y_offset,depth], ...
                'Length',alength,'Width',awidth,'TipAngle',30,'FaceColor',params.agent_trail_color);

      elseif all(path_diff(:,p)==[1;0])
        new_move = 3;
        new_offset = [0;params.move_y_offset];
        if new_move==prev_move
          trail(:,p) = trail(:,p) + new_offset;
        else
          trail(:,p) = trail(:,p) + prev_offset + new_offset;
        end
        %plot3(f_axis,trail(1,p)+params.path_x_offset,trail(2,p)+params.path_y_offset,depth,'>', ...
        %  'LineWidth',params.agent_trail_sz,'markersize',params.agent_trail_sz,'Color',params.agent_trail_color);
        h=arrow([trail(1,p)+params.path_x_offset-astart,trail(2,p)+params.path_y_offset,depth], ...
          [trail(1,p)+params.path_x_offset+astop,trail(2,p)+params.path_y_offset,depth], ...
          'Length',alength,'Width',awidth,'TipAngle',30,'FaceColor',params.agent_trail_color);

      elseif all(path_diff(:,p)==[0;-1])
        new_move = 4;
        %new_offset = [params.move_x_offset;0];
        new_offset = [-params.move_x_offset;0];
        if new_move==prev_move
          trail(:,p) = trail(:,p) + new_offset;
        else
          trail(:,p) = trail(:,p) + prev_offset + new_offset;
        end
        %plot3(f_axis,trail(1,p)+params.path_x_offset,trail(2,p)+params.path_y_offset,depth,'v', ...
        %  'LineWidth',params.agent_trail_sz,'markersize',params.agent_trail_sz,'Color',params.agent_trail_color);
        h=arrow([trail(1,p)+params.path_x_offset,trail(2,p)+params.path_y_offset+astart,depth], ...
                [trail(1,p)+params.path_x_offset,trail(2,p)+params.path_y_offset-astop,depth], ...
                'Length',alength,'Width',awidth,'TipAngle',30,'FaceColor',params.agent_trail_color);

      elseif all(path_diff(:,p)==[0;1])
        new_move = 5;
        %new_offset = [-params.move_x_offset;0];
        new_offset = [params.move_x_offset;0];
        if new_move==prev_move
          trail(:,p) = trail(:,p) + new_offset;
        else
          trail(:,p) = trail(:,p) + prev_offset + new_offset;
        end
        %plot3(f_axis,trail(1,p)+params.path_x_offset,trail(2,p)+params.path_y_offset,depth,'^', ...
        %  'LineWidth',params.agent_trail_sz,'markersize',params.agent_trail_sz,'Color',params.agent_trail_color);
        h=arrow([trail(1,p)+params.path_x_offset,trail(2,p)+params.path_y_offset-astart,depth], ...
                [trail(1,p)+params.path_x_offset,trail(2,p)+params.path_y_offset+astop,depth], ...
                'Length',alength,'Width',awidth,'TipAngle',30,'FaceColor',params.agent_trail_color);

      end
      
      prev_move = new_move;
      prev_offset = new_offset;
      
    end % for p=1:(frame-1)
    
    trail(:,frame) = trail(:,frame) + prev_offset;
    
    % connect the dots
    %plot3(f_axis,trail(1,:)+params.path_x_offset,trail(2,:)+params.path_y_offset,repmat(depth,1,frame),'-', ...
    %  'LineWidth',.5,'Color',params.agent_trail_color);
    % CB: figure
    plot3(f_axis,trail(1,:)+params.path_x_offset,trail(2,:)+params.path_y_offset,repmat(depth,1,frame),'-', ...
      'LineWidth',4,'Color',params.agent_trail_color);

  end % if frame>1

end % if params.agent_trail == ?


    
goal_pose_mat = cell2mat(env.goal_pose);
n_goal_pose = size(goal_pose_mat,2);

% plot agent
if params.agent_type == 1 % text
  depth=depth+1;
  text(path(1,frame)+params.path_x_offset,path(2,frame)+params.path_y_offset,depth,params.agent_text, ...
    'FontSize',params.agent_sz,'FontWeight','bold','Color',params.agent_color, ...
    'horizontalalignment','center','parent',f_axis);
    
elseif params.agent_type == 2 % marker
  depth=depth+1;
  plot3(f_axis,path(1,frame)+params.path_x_offset,path(2,frame)+params.path_y_offset,params.agent_text,depth, ...
    'MarkerSize',params.agent_sz,'Color',params.agent_color,'MarkerFaceColor',params.agent_color);
  
elseif params.agent_type == 3 % image
  
  if frame==size(path,2) && any(all(goal_pose_mat==repmat(path(:,frame),1,n_goal_pose),1))
    % HACK: show agent eating
    % CB: eventually, pass in observations of EAT actions
    depth=depth+1;
    draw_entity(f_axis,params.agent_img{2},path(:,frame),params.agent_sz,depth);
    
  else
    % don't show agent eating
    depth=depth+1;
    draw_entity(f_axis,params.agent_img{1},path(:,frame),params.agent_sz,depth);

  end

end % if params.agent_type == ?


% plot field-of-view (fov)
if ~isempty(env.fov) && ~isempty(path)
  path_ind = sub2indv(env.graph_sz,path{1}(:,frame));
  fov_sub = double(ind2subv(env.graph_sz,find(env.fov(:,path_ind)))');
  n_fov_sub = size(fov_sub,2);
  
  fov_plot_x = reshape(repmat(fov_sub(1,:),8,1),2,4*n_fov_sub) ...
    +repmat([[0;0],[1;1],[0;1],[0;1]],1,n_fov_sub) + obst_x_offset(1);
  
  fov_plot_y = reshape(repmat(fov_sub(2,:),8,1),2,4*n_fov_sub) ...
    +repmat([[0;1],[0;1],[0;0],[1;1]],1,n_fov_sub) + obst_y_offset(2);
  
  h = line(fov_plot_x,fov_plot_y,'linewidth',2,'linestyle','--','color',[1 0 0]);

end


% display isovist
if params.isovist
  world = [];
  world.graph_sz = env.graph_sz;
  world.obst_pose = env.obst_pose;
  world.obst_sz = env.obst_sz;
  isopoly = isovist(world,path(:,frame));
  isopoly{1} = bsxfun(@minus,isopoly{1},[params.box_offset params.box_offset]);

  % polygon of outer boundary (specified by env.graph_sz) in cw order
  graph_poly = zeros(4,2);
  graph_poly(1,:) = [params.box_offset params.box_offset];
  graph_poly(2,:) = [params.box_offset params.box_offset]+[0.0 env.graph_sz(2)];
  graph_poly(3,:) = [params.box_offset params.box_offset]+env.graph_sz';
  graph_poly(4,:) = [params.box_offset params.box_offset]+[env.graph_sz(1) 0.0];
  
  % fix numerical issues!
  num = 1000;
  ip = round(isopoly{1}*num)/num;
  gp = round(graph_poly*num)/num;

  [shade_poly_x,shade_poly_y] = polybool('-',gp(:,1),gp(:,2),ip(:,1),ip(:,2));

  depth=depth+1;
  h=patch(shade_poly_x,shade_poly_y,repmat(depth,1,length(shade_poly_x)),[.2 .2 .2],'facealpha',.5,'alphadatamapping','none','parent',f_axis);

end


switch params.view_opt
case 1
  view(f_axis,0,90)
case 2
  view(f_axis,90,90)
case 3
  view(f_axis,180,90)
case 4
  view(f_axis,270,90)
case 5
  view(f_axis,180,270) % reflected
case 6
  view(f_axis,90,270) % reflected
case 7
  view(f_axis,0,270) % reflected
case 8
  view(f_axis,270,270) % reflected
otherwise
  error('path_anim params.view_opt')
end % switch view_opt

if ~isempty(params.window_title)
  title(params.window_title,'FontSize',16);
end

drawnow;



function plot_obst(f_axis,obst_pose,obst_sz,obst_x_offset,obst_y_offset,obst_color,linewidth,edgecolor,depth)

for ni=1:size(obst_pose,2)
  pose_ni = obst_pose(:,ni)';
  sz_ni   = obst_sz(:,ni)';
  h=patch([pose_ni(1), pose_ni(1), pose_ni(1)+sz_ni(1), pose_ni(1)+sz_ni(1)]+obst_x_offset, ...
          [pose_ni(2), pose_ni(2)+sz_ni(2), pose_ni(2)+sz_ni(2), pose_ni(2)]+obst_y_offset, ...
          [depth, depth, depth, depth], ...
          obst_color(ni,:),'linewidth',linewidth(ni),'edgecolor',edgecolor(ni,:), ...
          'parent',f_axis);

end


function depth = draw_box(f_axis,graph_sz,box_width,box_offset,depth)

% black border
patch([0, graph_sz(1)+box_offset+box_width, graph_sz(1)+box_offset+box_width, 0], ...
      [0, 0                               , graph_sz(2)+box_offset+box_width, graph_sz(2)+box_offset+box_width], ...
      [depth, depth, depth, depth], ...
      [0 0 0], ...
      'parent',f_axis);

if ~ishold(f_axis)
  hold(f_axis,'on');
end

% white fill
depth = depth+1;
patch([box_width, graph_sz(1)+box_offset, graph_sz(1)+box_offset, box_width], ...
      [box_width, box_width             , graph_sz(2)+box_offset, graph_sz(2)+box_offset], ...
      [depth, depth, depth, depth], ...
      [1 1 1], ...
      'parent',f_axis);


function draw_entity(f_axis, img, loc, dims, depth)

img_sz = size(img.img);

x = linspace(loc(1)-(dims(1)/2),loc(1)+(dims(1)/2),img_sz(1));
y = linspace(loc(2)-(dims(2)/2),loc(2)+(dims(2)/2),img_sz(2));
[X,Y]=meshgrid(x,y);
Z = zeros(size(X))+depth;

h=surface(X,Y,Z,'CData',double(img.img(end:(-1):1,:,:))./255, ...
  'facecolor','texturemap','facealpha','texturemap','alphadata',img.alpha(end:(-1):1,:), ...
  'linestyle','none','parent',f_axis);
