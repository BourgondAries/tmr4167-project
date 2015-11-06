
% Beregner midt-moment ved jevnt fordelt last. 
function [moment] = computeMomentUnderBeamLoad(qloads, endmoments, beamsize)
	%{
		Formelen for fastinnpenningsmoment er:
			   q
		a -----|--------- b
		 VVVVVVVVVVVVVVV
		|---------------|

		a + b = L
	
	%}
	moment = zeros(beamsize, 1);
	% Søker gjennom matrisen qloads for å hente informasjon om de jevnt
	% fordelte lastene. 
	for i = 1:size(qloads)
		% Henter informasjon om hvilket element lasten virker på og lengden
		% på elementet. 
		beamid = qloads(i, 2);
		length = qloads(i, 10);
		
		% Definerer last i x, y og z-retning. 
		qx = qloads(i, 3);	
		qy = qloads(i, 4);  
			assert(qy == 0); % Last i y-retning er alltid 0 (2D modell).
		qz = qloads(i, 5);
		
		% Definerer minste og største node for elementet. 
		node1 = qloads(i, 6);
		node2 = qloads(i, 7);

		% Vektorene er allerede normalisert.
		% Regner lengden av lasten. 
		dx = qloads(i, 8);
		dz = qloads(i, 9);

		% Projiserer på xz planet for å finne størrelsen på lasten dersom
		% den har flere komponenter. 
		projection = [dx dz] * [qx; qz];
		q = [qx qz] - projection * [dx dz];
		
		% For å finne retningen til momentet tar vi kryssproduktet og finner hvilken
		% akse lastvektoren står normalt på (høyrehåndsregelen gjelder). 
		neg = cross([q(1) 0 q(2)], [dx 0 dz]);
		neg = -neg(2);
		
	   % Definerer endemomenter for elementet. 
		L = length; 
		M_a = endmoments(1, i);
		M_b = endmoments(2, i);
		
		% Beregner moment under jevnt fordelt last med formelen vist over. 
		middle = (-M_a + M_b) / 2;
		moment(qloads(i, 2)) = neg*L^2/8 + middle;
	end
end
