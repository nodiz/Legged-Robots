function M = eval_M_tmp(l1,l2,l3,m1,m2,m3,q1,q2,q3)
%EVAL_M_TMP
%    M = EVAL_M_TMP(L1,L2,L3,M1,M2,M3,Q1,Q2,Q3)

%    This function was generated by the Symbolic Math Toolbox version 8.1.
%    14-Oct-2019 16:32:27

t2 = q1-q2;
t3 = cos(t2);
t4 = q1-q3;
t5 = cos(t4);
t6 = l1.*l3.*m3.*t5.*(1.0./2.0);
M = reshape([l1.^2.*(m1.*(1.0./4.0)+m2+m3),l1.*l2.*m2.*t3.*(-1.0./2.0),t6,l1.*l2.*m2.*t3.*(-1.0./2.0),l2.^2.*m2.*(1.0./4.0),0.0,t6,0.0,l3.^2.*m3.*(1.0./4.0)],[3,3]);