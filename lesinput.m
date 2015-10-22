function [nodes beams materials geometries beamloads nodeloads incloads] = lesinput()
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
	%  | ('PIPE'|'BOX') geometry_id do thickness
	%  | 'BEAMLOAD' case elem qx qy qz
	%  | 'NODELOAD' case elem px py pz distance
	%  | 'INCLOAD' case elem begin end

	% Initialize the return parameters
	nodes = [];
	beams = [];
	materials = [];
	geometries = [];
	beamloads = [];
	nodeloads = [];
	incloads = [];

	% Ew! Impure IO! Needs to be removed, input ought to be a string.
	fid = fopen('stru.fem','r');

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
			elseif strcmp(ll, 'MISOIEP')
				materials = [materials; quantify];
			elseif strcmp(ll, 'PIPE') || strcmp(ll, 'BOX')
				geometries = [geometries; quantify];
			elseif strcmp(ll, 'BEAMLOAD')
				beamloads = [beamloads; quantify];
			elseif strcmp(ll, 'NODELOAD')
				nodeloads = [nodeloads; quantify];
			elseif strcmp(ll, 'INCLOAD')
				incloads = [incloads; quantify];
			end
		end
		line = fgets(fid);
	end
	fclose(fid);
end
