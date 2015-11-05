function shear = computeMomentShear(endmoments)
	shear = [];
	for i = endmoments
		shearVal = (i(1) + i(2)) / 2;
		shear = [shear; shearVal];
	end
end
