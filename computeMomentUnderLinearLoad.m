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
	moments = zeros(beamsize, 1);
	for i = 1:size(incloads)
		beamid = incloads(i, 2);
		length = incloads(i, 9);
		node1 = incloads(i, 5);
		node2 = incloads(i, 6);
		% Assume the load is perpendicular.
		q1 = incloads(i, 3);
		q2 = incloads(i, 4);

		L = length;
		P = -neg;
		M_a = endmoments(1, i);
		M_b = endmoments(2, i);


		% So how do we proceed? Well, we have spaces 1/3 from each end.
		% Both points have a different magnitude. We need to find the
		% Sum(M_b) = M_a + M_b - q1*L/2 * 2/3L - q2*L/2 * L/3 + A_z * L = 0
		% => -(M_a + M_b - q1*L/2 * 2/3L - q2*L/2 * L/3)/L = A_z
		% A_z =
		moment(incloads(i, 2)) =

	end
end
