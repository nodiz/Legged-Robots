addpath('../dynamics/', '../set_parameters/');

[m1, m2, m3, l1, l2, l3, g] = set_parameters();
q_test = [0.9134    0.6324    0.0975];
dq_test = [0.2785    0.5469    0.9575];

C_test = [0  -0.132706376041645   1.037364687878396
   0.067578580595352                   0                   0
  -0.301729572401184                   0                   0];

M_test = [ 6.437500000000000  -0.840681276908014   1.019254579560482
          -0.840681276908014   0.437500000000000                   0
          1.019254579560482                   0   0.520625000000000];
G_test = 100 * [-1.067750441505868
            0.101474058206939
            -0.028410069075374];

error_C = round(eval_C(q_test, dq_test) - C_test, 5);
fprintf('error_C: \n');
disp(error_C)


error_M = round(eval_M(q_test) - M_test, 5);
fprintf('error_M: \n');
disp(error_M)

error_G = round(eval_G(q_test) - G_test, 5);
fprintf('error_G: \n');
disp(error_G)

q_m_test = [0.2345; -0.2345; 0.123];
dq_m_test = [1.234; 0.2744; 0.222];
q_p_test = [-0.2345; 0.2345; 0.123];
dq_p_test = [0.485693398286875; -0.367502841947348; 2.425862898543675];
T_m_test = 5.071347258785892;
V_m_test = 1.434623392402943e+02;
energy_loss_test = 0.969497886379855;

[T_m_check, V_m_check] = eval_energy(q_m_test, dq_m_test);
[T_p_check, V_p_check] = eval_energy(q_p_test, dq_p_test);

error_T = round(T_m_check - T_m_test, 5);
fprintf('error_T: \n');
disp(error_T);
error_V = round(V_m_check - V_m_test, 5);
fprintf('error_V: \n');
disp(error_V);

[q_p_check, dq_p_check] = impact(q_m_test, dq_m_test);

error_q_p_impact = round(q_p_check - q_p_test, 5);
error_dq_p_impact = round(dq_p_check - dq_p_test, 5);
fprintf('error_q_p_impact: \n');
disp(error_q_p_impact)
fprintf('error_dq_p_impact: \n');
disp(error_dq_p_impact);

error_energy_loss = round(T_m_check + V_m_check - T_p_check - V_p_check ...
    - energy_loss_test, 5);
fprintf('error_energy_loss: \n');
disp(error_energy_loss);



