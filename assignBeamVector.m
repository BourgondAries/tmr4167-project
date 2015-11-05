
% Definerer koordinatsystem og definerer elementene som vektorer.
function [beams] = assignBeamVector(beams, nodes)
	to_add = [];
	for i = 1:size(beams)
		dx = -1;
		dy = -1;
        
        % Løkken kjører gjennom matrisen nodes.
        % Definerer minste og største knutepunkt for hvert element til bruk
        % i senere beregninger av moment og skjærkraft.
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
        % Henter ut elementlengder fra matrisen beams.
        l = beams(i, 6);
		to_add = [to_add; -dx -dy];
    end
    % Legger itl definisjon av minste og største node for hvert element 
    % i matrisen beams. 
	beams = [beams to_add];
end
