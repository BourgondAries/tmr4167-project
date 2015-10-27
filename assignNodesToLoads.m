function [matrix] = assignNodesToLoads(loads, beams)
	% Assume the loads have elements in the second column
	matrix = [];
	for i = 1:size(loads)
		for j = 1:size(beams)
			if loads(i, 2) == j
				matrix = [matrix; beams(j, 2) ...
					beams(j, 3)];
			end
		end
	end
end
