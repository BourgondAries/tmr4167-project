function [loadvec] = computeFixedEndMomentPointLoad(ploads)
	%{
		The fomula for fixed end point loads:

		       P
		a -----|--------- b
		       V
		|---------------|

		a + b = L

		Gives -Pab^2/L^2 left, and Pa^2b/L^2 to the right
	%}
	loadvec = [];
	for i = 1:size(ploads)
		length = ploads(i, 10);
		qx = ploads(i, 3);

		qy = ploads(i, 4);  % Always zero
		assert(qy == 0);

		qz = ploads(i, 5);
		node1 = ploads(i, 6);
		node2 = ploads(i, 7);

		% The vectors are already normalized.
		dx = ploads(i, 8);
		dz = ploads(i, 9);

		% Our vector may project onto a beam.
		% That projection is ignored.
		projection = [dx dz] * [qx; qz];
		q = [qx qz] - projection * [dx dz];
		% Now to find out what direction the vector is perpendicular to. Is it positive to the left node? Or is it negative? How do we know this mathematically? Ah! We can use vector maths. Cross product! Let's try it out!
		neg = cross([q(1) 0 q(2)], [dx 0 dz]);
		neg = neg(2);
		% If neg < 0, then we have that P is a clockwise moment around the least node.
		% Gives Pab^2/L^2 left, and -Pa^2b/L^2 to the right
		% Ensure the vector exists
		if numel(loadvec) < node1
			loadvec(node1) = 0;
		end
		if numel(loadvec) < node2
			loadvec(node2) = 0;
		end
		L = length;
		loadvec(node1) = loadvec(node1) + ...
			neg * L ^ 2 / 12;
		loadvec(node2) = loadvec(node2) + ...
			-neg * L ^ 2 / 12;
	end
end
