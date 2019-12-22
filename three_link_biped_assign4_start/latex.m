%rowLabPD = ['$K_p_torso$','$K_p_spread$','$K_d_torso$','$K_d_spread$','$qt_des$','$spread_des$'];
%rowLabVMC = ['$k_1$','$k_2$','$k_3$','$C_1$','$C_2$','$C_3$','$qt_des$','$x_des$','$speed$'];
load('control_params_PD.mat')
matrix2latex(control_params, 'latex_PD')%, 'rowLabels', rowLabPD)
load('control_params_VMC.mat')
matrix2latex(control_params, 'latex_VMC')%, 'rowLabels', rowLabVMC)