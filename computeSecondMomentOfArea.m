function [i] = computeSecondMomentOfArea(outer_radius, inner_radius, is_box)
	if is_box
		i = outer_radius .^ 4 / 12;
		i = i - inner_radius .^ 4 / 12;
	else
		i = pi * (outer_radius .^ 4 - inner_radius .^ 4) / 4;
	end
end
