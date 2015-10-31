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
		% If neg < 0, then we have that P is a clockwise moment around the least node.
		% Gives Pab^2/L^2 left, and -Pa^2b/L^2 to the right
		L = length;
		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			neg * L ^ 2 / 12;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			-neg * L ^ 2 / 12;
	end
end
