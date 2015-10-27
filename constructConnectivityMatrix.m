function [matrix] = constructConnectivityMatrix(beams)
	matrix = [];
	for i=1:size(beams)
		elem = beams(i, 1);
		np1 = beams(i, 2);
		np2 = beams(i, 3);
		matrix = [matrix; elem np1 np2];
	end
	matrix = transpose(matrix);
end
