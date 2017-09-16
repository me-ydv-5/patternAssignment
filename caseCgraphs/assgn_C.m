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
observations = .75*rows(dataSetforClass1)
fprintf('\n');
trainingSet1 = dataSetforClass1(1:observations,:);
trainingSet2 = dataSetforClass2(1:observations,:);
trainingSet3 = dataSetforClass3(1:observations,:);


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

covarianceForClass1 = cov(trainingSet1);
covarianceForClass2 = cov(trainingSet2);
covarianceForClass3 = cov(trainingSet3);
covarianceForClass1(2,1) = covarianceForClass1(1,2) = 0;
covarianceForClass2(2,1) = covarianceForClass2(1,2) = 0;
covarianceForClass3(2,1) = covarianceForClass3(1,2) = 0;
covarianceForClass1
covarianceForClass2
covarianceForClass3

% finalcovariance = covariance(covarianceForClass1,covarianceForClass2,covarianceForClass3)
% finalcovariance(1,1)
fprintf('Taking the rest 25%% of the data as test..\n')


%-----------------------------------------------------%
% Finding g(x) for all the three classes

testdata1 = dataSetforClass1(observations+1:rows(dataSetforClass1),:);
x = mean(trainingSet1);
mu1 = x' ;
% gMatrix1 = gOfX(testdata1,mu1,covarianceForClass1);
% save result1.csv gMatrix1;


testdata2 = dataSetforClass2(observations+1:rows(dataSetforClass2),:);
x = mean(trainingSet2);
mu2 = x' ;
% gMatrix2 = gOfX(testdata2,mu2,covarianceForClass2);
% save result2.csv gMatrix2;


testdata3 = dataSetforClass3(observations+1:rows(dataSetforClass3),:);
x = mean(trainingSet3);
mu3 = x' ;
% gMatrix3 = gOfX(testdata3,mu3,covarianceForClass3);
% save result3.csv gMatrix3;

%-----------------------------------------------------%
% Printing the output to files for proving linearly separable data

fp1 = fopen('red.csv','w');
fp2 = fopen('blue.csv','w');

%deciding the ranges


for x = -4:0.1:2,	
	for y = -2:0.1:1.5,
		vector = [x , y];
		vara = gOfX(vector,mu1,covarianceForClass1) ;
		varb = gOfX(vector,mu2,covarianceForClass2) ;
		fflush(fp1);
		fflush(fp2);
		if vara < varb
			fprintf(fp2,'%d,%d\n',x,y);		
		else 
			fprintf(fp1,'%d,%d\n',x,y);
		endif;
	endfor
endfor

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

for x = -2:0.1:4,	
	for y = -2:0.1:1.5,
		vector = [x , y];
		vara = gOfX(vector,mu2,covarianceForClass2) ;
		varb = gOfX(vector,mu3,covarianceForClass3) ;
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


% Plotting the output of the files

cyanColor = csvread('cyan.csv');
blueColor = csvread('blue.csv');

figure;
% plot(trainingSet1(:,1),trainingSet1(:,2),'rx','MarkerSize',10);
% hold on;
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

for x = -4:0.1:4,	
	for y = -0.5:0.1:1.5,
		vector = [x , y];
		vara = gOfX(vector,mu1,covarianceForClass1) ;
		varb = gOfX(vector,mu3,covarianceForClass3) ;
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
%Deciding the accuracy of classifier on test data

WrongDataInClass1 = 0;
RightDataInClass1 = 0;

for i = 1:rows(testdata1)
	vector = testdata1(i,:);
	vara = gOfX(vector,mu1,covarianceForClass1) ;
	varb = gOfX(vector,mu2,covarianceForClass2) ;
	varc = gOfX(vector,mu3,covarianceForClass3) ;
	array = [vara,varb,varc];
	if max(array) == vara
		RightDataInClass1 += 1;
	else
		WrongDataInClass1 += 1;
	endif;
endfor

fprintf('\n');
RightDataInClass1
WrongDataInClass1
fprintf('\n');

WrongDataInClass2 = 0;
RightDataInClass2 = 0;

for i = 1:rows(testdata2)
	vector = testdata2(i,:);
	vara = gOfX(vector,mu1,covarianceForClass1) ;
	varb = gOfX(vector,mu2,covarianceForClass2) ;
	varc = gOfX(vector,mu3,covarianceForClass3) ;
	array = [vara,varb,varc];
	if max(array) == varb
		RightDataInClass2 += 1;
	else 
		WrongDataInClass2 += 1;
	endif;
endfor

RightDataInClass2
WrongDataInClass2
fprintf('\n');

WrongDataInClass3 = 0;
RightDataInClass3 = 0;

for i = 1:rows(testdata3)
	vector = testdata3(i,:);
	vara = gOfX(vector,mu1,covarianceForClass1) ;
	varb = gOfX(vector,mu2,covarianceForClass2) ;
	varc = gOfX(vector,mu3,covarianceForClass3) ;
	array = [vara,varb,varc];
	if max(array) == varc
		RightDataInClass3 += 1;
	else 
		WrongDataInClass3 += 1;
	endif;
endfor

RightDataInClass3
WrongDataInClass3
fprintf('\n');



%------------------------------------------------------------------------%
% Decision Region plot for all classes together with training data superposed

fp1 = fopen('red.csv','w');
fp2 = fopen('blue.csv','w');
fp3 = fopen('cyan.csv','w');
%deciding the ranges


for x = -4:0.1:4,	
	for y = -2:0.1:1.5,

		vector = [x , y];
		vara = gOfX(vector,mu1,covarianceForClass1) ;
		varb = gOfX(vector,mu2,covarianceForClass2) ;
		varc = gOfX(vector,mu3,covarianceForClass3) ;
		
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