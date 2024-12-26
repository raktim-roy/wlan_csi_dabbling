clear all;
fs=50;
n=0:1/fs:100;
f=2;
x=cos(2*pi*f*n);

figure(1)
plot(n,x);


% Find FFT

Xf = fft(x);
Xf_corrected=Xf(1,ceil(length(Xf)/2));
xifft= ifft(Xf_corrected);

figure(3)
plot(n,(xifft));
