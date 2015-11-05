function [moment] = computeMomentUnderLinearLoad(incloads, endmoments, beamsize)
	%{
		The fomula for fixed end point loads:

		 q1              q2
		a --------------- b
		           VVVVV
		      VVVVVVVVVV
		 VVVVVVVVVVVVVVV
		|---------------|

	%}
	moment = zeros(beamsize, 1);
	for i = 1:size(incloads)
		beamid = incloads(i, 2);
		length = incloads(i, 9);
		node1 = incloads(i, 5);
		node2 = incloads(i, 6);
		% Assume the load is perpendicular.
		q1 = incloads(i, 3);
		q2 = incloads(i, 4);

		L = length;
		M_a = endmoments(1, i);
		M_b = endmoments(2, i);

		middle = (-M_a + M_b) / 2;
		moment(beamid) = -q1*L^2/8 - 1/24*(q2-q1)*L^2 + middle;

	end
end
