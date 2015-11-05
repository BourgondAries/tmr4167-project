function [nodes beams materials pipes beamloads nodeloads incloads moments] = readEhsFile(filename)
	% The grammar is LL(1), implemented by a simple hand-written parser.
	% The comment preprocessor is embedded due to its simplicity.
	% Comments are lines starting with a '#' character.
	% Other lines start with a lexeme that determines the productions for that line.
	% Here is the grammar:
	% START ::= { ENTITY }
	% ENTITY ::=
	%  | 'NODE' node_id x y z { boundary_code }
	%  | 'BEAM' elem_id node1 node2 material geometry
	%  | 'MISOIEP material_id e_modulus poisson_modulus yield_strength density
	%  | 'PIPE' geometry_id do thickness
	%  | 'BEAMLOAD' case elem qx qy qz
	%  | 'NODELOAD' case elem px py pz distance
	%  | 'INCLOAD' case elem begin end
	%  | 'MOMENT' case elem moment distance

	% Setter opp hvilke parametre vi ønsker å returnere.
	nodes = [];
	beams = [];
	materials = [];
	pipes = [];
	beamloads = [];
	nodeloads = [];
	incloads = [];
	moments = [];

	% Åpner inputfil
	fid = fopen(filename,'r');

	% Sorterer input etter hvilken matrise informasjonen skal inn i.
	line = fgets(fid);
	while line ~= -1
		if line(1) == '#'
			% Hopper over linjer med #
        else % Deler opp stringer, lagrer informasjonen i celler.
			elements = strsplit(line);
			ll = elements{1};  % ll = lookahead
            % Ønsker input som tall data, koverterer fra tekst til tall.
			quantify = cellfun(@str2num, elements(2:end - 1), 'un', 0);
			if strcmp(ll, 'NODE')
				nodes = [nodes; quantify];
			elseif strcmp(ll, 'BEAM')
				beams = [beams; quantify];
			elseif strcmp(ll, 'MATERIAL')
				materials = [materials; quantify];
			elseif strcmp(ll, 'PIPE')
				pipes = [pipes; quantify];
			elseif strcmp(ll, 'BEAMLOAD')
				beamloads = [beamloads; quantify];
			elseif strcmp(ll, 'NODELOAD')
				nodeloads = [nodeloads; quantify];
			elseif strcmp(ll, 'INCLOAD')
				incloads = [incloads; quantify];
			elseif strcmp(ll, 'MOMENT')
				moments = [moments; quantify];
			else
				% Dersom funksjonen åpner feil fil, avsluttes funksjonen.
				assert(false);
			end
		end
		line = fgets(fid);
    end
    %Lukker inputfilen.
	fclose(fid);

	% Konverterer alle cellestrukturer til matriser.
	nodes = cell2mat(nodes);
	beams = cell2mat(beams);
	materials = cell2mat(materials);
	pipes = cell2mat(pipes);
	beamloads = cell2mat(beamloads);
	nodeloads = cell2mat(nodeloads);
	incloads = cell2mat(incloads);
	moments = cell2mat(moments);
end
