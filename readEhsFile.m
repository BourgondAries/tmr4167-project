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

	% Initialize the return parameters
	nodes = [];
	beams = [];
	materials = [];
	pipes = [];
	beamloads = [];
	nodeloads = [];
	incloads = [];
	moments = [];

	% Ew! Impure IO! Needs to be removed, input ought to be a string.
	fid = fopen(filename,'r');

	% Sort the input according to its lookahead
	line = fgets(fid);
	while line ~= -1
		if line(1) == '#'
			% Skip this line, it is a comment
		else
			elements = strsplit(line);
			ll = elements{1};  % ll = lookahead
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
				% File contains a FIRST set element
				% that is unknown.
				assert(false);
			end
		end
		line = fgets(fid);
	end
	fclose(fid);

	% Convert all cell arrays to matrices.
	nodes = cell2mat(nodes);
	beams = cell2mat(beams);
	materials = cell2mat(materials);
	pipes = cell2mat(pipes);
	beamloads = cell2mat(beamloads);
	nodeloads = cell2mat(nodeloads);
	incloads = cell2mat(incloads);
	moments = cell2mat(moments);
end
