function shear = computeBeamShear(qloads, beamsize)
	shear = zeros(beamsize, 2);
	for i = 1:size(qloads)
		beamid = qloads(i, 2);
		length = qloads(i, 10);
		qx = qloads(i, 3);
		qy = qloads(i, 4);  % Always zero
		assert(qy == 0);
		qz = qloads(i, 5);
		node1 = qloads(i, 6);
		node2 = qloads(i, 7);
		dx = qloads(i, 8);
		dz = qloads(i, 9);
		projection = [dx dz] * [qx; qz];
		q = [qx qz] - projection * [dx dz];
		neg = cross([q(1) 0 q(2)], [dx 0 dz]);
		neg = neg(2);

		unit = -neg/2*length;
		shear(beamid, :) = [unit -unit];
	end
end
