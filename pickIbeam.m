function [h i] = pickIbeam(n)
	if n == 1 h = 40; i = 0.801 * 10 ^ -6;
	elseif n == 2 h = 50; i = 1.71 * 10 ^ -6;
	elseif n == 3 h = 60; i = 3.18 * 10 ^ -6;
	elseif n == 4 h = 70; i = 5.41 * 10 ^ -6;
	elseif n == 5 h = 80; i = 8.69 * 10 ^ -6;
	elseif n == 6 h = 90; i = 13.2 * 10 ^ -6;
	elseif n == 7 h = 100; i = 19.4 * 10 ^ -6;
	elseif n == 8 h = 110; i = 27.7 * 10 ^ -6;
	elseif n == 9 h = 120; i = 38.9 * 10 ^ -6;
	elseif n == 10 h = 135; i = 57.9 * 10 ^ -6;
	elseif n == 11 h = 150; i = 83.6 * 10 ^ -6;
	elseif n == 12 h = 165; i = 117.7 * 10 ^ -6;
	elseif n == 13 h = 180; i = 162.7 * 10 ^ -6;
	elseif n == 14 h = 200; i = 231.3 * 10 ^ -6;
	elseif n == 15 h = 225; i = 337.4 * 10 ^ -6;
	elseif n == 16 h = 250; i = 482.0 * 10 ^ -6;
	elseif n == 17 h = 275; i = 671.2 * 10 ^ -6;
	elseif n == 18 h = 300; i = 920.8 * 10 ^ -6;
	else h = 0; i = 0; end
end
