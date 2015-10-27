function [geometries] = createGeometries(pipes, boxes)
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
			pipes(i, 2),...
			pipes(i, 2) - pipes(i, 3))];
		prevmax = i;
	end
	for i = 1:size(boxes, 1)
		geometries = [geometries; prevmax + i, computeSecondMomentOfAreaBox(...
			boxes(i, 5),...
			boxes(i, 3),...
			boxes(i, 4),...
			boxes(i, 2))];
	end
end
