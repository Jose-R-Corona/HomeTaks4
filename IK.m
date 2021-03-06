function q = IK(Td, q0,q_symbs, only_position,FowardK,Jacobian)
    
    eps_p = 1e-06; % error in position
    eps_o = 1e-05; % error in orientation
    % Max number of iteration  
    K = 40; 
    k = 0;
    % initialization of the variables
    q = q0;
    %just to avoid errors in q initial with 0 position
    if (norm(q0)==0)
        q = q0;
        q(1)=q(1)+0.01;
    end
    
    pd = Td(1:3, 4);            %position we want go
    Rd = Td(1:3, 1:3);
    sd = rot2cuat(Rd); 
    
    T=double(subs(FowardK, [q_symbs], [q'] ));
    
    p = T(1:3, 4);
    R = T(1:3, 1:3);
    s = rot2cuat(R);
    
    e_p = pd - p;
    s_e = multcuat(sd, invcuat(s));
    e_o = s_e(2:end);
    e = 1;
    
    % Complete the initialization and cycle responsible for implementing the iterative method
    %while((norm(e) > eps) && (k < K))
    while(((norm(e_p) > eps_p) || (norm(e_o) > eps_o)) && (k < K))
        %disp(k)
        T = double(subs(FowardK, [q_symbs], [q'] ));
        J = double(subs(Jacobian, [q_symbs], [q'] ));
        
        p = T(1:3, 4);
        e_p = pd - p;   %is the error in position, destination position - position of this iteration
        
        if(only_position == 1)
            J = J(1:3,:);   %first 3 rows, Jacobian secction for joints velocity 
            Ji = J'/(J*J'+0.1*eye(3)); %add small increment
            e = e_p;
            e_o=eps_o;  %only position, dont care orientation error
        else
            R = T(1:3, 1:3);
            s = rot2cuat(R);
            s_e = multcuat(sd, invcuat(s));
            e_o = s_e(2:end);
            Ji = J'/(J*J'+0.1*eye(6));
            e = [e_p; e_o];
        end
        
        q = q + Ji*e; % The solution is updated
        k = k + 1;
        %draw_robot(q',[1, 1, 1])
        %pause(0.01);
    end
    i=1;
    while (i<3) % angles #
        q(i)=wrapToPi(q(i));
        i=i+1;
    end
end