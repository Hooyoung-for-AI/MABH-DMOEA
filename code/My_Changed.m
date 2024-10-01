function [changed,RePop2,diversityIncrease,changeSeverityRecord] = My_Changed(Problem,Population,changeSeverityRecord,changeTag)
% Detect whether the problem changes

%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    RePop1  = Population(randperm(end,ceil(end/10)));
    RePop2  = Problem.Evaluation(RePop1.decs);
    changed = ~isequal(RePop1.objs,RePop2.objs) || ~isequal(RePop1.cons,RePop2.cons);
    diversityIncrease = 0;
%     if changed && changeTag == 1
%         changeSeverity = mean(sum(abs(RePop2.objs - RePop1.objs),2),1);
%         meanChangeSeverity = mean(changeSeverityRecord);
%         maxError = max(abs(changeSeverityRecord - meanChangeSeverity));
%         if maxError == 0
%             diversityIncrease = 1;
%             return
%         end
%         Error = abs(changeSeverity - meanChangeSeverity);
%         if Error/maxError > 1
%             diversityIncrease = 1;
%         else
%             diversityIncrease = 0;
%         end
%         changeSeverityRecord = [changeSeverityRecord,changeSeverity];
%     elseif ~changed
%         diversityIncrease = 0;
%     else
%         changeSeverity = mean(sum(abs(RePop2.objs - RePop1.objs),2),1);
%         changeSeverityRecord = [changeSeverityRecord,changeSeverity];
%         diversityIncrease = 0;
%     end
end