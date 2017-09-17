% ranges are to be automated

% Clear and Close Figures
clear ; close all; clc

%------------------------------------------------------------------------%
% File I/O
inputFile1 = input('Give the path to first input file : ','s');
inputFile2 = input('Give the path to second input file : ','s');
inputFile3 = input('Give the path to third input file : ','s');

dataSetforClass1 = load(inputFile1);
dataSetforClass2 = load(inputFile2);
dataSetforClass3 = load(inputFile3);

%------------------------------------------------------------------------%
% Choosing first 75% as the traiing set
fprintf('\n');
observations1 = .75*rows(dataSetforClass1)
observations2 = .75*rows(dataSetforClass2)
observations2 = floor(observations2);
observations3 = .75*rows(dataSetforClass3)
fprintf('\n');
trainingSet1 = dataSetforClass1(1:observations1,:);
trainingSet2 = dataSetforClass2(1:observations2,:);
trainingSet3 = dataSetforClass3(1:observations3,:);


%------------------------------------------------------------------------%
%% Plotting the three datasets together
% figure;
% plot(trainingSet1(:,1),trainingSet1(:,2),'ro','MarkerSize',10);
% hold on;
% plot(trainingSet2(:,1),trainingSet2(:,2),'bo','MarkerSize',10);
% hold on;
% plot(trainingSet3(:,1),trainingSet3(:,2),'co','MarkerSize',10);
% hold off;
% legend('Class1','Class2');
% xlabel('Feature1');
% ylabel('Feature2');
%------------------------------------------------------------------------%
% Finding the covariance matrix

covarianceForClass1 = cov(trainingSet1)
covarianceForClass2 = cov(trainingSet2)
covarianceForClass3 = cov(trainingSet3)

finalcovariance = covariance(covarianceForClass1,covarianceForClass2,covarianceForClass3)

fprintf('Taking the rest 25%% of the data as test..\n')


%-----------------------------------------------------%
% Finding g(x) for all the three classes

testdata1 = dataSetforClass1(observations1+1:rows(dataSetforClass1),:);
x = mean(trainingSet1);
mu1 = x' ;
% gMatrix1 = gOfX(testdata1,mu1,covarianceForClass1);
% save result1.csv gMatrix1;


testdata2 = dataSetforClass2(observations2+1:rows(dataSetforClass2),:);
x = mean(trainingSet2);
mu2 = x' ;
% gMatrix2 = gOfX(testdata2,mu2,covarianceForClass2);
% save result2.csv gMatrix2;


testdata3 = dataSetforClass3(observations3+1:rows(dataSetforClass3),:);
x = mean(trainingSet3);
mu3 = x' ;
% gMatrix3 = gOfX(testdata3,mu3,covarianceForClass3);
% save result3.csv gMatrix3;

mu1a = mu1(1,1);
mu1b = mu1(2,1);

mu2a = mu2(1,1);
mu2b = mu2(2,1);

mu3a = mu3(1,1);
mu3b = mu3(2,1);

final = inv(finalcovariance);

p1 = final(1,1)*mu1a + final(1,2)*mu1b ;
q1 = final(2,1)*mu1a + final(2,2)*mu1b ;

p2 = final(1,1)*mu2a + final(1,2)*mu2b ;
q2 = final(2,1)*mu2a + final(2,2)*mu2b ;

p3 = final(1,1)*mu3a + final(1,2)*mu3b ;
q3 = final(2,1)*mu3a + final(2,2)*mu3b ;

probabilityofClass1Elements = observations1/(rows(trainingSet1) + rows(trainingSet2) + rows(trainingSet3));
probabilityofClass2Elements = observations2/(rows(trainingSet1) + rows(trainingSet2) + rows(trainingSet3));
probabilityofClass3Elements = observations3/(rows(trainingSet1) + rows(trainingSet2) + rows(trainingSet3));

constantForClass1 = log(probabilityofClass1Elements);
constantForClass2 = log(probabilityofClass2Elements);
constantForClass3 = log(probabilityofClass3Elements);


%-----------------------------------------------------%
% Printing the output to files for proving linearly separable data

fp1 = fopen('red.csv','w');
fp2 = fopen('blue.csv','w');

%deciding the ranges
% NLS Data
% k = -4:0.1:4;	
% j = -4:0.1:4;
% RD Data
k = 0:100:2500;	
j = 0:100:2500;
% LS Data
% k = -30:0.5:30;
% j = -30:0.5:30;
[Q,W] = meshgrid(k,j);
%deciding the ranges
% NLS Data
% for x = -4:0.1:2,	
% 	for y = -2:0.1:1.5,
% RD Data
for x = 0:100:2500,	
	for y = 0:100:2500,
