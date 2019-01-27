clear all
close all
clc

% Part (d)
data = csvread('Hill_Valley_without_noise_Training.data.txt',1,0);
y = data(:,end);
X = data(:,1:end-1);

X = X - repmat(mean(X.').',1,size(X,2));
X = normr(X);

X_aug = [ones(size(X,1),1),X];
trial = 100;
iterstop = zeros(1,trial);

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
    T = 10000;
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
        
        if rem(t,1000)==0
            disp(['t=',num2str(t), ', error = ',num2str(errs(t))]);
        end
        
    end
    
    myind = find(errs < 1e-6);
    iterstop(trial) = myind(1);
    
end

mean(iterstop)