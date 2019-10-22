% run the following code
clear all
load('sln_test.mat') 
q0 = [pi/6; -pi/3; 0];
dq0 = [0;0;0];
num_steps = 1000;
sln = solve_eqns(q0, dq0, num_steps);
if(isequaln(sln, sln_test))
    disp('Great! your answer is right!')
else
    disp('OPS! Something is wrong! Please check your code carefully!')
end
