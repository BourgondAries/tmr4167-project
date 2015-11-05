
% Definerer høyden på tverrsnittet til hvert element og lagrer
% informasjonen sm en ny kolonne i matrisen beams. 
function beams = assignBeamHeight(beams, pipes, iheight)
	to_add = [];
	for i = 1:size(beams, 1)
		if any(beams(i, 5) == pipes(:, 1))
			mat = beams(i, 5);
			to_add = [to_add; pipes(mat, 2)];
		else
			to_add = [to_add; iheight];
		end
	end
	beams = [beams to_add];
end
