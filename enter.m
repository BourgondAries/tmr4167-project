function [] = enter()
	[nodes, beams, mats, geoms, qloads, ploads, incload] = lesinput();
	%  constructConnectivityMatrix(beams);

	constructStiffnessMatrix(...
		[1 2 3; 1 2 2; 2 3 3], [9 9; 8 8])
end
