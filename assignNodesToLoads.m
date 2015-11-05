
% Definerer hvilke type laster som virker på hvilke element. 
function [matrix] = assignNodesToLoads(loads, beams)
	% Antar at lastene har elementer i neste linje.
	matrix = [];
	for i = 1:size(loads)
		for j = 1:size(beams)
			if loads(i, 2) == j
				matrix = [matrix; beams(j, 2)...
					beams(j, 3) beams(j, 9)...
					/ beams(j, 6) beams(j, 10)...
					/ beams(j, 6) beams(j, 6)];
			end
		end
	end
	matrix = [loads matrix];
end
