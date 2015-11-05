% Tabell over standard IPE-profiler.
% Angir nummer i tabellen, høyde og annet arealmoment (I_y).
% Vi har definert 26 forskjellige IPE-profiler.

function [h i] = pickIbeam(n)
	if n == 1 h = 80; i = 0.801 * 10 ^ 6;
	elseif n == 2 h = 100; i = 1.71 * 10 ^ 6;
	elseif n == 3 h = 120; i = 3.18 * 10 ^ 6;
	elseif n == 4 h = 140; i = 5.41 * 10 ^ 6;
	elseif n == 5 h = 160; i = 8.69 * 10 ^ 6;
	elseif n == 6 h = 180; i = 13.2 * 10 ^ 6;
	elseif n == 7 h = 200; i = 19.4 * 10 ^ 6;
	elseif n == 8 h = 220; i = 27.7 * 10 ^ 6;
	elseif n == 9 h = 240; i = 38.9 * 10 ^ 6;
	elseif n == 10 h = 270; i = 57.9 * 10 ^ 6;
	elseif n == 11 h = 300; i = 83.6 * 10 ^ 6;
	elseif n == 12 h = 330; i = 117.7 * 10 ^ 6;
	elseif n == 13 h = 360; i = 162.7 * 10 ^ 6;
	elseif n == 14 h = 400; i = 231.3 * 10 ^ 6;
	elseif n == 15 h = 450; i = 337.4 * 10 ^ 6;
	elseif n == 16 h = 500; i = 482.0 * 10 ^ 6;
	elseif n == 17 h = 550; i = 671.2 * 10 ^ 6;
	elseif n == 18 h = 600; i = 920.8 * 10 ^ 6;
	elseif n == 19 h = 650; i = 1120.0 * 10 ^ 6;
	elseif n == 20 h = 700; i = 1351.01 * 10 ^ 6;
	elseif n == 21 h = 750; i = 1972.77* 10 ^ 6;
	elseif n == 22 h = 800; i = 2329.21* 10 ^ 6;
	elseif n == 23 h = 850; i = 2724.41 * 10 ^ 6;
	elseif n == 24 h = 900; i = 3579.25 * 10 ^ 6;
	elseif n == 25 h = 950; i = 4118.68 * 10 ^ 6;
	elseif n == 26 h = 1000; i = 4707.73* 10 ^ 6;
	else h = 0; i = 0; end
	h = h / 2000;
	i = i * 10 ^ (-12);
end
