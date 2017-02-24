function [V] = parse_policyx(filename)
% [V] = parse_policyx(filename)

xDoc = xmlread(filename);

D = xDoc.getDocumentElement;

n_alpha = str2num(D.item(1).getAttribute('numVectors'));
alpha_dim = str2num(D.item(1).getAttribute('vectorLength'));
n_state = str2num(D.item(1).getAttribute('numObsValue'));

V.alphas = zeros(n_alpha,alpha_dim);
V.policy = zeros(1,n_alpha);
V.states = zeros(1,n_alpha);
for na=1:n_alpha
  V.alphas(na,:) = str2num(D.item(1).item(2*na-1).getFirstChild.getData);
  V.policy(na) = str2num(D.item(1).item(2*na-1).getAttribute('action'));
  V.states(na) = str2num(D.item(1).item(2*na-1).getAttribute('obsValue'));
end




return;

alpha_count = zeros(1,n_state);
for ns=1:n_state
  alpha_count(ns) = sum(states==(ns-1));
end

V_cell = mat2cell(alphas',alpha_dim,alpha_count);
policy_cell = mat2cell(policy,1,alpha_count);


b_sub0 = repmat(1/alpha_dim,alpha_dim,1);
[V_b,max_alpha,max_ind] = value_belief_point1(V_cell,b_sub0)

state_policy = zeros(1,n_state);
for ns=1:n_state
  state_policy(ns) = policy_cell{ns}(max_ind{ns});
end

