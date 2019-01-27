clear all
close all
clc

% Part (a)
data = csvread('Hill_Valley_without_noise_Training.data.txt',1,0);
y = data(:,end);
X = data(:,1:end-1);

% Part (b)
X = X - repmat(mean(X.').',1,size(X,2));
X = normr(X);

% Part (c)
X_aug = [ones(size(X,1),1),X];
trial = 100;
mean_errs = zeros(1,trial);

for i = 1:trial
    
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
    T = 500;
    mu = 0.01;
    
    errs = zeros(T,1);
    
    for t = 1:T
        
        yvals = (1)./(1 + exp(-Xtrain*theta));
        gradf = -XtrainT*ytrain + XtrainT*yvals + lambda*[0;theta(2:end)];
        f = sum(-(Xtrain*theta).*ytrain + log(1 + exp(Xtrain*theta)) + lambda/2*norm(theta(2:end))^2);
        thetaprev = theta;
        theta = theta - mu*gradf;
        ypredreg = (1)./(1 + exp(-Xtest*theta));
        errs(t) = norm(gradf)^2/(1+abs(f));
        
    end
    
    ypredreg = (1)./(1 + exp(-Xtest*theta));
    ypred = ypredreg;
    ypred(ypredreg>=0.5) = 1;
    ypred(ypredreg<0.5) = 0;
    mean_errs(i) = sum(ypred ~= ytest)/length(ypred);
    
end

mean(mean_errs)

