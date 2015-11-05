
% Beregner fastinnspenningsmoment for jevnt fordelt last.
function [loadvec] = computeFixedEndMomentBeamLoad(qloads, vecsize, beamsize, nodes)
	%{
		The fomula for fixed end point loads:

		       q
		a -----|--------- b
		 VVVVVVVVVVVVVVV
		|---------------|

		a + b = L

		Gives -Pab^2/L^2 left, and Pa^2b/L^2 to the right
	%}
	loadvec = zeros(vecsize, 1, beamsize);
	for i = 1:size(qloads)
		beamid = qloads(i, 2);
		length = qloads(i, 10);
		qx = qloads(i, 3);  % Vindlast i x-retning

		qy = qloads(i, 4);  % Ingen last i y-retning.
		assert(qy == 0);

		qz = qloads(i, 5);
		node1 = qloads(i, 6);
		node2 = qloads(i, 7);

		% Vektorene er allerede normaliserte.
		dx = qloads(i, 8);
		dz = qloads(i, 9);

		% Vektorene kan projisere ned på elementet.
		% Dette blir ignorert.
		projection = [dx dz] * [qx; qz];
		q = [qx qz] - projection * [dx dz];

        % Vi ønsker å finne hvilken akse vektoren står normalt på.
        % Bruker kryssproduktet til å finne det ut:
		neg = cross([q(1) 0 q(2)], [dx 0 dz]);
		neg = -neg(2);
		% Hvis neg < 0, vil momentet (kalt P) gå med klokken rundt den
		% minste noden.

        % Gir Pab^2/L^2 til venstre, og -Pa^2b/L^2 til høyre.
		L = length;
		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			-neg * L ^ 2 / 12;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			neg * L ^ 2 / 12;
	end
end
