function cells = kiloify(matrix)
	cells = {};
	for i = 1:size(matrix, 2)
		mat = matrix(:, i);
		for j = 1:size(mat, 1)
			if abs(mat(j)) > 1000
				cells{j, i} = [num2str(mat(j)/1000) ' kNm'];
			else
				cells{j, i} = [num2str(mat(j)) ' Nm'];
			end
		end
	end
end
