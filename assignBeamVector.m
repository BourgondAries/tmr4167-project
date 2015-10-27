function [beams] = assignBeamVector(beams, nodes)
	to_add = [];
	for i = 1:size(beams)
		dx = -1;
		dy = -1;
		for j = 1:size(nodes)
			if nodes(j, 1) == beams(i, 2) ||...
			   nodes(j, 1) == beams(i, 3)
				if dx == -1
					dx = nodes(j, 2);
				else
					dx = dx - nodes(j, 2);
				end
				if dy == -1
					dy = nodes(j, 4);
				else
					dy = dy - nodes(j, 4);
				end
			end
		end
		to_add = [to_add; -dx -dy];
	end
	beams = [beams to_add];
end
