function [matrix] = computeElementStiffness(hooke_module, secondmomentarea, length)
	i = secondmomentarea;
	e = hooke_module;
	l = length
	s = 4 * e * i / l;
	s2 = s / 2;
	matrix = [s s2; s2 s];
end
