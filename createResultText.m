function text = createResultText(moments, shear, tension)
	beam = 'Beam: ';
	node = 'Node: ';
	mom = 'Moment: ';
	shr = 'Shear: ';
	ten = 'Tension: ';
	text = '';
	for i = 1:size(moments, 2)
		beamn = strcat('\n', beam, num2str(i), '\n');

		node1 = strcat('----------\n', node, '1\n');
		mom1 = strcat(mom, num2str(moments(1, i)), 'kNm\n');
		shr1 = strcat(shr, num2str(shear(i, 1)), 'kN\n');
		ten1 = strcat(ten, num2str(tension(1, i)), 'kPa\n');

		node2 = strcat('----------\n', node, '2\n');
		mom2 = strcat(mom, num2str(moments(2, i)), 'kNm\n');
		shr2 = strcat(shr, num2str(shear(i, 2)), 'kN\n');
		ten2 = strcat(ten, num2str(tension(2, i)), 'kPa\n');


		node3 = strcat('----------\n', node, 'middle/max\n');
		maxmoment = max(abs([moments(3, i) moments(4, i)]));
		mom3 = strcat(mom, num2str(maxmoment), 'kNm\n');
		maxtension = max(abs([tension(3, i) tension(4, i)]));
		ten3 = strcat(ten, num2str(maxtension), 'kPa\n');

		text = strcat(text, beamn,...
			node1, mom1, shr1, ten1,...
			node2, mom2, shr2, ten2,...
			node3, mom3, ten3);
	end
	text = regexprep(text, '\\n', sprintf('%s', '\n'));
end
