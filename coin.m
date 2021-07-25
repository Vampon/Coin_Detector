%%%ͼ����ʵ�顪��Ӳ�Ҽ��
I = imread('Chinacoins1.jpg');
 I=imresize(I,0.5);
[m,n,l] = size(I);
tempImg=I;
if l == 3
    I = rgb2gray(I);    %���Ϊ��ɫͼ ��ת��Ϊ�Ҷ�ͼ
end
imshow(tempImg)
I1=im2bw(I,graythresh(I));   %ת��Ϊ��ֵͼ��
I2=imopen(I1,strel('disk',3));   %������   ƽ��ͼ���Ե
I3=imfill(~I2,'holes');  %���ͼ��ն�,~I2Ϊ��I2ͼ��ȡ��
I22=~I2;


%I4=bwareaopen(I3,1500);%ɾ����ֵͼ��BW�����С��1500�Ķ���


BW = edge(I3,'sobel');  
 
step_r = 8;  
step_angle = 0.5;  
minr =60;
maxr = 150;  
thresh = 0.666;  
 
[Hough_Space,Hough_Circle,para] = hough_circle(BW,step_r,step_angle,minr,maxr,thresh);  
subplot(2,3,1);
imshow(tempImg),title('ԭʼͼ��')  
subplot(2,3,2);
imshow(BW),title('��Ե���')  
subplot(2,3,3);
imshow(Hough_Circle),title('�����')  

circleParaXYR=para;  
 
%���  
%fprintf(1,'\n---------------Բͳ��----------------\n');  
[r,c]=size(circleParaXYR);%r=size(circleParaXYR,1);  
fprintf(1,'������%d��Ӳ��\n',r);%Ӳ�ҵĸ���
radius=[];
for n=1:r  
    fprintf(1,'Ӳ��%d  Բ�ģ�%d��%d�� �뾶ֵ %d\n',n,floor(circleParaXYR(n,1)),floor(circleParaXYR(n,2)),floor(circleParaXYR(n,3)));  
    radius=[radius;floor(circleParaXYR(n,3))];
end  

 
%���Բ  
subplot(2,3,4);
imshow(I),title('����ͼ�е�Բ')  
hold on;  
 plot(circleParaXYR(:,2), circleParaXYR(:,1), 'r+');  
 for k = 1 : size(circleParaXYR, 1)  
  t=0:0.01*pi:2*pi;  
  x=cos(t).*circleParaXYR(k,3)+circleParaXYR(k,2);y=sin(t).*circleParaXYR(k,3)+circleParaXYR(k,1);  
  plot(x,y,'r-');  
 end
 
%���Ӳ������   
[m,n,l] = size(tempImg);
coin5=0;%һ��
coin1=0;%���
coin10=0;%һԪ
subplot(2,3,5);
imshow(tempImg),title('Ӳ���������') 
hold on;  
 for k=1:13
     num=0;
    r=[];
    g=[];
    b=[];
    
    for i=para(k,2)-100:para(k,2)+100 %����������Ч�ʸ���
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
 
    fprintf('RGB��ֵΪR%d G%d B%d ����%d\n',round(mean(r(:))),round(mean(g(:))),round(mean(b(:))),num);
    if round(mean(r(:)))>110&&round(mean(b(:)))<100&&para(k,3)<90%��⵽��rgbƽ��ֵ�ӽ���ɫ
        coin5=coin5+1;
        text(para(k,2),para(k,1),[num2str(k),'���Ӳ��'],'FontSize',6,'FontWeight','bold')%ͼƬԲ��ʶ���
    else if para(k,3)<90
        coin1=coin1+1;
        text(para(k,2),para(k,1),[num2str(k),'һ��Ӳ��'],'FontSize',6,'FontWeight','bold')%ͼƬԲ��ʶ���
    else if para(k,3)>90
        coin10=coin10+1;
        text(para(k,2),para(k,1),[num2str(k),'һԪӲ��'],'FontSize',6,'FontWeight','bold')%ͼƬԲ��ʶ���
        end
        end
    end
        
 end
 subplot(2,3,6);
 bar(radius),title('�ߴ�ֱ��ͼ') ;
 xlabel('Ӳ��')
 ylabel('�뾶')
 money=0.1*coin1+0.5*coin5+1*coin10;
 fprintf('���Ӳ������:%d,һ��Ӳ������:%d,һԪӲ������:%d,�ܽ��:%.2f\n',coin5,coin1,coin10,money)
