function [ans] = enter()
	file = 'structure2.ehs';
	[nodes, beams, mats, pipes, qloads, ploads, incload, moments] = readEhsFile(file);

	yieldStrength = mats(1, 4) * 0.7;
	ans = 0;

	pipeThickness = pipes(3);
	ibeamCounter = 1;

	for i = 1:100
		[nodes, beams, mats, pipes, qloads, ploads, incload, moments] = ...
			readEhsFile(file);
		[h i] = pickIbeam(ibeamCounter);
		if h == 0
			ans = 'NO SUITABLE SOLUTION!';
			return;
		end
		pipes(3) = pipeThickness;

		% Add information to the matrix.
		conn = constructConnectivityMatrix(beams);
		geoms = createGeometries(pipes, i);
		beams = assignBeamLength(beams, nodes);
		beams = assignBeamElasticity(beams, mats);
		beams = assignBeamSecondMomentArea(beams, geoms);
		beams = assignBeamVector(beams, nodes);
		beams = assignBeamHeight(beams, pipes, h);

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
		momentvector = -sumNodeMoments(fem);
		% momentvector is correct.

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
		momentsBeam = computeMomentUnderBeamLoad(qloads, endmoments, beamsize);
		momentsBeam = momentsBeam + ...
			computeMomentUnderLinearLoad(incloads, endmoments, beamsize);
		allMoments = [endmoments; transpose(moments); transpose(momentsBeam)];

		% Check if the structure is yielding. If so; where?
		yieldingBeam = isYielding(allMoments, beams, yieldStrength);
		if yieldingBeam ~= 0
			if beams(yieldingBeam, 5) == 1
				% Increase pipe thickness
				pipeThickness = pipeThickness * 1.1;
			else
				% Increase I profile
				ibeamCounter = ibeamCounter + 1;
				if ibeamCounter == 27
					ibeamCounter = 1;
					pipeThickness = pipeThickness * 1.1;
				end
			end
		else
			fprintf('%d %i\n', ...
				pipeThickness, ibeamCounter);
			pipeThickness = pipeThickness * 0.9;
			ans = {ibeamCounter pipeThickness allMoments};
		end
	end

	ans = createResultText(ans);
end
