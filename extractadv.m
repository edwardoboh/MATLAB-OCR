clc
clear all
close all
warning off
k=(imread('name.png'));
imshow(k);
sam=k;
m=imadjust(rgb2gray(k));
[r c]=size(k);
BW = edge(m,'canny');
% imshow(BW);
[H,T,R] = hough(BW);
imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
P  = houghpeaks(H,1,'threshold',ceil(0.9*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
lines = houghlines(BW,T,R,P,'FillGap',0.8*c,'MinLength',40);
figure, imshow(k), hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',5,'Color','green');
end
figure;
if(lines.theta<0)
g=imrotate_white(m,(90-abs(lines.theta)));
else
    g=(imrotate_white(m,lines.theta-90));
end
subplot(1,2,1);
imshow(sam);
subplot(1,2,2);imshow(g);
%%
figure;
imshow(g);
m=ocr(g);
disp(m.Text);

function rotated_image = imrotate_white(image, rot_angle_degree)
    RA = imref2d(size(image));    
    tform = affine2d([cosd(rot_angle_degree)    -sind(rot_angle_degree)     0; ...
                      sind(rot_angle_degree)     cosd(rot_angle_degree)     0; ...
                      0                          0                          1]);
      Rout = images.spatialref.internal.applyGeometricTransformToSpatialRef(RA,tform);
      Rout.ImageSize = RA.ImageSize;
      xTrans = mean(Rout.XWorldLimits) - mean(RA.XWorldLimits);
      yTrans = mean(Rout.YWorldLimits) - mean(RA.YWorldLimits);
      Rout.XWorldLimits = RA.XWorldLimits+xTrans;
      Rout.YWorldLimits = RA.YWorldLimits+yTrans;
      rotated_image = imwarp(image, tform, 'OutputView', Rout, 'interp', 'cubic', 'fillvalues', 255);
  end