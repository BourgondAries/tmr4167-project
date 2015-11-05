function [where] = isYielding(tension, beams, yieldStrength)
	% If the yield is at position 0, then nothing is yielding.
	where = 0;
	for i = 1:size(tension, 2)
		stress = tension(:, i);
		if any(abs(stress) > yieldStrength)
			% fprintf('%i %d\n', i, max(stress));
			where = i;
			return;
		end
	end
end