% LS Data
% for x = 5:0.5:25,	
% 	for y = -15:0.5:15,
		vector = [x , y];
		vara = gOfX(vector,mu1,finalcovariance) + constantForClass1 ;
		varb = gOfX(vector,mu2,finalcovariance) + constantForClass2 ;
		fflush(fp1);
		fflush(fp2);
		if vara < varb
			fprintf(fp2,'%d,%d\n',x,y);		
		else 
			fprintf(fp1,'%d,%d\n',x,y);
		endif;
	endfor
endfor


z1 = p1.*Q + q1.*W - 0.5*(mu1a.*p1 + mu1b.*q1);
z2 = p2.*Q + q2.*W - 0.5*(mu2a.*p2 + mu2b.*q2);
z = z1 - z2;
figure;
contour(Q,W,z,'showtext','on'); 
hold on;
plot(trainingSet1(:,1),trainingSet1(:,2),'ro','MarkerSize',10);
hold on;
plot(trainingSet2(:,1),trainingSet2(:,2),'ko','MarkerSize',10);
hold off;
xlabel('Feature1');
ylabel('Feature2');
legend('Contour Plot of Class 1 and 2','Class1','Class2');



fclose(fp1);
fclose(fp2);


% Plotting the output of the files

redColor = csvread('red.csv');
blueColor = csvread('blue.csv');

figure;
plot(trainingSet1(:,1),trainingSet1(:,2),'rx','MarkerSize',10);
hold on;
plot(trainingSet2(:,1),trainingSet2(:,2),'kx','MarkerSize',10);
hold on;
plot(redColor(:,1),redColor(:,2),'mo','MarkerSize',10);
hold on;
plot(blueColor(:,1),blueColor(:,2),'ko','MarkerSize',10);
hold off;

xlabel('Feature 1');
ylabel('Feature 2');
legend('Class 1','Class 2','Points in decision region of Class1','Points in decision region of Class2');


fp1 = fopen('blue.csv','w');
fp2 = fopen('cyan.csv','w');

%deciding the ranges
% NLS Data
% k = -4:0.1:4;	
% j = -4:0.1:4;
% RD Data
k = 0:100:2500;	
j = 0:100:2500;
% LS Data
% k = -30:0.5:30;
% j = -30:0.5:30;
[Q,W] = meshgrid(k,j);

%deciding the ranges
% NLS Data
% for x = -2:0.1:4,	
% 	for y = -2:0.1:1.5,
% RD Data
for x = 0:100:2500,	
	for y = 0:100:2500,
% LS Data
% for x = -10:0.5:20,	
% 	for y = -15:0.5:15,
		vector = [x , y];
		vara = gOfX(vector,mu2,finalcovariance) + constantForClass2 ;
		varb = gOfX(vector,mu3,finalcovariance) + constantForClass3 ;
		fflush(fp1);
		fflush(fp2);
		if vara > varb
			fprintf(fp1,'%d,%d\n',x,y);		
		else 
			fprintf(fp2,'%d,%d\n',x,y);
		endif;
	endfor
endfor



z2 = p2.*Q + q2.*W - 0.5*(mu2a.*p2 + mu2b.*q2);
z3 = p3.*Q + q3.*W - 0.5*(mu1a.*p3 + mu1b.*q3);
z = z2 - z3;

figure;
contour(Q,W,z,'showtext','on'); 
hold on;
plot(trainingSet2(:,1),trainingSet2(:,2),'ro','MarkerSize',10);
hold on;
plot(trainingSet3(:,1),trainingSet3(:,2),'ko','MarkerSize',10);
hold off;
xlabel('Feature1');
ylabel('Feature2');
legend('Contour Plot of Class 2 and 3','Class2','Class3');

fclose(fp1);
fclose(fp2);


% Plotting the output of the files

cyanColor = csvread('cyan.csv');
blueColor = csvread('blue.csv');

figure;
plot(trainingSet2(:,1),trainingSet2(:,2),'rx','MarkerSize',10);
hold on;
plot(trainingSet3(:,1),trainingSet3(:,2),'kx','MarkerSize',10);
hold on;
plot(cyanColor(:,1),cyanColor(:,2),'co','MarkerSize',10);
hold on;
plot(blueColor(:,1),blueColor(:,2),'bo','MarkerSize',10);
hold off;
xlabel('Feature 1');
ylabel('Feature 2');
legend('Class 2','Class 3','Points in decision region of Class3','Points in decision region of Class2');

