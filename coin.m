%%%图像处理实验——硬币检测
I = imread('Chinacoins1.jpg');
 I=imresize(I,0.5);
[m,n,l] = size(I);
tempImg=I;
if l == 3
    I = rgb2gray(I);    %如果为彩色图 则转化为灰度图
end
imshow(tempImg)
I1=im2bw(I,graythresh(I));   %转化为二值图像
I2=imopen(I1,strel('disk',3));   %开运算   平滑图像边缘
I3=imfill(~I2,'holes');  %填充图像空洞,~I2为对I2图像取反
I22=~I2;


%I4=bwareaopen(I3,1500);%删除二值图像BW中面积小于1500的对象


BW = edge(I3,'sobel');  
 
step_r = 8;  
step_angle = 0.5;  
minr =60;
maxr = 150;  
thresh = 0.666;  
 
[Hough_Space,Hough_Circle,para] = hough_circle(BW,step_r,step_angle,minr,maxr,thresh);  
subplot(2,3,1);
imshow(tempImg),title('原始图像')  
subplot(2,3,2);
imshow(BW),title('边缘检测')  
subplot(2,3,3);
imshow(Hough_Circle),title('检测结果')  

circleParaXYR=para;  
 
%输出  
%fprintf(1,'\n---------------圆统计----------------\n');  
[r,c]=size(circleParaXYR);%r=size(circleParaXYR,1);  
fprintf(1,'共检测出%d个硬币\n',r);%硬币的个数
radius=[];
for n=1:r  
    fprintf(1,'硬币%d  圆心（%d，%d） 半径值 %d\n',n,floor(circleParaXYR(n,1)),floor(circleParaXYR(n,2)),floor(circleParaXYR(n,3)));  
    radius=[radius;floor(circleParaXYR(n,3))];
end  

 
%标出圆  
subplot(2,3,4);
imshow(I),title('检测出图中的圆')  
hold on;  
 plot(circleParaXYR(:,2), circleParaXYR(:,1), 'r+');  
 for k = 1 : size(circleParaXYR, 1)  
  t=0:0.01*pi:2*pi;  
  x=cos(t).*circleParaXYR(k,3)+circleParaXYR(k,2);y=sin(t).*circleParaXYR(k,3)+circleParaXYR(k,1);  
  plot(x,y,'r-');  
 end
 
%检测硬币数量   
[m,n,l] = size(tempImg);
coin5=0;%一角
coin1=0;%五角
coin10=0;%一元
subplot(2,3,5);
imshow(tempImg),title('硬币数量检测') 
hold on;  
 for k=1:13
     num=0;
    r=[];
    g=[];
    b=[];
    
    for i=para(k,2)-100:para(k,2)+100 %方形区域检测效率更好
        for j=para(k,1)-100:para(k,1)+100
            %plot(para(k,2),para(k,1),'o'); 
            if ((para(k,2)-i)^2+(para(k,1)-j)^2 < para(k,3)^2)
                %plot(para(k,2),para(k,1),'o'); 
                %=r+tempImg(j,i,1);
                %g=g+tempImg(j,i,2);
                %b=b+tempImg(j,i,3);
                r=[r;tempImg(j,i,1)];
                g=[g;tempImg(j,i,2)];
                b=[b;tempImg(j,i,3)];
                num=num+1;
                end
            end    
        end
 
    fprintf('RGB均值为R%d G%d B%d 像素%d\n',round(mean(r(:))),round(mean(g(:))),round(mean(b(:))),num);
    if round(mean(r(:)))>110&&round(mean(b(:)))<100&&para(k,3)<90%检测到的rgb平均值接近黄色
        coin5=coin5+1;
        text(para(k,2),para(k,1),[num2str(k),'五角硬币'],'FontSize',6,'FontWeight','bold')%图片圆标识编号
    else if para(k,3)<90
        coin1=coin1+1;
        text(para(k,2),para(k,1),[num2str(k),'一角硬币'],'FontSize',6,'FontWeight','bold')%图片圆标识编号
    else if para(k,3)>90
        coin10=coin10+1;
        text(para(k,2),para(k,1),[num2str(k),'一元硬币'],'FontSize',6,'FontWeight','bold')%图片圆标识编号
        end
        end
    end
        
 end
 subplot(2,3,6);
 bar(radius),title('尺寸直方图') ;
 xlabel('硬币')
 ylabel('半径')
 money=0.1*coin1+0.5*coin5+1*coin10;
 fprintf('五角硬币数量:%d,一角硬币数量:%d,一元硬币数量:%d,总金额:%.2f\n',coin5,coin1,coin10,money)
