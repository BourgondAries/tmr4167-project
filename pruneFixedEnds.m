% Randbetingelser: Nuller kolonner og tilsvarende elementer der 
% lastvektoren er 0 (i fast innspente opplager). 
function [matrix, newmoment] = pruneFixedEnds(nodes, momentvec, stiffness)
	
	% Kun interessert i boundarycode for rotasjon om y-akse.
	% Nuller ut alle kolonner og tilsvarende rader i stivhetsmatrisen
	% der lastvektoren er null slik at likningssettet kan løses. 
	remove = [];
	zero = zeros(size(stiffness, 1), 1);
	for i = 1:size(nodes, 1)
		cons = nodes(i, 9);
		if cons == 1
			% remove = [remove i];
			stiffness(i, :) = zero;
			stiffness(:, i) = transpose(zero);
			
			% Setter diagonalelementene lik 1. 
			stiffness(i, i) = 1;
			momentvec(i) = 0;
		end
	end
	% Definerer momentvektor og stivhetsmatrise for elementene, brukes til
	% å løse likningssettet. 
	newmoment = momentvec;
	matrix = stiffness;
end
