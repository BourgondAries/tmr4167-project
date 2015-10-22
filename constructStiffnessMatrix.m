function [matrix] = constructStiffnessMatrix(connectivity, locals)
	matrix = zeros(10, 10);
	for i = 1:size(connectivity, 2)
		start = connectivity(2, i);
		stop = connectivity(3, i);
		matrix(start, start) = matrix(start, start) + locals(1, 1);
		matrix(start, stop) = matrix(start, stop) + locals(1, 2);
		matrix(stop, start) = matrix(stop, start) + locals(2, 1);
		matrix(stop, stop) = matrix(stop, stop) + locals(2, 2);
	end
end
