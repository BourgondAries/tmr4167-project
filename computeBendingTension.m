function tension = computeBendingTension(moments, beams)
	stress = zeros(size(moments, 1), size(moments, 2));
	for i = 1:size(moments, 2)
		stress(:, i) = moments(:, i) ./ beams(i, 8) .* beams(i, 11);
	end
	tension = stress;
end
