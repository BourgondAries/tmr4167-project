% Setter opp matrise med info om geometri-id og annet arealmoment.
% Hjelpefunksjon til senere bruk. 
function [geometries] = createGeometries(pipes, ibeam)
	%{
		Create a matrix that has the columns:
		Geom_id, I module

		[1, 2*10^3;
		 2, ...]
	%}
	% Definerer først en tom matrise.
	geometries = [];
	prevmax = 0;
	
	% Iterer gjennom matrisen pipes med info om rørprofilet. 
	for i = 1:size(pipes, 1)
		
		% Setter opp matrisen med informasjon om type geometri, og annet
		% arealmoment for tverrsnittet. 
		geometries = [geometries; i, computeSecondMomentOfArea(...
			pipes(i, 2)/2,...
			pipes(i, 2)/2 - pipes(i, 3))];
		prevmax = i;
	end
	geometries = [geometries; prevmax + 1, ibeam];
end
