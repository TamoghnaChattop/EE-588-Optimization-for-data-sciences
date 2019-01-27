clear all;
tv_img_interp;

% l2 interpolation
cvx_begin
 
  variable Ul2(m,n);
  
  % Fix known pixel values
  Ul2(Known) == Uorig(Known)
  
  % Horizontal Differences
  Ux = Ul2(2:end,2:end) - Ul2(2:end,1:end-1);
  
  % Vertical Differences
  Uy = Ul2(2:end,2:end) - Ul2(1:end-1,2:end);
  
  % l2 roughness measure
  minimize(norm([Ux(:);Uy(:)], 2));
  
cvx_end

% total variation interpolation
cvx_begin

  variable Utv(m,n);
  
  % Fix known pixel values
  Utv(Known) == Uorig(Known)
  
  % Horizontal Differences
  Ux = Utv(2:end,2:end) - Utv(2:end,1:end-1);
  
  % Vertical Differences
  Uy = Utv(2:end,2:end) - Utv(1:end-1,2:end);
  
  % l2 roughness measure
  minimize(norm([Ux(:);Uy(:)], 2));
  
cvx_end

% Graph everything.
figure(1); cla;
colormap gray;

subplot(221);
imagesc(Uorig)
title('Original image');
axis image;

subplot(222);
imagesc(Known.*Uorig + 256-150*Known);
title('Obscured image');
axis image;

subplot(223);
imagesc(Ul2);
title('l_2 reconstructed image');
axis image;

subplot(224);
imagesc(Utv);
title('Total variation reconstructed image');
axis image;

  