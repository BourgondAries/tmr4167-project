
% Sjekker om elementet flyter. 
function [where] = isYielding(tension, beams, yieldStrength)
	% Hvis den flyter i posisjon 0, ser vi bort fra flyt. 
	where = 0;
		% Løkken kjører gjennom matrisen med momentene. 
		% Beregner spenning for hvert element.
		for i = 1:size(tension, 2)
		stress = tension(:, i);
		% Hvis over flytespenning i et av elementene --> returnerer
		% spenningsverdi. 
		
		if any(abs(stress) > yieldStrength)
			% fprintf('%i %d\n', i, max(stress));
			where = i;
			return;
		end
	end
end
