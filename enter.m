function [] = enter()
	[nodes, beams, mats, geoms, qloads, ploads, incloasd] = lesinput();
	constructConnectivityMatrix(beams)
end
