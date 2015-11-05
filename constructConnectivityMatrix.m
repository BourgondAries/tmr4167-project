% Setter opp konnektivitetsmatrise for alle element. 
function [matrix] = constructConnectivityMatrix(beams)
	% F�rst en tom matrise.
    matrix = [];
    
    % Itererer gjennom matrisen beams.
	for i=1:size(beams)
        
        % Henter ut antall elementer og hvilke knutepunkt de g�r mellom. 
		elem = beams(i, 1);
		np1 = beams(i, 2);
		np2 = beams(i, 3);
        
        % Setter opp matrisen med konnektivitet. 
		matrix = [matrix; elem np1 np2];
	end
	matrix = transpose(matrix);
end
