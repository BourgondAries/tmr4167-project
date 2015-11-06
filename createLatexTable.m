function text = createLatexTable(moments)
	text = '';
	d = ' & ';
	e = '\\ \hline';
	moments(3, :) = max(abs(moments(3:4, :)));
	moments(4, :) = [];
	moments = kiloify(moments);
	for i = 1:size(moments, 2)
		m = moments(:, i);

		t = [num2str(i) d m{1} d m{2} d m{3} e ];
		t = [t, sprintf('%s', '\n')];
		text = [text, t];
	end
end
