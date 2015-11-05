% Beregner lokale forskyvning (endemoment) basert på rotasjoner og lokale
% stivhetsmatriser for hvert element. 
function [moments] = computeMomentsPerBeam(localstiffnesses, fem, rotations, beams)
	% We know there are only two points per fem, ideally, this should be optimized away.
	% The current method will work.
	moments = zeros(2, size(localstiffnesses, 3));
	for i = 1:size(fem, 3)
		beamfem = fem(:, :, i);
		beam = beams(i, :);
		node1 = beam(2);
		node2 = beam(3);

		moments(:, i) = ...
			localstiffnesses(:, :, i) * [rotations(node1);...
				rotations(node2)] + [beamfem(node1);...
				beamfem(node2)];
	end
end
