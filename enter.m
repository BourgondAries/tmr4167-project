% Sletter alle variabler
clc;
clear all;

file = 'structure1.ehs';
%-------leser inputfilen og strukturer informasjonen i matriser-------
[nodes beams mats pipes qloads ploads incload moments] = readEhsFile(file);

% Henter ut flytespenning.
    yieldStrength = mats(1, 4) * 0.7;
    %starter med første IPE-bjelke, definerer høyde og annet
    pipeThickness = pipes(3);
    %arealmoment til senere bruk.
    ibeamCounter = 1;


for i = 1:100
    [nodes beams mats pipes qloads ploads incload moments] = readEhsFile(file);
	%starter med første IPE-bjelke, definerer høyde og annet
	%arealmoment til senere bruk.
    [h i] = pickIbeam(ibeamCounter);
    if h == 0
        proper = 'NO SUITABLE SOLUTION!';
        return;
    end

    %Hvis spenningen er utenfor kravet, defineres en ny tykkelse for
    %rørtverrsnittet. Denne linjen brukes under iterering.
    pipes(3) = pipeThickness;

   %---------- Linjene under brukes til å lagre data i matrisene
   %definert over til senere bruk ----------------------------
   % Setter opp konnektivitetsmatrisen.
    conn = constructConnectivityMatrix(beams);

    % Setter opp I-verdier for alle ulike geometrier i en matrise kalt geoms
    geoms = createGeometries(pipes, i);

    %Beregner lengde på hvert element.
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

    % Definerer fire forskjellige typer last.
    % Definerer hvilken bjelke lasten virker på.
    % Defienrer bjelken som en vektor.
    ploads = assignNodesToLoads(ploads, beams);
    qloads = assignNodesToLoads(qloads, beams);
    incloads = assignNodesToLoads(incload, beams);
    moments = assignNodesToLoads(moments, beams);


    %---- Beregner fastinnspenningsmomenter for hver type last----
    vecsize = max(nodes(:, 1));
    beamsize = max(beams(:, 1));
    fem1 = computeFixedEndMomentPointLoad(ploads, vecsize, beamsize, nodes);
    fem2 = computeFixedEndMomentMomentLoad(moments, vecsize, beamsize, nodes);
    fem3 = computeFixedEndMomentBeamLoad(qloads, vecsize, beamsize, nodes);
    fem4 = computeFixedEndMomentLinearLoad(incloads, vecsize, beamsize, nodes);
    fem = fem1 + fem2 + fem3 + fem4;
    momentvector = -sumNodeMoments(fem);

    %-------- Løser likningssettet --------------------------
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
    % allMoments gir endemoment for alle elementene.
    allMoments = [endmoments; transpose(moments); transpose(momentsBeam)];

	momentShear = computeMomentShear(endmoments);
	pointShear = computePointShear(ploads, beamsize);
	beamShear = computeBeamShear(qloads, beamsize);
	linearShear = computeLinearShear(incloads, beamsize);
	totalShear = momentShear + pointShear + beamShear + linearShear;

	tension = computeBendingTension(allMoments, beams);

    % ---------------- Dimensjonering ---------------------------
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
                % Vi har kun definert 26 IPE-profiler fra tabell,
                % dersom spenninger fortsatt er for stor på IPE1000
                % ønsker vi istedet å øke tykkelsen på røret.
                ibeamCounter = 1;
                pipeThickness = pipeThickness * 1.1;
            end
        end
    else
        fprintf('%d %i\n', ...
            pipeThickness, ibeamCounter);
        proper = {ibeamCounter pipeThickness allMoments};
        pipeThickness = pipeThickness * 0.9;
    end
end

text = createResultText(allMoments, totalShear, tension);
fid = fopen('results.txt', 'w');
fwrite(fid, text);
fclose(fid);

