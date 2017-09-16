function mat = covariance(class1,class2,class3)

sumA = (class1(1,1) + class1(2,2) + 2*class1(1,2))/4;

sumB = (class2(1,1) + class2(2,2) + 2*class2(1,2))/4;

sumC = (class3(1,1) + class3(2,2) + 2*class3(1,2))/4;

sum = (sumA + sumB + sumC)/3;

mat = sum*eye(2,2);