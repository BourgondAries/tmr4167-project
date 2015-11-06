
% Sjekker om elementet flyter. 
function [where] = isYielding(tension, beams, yieldStrength)
	% Dersom funksjonen returnerer 0, er det ingen flyt noen steder. 
	where = 0;
		% Løkken kjører gjennom matrisen med momentene. 
		% Beregner spenning for hvert element.
		for i = 1:size(tension, 2)
		stress = tension(:, i);
		% Hvis over flytespenning i et av elementene --> returnerer
		% spenningsverdi. 
		
		if any(abs(stress) > yieldStrength)
			where = i;
			return;
		end
	end
end
