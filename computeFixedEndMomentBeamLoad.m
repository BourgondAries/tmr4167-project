
% Beregner fastinnspenningsmoment for jevnt fordelt last.
function [loadvec] = computeFixedEndMomentBeamLoad(qloads, vecsize, beamsize, nodes)
	%{
		Formelen for fastinnspenningsmomenter for jevnt fordelt last:

		       q
		a -----|--------- b
		 VVVVVVVVVVVVVVV
		|---------------|

		Gir -qL^/12 til venstre, og qL^/12 to til høyre.
	%}
	% Definerer en tom lastvektor
    loadvec = zeros(vecsize, 1, beamsize);
	for i = 1:size(qloads)
		beamid = qloads(i, 2);
		length = qloads(i, 10);

		qx = qloads(i, 3);  % Vindlast i x-retning
		qy = qloads(i, 4);  % Ingen last i y-retning.
		assert(qy == 0);

		qz = qloads(i, 5);  % Fordelte laster i z-retning.
		node1 = qloads(i, 6);
		node2 = qloads(i, 7);

		% Vektorene er allerede normaliserte.
		dx = qloads(i, 8);
		dz = qloads(i, 9);

		% Vektorene kan projisere ned på elementet.

		% Dette ser vi bort fra.
		projection = [dx dz] * [qx; qz];
		q = [qx qz] - projection * [dx dz];

        % Vi ønsker å finne hvilken akse vektoren står normalt på.
        % Bruker kryssproduktet til å finne det ut:
		neg = cross([q(1) 0 q(2)], [dx 0 dz]);
		neg = neg(2);
		% Hvis neg < 0, vil momentet (kalt P) gå med klokken rundt den
		% minste noden.

        % Gir -qL^/12 til venstre, og qL^/12 to til høyre.
		L = length;
		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			neg * L ^ 2 / 12;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			-neg * L ^ 2 / 12;
	end
end
