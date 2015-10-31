function [moments] = computeMomentsPerBeam(localstiffnesses, fem, rotations)
	% We know there are only two points per fem, ideally, this should be optimized away.
	% The current method will work.
	moments = zeros(2, size(localstiffnesses, 3));
	for i = 1:size(fem, 3)
		beamfem = fem(:, :, i);
		node1 = find(beamfem ~= 0, 1, 'first');
		node2 = find(beamfem ~= 0, 1, 'last');

		if isempty(node1)
			continue;
		end

		moments(:, i) = ...
			localstiffnesses(:, :, i) * [rotations(node1);...
				rotations(node2)] + [beamfem(node1);...
				beamfem(node2)];
	end
end
