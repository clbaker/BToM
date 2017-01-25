function [] = add_errorbar_lw(h,w)

% increase errorbar line width
hb = get(h,'children');
Xdata = get(hb(2),'Xdata');
temp = 4:3:length(Xdata);
temp(3:3:end) = [];
% xleft and xright contain the indices of the left and right
% endpoints of the horizontal lines
xleft = temp; xright = temp+1;
% Increase line length by 0.2 units
Xdata(xleft) = Xdata(xleft) - w;
Xdata(xright) = Xdata(xright) + w;
set(hb(2),'Xdata',Xdata)
