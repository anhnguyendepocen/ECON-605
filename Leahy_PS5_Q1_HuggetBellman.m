%Created by RM on 2017.12.07
%For Hugget Model in ECON 605 PS 5 Q1
maxiter = 500
% Initialize parameters

r = .05
p = .8
q = .55
gamma = 2
beta = .95

transition = [p 1-p; 1-q q]
income = [12 25]

assets = [-200:400]';
%assetsprime = [0:1000]'
assetspace = assets ./ 5
%assetsprime = assetsprime ./ 5

initialassets = 20
initialstate = 1

presizeassets = size(assetspace)
sizeassets = presizeassets(1,1)
presizetransition = size(transition)
sizetransition = presizetransition(1,1)
%Now Need to Iterate to Pick consumption

utilspace = zeros(sizeassets,sizeassets*sizetransition);


for i = 1:sizeassets;
    for j=1:sizeassets ;
        for k=1:sizetransition;
            input_utils = (1+r)*assetspace(i,1) + income(1,k) - assetspace(j,1);
            utilspace(i,j*k) = (input_utils^(1-gamma)-1)/(1-gamma);
          
        end;
    end;
    i;
end;


v = zeros(sizeassets,2) + .01
tomax = utilspace;


for iter=1:maxiter

%Need to turn matrix now into expanded matrix that takes same value 
%utilspace is u(i,j,k) = utility of having assets i, picking next period
%assets j in state k

%therefore, need to take v for current state i,k and add the relvant value

for i = 1:sizeassets;
    for j=1:sizeassets ;
        for k=1:sizetransition;
            for k2=1:sizetransition;        
                tomax(i,j*k) = utilspace(i,j*k) + beta * transition(k,k2) * v(i,k2);
            end;         
        end;
    end;
end;


%tomax is tomax(i,j,k) = value of having assets i, picking next period
%assets j, in state k
%now find best choice by state

bestchoices = zeros(sizeassets,sizetransition);
for state = 1:sizetransition

    state_tomax = tomax(:,sizeassets*(state-1)+1:sizeassets*state);
    bestvalue = max(state_tomax');
    for i = 1:sizeassets;
        bestchoices(i,state) = bestvalue(1,i);
    end;
end;

diff = abs(bestchoices - v);
v = bestchoices;

iter

end;

%part 3
%construct the matrix of transitions from (a,y) to (a',y') 
%given initial asset, maximize u + beta v


next_value = zeros(sizeassets,sizetransition,sizeassets);
for i = 1:sizeassets;
    for j=1:sizeassets ;
        for k=1:sizetransition; 
            for k2 = 1:sizetransition;
                    next_value(i,k,j) = utilspace(i,j*k) +  beta * transition(k,k2) * v(i,k2);
            end;
         end;
    end;
    i
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
                ergodic_choice(i,k) = j;
                ergodic_value(i,k) = next_value(i,k,j);
               % end;
            end;
         end;
    end;
    i
end;   

%%

ergodic_density = zeros(sizeassets,sizetransition,sizeassets,sizetransition);
ergodic_count = zeros(sizeassets,sizetransition,sizeassets,sizetransition);
ergodic_transition = transition^1000

for i=1:sizeassets;
       for j=1:sizeassets;
           for k=1:sizetransition;
             for k2=1:sizetransition;
                if ergodic_choice(i,k) == j;
                    ergodic_density(i,k,j,k2) = ergodic_transition(1,k2) ;
                    ergodic_count(i,k,j,k2) =  ergodic_count(i,k,j,k2) + 1; 
                end;
             end;
           end;
           
       end;
       i
end;
%%

ergodic_density_2d = zeros(sizeassets*sizetransition,sizeassets*sizetransition);
ergodic_count_2d = zeros(sizeassets*sizetransition,sizeassets*sizetransition);

for i=1:sizeassets;
       for j=1:sizeassets;
           for k=1:sizetransition;
             for k2=1:sizetransition;
                if ergodic_choice(i,k) == j;
                    ergodic_density_2d(sizeassets*(k-1)+i,sizeassets*(k2-1)+j) = ergodic_density(i,k,j,k2) ;
                    ergodic_count_2d(sizeassets*(k-1)+i,sizeassets*(k2-1)+j) =   ergodic_count(i,k,j,k2) ;
                end;
             end;
           end;
           
       end;
       i
end;
           
%%
pre_ergodic_density_fin = ergodic_density_2d^1000;

ergodic_density_fin=pre_ergodic_density_fin(1,:);

    






