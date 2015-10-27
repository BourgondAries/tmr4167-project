function [matrix] = constructStiffnessMatrix(connectivity, locals)
	% Need to find the global matrix size by looking at the largest node.
	n1 = max(connectivity(2, :));
	n2 = max(connectivity(3, :));
	largest = max(n1, n2);

	matrix = zeros(largest);
	for i = 1:size(connectivity, 2)
		start = connectivity(2, i);
		stop = connectivity(3, i);
		matrix(start, start) = matrix(start, start) + locals(1, 1, 1);
		matrix(start, stop) = matrix(start, stop) + locals(1, 1, 2);
		matrix(stop, start) = matrix(stop, start) + locals(1, 2, 1);
		matrix(stop, stop) = matrix(stop, stop) + locals(1, 2, 2);
	end
end
