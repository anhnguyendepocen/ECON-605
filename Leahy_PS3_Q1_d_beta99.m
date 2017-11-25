% Created by RM on 2017.11.25 for ECON 605 Leahy PS 3 Q1
%Designed to calculate risk free rate and returns 

%%%%%%
 %Q1b: Risk free rate & unconditional equity return based on Mehra Prescott */
%%%%%


%Add parameters
beta = .99

mu = .018

delta = .036

gam_list = [2 4 6 10]

transition = [.6 1-.6; 1-.9 .9]

I = eye(2)

ones = [1 1]

gam_size = size(gam_list)

iters = gam_size(1,2)

pre_ans_mat = zeros(4)
ans_mat = pre_ans_mat(:,1:3)


for g = 1:iters

%Calculate equity premium
gamma = gam_list(1,g)

lambda = [1.02252  1-.06785]
lambda_mat = [(1+mu+delta)^(1-gamma) 0; 0 (1+mu-delta)^(1-gamma)]


%Create W Matrix

pre_w_to_invert = I - beta*transition*lambda_mat
pre_w_inverted = pre_w_to_invert^-1
w = beta*pre_w_inverted*transition*lambda_mat*ones'

ERS = (transition * (lambda'.*(w+1)))./w

transition_longrun = transition^1000

longrunprob = transition_longrun(:,1)

uncond_equity_ret = longrunprob' * ERS

ans_mat(g,1) = gamma
ans_mat(g,2) = uncond_equity_ret

%Calculate risk free rate

lambda_rkfree = [lambda(1,1)^(-gamma) 0; 0 lambda(1,2)^(-gamma)]

pre_state_ret = lambda_rkfree*transition
state_ret = (beta*sum(pre_state_ret))
state_ret_inv = state_ret.^(-1)

avg_rkfree = state_ret_inv * longrunprob

ans_mat(g,1) = gamma
ans_mat(g,3) = avg_rkfree

end

ans_mat
 











