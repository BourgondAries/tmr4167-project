% Beregner bøyespenning.
function tension = computeBendingTension(moments, beams)
	% Setter opp en tom matrise.
    stress = zeros(size(moments, 1), size(moments, 2));
    
    % Bruker formelen Sigma = (M/I)*Z_max til å beregne bøyespenning.
	for i = 1:size(moments, 2)
		stress(:, i) = moments(:, i) ./ beams(i, 8) .* beams(i, 11);
	end
	tension = stress;
end
