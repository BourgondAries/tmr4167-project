
% Beregner moment under punktlast p� element. 
function [moment] = computeMomentUnderPointLoad(ploads, endmoments, beamsize)
	%{
			 P
		a----|--------b
			 V
		|-------------|

		Momentet i endene m� v�re null:
		Sum(M_b) = M_b - P*b + M_a + V_a*L = 0
		V_a = (-M_b - M_a + P*b)/L
		Sum(x) = M_a + V_a*a + M = 0
		M = -M_a - V_a*a
		
		omorganiserer:
		a*(P*b - M_a - M_b)/L = M_p
		a*(P*b - M_a - M_b)/L + M_a = M_r
		M_a og M_b representerer endemomentene.
	%}

	moment = zeros(beamsize, 1);
	% kj�rer gjennom matrisen med informasjon om punktlastene.
	for i = 1:size(ploads)
		% Henter ut informasjon om hvilket element den virker p�, lengden
		% p� elmentet, avstand fra minste node og st�rrelse p� lasten. 
		beamid = ploads(i, 2);
		length = ploads(i, 11);
		distance = ploads(i, 6);
		% Definerer st�rrelse i x, y og z-retning. 
		px = ploads(i, 3);
		py = ploads(i, 4);  % Always zero
		assert(py == 0);
		pz = ploads(i, 5);
		
		% Identifiserer hvilken node som er minste node (node1) og st�rste
		% node(node2).
		node1 = ploads(i, 7);
		node2 = ploads(i, 8);

		% Vektorene er allerede normalisert.
		dx = ploads(i, 9);
		dz = ploads(i, 10);

		% Projiserer ned p� xz-planet for � kunne regne ut st�rrelsen p�
		% lasten i x,y og z-retning, dersom punktlasten har flere
		% komponenter. 
		projection = [dx dz] * [px; pz];
		p = [px pz] - projection * [dx dz];
		
		% Bruker igjen kryssproduktet for � finne retningen momentet virker.
		% Her benyttes h�yreh�ndsregelen. 
		neg = cross([p(1) 0 p(2)], [dx 0 dz]);
		neg = neg(2);
		
		L = length;
		a = distance;
		b = L - a;
		P = -neg;
		
		% Definerer endemomentene for elementet. 
		M_a = endmoments(1, i);
		M_b = endmoments(2, i);
		% Beregner momentet under lasten 
		V_a = (-M_b - M_a + P*b)/L;
		M = -M_a - V_a*a;
		moment(ploads(i, 2)) = M;
	end

end
