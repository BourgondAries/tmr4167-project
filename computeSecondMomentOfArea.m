% Beregner andrearealmoment av r�rprofil.
function [i] = computeSecondMomentOfArea(outer_radius, inner_radius)
		i = pi * (outer_radius .^ 4 - inner_radius .^ 4) / 4;
end
