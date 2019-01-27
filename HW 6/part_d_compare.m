clear all
close all
clc

data = csvread('Hill_Valley_without_noise_Training.data.txt',1,0);
y = data(:,end);
X = data(:,1:end-1);

X = X - repmat(mean(X.').',1,size(X,2));
X = normr(X);

X_aug = [ones(size(X,1),1),X];
trial = 100;
beta = 0.92;
T = 500;

errstot = zeros(T,3);
indopt = 0;

for acceleratedopt = [0,1,2]
    
    indopt = indopt + 1;
    indall = randperm(size(X,1));
    indtest = indall(1:106);
    indtrain = indall;
    indtrain(indtest) = [];
    
    Xtrain = X_aug(indtrain,:);
    Xtest = X_aug(indtest,:);
    	
    ytrain = y(indtrain,1);
    ytest = y(indtest,1);
    
    XtrainT = Xtrain.';
    
    theta = zeros(size(X,2)+1,1);
    thetaprev = zeros(size(X,2)+1,1);
    
    lambda = 0.01;
    mu = 0.01;
    
    errs = zeros(T,1);
    
    for t = 1:T
        
        if acceleratedopt == 0
            
            yvals = (1)./(1 + exp(-Xtrain*theta));
            gradf = -XtrainT*ytrain + XtrainT*yvals + lambda*[0;theta(2:end)];
            f = sum(-(Xtrain*theta).*ytrain + log(1 + exp(Xtrain*theta)) + lambda/2*norm(theta(2:end))^2);
            thetaprev = theta;
            theta = theta - mu*gradf;
                
        elseif acceleratedopt == 1
            
            z = theta + beta*(theta - thetaprev);
            yvalsz = (1)./(1 + exp(-Xtrain*z));
            gradfz = -XtrainT*ytrain + XtrainT*yvalsz + lambda*[0;z(2:end)];
            yvals = (1)./(1 + exp(-Xtrain*theta));
            gradf = -XtrainT*ytrain + XtrainT*yvals + lambda*[0;theta(2:end)];
            thetaprev = theta;
            theta = z - mu*gradfz;
            f = sum(-(Xtrain*theta).*ytrain + log(1 + exp(Xtrain*theta)) + lambda/2*norm(theta(2:end))^2);
            
        else
            
            z = theta + beta*(theta - thetaprev);
            yvalsz = (1)./(1 + exp(-Xtrain*z));
            gradfz = -XtrainT*ytrain + XtrainT*yvalsz + lambda*[0;z(2:end)];
            yvals = (1)./(1 + exp(-Xtrain*theta));
            gradf = -XtrainT*ytrain + XtrainT*yvals + lambda*[0;theta(2:end)];
            thetaprev = theta;
            theta = z - mu*gradf;
            f = sum(-(Xtrain*theta).*ytrain + log(1 + exp(Xtrain*theta)) + lambda/2*norm(theta(2:end))^2);
            
        end
        
        ypredreg = (1)./(1 + exp(-Xtest*theta));
        errs(t) = norm(gradf)^2/(1+abs(f));
        
    end
    
    errstot(:,indopt) = errs;
    
end

dlmwrite('D:\EE 588\HW 6\HW6_Partd' ,[ (1:T)', errstot ] ,'delimiter',',');
            