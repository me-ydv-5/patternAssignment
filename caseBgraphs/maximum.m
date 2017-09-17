function z = maximum(z1,z2,z3)
	z = ones(rows(z1),columns(z1));
	for i = 1 : rows(z1)
		for j = 1 : columns(z1)
			if z1(i,j) > z2(i,j)
				max = z1(i,j);
			else 
				max = z2(i,j);
			endif;
			
			if max > z3(i,j)
				max = max;
			else 
				max = z3(i,j);
			endif;
			z(i,j) = max;
		endfor;
	endfor;
end;