function [loadvec] = computeFixedEndMomentPointLoad(ploads, vecsize, beamsize, nodes)
	%{
		The fomula for fixed end point loads:

		       P
		a -----|------- b
		       V
		|---------------|

		a + b = L

		Gives -Pab^2/L^2 left, and Pa^2b/L^2 to the right
	%}
	loadvec = zeros(vecsize, 1, beamsize);
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
		% If neg < 0, then we have that P is a clockwise moment around the least node.
		% Gives Pab^2/L^2 left, and -Pa^2b/L^2 to the right
		L = length;
		a = distance;
		b = L - a;

		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			-neg * a * b ^ 2 / L ^ 2;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			neg .* a .^ 2 .* b ./ L .^ 2;
	end
end
