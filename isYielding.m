function [where] = isYielding(moments, beams, yieldStrength)
	% If the yield is at position 0, then nothing is yielding.
	where = 0;
	for i = 1:size(moments, 2)
		stress = moments(:, i) ./ beams(i, 8) .* beams(i, 11);
		if any(stress > yieldStrength)
			fprintf('%i %d\n', i, max(stress));
			where = i;
			return;
		end
	end
end
