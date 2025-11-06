function X=initialization(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,2); % numnber of boundaries
VarSize=[1 dim];
% If the boundaries of all variables are equal
if Boundary_no==1
    for i=1:SearchAgents_no
        if i>1
            X(i,:)=rand(VarSize).*(ub-lb)+lb;
        else
            X(i,:)=ones(VarSize);
        end
    end
end

% If each variable has a different lb and ub
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        X(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
    end
end