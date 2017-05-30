%%This function is find peaks and get detailed information of them

%ph:a row matrix of peak height; 
%px:a row matrix of peak location;
%w:a row matrix of peak width;
%p:don't care about it
%tl:changed time duration as 'min'

function [ph,px,w,p,tl] = fpeak(X,Yo,n)
fs=5000; %sampling rate = 5000 Hz
x=X;
y=Yo;
[yc, yb, l]=basecor(y); %correct baseline
tl=fix(l/200)*200/fs/60
% ycf=wden(yc,'heursure','s','mln',3,'sym7');
% dthre=median(yc)+n*std(yc);
thre=median(yc)+n*mad(yc,1)/0.6745;
[ph,px,w,p]=findpeaks(yc,'MinPeakHeight',thre, 'MinPeakWidth',2, 'MinPeakDistance', 15);
% [ph,px,w,p]=findpeaks(yc,'MinPeakHeight',thre, 'MinPeakWidth',2, 'MinPeakDistance', 15);
% pthre=median(ph)+7*mad(ph,1)/0.6745;
% pInd=find(ph>pthre);
% ph=ph(pInd);
% px=px(pInd);
% w=w(pInd);
% p=p(pInd);
t=(px-1)/fs;
figure
stem(t,yc(px)); % mark the peaks, but I find it shifts a bit
hold on
plot(x(1:l),yc);
plot([x(1),x(end)],[thre thre],'--b'); %plot threhold line
% plot([x(1),x(end)],[pthre pthre],'--r');
% plot([x(1),x(end)],[dthre dthre],'--g');
hold off