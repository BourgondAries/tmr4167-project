function [] = enter()
	[nodes, beams, mats, geoms, qloads, ploads, incloasd] = lesinput();
	constructConnectivityMatrix(nodes, beams)
end
