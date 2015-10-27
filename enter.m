function [] = enter()
	[nodes, beams, mats, pipes, boxes, qloads, ploads, incload] = lesinput();

	conn = constructConnectivityMatrix(beams);
	geoms = createGeometries(pipes, boxes);
	beams = assignBeamLength(beams, nodes);
	beams = assignBeamElasticity(beams, mats);
	beams = assignBeamSecondMomentArea(beams, geoms);
	beams = assignBeamVector(beams, nodes)

	locals = computeAllElementStiffnesses(beams);
	stiffness = constructStiffnessMatrix(conn, locals);

	% Assign the two nodes associated with the loads on the specific beam.
	% Also add the vector of the beam. This is used so that point loads are correctly applied.
	ploads = assignNodesToLoads(ploads, beams);
	qloads = assignNodesToLoads(qloads, beams);
	incloads = assignNodesToLoads(incload, beams);

	% Compute the fixed end moments of each type of load

	computeFixedEndMomentPointLoad(ploads)
end
