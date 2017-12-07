%Created by RM on 2017.12.07
%For Hugget Model in ECON 605 PS 5 Q1

% Initialize parameters

r = .05
p = .8
q = .55
gamma = 2
beta = .95

transition = [p 1-p; 1-q q]
income = [12 25]

assets = [0:1000]'
assetsprime = [0:1000]'
assets = assets ./ 5
assetsprime = assetsprime ./ 5

initialassets = 20
initialstate = 1

%Now Need to Iterate to Pick consumption

input_inst_utils = [(1+r) .* initialassets + income]' - assetsprime'
inst_utils = [((input_inst_utils .^ (1-gamma))-1) ./ (1-gamma)]'
%max_state_1 = max(inst_utils(:,1))
%max_state_2 = max(inst_utils(:,2))

max_choice = max(inst_utils)
[M,I] = max(inst_utils)

ergodic = transition^10000





