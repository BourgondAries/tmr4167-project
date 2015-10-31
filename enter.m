function [ans] = enter()
	[nodes, beams, mats, pipes, boxes, qloads, ploads, incload, moments] = readEhsFile('structure1.ehs');

	% Add information to the matrix.
	conn = constructConnectivityMatrix(beams);
	geoms = createGeometries(pipes, boxes);
	beams = assignBeamLength(beams, nodes);
	beams = assignBeamElasticity(beams, mats);
	beams = assignBeamSecondMomentArea(beams, geoms);
	beams = assignBeamVector(beams, nodes);

	locals = computeAllElementStiffnesses(beams);
	stiffness = constructStiffnessMatrix(conn, locals);

	% Assign the two nodes associated with the loads on the specific beam.
	% Also add the vector of the beam. This is used so that point loads are correctly applied.
	ploads = assignNodesToLoads(ploads, beams);
	qloads = assignNodesToLoads(qloads, beams);
	incloads = assignNodesToLoads(incload, beams);
	moments = assignNodesToLoads(moments, beams);


	% Compute the fixed end moments of each type of load
	vecsize = max(nodes(:, 1));
	beamsize = max(beams(:, 1));
	fem1 = computeFixedEndMomentPointLoad(ploads, vecsize, beamsize);
	fem2 = computeFixedEndMomentMomentLoad(moments, vecsize, beamsize);
	fem3 = computeFixedEndMomentBeamLoad(qloads, vecsize, beamsize);
	fem4 = computeFixedEndMomentLinearLoad(incloads, vecsize, beamsize);
	fem = fem1 + fem2 + fem3 + fem4;

	momentvector = sumNodeMoments(fem);

	% Now we're almost done, we have
	% Kr = M
	% We need to kill the columns that are constrained, so we need to build an identity matrix where some elements are 0.
	[stiffness momentvector] = pruneFixedEnds(nodes, momentvector, stiffness);
	rotations = inv(stiffness) * momentvector;

	% We now have the angles for each point, with the fixed ends skipped
	% Now we have S = Kr + M
	% K is the local matrix, r is the known rotation. M is the local moment caused by external forces.
	% We don't have a function yet that does this. For each beam, it must create a sum of moments in both ends.
	rotations = addZerosToRotations(rotations, nodes);
	ans = computeMomentsPerBeam(locals, fem, rotations);
	ans = rotations;
end
