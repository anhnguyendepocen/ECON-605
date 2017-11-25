%Comment here

%Add parameters
beta = .99

mu = .018

delta = .036

gam_list = [2 4 6 10]

transition = [.43 1-.43; 1-.43 .43]

I = eye(2)

ones = [1 1]

gam_size = size(gam_list)

iters = gam_size(1,2)

pre_ans_mat = zeros(4)
ers_ans_mat = pre_ans_mat(:,1:2)
rkfree_ans_mat = pre_ans_mat(:,1:2)


for g = 1:iters

gamma = gam_list(1,g)

lambda = [1+mu+delta  1+mu-delta]
lambda_mat = [(1+mu+delta)^(1-gamma) 0; 0 (1+mu-delta)^(1-gamma)]


%Create W Matrix

pre_w_to_invert = I - beta*transition*lambda_mat
pre_w_inverted = pre_w_to_invert^-1
w = beta*pre_w_inverted*transition*lambda_mat*ones'

ERS = (transition * (lambda'.*(w+1))).*w

transition_longrun = transition^1000

longrunprob = transition_longrun(:,1)

uncond_equity_ret = longrunprob' * ERS

ans_mat(g,1) = gamma
ans_mat(g,2) = uncond_equity_ret

end
 







