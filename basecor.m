%%This function is to correct the baseline drift by a subtract the median
%%of every 200 (lamda) time points.

%Ybc: corrected signal; 
%Yb: the baseline; 
%l: the length of outputed Ybc and Yb.

%It should be noted that the lengths of Ybc and Yb are a little bit
%different from x, because this function keeps integral multiples of 200
%(lamda). Less than 200 (lamda) time points at the end of the data are cut.

function [Ybc, Yb, l] = basecor(x)
lamda=200; %if peak is wider than 100 time points(20 ms), change this number to 5 folds of the time width at
m=length(x);
n=fix(m/lamda);

Yb(lamda*n)=0;
l=lamda*n; %NOTE: The length of the input x is changed.
Yb=Yb';

for i=1:n    
        Yb((lamda*i-lamda+1):lamda*i)=median(x((lamda*i-lamda+1):lamda*i));
end

for i=1:l
    Ybc(i)=x(i)-Yb(i);
end
