
% Legger tilbake nullverdi i rotasjonsvektor der det er fast innspenning.
function [rotations] = addZerosToRotations(rotations, nodes)
	for i = 1:size(nodes, 1)
		if nodes(i, 9) == 1
			rotations = [rotations(1:i-1); 0; rotations(i:end)];
		end
	end
end
