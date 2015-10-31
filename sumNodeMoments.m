function [moments] = sumNodeMoments(matrix)
	moments = zeros(size(matrix, 1), 1);
	for i = 1:size(matrix, 3)
		moments = moments + matrix(:, :, i);
	end
end
