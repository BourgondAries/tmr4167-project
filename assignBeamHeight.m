
% Definerer høyden på tverrsnittet til hvert element, og lagrer
% informasjonen som en ny kolonne i matrisen beams.
function beams = assignBeamHeight(beams, pipes, iheight)
	to_add = [];
    
    % Iterer gjennom matrisen beams.
	for i = 1:size(beams, 1)
		if any(beams(i, 5) == pipes(:, 1))  % Hvis elementet er rør:
			mat = beams(i, 5);
			to_add = [to_add; pipes(mat, 2)];  % Legger til en kolonne med 
                                               % informasjon om høyde på 
                                               % rørtverrsnittet.
       
        else                              % Hvis IPE-bjelke:
			to_add = [to_add; iheight]; % Legger til høyde på tverrsnittet.
		end
	end
	beams = [beams to_add];
end
