function beams = assignBeamHeight(beams, pipes, iheight)
	to_add = [];
	for i = 1:size(beams, 1)
		if beams(i, 5) == 1
			to_add = [to_add; pipes(2)];
		else
			to_add = [to_add; iheight];
		end
	end
	beams = [beams to_add];
end
