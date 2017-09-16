function gmatrix = gOfX(testdata1,mu,finalcovariance)
	
gmatrix = ones(rows(testdata1),1);
for i = 1:rows(testdata1)
	x = testdata1(i,:)' ;
	a = (inv(finalcovariance)*mu)'*x ;
	b = 0.5*mu'*inv(finalcovariance)*mu;
	gmatrix(i)  = a-b;
end
end
