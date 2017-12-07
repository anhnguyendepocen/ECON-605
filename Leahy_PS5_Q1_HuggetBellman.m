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

assets = [0:500]';
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




%for i = 1:sizeassets;
%    for k = 1:sizetransition;
%        bestchoices(i,k) = tomax(i,max,k)
        
    






