function [x, dxm] = fast_kinHip(q1,dq1,  h, tStart, tEnd)
%--------------------------------------------------------------------------
%   fast_kinHip : compute the x position of the hip and his x velocity
%--------------------------------------------------------------------------

    [~, ~, ~, l, ~, ~, ~] = set_parameters();
    
    if nargin == 3
        x = h * l * sum(dq1(:).*cos(q1(:)));
    elseif nargin > 2
        xStabilize = h * l * sum(dq1(1:tStart).*cos(q1(1:tStart)));
        xStable = h * l * sum(dq1(tStart+1:tEnd).*cos(q1(tStart+1:tEnd)));
        x = xStabilize+xStable;
        dxm = xStable / ((tEnd - tStart)*h);
    end
end

