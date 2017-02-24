function [obst_sub] = get_obst_sub(obst_pose,obst_sz)
% [obst_sub] = get_obst_sub(obst_pose,obst_sz)

n_obst = size(obst_pose,2);
if n_obst > 0
  n_ind  = obst_sz(1,:)*obst_sz(2,:)';
  obst_sub = zeros(2,n_ind);
  ind = 1;
  for oi=1:n_obst
    for xi=0:(obst_sz(1,oi)-1)
      for yi=0:(obst_sz(2,oi)-1)
        obst_sub(:,ind) = obst_pose(:,oi) + [xi yi]';
        ind = ind+1;
      end
    end
  end
else
  obst_sub = zeros(2,0);
end

