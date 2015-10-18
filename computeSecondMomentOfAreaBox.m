function [i] = computeSecondMomentOfAreaBox(outer_b, outer_h, inner_b, inner_h)
	i = outer_b * outer_h .^ 3 / 12;
	i = i - inner_b * inner_h .^ 3 / 12;
end
