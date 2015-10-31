function [matrix, newmoment] = pruneFixedEnds(nodes, momentvec, stiffness)
	% All we really care about is the boundary code for moment around the y axis (depth).
	% We just remove the columns of the stiffness matrix, and remove any rows from the
	% moment vector where it is zero.
	remove = [];
	for i = 1:size(nodes, 1)
		cons = nodes(i, 9);
		if cons == 1
			remove = [remove i];
		end
	end
	stiffness(:, remove) = [];
	stiffness(remove, :) = [];
	matrix = stiffness;
	momentvec(remove, :) = [];
	newmoment = momentvec;
end
