function [loadvec] = computeFixedEndMomentMomentLoad(mloads, vecsize)
	%{
		The fomula for fixed end point loads:

		       M
		a -----|--------- b
		       V
		|---------------|

		a + b = L

		Gives Mb(2a-b)/L^2 to the left and Ma(2b-a)/L^2 to the right
	%}
	loadvec = zeros(vecsize, 1);
	for i = 1:size(mloads)
		length = mloads(i, 9);
		distance = mloads(i, 4);
		M = mloads(i, 3);

		node1 = mloads(i, 5);
		node2 = mloads(i, 6);

		% Assume positive moment is clockwise.

		% Ensure the vector exists
		if numel(loadvec) < node1
			loadvec(node1) = 0;
		end
		if numel(loadvec) < node2
			loadvec(node2) = 0;
		end
		L = length;
		a = distance;
		b = L - a;
		loadvec(node1) = loadvec(node1) + ...
			M * b * (2 * a - b) / L ^ 2;
		loadvec(node2) = loadvec(node2) + ...
			M * a * (2 * b - a) / L ^ 2;
	end
end
