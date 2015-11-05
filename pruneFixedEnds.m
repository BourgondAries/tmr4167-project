% Nuller kolonner og tilsvarende elementer der lastvektoren er 0.
function [matrix, newmoment] = pruneFixedEnds(nodes, momentvec, stiffness)
	% All we really care about is the boundary code for moment around the y axis (depth).
	% We just remove the columns of the stiffness matrix, and remove any rows from the
	% moment vector where it is zero.
	remove = [];
	zero = zeros(size(stiffness, 1), 1);
	for i = 1:size(nodes, 1)
		cons = nodes(i, 9);
		if cons == 1
			% remove = [remove i];
			stiffness(i, :) = zero;
			stiffness(:, i) = transpose(zero);
			stiffness(i, i) = 1;
			momentvec(i) = 0;
		end
	end
	newmoment = momentvec;
	matrix = stiffness;
end
