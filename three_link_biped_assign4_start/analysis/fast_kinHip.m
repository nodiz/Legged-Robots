function [x, dxm] = fast_kinHip(q1,dq1,  h, tStart, tFin)
%FAST_KINHIP Summary of this function goes here
%   Detailed explanation goes here
    l = 0.5;
    if nargin == 3
        x = h * l * sum(dq1(:).*cos(q1(:)));
    elseif nargin > 2
        xStabilize = h * l * sum(dq1(1:tStart).*cos(q1(1:tStart)));
        xStable = h * l * sum(dq1(tStart+1:tFin).*cos(q1(tStart+1:tFin)));
        x = xStabilize+xStable;
        dxm = xStable / ((tFin - tStart)*h);
    end
end

