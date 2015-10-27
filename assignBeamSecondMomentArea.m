function [matrix] = assignBeamSecondMomentArea(beams, geometry)
	to_add = [];
	for i = 1:size(beams)
		for j = 1:size(geometry)
			if beams(i, 5) == j
				to_add = [to_add geometry(j, 2)];
			end
		end
	end
	matrix = [beams transpose(to_add)];
end
