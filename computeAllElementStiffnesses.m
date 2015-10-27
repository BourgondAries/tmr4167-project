function [matrix] = computeAllElementStiffnesses(beams)
	matrix = [];
	for i = 1:size(beams, 1)
		matrix(:, :, i) = ...
			computeElementStiffness(beams(i, 7),...
				beams(i, 8), beams(i, 6));
	end
end
