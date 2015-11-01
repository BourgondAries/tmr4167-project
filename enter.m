function [ans] = enter()
	[nodes, beams, mats, pipes, boxes, qloads, ploads, incload, moments] = readEhsFile('structure1.ehs');

	% Add information to the matrix.
	conn = constructConnectivityMatrix(beams);
	geoms = createGeometries(pipes, boxes);
	beams = assignBeamLength(beams, nodes);
	beams = assignBeamElasticity(beams, mats);
	beams = assignBeamSecondMomentArea(beams, geoms);
	beams = assignBeamVector(beams, nodes);

	% Calculate all local stiffness matrices
	locals = computeAllElementStiffnesses(beams);

	% Use the local stiffnesses and the connectivity matrix to construct
	% the system's stiffness matrix.
	stiffness = constructStiffnessMatrix(conn, locals);

	% Assign the two nodes associated with the loads on the specific beam.
	% Also add the vector of the beam.
	% This is used so that loads are correctly applied.
	ploads = assignNodesToLoads(ploads, beams);
	qloads = assignNodesToLoads(qloads, beams);
	incloads = assignNodesToLoads(incload, beams);
	moments = assignNodesToLoads(moments, beams);

	% Compute the fixed end moments of each type of load
	vecsize = max(nodes(:, 1));
	beamsize = max(beams(:, 1));
	fem1 = computeFixedEndMomentPointLoad(ploads, vecsize, beamsize, nodes);
	fem2 = computeFixedEndMomentMomentLoad(moments, vecsize, beamsize, nodes);
	fem3 = computeFixedEndMomentBeamLoad(qloads, vecsize, beamsize, nodes);
	fem4 = computeFixedEndMomentLinearLoad(incloads, vecsize, beamsize, nodes);
	fem = fem1 + fem2 + fem3 + fem4;
	momentvector = sumNodeMoments(fem);

	% Now we're almost done, we have
	% Kr = R => r = K^-1R
	% We need to kill the rows and columns that are constrained
	[stiffness momentvector] = pruneFixedEnds(nodes, momentvector, stiffness);
	rotations = inv(stiffness) * momentvector;

	% We now have the angles for each point, with the fixed ends skipped
	% Zero rotations are added back into the vector and the moments are
	% Computed using the local stiffness matrices.
	rotations = addZerosToRotations(rotations, nodes);
	endmoments = computeMomentsPerBeam(locals, fem, rotations, beams);
	moments = computeMomentUnderPointLoad(ploads, endmoments, beamsize);
	moments = moments + computeMomentUnderBeamLoad(qloads, endmoments, beamsize);
	ans = [endmoments; transpose(moments)];
end
