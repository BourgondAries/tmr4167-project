% Sletter alle variabler
clc;
clear all;

for filenumber = 1:2

	% �pne en fil som tilsvarer konstruksjonen.
	file = strcat('structure', num2str(filenumber), '.ehs');
	% -------leser inputfilen og strukturer informasjonen i matriser-------
	[nodes beams mats pipes qloads ploads incload moments] = readEhsFile(file);

	% Henter ut flytespenning.
	yieldStrength = mats(1, 4) * 0.7;
	% Definerer startverdi for dimensjoner: r�rtykkelse gitt i inputfil,
	% samt startverdi for IPE-profil gitt i egen tabell (pickIBeam.m).
	pipeThickness = pipes(1, 3);
	ibeamCounter = 1;


	for i = 1:100
		[nodes beams mats pipes qloads ploads incload moments] = readEhsFile(file);
		% starter med f�rste IPE-bjelke, definerer h�yde og annet
		% arealmoment til senere bruk.
		[h i] = pickIbeam(ibeamCounter);
		if h == 0
			proper = 'NO SUITABLE SOLUTION!';
			return;
		end

		% Hvis spenningen er utenfor kravet, defineres en ny tykkelse for
		% r�rtverrsnittet. Denne linjen brukes under iterering.
		pipes(3) = pipeThickness;

		 % ---------- Linjene under brukes til � lagre data i matrisene
		 % definert over til senere bruk ----------------------------
		 % Setter opp konnektivitetsmatrisen.
		conn = constructConnectivityMatrix(beams);

		% Setter opp I-verdier for alle ulike geometrier i en matrise kalt geoms
		geoms = createGeometries(pipes, i);

		% Beregner lengde p� hvert element.
		beams = assignBeamLength(beams, nodes);

		% Beregner b�yestivhet for elementene og lagrer informasjonen i
		% matrisen: beams.
		beams = assignBeamElasticity(beams, mats);

		% Legger til en kolonne med andre arealmoment til matrisen beam for
		% de ulike geometriene.
		beams = assignBeamSecondMomentArea(beams, geoms);

		% Definerer aksesystem og elementene som vektorer.
		beams = assignBeamVector(beams, nodes);

		% Legger til h�yden p� tverrsnittet for r�r og IPE-bjelkene.
		beams = assignBeamHeight(beams, pipes, h);

		% Beregner lokale stivhetsmatriser for hvert element.
		locals = computeAllElementStiffnesses(beams);

		% Bruker lokale stivhetsmatriser for � beregne
		% systemstivhetsmatrisen.
		stiffness = constructStiffnessMatrix(conn, locals);

		% Definerer fire forskjellige typer last: punktlast, jevnt fordelt
		% last, lin�rt fordelt last og p�satt moment.
		% Definerer hvilken bjelke lasten virker p�.
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

		% -------- L�ser likningssettet --------------------------
		% Kr = R => r = K^-1R
		% Setter inn randbetingelser for fast innspent slik at rotasjonene
		% her blir null.
		[stiffness momentvector] = pruneFixedEnds(nodes, momentvector, stiffness);
		% L�ser likningssettet.
		rotations = inv(stiffness) * momentvector;

		% Vi har n� rotasjonen for hvert punkt i vektoren rotations, utenom
		% fast innspente opplager.
		% Nullrotasjonene er lagt tilbake i vektoren slik at vi kan beregne
		% endemoment for hvert knutepunkt.
		% Momentene er beregnet ved bruk av de lokale stivhetsmatrisene.
		endmoments = computeMomentsPerBeam(locals, fem, rotations, beams);

		pointmoments = computeMomentUnderPointLoad(ploads, endmoments, beamsize);
		momentsBeam = computeMomentUnderBeamLoad(qloads, endmoments, beamsize);
		momentsBeam = momentsBeam + ...
			computeMomentUnderLinearLoad(incloads, endmoments, beamsize);

		% ---------------- Beregning av skj�rkrefter -------------------%
		% Beregner skj�rbidrag fra endemomenter.
		momentShear = computeMomentShear(endmoments, beams);
		% Beregner skj�rbidrag fra punktlast.
		pointShear = computePointShear(ploads, beamsize);
		% Beregner skj�rbidrag fra jevnt fordelt last.
		beamShear = computeBeamShear(qloads, beamsize);
		% Beregner skj�rbidrag fra lin�rt fordelt last.
		linearShear = computeLinearShear(incloads, beamsize);
		% Summerer opp totalt bidrat for hvertelement.
		totalShear = momentShear + pointShear + beamShear + linearShear;

		% allMoments gir endemoment for alle elementene.
		allMoments = [endmoments; transpose(pointmoments); transpose(momentsBeam)];

		tension = computeBendingTension(allMoments, beams);

		% ---------------- Dimensjonering ---------------------------
		% Sjekker om konstruksjonen flyter, og i s� fall hvor.
		yieldingBeam = isYielding(tension, beams, yieldStrength);
		if yieldingBeam ~= 0
			if beams(yieldingBeam, 5) == 1
				% �ker tykkelse p� r�rprofilet.
				pipeThickness = pipeThickness * 1.1;
			else
				% �ker IPE-profil.
				ibeamCounter = ibeamCounter + 1;
				if ibeamCounter == 27
					% Vi har kun definert 26 IPE-profiler fra tabell,
					% dersom spenninger fortsatt er for stor p� IPE1000
					% �nsker vi istedet � �ke tykkelsen p� r�ret.
					ibeamCounter = 1;
					pipeThickness = pipeThickness * 1.1;
				end
			end
		else
		% Hvis spenningen er innenfor omr�det �nsker vi � optimalisere
			 % ved � redusere tykkelsen p� r�rprofilen s� mye som mulig.

			 %fprintf('% d % i\n', ...
				%pipeThickness, ibeamCounter);
			proper = {ibeamCounter pipeThickness allMoments};
			pipeThickness = pipeThickness * 0.9;
		end
	end


	dlmwrite(strcat('momentShear', num2str(filenumber), '.txt'), momentShear);
	dlmwrite(strcat('externalShear', num2str(filenumber), '.txt'), totalShear - momentShear);

	text = createResultText(allMoments ./ 1000, totalShear ./ 1000, tension ./ 1000);
	fid = fopen(strcat('text', num2str(filenumber), '.txt'), 'w');
	fwrite(fid, createLatexTable(allMoments));
	fclose(fid);

	% Lagrer resultatene i en tekstfil.
	fid = fopen(strcat('results', num2str(filenumber), '.txt'), 'w');
	fwrite(fid, text);
	fwrite(fid, sprintf('\nPipe thickness: % d\nIPE: % d\n', pipeThickness, h*2));
	fclose(fid);

	% Skriver ut rotasjonsvektor og stivhetsmatrise til bruk i rapporten.
	dlmwrite(strcat('rotations', num2str(filenumber), '.txt'), rotations);
	dlmwrite(strcat('stiffness', num2str(filenumber), '.txt'), stiffness);
end
