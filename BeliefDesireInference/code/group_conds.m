function [group_inds] = group_conds(irrational)
% [group_inds] = group_conds
% return indices for 7 groups of conditions for
% which model & human inferences should follow similar patterns
%
% Group 1: check - go back (G2 present)
% Group 2: check - stay (G2 present)
% Group 3: no check (G2 present)
% Group 4: check - go back (G2 absent)
% Group 5: no check (G2 absent)
% Group 6: check partial (G2 present)
% Group 7: check partial (G2 absent)
%


if ~irrational
  group_inds = { ...
    % check - go back (G2 present)
    [ 1  6  3  8 13 40 43 46 25 28 31] ...
    % check - stay (G2 present)
    [ 2  7  4  9 14 41 44 47 26 29 32] ...
    % no check (G2 present)
    [ 5 10 15 42 45 48 27 30 33] ...
    % check - go back (G2 absent)
    [16 19 17 20 23 49 51 53 34 36 38] ...
    % no check (G2 absent)
    [18 21 24 50 52 54 35 37 39] ...
    % check partial (G2 present)
    [55 63 59 67 75 57 65 73 61 69 77] ...
    % check partial (G2 absent)
    [56 64 60 68 76 58 66 74 62 70 78]};
else
  group_inds = { ...
    % check - go back (G2 present)
    [ 1  6 11  3  8 13 40 43 46 25 28 31] ...
    % check - stay (G2 present)
    [ 2  7 12  4  9 14 41 44 47 26 29 32] ...
    % no check (G2 present)
    [ 5 10 15 42 45 48 27 30 33] ...
    % check - go back (G2 absent)
    [16 19 22 17 20 23 49 51 53 34 36 38] ...
    % no check (G2 absent)
    [18 21 24 50 52 54 35 37 39] ...
    % check partial (G2 present)
    [55 63 71 59 67 75 57 65 73 61 69 77] ...
    % check partial (G2 absent)
    [56 64 72 60 68 76 58 66 74 62 70 78]};
end
