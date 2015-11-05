
% Setter opp systemstivhetsmatrisen.
function [matrix] = computeAllElementStiffnesses(beams)
	matrix = [];
	for i = 1:size(beams, 1)
		% Kaller opp beregninger om bøyestivhet i elementer og lokal
		% stivhetsmatriser.
		% beams(i, 7)  % E
		% beams(i, 8)  % I
		% beams(i, 6)  % L
		matrix(:, :, i) = ...
			computeBeamStiffness(beams(i, 7),...
				beams(i, 8), beams(i, 6));
	end
end
