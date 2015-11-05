% Beregner skj�rkraft for p�satt moment. 
function shear = computeMomentShear(endmoments, beams)
	% Setter opp en tom vektor.
    shear = [];
    % Iterer gjennom endemomentene.
    % Beregner skj�rkraft bidrag fra endemomenter med formelen: 
    %          
    %           Q_endemoment = -(M1+M2)/L
    % 
    t = 0;
	for i = endmoments
         t = t+1
        L = beams(t,6);
		shearVal = (i(1) + i(2)) / L;
		shear = [shear; shearVal -shearVal];
    end
    
    shear
    assert(false)
end
