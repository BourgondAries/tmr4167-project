function [loadvec] = computeFixedEndMomentMomentLoad(mloads, vecsize, beamsize)
	%{
		The fomula for fixed end point loads:

		       M
		a -----|--------- b
		       V
		|---------------|

		a + b = L

		Gives Mb(2a-b)/L^2 to the left and Ma(2b-a)/L^2 to the right
	%}
	loadvec = zeros(vecsize, 1, beamsize);
	for i = 1:size(mloads)
		beamid = mloads(i, 2);
		length = mloads(i, 9);
		distance = mloads(i, 4);
		M = mloads(i, 3);

		node1 = mloads(i, 5);
		node2 = mloads(i, 6);

		% Assume positive moment is clockwise.

		L = length;
		a = distance;
		b = L - a;
		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			M * b * (2 * a - b) / L ^ 2;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			M * a * (2 * b - a) / L ^ 2;
	end
end
