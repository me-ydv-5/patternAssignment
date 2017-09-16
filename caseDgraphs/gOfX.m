function gmatrix = gOfX(testdata1,mu,classcovariance)
	
gmatrix = ones(rows(testdata1),1);

W = -0.5*inv(classcovariance);
w = inv(classcovariance)*mu;

for i = 1:rows(testdata1)
	x = testdata1(i,:)' ;
	a = x'*W*x ;
	b = w'*x;
	c = 0.5*(mu'*w + log(det(classcovariance)));
	gmatrix(i)  = a+b-c;
end
end
