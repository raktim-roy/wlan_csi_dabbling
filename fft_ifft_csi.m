clear all;
fs=50;
n=0:1/fs:100;
NFFT=128;
f=2;
x=cos(2*pi*f*n);
f_axis = -fs/2:(fs/(NFFT)):fs/2-(fs/(2*NFFT));

xdft = fft(x,NFFT);  
xhat = ifft(xdft,NFFT);

xfft_f1= xdft(1:ceil(length(xdft)/2));
xfft_f2= abs(xfft_f1).*exp(angle(xfft_f1).*-1i);
xfft_f2_corrected = flip(xfft_f2(1:end));
xfft_2sided = [xfft_f1 xfft_f2_corrected(1:end)];
xfft= (xfft_2sided);

figure(1)
plot(angle(xdft));

figure(2)
plot(angle(xfft));

figure(3)
plot(f_axis,fftshift(abs(xdft)));

figure(4)
plot(f_axis,abs(fftshift(xfft)));

xt=ifft(xfft);

figure(5)
plot(real(xt));