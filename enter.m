%sletter alle variabler før start
clear all
clc
function [ans] = enter()
    %----leser inputfilen og strukturer informasjonen i matriser----
	[nodes, beams, mats, pipes, qloads, ploads, incload, moments] = readEhsFile('structureEx.ehs');

	yieldStrength = mats(1, 4) * 0.7;
	ans = 0;
    pipeThickness = pipes(3);
	ibeamCounter = 1;

	
        %starter med første IPE-bjelke, definerer høyde og annet
        %arealmoment til senere bruk.

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
        % Setter opp I-verdier for alle ulike geometrier i en matrise kalt geoms
		geoms = createGeometries(pipes, i);  
        % Beregner lengde på hvert element.
		conn = constructConnectivityMatrix(beams);
        %Setter opp I-verdier for alle ulike geometrier i en matrise kalt geoms
		geoms = createGeometries(pipes, i);
        %Beregner lengde på hvert element.
		beams = assignBeamLength(beams, nodes);
        % Beregner bøyestivhet for elementene og lagrer informasjonen i
        %matrisen: beams.
		beams = assignBeamElasticity(beams, mats);
        % Legger til en kolonne med andre arealmoment til matrisen beam for
        %de ulike geometriene. 

        %Legger til en kolonne med andre arealmoment til matrisen beam for
        %de ulike geometriene.

		beams = assignBeamSecondMomentArea(beams, geoms);
        % Definerer aksesystem og elementene som vektorer.
		beams = assignBeamVector(beams, nodes);
        % Legger til høyden på tverrsnittet for '
		beams = assignBeamHeight(beams, pipes, h);

		% Beregner lokale stivhetsmatriser for hvert element. 
		locals = computeAllElementStiffnesses(beams);

		% Bruker lokale stivhetsmatriser for å beregne
		% systemstivhetsmatrisen.
		stiffness = constructStiffnessMatrix(conn, locals);

		% Definerer fire forskjellige typer last.
		% Definerer hvilken bjelke lasten virker på.
		% Defienrer bjelken som en vektor.
		ploads = assignNodesToLoads(ploads, beams);
		qloads = assignNodesToLoads(qloads, beams);
		incloads = assignNodesToLoads(incload, beams);
		moments = assignNodesToLoads(moments, beams);

		% Beregner fastinnspenningsmomenter for hver type last.
		vecsize = max(nodes(:, 1));
		beamsize = max(beams(:, 1));
		fem1 = computeFixedEndMomentPointLoad(ploads, vecsize, beamsize, nodes);
		fem2 = computeFixedEndMomentMomentLoad(moments, vecsize, beamsize, nodes);
		fem3 = computeFixedEndMomentBeamLoad(qloads, vecsize, beamsize, nodes);
		fem4 = computeFixedEndMomentLinearLoad(incloads, vecsize, beamsize, nodes);
		fem = fem1 + fem2 + fem3 + fem4;
		momentvector = -sumNodeMoments(fem);
		% momentvector is correct.

		% Deretter løse likningssettet:
		% Kr = R => r = K^-1R
		% Setter inn randbetingelser for fast innspent slik at rotasjonene
		% her blir null.
		[stiffness momentvector] = pruneFixedEnds(nodes, momentvector, stiffness);
		rotations = inv(stiffness) * momentvector;

		% Vi har nå rotasjonen for hvert punkt i vektoren rotations, utenom
		% fast innspente opplager.
		% Nullrotasjonene er lagt tilbake i vektoren slik at vi kan beregne
		% endemoment for hvert knutepunkt.
		% Momentene er beregnet ved bruk av de lokale stivhetsmatrisene. 
		rotations = addZerosToRotations(rotations, nodes);
		endmoments = computeMomentsPerBeam(locals, fem, rotations, beams);
		moments = computeMomentUnderPointLoad(ploads, endmoments, beamsize);
		momentsBeam = computeMomentUnderBeamLoad(qloads, endmoments, beamsize);
		momentsBeam = momentsBeam + ...
			computeMomentUnderLinearLoad(incloads, endmoments, beamsize);
		allMoments = [endmoments; transpose(moments); transpose(momentsBeam)];

		% Sjekker om konstruksjonen flyter, og i så fall hvor.
		yieldingBeam = isYielding(allMoments, beams, yieldStrength);
		if yieldingBeam ~= 0
			if beams(yieldingBeam, 5) == 1
				% Øker tykkelse på rørprofilet.
				pipeThickness = pipeThickness * 1.1;
			else
				% Øker IPE-profil.
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
