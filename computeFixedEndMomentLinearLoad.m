
% Beregner fastinnspenningsmoment for lineært fordelte laster.
function [loadvec] = computeFixedEndMomentLinearLoad(incloads, vecsize, beamsize, nodes)
	%{
		Formelen for fastinnspenningsmoment er:

		 q1              q2
		a --------------- b
		           VVVVV
		      VVVVVVVVVV
		 VVVVVVVVVVVVVVV
		|---------------|

		Gir -qL^2/30 til venstre, og qL^2/20 til høyre. Vi velger å dele 
        lasten i to slike trekantlaster. Totalverdien er da avhengige av
        hverandre. 
	%}
    % Definerer en tom lastvektor. 
	loadvec = zeros(vecsize, 1, beamsize);
	for i = 1:size(incloads)
        % Identifiserer hvilke noder og elementer som har lineært fordelte
        % laster.
		beamid = incloads(i, 2);
		length = incloads(i, 9);
		node1 = incloads(i, 5);
		node2 = incloads(i, 6);
        
		% Definerer lastintensiteten i hver ende av elementet som q1 og q2.
		q1 = incloads(i, 3);
		q2 = incloads(i, 4);

		L = length;
		% Deler opp lasten i to trekantlaster.
        % Beregner fastinnspenningsmomenter basert på formelen over.
		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			-q1*L^2/20;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			q1*L^2/30;
		loadvec(node1, 1, beamid) = loadvec(node1, 1, beamid) + ...
			-q2*L^2/30;
		loadvec(node2, 1, beamid) = loadvec(node2, 1, beamid) + ...
			q2*L^2/20;
	end
end
