
% Beregner fastinnspenningsmomenter for punktlaster.
function [loadvec] = computeFixedEndMomentPointLoad(ploads, vecsize, beamsize, nodes)
	%{
		Formelen for fastinnspenningsmomentene er:

			   P
		a -----|------- b
			   V
		|---------------|

		a + b = L

		Gir -Pab^2/L^2 til venstre, og Pa^2b/L^2 til høyre.
	%}
	% Definerer en tom lastvektor.
	loadvec = zeros(vecsize, 1, beamsize);
	for i = 1:size(ploads)
		beamid = ploads(i, 2);
		length = ploads(i, 11);
		distance = ploads(i, 6);
		px = ploads(i, 3);

		py = ploads(i, 4);  % Ingen last i y-retning
		assert(py == 0);

		pz = ploads(i, 5);
		node1 = ploads(i, 7);
		node2 = ploads(i, 8);

		% Vektorene er allerede normaliserte.
		dx = ploads(i, 9);
		dz = ploads(i, 10);

		% Vektoren kan bli projisert, dette ser vi bort fra.
		projection = [dx dz] * [px; pz];
		p = [px pz] - projection * [dx dz];

		% Vi ønsker å finne hvilken akse vektoren står normalt på.
		% Bruker kryssproduktet til å finne det ut:
		neg = cross([p(1) 0 p(2)], [dx 0 dz]);
		neg = neg(2);

		% Hvis neg < 0, vil momentet (kalt P) gå med klokken rundt den
		% minste noden.

		% Gir Pab^2/L^2 til venstre, og -Pa^2b/L^2 til høyre.
		L = length;
		a = distance;
		b = L - a;


		% Setter opp lastvektor og regner ut momentene.
		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			neg * a * b ^ 2 / L ^ 2;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			-neg * a ^ 2 * b / L ^ 2;
	end
end