%deciding the ranges

fp1 = fopen('red.csv','w');
fp2 = fopen('cyan.csv','w');

%deciding the ranges
% NLS Data
% k = -4:0.1:4;	
% j = -4:0.1:4;
% RD Data
k = 0:100:2500;	
j = 0:100:2500;
% LS Data
% k = -30:0.5:30;
% j = -30:0.5:30;
[Q,W] = meshgrid(k,j);

%deciding the ranges
% NLS Data
% for x = -4:0.1:4,	
% 	for y = -2:0.1:1.5,
% RD Data
for x = 0:100:2500,	
	for y = 0:100:2500,
% LS Data
% for x = -10:0.5:25,	
% 	for y = -15:0.5:15,
		vector = [x , y];
		vara = gOfX(vector,mu1,finalcovariance) + constantForClass1 ;
		varb = gOfX(vector,mu3,finalcovariance) + constantForClass3 ;
		fflush(fp1);
		fflush(fp2);
		if vara > varb
			fprintf(fp1,'%d,%d\n',x,y);		
		else 
			fprintf(fp2,'%d,%d\n',x,y);
		endif;
	endfor
endfor

fclose(fp1);
fclose(fp2);

z3 = p3.*Q + q3.*W - 0.5*(mu1a.*p3 + mu1b.*q3);
z1 = p1.*Q + q1.*W - 0.5*(mu1a.*p1 + mu1b.*q1);
z = z3 - z1;

figure;
contour(Q,W,z,'showtext','on'); 
hold on;
plot(trainingSet3(:,1),trainingSet3(:,2),'ro','MarkerSize',10);
hold on;
plot(trainingSet1(:,1),trainingSet1(:,2),'ko','MarkerSize',10);
hold off;
xlabel('Feature1');
ylabel('Feature2');
legend('Contour Plot of Class 3 and 1','Class3','Class1');


% Plotting the output of the files

redColor = csvread('red.csv');
cyanColor = csvread('cyan.csv');

figure;
plot(trainingSet1(:,1),trainingSet1(:,2),'rx','MarkerSize',10);
hold on;
plot(trainingSet3(:,1),trainingSet3(:,2),'kx','MarkerSize',10);
hold on;
plot(cyanColor(:,1),cyanColor(:,2),'co','MarkerSize',10);
hold on;
plot(redColor(:,1),redColor(:,2),'ro','MarkerSize',10);
hold off;
xlabel('Feature 1');
ylabel('Feature 2');
legend('Class 1','Class 3','Points in decision region of Class3','Points in decision region of Class1');


%------------------------------------------------------------------------%
% Decision Region plot for all classes together with training data superposed

fp1 = fopen('red.csv','w');
fp2 = fopen('blue.csv','w');
fp3 = fopen('cyan.csv','w');
%deciding the ranges
% NLS Data
% k = -4:0.1:4;	
% j = -4:0.1:4;
% RD Data
k = 0:100:2500;	
j = 0:100:2500;
% LS Data
% k = -30:0.5:30;
% j = -30:0.5:30;
[Q,W] = meshgrid(k,j);

%deciding the ranges
% NLS Data
% for x = -4:0.1:4,	
% 	for y = -2:0.1:1.5,
% RD Data
for x = 0:100:2500,	
	for y = 0:100:2500,
% LS Data
% for x = -10:0.5:25,	
% 	for y = -15:0.5:15,
		vector = [x , y];
		vara = gOfX(vector,mu1,finalcovariance) + constantForClass1 ;
		varb = gOfX(vector,mu2,finalcovariance) + constantForClass2 ;
		varc = gOfX(vector,mu3,finalcovariance) + constantForClass3 ;
		
		fflush(fp1);
		fflush(fp2);
		fflush(fp3);

		array = [vara,varb,varc];

		if max(array) == vara 
			fprintf(fp1,'%d,%d\n',x,y);		
		elseif max(array) == varb
			fprintf(fp2,'%d,%d\n',x,y);
		else fprintf(fp3,'%d,%d\n',x,y);
		endif;
	endfor
endfor

fclose(fp1);
fclose(fp2);
fclose(fp3);



% Plotting the output of the files

redColor = csvread('red.csv');
blueColor = csvread('blue.csv');
cyanColor = csvread('cyan.csv');
%Plotting the three classes
%class having red -> magenta, blue -> black

