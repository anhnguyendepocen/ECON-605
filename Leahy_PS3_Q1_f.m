% Created by RM on 2017.11.25 for ECON 605 Leahy PS 3 Q1
%Designed to calculate risk free rate and returns 


%%%%%%
 %Q1f: Risk free rate & unconditional equity return based on Mehra Prescott */
 %Based on 1.c paramters
%%%%%
% Created by RM on 2017.11.25 for ECON 605 Leahy PS 3 Q1



%Add parameters
beta = .99

mu = .018

delta = .036

gam_list = [2 4 6 10]

transition = [.987 1-.987; 1-.516 .516]

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
%lambda_mat = [lambda(1,1)^(1-gamma) 0; 0 lambda(1,2)^(1-gamma)]
lambda_next = [lambda(1,1)^(gamma) 0; 0 lambda(1,2)^(gamma)]
lambda_boom = sum(lambda_next * transition(1,:)')*lambda(1,1)^(-gamma-1)
lambda_bust = sum(lambda_next * transition(2,:)')*lambda(1,2)^(-gamma-1)

lambda_mat = [lambda_boom 0; 0 lambda_bust]

%Create W Matrix

pre_w_to_invert = I - beta*transition*lambda_mat
pre_w_inverted = pre_w_to_invert^-1
w = beta*pre_w_inverted*transition*lambda_mat*ones'

ERS = (transition * ([lambda_boom lambda_bust]'.*(w+1)))./w

transition_longrun = transition^1000

longrunprob = (transition_longrun(1,:))'

uncond_equity_ret = longrunprob' * ERS

ans_mat(g,1) = gamma
ans_mat(g,2) = uncond_equity_ret

%Calculate risk free rate
lambda_next = [lambda(1,1)^(gamma-1) 0; 0 lambda(1,2)^(gamma-1)]
lambda_next_boom = sum(lambda_next * transition(1,:)')*lambda(1,1)^(-gamma)
lambda_next_bust = sum(lambda_next * transition(2,:)')*lambda(1,2)^(-gamma)

boom_ret = (beta*lambda_next_boom)^(-1)
bust_ret = (beta*lambda_next_bust)^(-1)
%pre_state_ret = transition*lambda_rkfree
%state_ret = (beta*sum(pre_state_ret'))
%state_ret_inv = state_ret.^(-1)

avg_rkfree = boom_ret * longrunprob(1,1) + bust_ret * longrunprob(2,1)

ans_mat(g,1) = gamma
ans_mat(g,3) = avg_rkfree
ans_mat(g,4) = ans_mat(g,2)-ans_mat(g,3)

end

ans_mat
 











