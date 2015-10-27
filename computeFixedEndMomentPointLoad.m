function [loadvec] = computeFixedEndMomentPointLoad(ploads)
	%{
		The fomula for fixed end point loads:

		       P
		a -----|--------- b
		       V
		|---------------|

		a + b = L

		Gives -Pab^2/L^2 left, and Pa^2b/L^2 to the right
	%}
	loadvec = [];
	for i = 1:size(ploads)
		distance = ploads(i, 6);
		px = ploads(i, 3);
		py = ploads(i, 4);
		pz = ploads(i, 5);
		node1 = ploads(i, 7);
		node2 = ploads(i, 8);

		% Need to calculate beam parallelity.
	end
	ploads

end
