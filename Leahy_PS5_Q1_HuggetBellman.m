%Created by RM on 2017.12.07
%For Hugget Model in ECON 605 PS 5 Q1

bond_clearing = 100;
iteration_r = 0;

rmin = -1;
rmax = 3;
r = (rmin+rmax)/2;



bonditer = 25;
history_r = zeros(bonditer,2);
for b = 1:bonditer;


 iteration_r = iteration_r + 1; 

maxiter = 500;
% Initialize parameters

p = .8;
q = .55;
gamma = 2;
beta = .9;

transition = [.2 .6 .2 ;.4 .3 .3;.1 .8 .1];
income = [3 6 8];

assets = [-40:200]';
%assetsprime = [0:1000]'
assetspace = assets*2;
%assetsprime = assetsprime ./ 5

presizeassets = size(assetspace);
sizeassets = presizeassets(1,1);
presizetransition = size(transition);
sizetransition = presizetransition(1,1);
%Now Need to Iterate to Pick consumption

utilspace = zeros(sizeassets,sizeassets*sizetransition);


for i = 1:sizeassets;
    for j=1:sizeassets ;
        for k=1:sizetransition;
            input_utils = (1+r)*assetspace(i,1) + income(1,k) - assetspace(j,1);
            utils = (input_utils^(1-gamma)-1)/(1-gamma);
            if input_utils < 0
                    utils = -10000000000000;
            end
            utilspace(i,j,k) = utils;
          
        end;
    end;
    i;
end;


v = zeros(sizeassets,sizetransition) + .1;
tomax = utilspace;

diff_v_hist = zeros(maxiter,1);
for iter=1:maxiter;

%Need to turn matrix now into expanded matrix that takes same value 
%utilspace is u(i,j,k) = utility of having assets i, picking next period
%assets j in state k

%therefore, need to take v for current state i,k and add the relvant value

for i = 1:sizeassets;
    for j=1:sizeassets ;
        for k=1:sizetransition;
            for k2=1:sizetransition;        
                tomax(i,j,k) = utilspace(i,j,k) + beta * transition(k,k2) * v(i,k2);
            end;         
        end;
    end;
end;


%tomax is tomax(i,j,k) = value of having assets i, picking next period
%assets j, in state k
%now find best choice by state

bestchoices = zeros(sizeassets,sizetransition);
for state = 1:sizetransition;

    state_tomax = tomax(:,:,state);
    bestvalue = max(state_tomax');
    for i = 1:sizeassets;
        bestchoices(i,state) = bestvalue(1,i);
    end;
end;

diff = abs(bestchoices - v);
v = bestchoices;
max_diff = max(diff);
max_max_diff = max(max_diff);
diff_v_hist(iter,1) = max_max_diff;

iter;

end;

%part 3
%construct the matrix of transitions from (a,y) to (a',y') 
%given initial asset, maximize u + beta v


next_value = zeros(sizeassets,sizetransition,sizeassets);
for i = 1:sizeassets;
    for j=1:sizeassets ;
        for k=1:sizetransition; 
            for k2 = 1:sizetransition;
                    next_value(i,k,j) = utilspace(i,j,k) +  beta * transition(k,k2) * v(i,k2);
            end;
         end;
    end;
    i;
end;

%%
%ergodic_choice = zeros(sizeassets,sizetransition,sizetransition);
%ergodic_value = ergodic_choice - 1000;
%assume only make one choice from each asset + state combo
%for i = 1:sizeassets;
%    for k = 1:sizetransition;
%for i = 1:sizeassets;
 %   for j=1:sizeassets ;
 %       for k=1:sizetransition; 
 %           for k2 = 1:sizetransition;
 %               if ergodic_value(i,k,k2) < next_value(i,k,j,k2);
 %               ergodic_choice(i,k,k2) = j;
 %               ergodic_value(i,k,k2) = next_value(i,k,j,k2);
 %               end;
 %           end;
  %       end;
  %  end;
  %  i
%end; 

ergodic_choice = zeros(sizeassets,sizetransition);
ergodic_value = ergodic_choice - 1000;
%assume only make one choice from each asset + state combo

for i = 1:sizeassets;
    for j=1:sizeassets ;
        for k=1:sizetransition; 
            %for k2 = 1:sizetransition;
                if ergodic_value(i,k) < next_value(i,k,j);
                ergodic_choice(i,k) = assetspace(j,1);
                ergodic_value(i,k) = next_value(i,k,j);
               % end;
            end;
         end;
    end;
    i;
end;   

policy_fct = ergodic_choice;
%%

ergodic_density = zeros(sizeassets,sizetransition,sizeassets,sizetransition);
ergodic_count = zeros(sizeassets,sizetransition,sizeassets,sizetransition);
ergodic_transition = transition^1000;

for i=1:sizeassets;
       for j=1:sizeassets;
           for k=1:sizetransition;
             for k2=1:sizetransition;
                if ergodic_choice(i,k) == assetspace(j,1);
                    ergodic_density(i,k,j,k2) = ergodic_transition(1,k2) ;
                    ergodic_count(i,k,j,k2) =  ergodic_count(i,k,j,k2) + 1; 
                end;
             end;
           end;
           
       end;
       i;
end;
%%

ergodic_density_2d = zeros(sizeassets*sizetransition,sizeassets*sizetransition);
ergodic_count_2d = zeros(sizeassets*sizetransition,sizeassets*sizetransition);

for i=1:sizeassets;
       for j=1:sizeassets;
           for k=1:sizetransition;
             for k2=1:sizetransition;
                if ergodic_choice(i,k) == assetspace(j,1);
                    ergodic_density_2d(sizeassets*(k-1)+i,sizeassets*(k2-1)+j) = ergodic_density(i,k,j,k2) ;
                    ergodic_count_2d(sizeassets*(k-1)+i,sizeassets*(k2-1)+j) =   ergodic_count(i,k,j,k2) ;
                end;
             end;
           end;
           
       end;
       i;
end;
           
%%
pre_ergodic_density_fin = ergodic_density_2d^1000;

ergodic_density_fin=pre_ergodic_density_fin(1,:);

%%
%loan market clearing:
%verify if \sum\lambda(a,s)g(a,s) = 0
bond_clearing = 0;

for i=1:sizeassets;
       for k=1:sizetransition;
            bond_clearing = bond_clearing + ergodic_density_fin(1,k)*ergodic_choice(i,k);
       end;
end;

bond_clearing
r

history_r(iteration_r,1) = r;
history_r(iteration_r,2) = bond_clearing;

if bond_clearing > .01
        rmax = r;
        r = (rmin+rmax)/2;
elseif bond_clearing < 0
        rmin =r;
        r = (rmin+rmax)/2;
end;



end;



      
               
    






