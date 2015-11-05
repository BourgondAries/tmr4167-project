% Beregner fastinnspenningsmomenter ved jevnt fordelt last.
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
	for i = 1:size(qloads)
		beamid = qloads(i, 2);
		length = qloads(i, 10);
		qx = qloads(i, 3);

		qy = qloads(i, 4);  % Always zero
		assert(qy == 0);

		qz = qloads(i, 5);
		node1 = qloads(i, 6);
		node2 = qloads(i, 7);

		% The vectors are already normalized.
		dx = qloads(i, 8);
		dz = qloads(i, 9);

		% Our vector may project onto a beam.
		% That projection is ignored.
		projection = [dx dz] * [qx; qz];
		q = [qx qz] - projection * [dx dz];
		% Now to find out what direction the vector is perpendicular to. Is it positive to the left node? Or is it negative? How do we know this mathematically? Ah! We can use vector maths. Cross product! Let's try it out!
		neg = cross([q(1) 0 q(2)], [dx 0 dz]);
		neg = neg(2);
		L = length;
		P = neg;
		M_a = endmoments(1, i);
		M_b = endmoments(2, i);
		middle = (-M_a + M_b) / 2;
		moment(qloads(i, 2)) = P*L^2/8 + middle;
	end
end
