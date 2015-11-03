function [where] = isYielding(moments, beams, yieldStrength)
	% If the yield is at position 0, then nothing is yielding.
	where = 0;
	for i = 1:size(moments, 2)
		moments(:, i) ./ beams(i, 8) .*
	end
end
