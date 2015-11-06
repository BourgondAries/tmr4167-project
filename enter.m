% Sletter alle variabler
clc;
clear all;

for filenumber = 3:3

	% Åpne en fil som tilsvarer konstruksjonen.
	file = strcat('structure', num2str(filenumber), '.ehs');
	% -------leser inputfilen og strukturer informasjonen i matriser-------
	[nodes beams mats pipes qloads ploads incload moments] = readEhsFile(file);

	% Henter ut flytespenning.
	yieldStrength = mats(1, 4) * 0.7;
	% Definerer startverdi for dimensjoner: rørtykkelse gitt i inputfil,
	% samt startverdi for IPE-profil gitt i egen tabell (pickIBeam.m).
	pipeThickness = pipes(1, 3);
	ibeamCounter = 1;


	for i = 1:100
		[nodes beams mats pipes qloads ploads incload moments] = readEhsFile(file);
		% starter med første IPE-bjelke, definerer høyde og annet
		% arealmoment til senere bruk.
		[h i] = pickIbeam(ibeamCounter);
		if h == 0
			proper = 'NO SUITABLE SOLUTION!';
			return;
		end

		% Hvis spenningen er utenfor kravet, defineres en ny tykkelse for
		% rørtverrsnittet. Denne linjen brukes under iterering.
		pipes(3) = pipeThickness;

		 % ---------- Linjene under brukes til å lagre data i matrisene
		 % definert over til senere bruk ----------------------------
		 % Setter opp konnektivitetsmatrisen.
		conn = constructConnectivityMatrix(beams);

		% Setter opp I-verdier for alle ulike geometrier i en matrise kalt geoms
		geoms = createGeometries(pipes, i);

		% Beregner lengde på hvert element.
		beams = assignBeamLength(beams, nodes);

		% Beregner bøyestivhet for elementene og lagrer informasjonen i
		% matrisen: beams.
		beams = assignBeamElasticity(beams, mats);

		% Legger til en kolonne med andre arealmoment til matrisen beam for
		% de ulike geometriene.
		beams = assignBeamSecondMomentArea(beams, geoms);

		% Definerer aksesystem og elementene som vektorer.
		beams = assignBeamVector(beams, nodes);

		% Legger til høyden på tverrsnittet for rør og IPE-bjelkene.
		beams = assignBeamHeight(beams, pipes, h);

		% Beregner lokale stivhetsmatriser for hvert element.
		locals = computeAllElementStiffnesses(beams);

		% Bruker lokale stivhetsmatriser for å beregne
		% systemstivhetsmatrisen.
		stiffness = constructStiffnessMatrix(conn, locals);

		% Definerer fire forskjellige typer last: punktlast, jevnt fordelt
		% last, linært fordelt last og påsatt moment.
		% Definerer hvilken bjelke lasten virker på.
		ploads = assignNodesToLoads(ploads, beams);
		qloads = assignNodesToLoads(qloads, beams);
		incloads = assignNodesToLoads(incload, beams);
		moments = assignNodesToLoads(moments, beams);

		% ---- Beregner fastinnspenningsmomenter for hver type last----
		vecsize = max(nodes(:, 1));
		beamsize = max(beams(:, 1));
		fem1 = computeFixedEndMomentPointLoad(ploads, vecsize, beamsize, nodes);
		fem2 = computeFixedEndMomentMomentLoad(moments, vecsize, beamsize, nodes);
		fem3 = computeFixedEndMomentBeamLoad(qloads, vecsize, beamsize, nodes);
		fem4 = computeFixedEndMomentLinearLoad(incloads, vecsize, beamsize, nodes);
		fem = fem1 + fem2 + fem3 + fem4;
		momentvector = -sumNodeMoments(fem);

		% -------- Løser likningssettet --------------------------
		% Kr = R => r = K^-1R
		% Setter inn randbetingelser for fast innspent slik at rotasjonene
		% her blir null.
		[stiffness momentvector] = pruneFixedEnds(nodes, momentvector, stiffness);
        % Løser likningssettet.
		rotations = inv(stiffness) * momentvector;

		% Vi har nå rotasjonen for hvert punkt i vektoren rotations, utenom
		% fast innspente opplager.
		% Nullrotasjonene er lagt tilbake i vektoren slik at vi kan beregne
		% endemoment for hvert knutepunkt.
		% Momentene er beregnet ved bruk av de lokale stivhetsmatrisene.
		endmoments = computeMomentsPerBeam(locals, fem, rotations, beams);

		moments = computeMomentUnderPointLoad(ploads, endmoments, beamsize);
		momentsBeam = computeMomentUnderBeamLoad(qloads, endmoments, beamsize);
		momentsBeam = momentsBeam + ...
			computeMomentUnderLinearLoad(incloads, endmoments, beamsize);

		% ---------------- Beregning av skjærkrefter -------------------%
        % Beregner skjærbidrag fra endemomenter.
        momentShear = computeMomentShear(endmoments, beams);
        % Beregner skjærbidrag fra punktlast.
		pointShear = computePointShear(ploads, beamsize);
        % Beregner skjærbidrag fra jevnt fordelt last.
		beamShear = computeBeamShear(qloads, beamsize);
        % Beregner skjærbidrag fra linært fordelt last.
		linearShear = computeLinearShear(incloads, beamsize);
        % Summerer opp totalt bidrat for hvertelement.
		totalShear = momentShear + pointShear + beamShear + linearShear;

		% allMoments gir endemoment for alle elementene.
		allMoments = [endmoments; transpose(moments); transpose(momentsBeam)];

		tension = computeBendingTension(allMoments, beams);

		% ---------------- Dimensjonering ---------------------------
		% Sjekker om konstruksjonen flyter, og i så fall hvor.
		yieldingBeam = isYielding(tension, beams, yieldStrength);
		if yieldingBeam ~= 0
			if beams(yieldingBeam, 5) == 1
				% Øker tykkelse på rørprofilet.
				pipeThickness = pipeThickness * 1.1;
			else
				% Øker IPE-profil.
				ibeamCounter = ibeamCounter + 1;
				if ibeamCounter == 27
					% Vi har kun definert 26 IPE-profiler fra tabell,
					% dersom spenninger fortsatt er for stor på IPE1000
					% ønsker vi istedet å øke tykkelsen på røret.
					ibeamCounter = 1;
					pipeThickness = pipeThickness * 1.1;
				end
			end
		else
        % Hvis spenningen er innenfor området ønsker vi å optimalisere
             % ved å redusere tykkelsen på rørprofilen så mye som mulig.

             %fprintf('% d % i\n', ...
				%pipeThickness, ibeamCounter);
			proper = {ibeamCounter pipeThickness allMoments};
			pipeThickness = pipeThickness * 0.9;
		end
	end

	allMoments

	text = createResultText(allMoments ./ 1000, totalShear ./ 1000, tension ./ 1000);

    % Lagrer resultatene i en tekstfil.
    fid = fopen(strcat('results', num2str(filenumber), '.txt'), 'w');
	fwrite(fid, text);
	fwrite(fid, sprintf('\nPipe thickness: % d\nIPE: % d\n', pipeThickness, h*2));
	fclose(fid);

	% Skriver ut rotasjonsvektor og stivhetsmatrise til bruk i rapporten.
    dlmwrite(strcat('rotations', num2str(filenumber), '.txt'), rotations);
	dlmwrite(strcat('stiffness', num2str(filenumber), '.txt'), stiffness);
end
