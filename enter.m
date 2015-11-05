function [ans] = enter()
	%leser inputfilen og strukturer informasjonen i matriser.
	file = 'structure1.ehs';
	[nodes, beams, mats, pipes, qloads, ploads, incload, moments] = readEhsFile(file);

	yieldStrength = mats(1, 4) * 0.7;
	ans = 0;

	pipeThickness = pipes(3);
	ibeamCounter = 1;
	%starter med første IPE-bjelke, definerer høyde og annet
	%arealmoment til senere bruk.

	for i = 1:100
		[nodes, beams, mats, pipes, qloads, ploads, incload, moments] = ...
			readEhsFile(file);
		[h i] = pickIbeam(ibeamCounter);
		if h == 0
			ans = 'NO SUITABLE SOLUTION!';
			return;
        end

        %Hvis spenningen er utenfor kravet, defineres en ny tykkelse for
        %rørtverrsnittet.
		pipes(3) = pipeThickness;

		% Legger til informasjon til matrisene.
         %setter opp konnektivitetsmatrisen.
		conn = constructConnectivityMatrix(beams);
        %Setter opp I-verdier for alle ulike geometrier i en matrise kalt geoms
		geoms = createGeometries(pipes, i);
        %Beregner lengde på hvert element.
		beams = assignBeamLength(beams, nodes);
        %Beregner bøyestivhet for elementene og lagrer informasjonen i
        %matrisen: beams.
		beams = assignBeamElasticity(beams, mats);
        %Legger til en kolonne med andre arealmoment til matrisen beam for
        %de ulike geometriene.
		beams = assignBeamSecondMomentArea(beams, geoms);
        %Definerer aksesystem og elementene som vektorer.
		beams = assignBeamVector(beams, nodes);
        %Legger til høyden på tverrsnittet for '
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
