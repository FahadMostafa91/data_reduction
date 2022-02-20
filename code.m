close all;
clear all;
load TrainImages.mat;
load TestImages.mat;
% Computing the PCA of Ytrain
[U S V]=svd(Ytrain); %SVD of Ytrain
[~,Index]=classifier(Ytrain,Ytest); % labeling the testing dataset
 for k=1:40
 tm=0;
 fm=0;
 for m=1:500

 U1=U(:,1:k); % U1 is the 1st k columns of the orthogonal matrix U
 Y1=U1'*Ytrain; % Ytrain reduced to a k-dimensional vector using the projection
 %randomly choosing an image from the Ytest
 idx=randsample(200,1);
 I=Ytest(:,idx);
 I1=U1'*I; % projection of I
 T_index=Index(idx); %index of our desired image in Ytrain data
 [~,ridx]=classifier(Y1,I1); % index of the recognized image
 if ridx==T_index
 tm=tm+1;
 else
 fm=fm+1;
 end
 end
 tm;
 F_PCA(k)=tm/500;
 end
figure(1);
plot(F_PCA,'r--');
%Computing the FDA of Ytrain
d=200/2; % define d acording to our problem given
U0=U(:,1:d); % computation of the projection matrix
Ytrain_new=U0'*Ytrain; % constructing the new training matrix
[V,lambda]=lda(Ytrain_new); %calculation of the matrix V
V=orth(V); %to make the column orthogonal
for k=1:40
 tm=0;
 fm=0;
 for m=1:500 
Global Journal of Engineering and Technology Advances, 2021, 08(01), 084?095
94
 V1=V(:,1:k);

 U1=U0*V1; %orthogonal matrix

 Y1=U1'*Ytrain; %projected reduced Ytrain data

 idx=randsample(200,1); %randomly selecting image from test data set
 I=Ytest(:,idx);
 I1=U1'*I; % projection of I
 T_index=Index(idx); %index of our desired image in Ytrain data
 [~,ridx]=classifier(Y1,I1); % index of the recognized image
 if ridx==T_index
 tm=tm+1;
 else
 fm=fm+1;
 end
 end
 tm;
 F_FDA(k)=tm/500;
end
hold on;
plot(F_FDA,'g');
%Computing the Simple Projection of Ytrain
%finding projections for different values of k(after reducing the dimension)
U=eye(644);
 for k=1:40
 tm=0;
 fm=0;
 for m=1:500

 U1=U(:,1:k); %orthogonal matrix

 Y1=U1'*Ytrain; %projected reduced Ytrain data

 idx=randsample(200,1); %randomly selecting image from test data set
 I=Ytest(:,idx);
 I1=U1'*I; % projection of I
 T_index=Index(idx); %index of our desired image in Ytrain data
 [~,ridx]=classifier(Y1,I1); % index of the recognized image
 if ridx==T_index
 tm=tm+1;
 else
 fm=fm+1;
 end
 end
 tm;
 F_Simple(k)=tm/500;
 end
 hold on;
 plot(F_Simple,'b--o');

 legend('PCA','FDA','SimPro');
 xlabel('k');
 ylabel('F(k)');
title('Variation of F(k) versus k')
 T=table(F_PCA',F_FDA',F_Simple');