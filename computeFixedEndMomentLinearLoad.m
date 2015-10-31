function [loadvec] = computeFixedEndMomentLinearLoad(incloads, vecsize, beamsize, nodes)
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
	loadvec = zeros(vecsize, 1, beamsize);
	for i = 1:size(incloads)
		beamid = incloads(i, 2);
		length = incloads(i, 9);
		node1 = incloads(i, 5);
		node2 = incloads(i, 6);
		% Assume the load is perpendicular.
		q1 = incloads(i, 3);
		q2 = incloads(i, 4);

		L = length;
		% Segment the first load
		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			-q1*L^2/20;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			q1*L^2/30;
		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			-q2*L^2/30;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			q2*L^2/20;
	end
end
