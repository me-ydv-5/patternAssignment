function gmatrix = gOfX(testdata1,mu,finalcovariance)
gmatrix = ones(rows(testdata1),1);
for i = 1:rows(testdata1)
	x = testdata1(i,:)' ;
	y = -0.5*(x'*x - 2*mu'*x + (mu'*mu));
	z = finalcovariance(1,1);
	gmatrix(i)  = y/z;
end
end
