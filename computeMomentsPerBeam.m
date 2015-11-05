% Beregner lokale forskyvning (endemoment) basert p� rotasjoner og lokale
% stivhetsmatriser for hvert element. 
function [moments] = computeMomentsPerBeam(localstiffnesses, fem, rotations, beams)
	% We know there are only two points per fem, ideally, this should be optimized away.
	% The current method will work.
    
    % Definerer en tom matrise.
	moments = zeros(2, size(localstiffnesses, 3));
    % Kj�rer gjennom matrisen med fastinnspenningsmomentene. 
	for i = 1:size(fem, 3)
        % Henter ut fastinnspeningsmoment og elementnummer og lagrer i
        % samme matrise: beam.
		beamfem = fem(:, :, i);
		beam = beams(i, :);
		node1 = beam(2);
		node2 = beam(3);

		% Beregner totale endemomenter med lokal stivhetsmatrise, rotasjonsvektor og
		% fastinnspenningsmoment. 
        moments(:, i) = ...
			localstiffnesses(:, :, i) * [rotations(node1);...
				rotations(node2)] + [beamfem(node1);...
				beamfem(node2)];
	end
end
