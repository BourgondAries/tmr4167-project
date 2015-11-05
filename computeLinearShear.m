function shear = computeLinearShear(incloads, beamsize)
	shear = zeros(beamsize, 2);
	for i = 1:size(incloads)
		beamid = incloads(i, 2);
		length = incloads(i, 9);
		node1 = incloads(i, 5);
		node2 = incloads(i, 6);
		q1 = incloads(i, 3);
		q2 = incloads(i, 4);
		L = length;

		q1s = [q1*L/6 q1*L/3];
		q2s = [q2*L/3 q2*L/6];
		shear(beamid, :) = [q1s+q2s];
	end
end
