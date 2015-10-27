function [] = enter()
	[nodes, beams, mats, pipes, boxes, qloads, ploads, incload] = lesinput();

	conn = constructConnectivityMatrix(beams);
	geoms = createGeometries(pipes, boxes);
	beams = assignBeamLength(beams, nodes);
	beams = assignBeamElasticity(beams, mats);
	beams = assignBeamSecondMomentArea(beams, geoms);

	locals = computeAllElementStiffnesses(beams);
	stiffness = constructStiffnessMatrix(conn, locals);

	assignNodesToLoads(ploads, beams)
	assignNodesToLoads(qloads, beams)
	assignNodesToLoads(incload, beams)
end
