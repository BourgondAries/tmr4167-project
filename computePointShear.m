function shear = computePointShear(ploads)
	shear = [];
	for i = 1:size(ploads)
		beamid = ploads(i, 2);
		length = ploads(i, 11);
		distance = ploads(i, 6);
		px = ploads(i, 3);
		py = ploads(i, 4);  % Always zero
		assert(py == 0);
		pz = ploads(i, 5);
		node1 = ploads(i, 7);
		node2 = ploads(i, 8);
		dx = ploads(i, 9);
		dz = ploads(i, 10);
		projection = [dx dz] * [px; pz];
		p = [px pz] - projection * [dx dz];
		neg = cross([p(1) 0 p(2)], [dx 0 dz]);
		neg = neg(2);
		shear = [shear; -neg/2];
	end
end
