function [loadvec] = computeFixedEndMomentMomentLoad(mloads)
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
	for i = 1:size(mloads)
		length = mloads(i, 9);
		distance = mloads(i, 4);
		M = mloads(i, 3);

		node1 = mloads(i, 5);
		node2 = mloads(i, 6);

		% Assume positive moment is counter clockwise.

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