z3 = p3.*Q + q3.*W - 0.5*(mu1a.*p3 + mu1b.*q3);
z1 = p1.*Q + q1.*W - 0.5*(mu1a.*p1 + mu1b.*q1);
z2 = p2.*Q + q2.*W - 0.5*(mu2a.*p2 + mu2b.*q2);

z = maximum(z1,z2,z3);

figure;
contour(Q,W,z,'showtext','on'); 
hold on;
plot(trainingSet1(:,1),trainingSet1(:,2),'ko','MarkerSize',10);
hold on;
plot(trainingSet2(:,1),trainingSet2(:,2),'ro','MarkerSize',10);
hold on;
plot(trainingSet3(:,1),trainingSet3(:,2),'bo','MarkerSize',10);
hold off;
xlabel('Feature1');
ylabel('Feature2');
legend('Contour Plot of Class 1,2 and 3','Class1','Class2','Class3');


figure;
plot(trainingSet1(:,1),trainingSet1(:,2),'rx','MarkerSize',10);
hold on;
plot(trainingSet2(:,1),trainingSet2(:,2),'bx','MarkerSize',10);
hold on;
plot(trainingSet3(:,1),trainingSet3(:,2),'cx','MarkerSize',10);
hold on;
plot(redColor(:,1),redColor(:,2),'ro','MarkerSize',10);
hold on;
plot(blueColor(:,1),blueColor(:,2),'bo','MarkerSize',10);
hold on;
plot(cyanColor(:,1),cyanColor(:,2),'co','MarkerSize',10);
hold off;

xlabel('Feature 1');
ylabel('Feature 2');
legend('Class 1','Class 2','Class3','Points in decision region of Class1','Points in decision region of Class2','Points in decision region of Class3','location','southeast');
%------------------------------------------------------------------------%

%Deciding the accuracy of classifier on test data
RightDataInClass1 = 0;
WrongDataInClass1ofClass2 = 0;
WrongDataInClass1ofClass3 = 0;

for i = 1:rows(testdata1)
	vector = testdata1(i,:);
	vara = gOfX(vector,mu1,finalcovariance) + constantForClass1 ;
	varb = gOfX(vector,mu2,finalcovariance) + constantForClass2 ;
	varc = gOfX(vector,mu3,finalcovariance) + constantForClass3 ;
	array = [vara,varb,varc];
	if max(array) == vara
		RightDataInClass1 += 1;
	elseif max(array) == varb
		WrongDataInClass1ofClass2 += 1;
	else WrongDataInClass1ofClass3 += 1;
	endif;
endfor

fprintf('\n');
RightDataInClass1 
WrongDataInClass1ofClass2 
WrongDataInClass1ofClass3
fprintf('\n');

RightDataInClass2 = 0;
WrongDataInClass2ofClass1 = 0;
WrongDataInClass2ofClass3 = 0;

for i = 1:rows(testdata2)
	vector = testdata2(i,:);
	vara = gOfX(vector,mu1,finalcovariance) + constantForClass1 ;
	varb = gOfX(vector,mu2,finalcovariance) + constantForClass2 ;
	varc = gOfX(vector,mu3,finalcovariance) + constantForClass3 ;
	array = [vara,varb,varc];
	if max(array) == varb
		RightDataInClass2 += 1;
	elseif max(array) == vara 
		WrongDataInClass2ofClass1 += 1;
	else WrongDataInClass2ofClass3 += 1;
	endif;
endfor

RightDataInClass2
WrongDataInClass2ofClass1
WrongDataInClass2ofClass3

fprintf('\n');

WrongDataInClass3ofClass1 = 0;
RightDataInClass3 = 0;
WrongDataInClass3ofClass2 = 0;

for i = 1:rows(testdata3)
	vector = testdata3(i,:);
	vara = gOfX(vector,mu1,finalcovariance) + constantForClass1 ;
	varb = gOfX(vector,mu2,finalcovariance) + constantForClass2 ;
	varc = gOfX(vector,mu3,finalcovariance) + constantForClass3 ;
	array = [vara,varb,varc];
	if max(array) == varc
		RightDataInClass3 += 1;
	elseif max(array) == vara 
		WrongDataInClass3ofClass1 += 1;
	else WrongDataInClass3ofClass2 += 1;
	endif;
endfor

WrongDataInClass3ofClass1 
RightDataInClass3 
WrongDataInClass3ofClass2 
fprintf('\n');



%------------------------------------------------------------------------%
