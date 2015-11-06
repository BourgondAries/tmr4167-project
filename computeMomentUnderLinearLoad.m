% Beregner momentet midt på element med lineær fordelt last. 
function [moment] = computeMomentUnderLinearLoad(incloads, endmoments, beamsize)
	%{
		Formelen er:

		 q1			  q2
		a --------------- b
				   VVVVV
			  VVVVVVVVVV
		 VVVVVVVVVVVVVVV
		|---------------|

	%}
	moment = zeros(beamsize, 1);
	% Søker gjennom matrisen incloads med informasjon om de lineære
	% lastene.
	for i = 1:size(incloads)
		% Henter ut hvilket element det virker på, lengden til elementet.
		beamid = incloads(i, 2);
		length = incloads(i, 9);
		
		% Definerer hvilken node som er minste og største node for
		% elementet. 
		node1 = incloads(i, 5);
		node2 = incloads(i, 6);
		
		% Antar at lasten står normal på bjelken, henter ut
		% lastintensiteten for gjeldende bjelke. 
		q1 = incloads(i, 3);
		q2 = incloads(i, 4);

		% Henter ut lengde og endemomenter for elementet. 
		L = length;
		M_a = endmoments(1, i);
		M_b = endmoments(2, i);

		% Beregner momentet basert på formelen gitt over. 
		middle = (-M_a + M_b) / 2;
		moment(beamid) = -q1*L^2/8 - 1/24*(q2-q1)*L^2 + middle;
		%moment(beamid) = (q2-q1)*L/6/L*(2*L^2-3*L^2/2+L^2/4) + (q2-q1)*L^2/8 + middle;
		% moment(beamid) = -q2*L^2/8 + middle;


	end
end
