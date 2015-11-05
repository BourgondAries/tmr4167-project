function [moment] = computeMomentUnderPointLoad(ploads, endmoments, beamsize)
	% Afaik there is no problem in assuming pressure/tension affects the
	% moment distribution.

	%{
		     P
		a----|--------b
		     V
		|-------------|

		The moments at the edges need to be zero:
		Sum(M_b) = M_b - P*b + M_a + V_a*L = 0
		V_a = (-M_b - M_a + P*b)/L
		Sum(x) = M_a + V_a*a + M = 0
		M = -M_a - V_a*a
		rearranged:
		a*(P*b - M_a - M_b)/L = M_p
		a*(P*b - M_a - M_b)/L + M_a = M_r
		Observe how this implies that M_a and M_b will be the end moments.
	%}

	moment = zeros(beamsize, 1);
	for i = 1:size(ploads)
		beamid = ploads(i, 2);
		length = ploads(i, 11);
		distance = ploads(i, 6);
		px = ploads(i, 3);

		py = ploads(i, 4);  % Always zero
		assert(py == 0);

		pz = ploads(i, 5);
		node1 = ploads(i, 7);
		node2 = ploads(i, 8);

		% The vectors are already normalized.
		dx = ploads(i, 9);
		dz = ploads(i, 10);

		% Our vector may project onto a beam.
		% That projection is ignored.
		projection = [dx dz] * [px; pz];
		p = [px pz] - projection * [dx dz];
		% Now to find out what direction the vector is perpendicular to. Is it positive to the left node? Or is it negative? How do we know this mathematically? Ah! We can use vector maths. Cross product! Let's try it out!
		neg = cross([p(1) 0 p(2)], [dx 0 dz]);
		neg = neg(2);
		L = length;
		a = distance;
		b = L - a;
		P = -neg;
		M_a = endmoments(1, i);
		M_b = endmoments(2, i);
		V_a = (-M_b - M_a + P*b)/L;
		M = -M_a - V_a*a;
		moment(ploads(i, 2)) = M;
	end

end
