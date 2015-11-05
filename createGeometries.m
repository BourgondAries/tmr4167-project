function [geometries] = createGeometries(pipes, ibeam)
	%{
		Create a matrix that has the columns:
		Geom_id, I module

		[1, 2*10^3;
		 2, ...]
	%}
	geometries = [];
	prevmax = 0;
	for i = 1:size(pipes, 1)
		geometries = [geometries; i, computeSecondMomentOfArea(...
			pipes(i, 2)/2,...
			pipes(i, 2)/2 - pipes(i, 3))];
		prevmax = i;
	end
	geometries = [geometries; prevmax + 1, ibeam];
end
