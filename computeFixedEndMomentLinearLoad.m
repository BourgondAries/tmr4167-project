function [loadvec] = computeFixedEndMomentLinearLoad(incloads, vecsize)
	%{
		The fomula for fixed end point loads:

		 q1              q2
		a --------------- b
		           VVVVV
		      VVVVVVVVVV
		 VVVVVVVVVVVVVVV
		|---------------|

		Gives -qL^2/30 to the left, and qL^2/20 to the right. In our case, we're given
		a non-triangular distribution. This means that we need to segment the distribution.
		To accomplish this, we can use a BeamLoad plus another triangular load. Or we create
		two triangular loads. Then we have no dual dependency.
	%}
	loadvec = zeros(vecsize, 1);
	for i = 1:size(incloads)
		length = incloads(i, 9);
		node1 = incloads(i, 5);
		node2 = incloads(i, 6);
		% Assume the load is perpendicular.
		q1 = incloads(i, 3);
		q2 = incloads(i, 4);

		% Ensure the vector exists
		if numel(loadvec) < node1
			loadvec(node1) = 0;
		end
		if numel(loadvec) < node2
			loadvec(node2) = 0;
		end
		L = length;
		% Segment the first load
		loadvec(node1) = loadvec(node1) + ...
			-q1*L^2/20;
		loadvec(node2) = loadvec(node2) + ...
			q1*L^2/30;
		loadvec(node1) = loadvec(node1) + ...
			-q2*L^2/30;
		loadvec(node2) = loadvec(node2) + ...
			q2*L^2/20;
	end
end
