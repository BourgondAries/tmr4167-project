
% Beregner lengden p� hvert element. 
function [matrix] = assignBeamLength(beams, nodes)
	to_add = [];
    
    % For-l�kken kj�rer gjennom matrisen fra f�rste til siste element.
	for i = 1:size(beams)
		dx = -1;
		dy = -1;
        
        % Henter ut plassering (koordinater) for hvert knutepunkt og regner
        % avstanden mellom dem. 
		for j = 1:size(nodes)
			if nodes(j, 1) == beams(i, 2) ||...
			   nodes(j, 1) == beams(i, 3)
				if dx == -1
					dx = nodes(j, 2);
				else
					dx = dx - nodes(j, 2);
				end
				if dy == -1
					dy = nodes(j, 4);
				else
					dy = dy - nodes(j, 4);
				end
			end
        end
        % Bruker Pytagoras for � beregne avstand, gjelder da ogs� for
        % bjelker osm st�r p� skr�. 
		to_add(i) = sqrt(dx^2 + dy^2);
    end
    
    % Legger til data om elementlengde i matrisen beams.
	matrix = [beams transpose(to_add)];
end
