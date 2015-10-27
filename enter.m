function [] = enter()
	[nodes, beams, mats, pipes, boxes, qloads, ploads, incload] = lesinput();
	constructConnectivityMatrix(beams);

	geoms = createGeometries(pipes, boxes);
	beams = assignBeamLength(beams, nodes);
	beams = assignBeamElasticity(beams, mats);
	beams = assignBeamSecondMomentArea(beams, geoms)



	%{
	constructStiffnessMatrix(...
		[1 2 3 4 5 6 7;...
		 1 1 1 2 4 3 5;...
		 4 3 2 3 3 5 4],...
		[4 2;...
		 2 4])
	%}
end
