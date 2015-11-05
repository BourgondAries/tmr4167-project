% Beregner skjærkraft for påsatt moment. 
function shear = computeMomentShear(endmoments)
	% Setter opp en tom vektor.
    shear = [];
	for i = endmoments
		shearVal = (i(1) + i(2)) / 2;
		shear = [shear; shearVal -shearVal];
	end
end
