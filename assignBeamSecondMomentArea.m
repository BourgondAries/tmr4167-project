
% Beregner andre arealmoment for elementet avhengig av hvilken
% tverrsnittsgeometri det er. 
function [matrix] = assignBeamSecondMomentArea(beams, geometry)
	to_add = [];
	for i = 1:size(beams)
		for j = 1:size(geometry)
			if beams(i, 5) == j
				to_add = [to_add geometry(j, 2)];
			end
		end
    end
    % Legger til informasjonen i matrisne beams. 
	matrix = [beams transpose(to_add)];
end
