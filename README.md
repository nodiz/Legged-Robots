# LeRo1.01

This project was conducted in the the frame of the course MICRO-507
Legged Robots
at EPFL. The aim is to
design, implement and analyse the walking control of a simple biped. The considered biped is 2-dimensional
and made out of three links (two legs and a torso), each of them having its own punctual mass (see Figure 1.1).
The biped, its kinematics, its dynamics and its control are modeled, simulated and animated in a
Matlab
environment.
In this project, three different controllers are implemented: two classical control methods (PD-controller and
Virtual Force Control) and one learning method (Deep Reinforcement Learning).
In a first time, this report explains how the kinematics and dynamics of the biped are designed and how
the controller are implemented and tuned so that the biped can walk.  Then, in a second time, the three
controller’s performance are analysed regarding different criteria (speed, robustness against perturbations, cost
of transport, etc.). Eventually a synthetic comparison of the three methods is made.
