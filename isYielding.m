% Sjekker om elementet flyter. 
function [where] = isYielding(moments, beams, yieldStrength)
	% Hvis den flyter i posisjon 0, ser vi bort fra flyt. 
	where = 0;
    % Løkken kjører gjennom matrisen med momentene. 
	for i = 1:size(moments, 2)
        % Beregner spenning for hvert element.
		stress = moments(:, i) ./ beams(i, 8) .* beams(i, 11);
        % Hvis over flytespenning i et av elementene --> returnerer
        % spenningsverdi. 
		if any(stress > yieldStrength)
			% fprintf('%i %d\n', i, max(stress));
			where = i;
			return;
		end
	end
end
