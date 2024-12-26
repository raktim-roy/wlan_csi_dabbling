%Read CSI data
clear all;
close all;
[csi] = read_csi_data('./person1_static.pcap');
csi = fliplr(csi);
csi_mag =abs(csi);
s=256;
p=length(csi);
np=2^(log2(p));
alpha= 1;

for i=1:p
  xfft_f1= [zeros(1) csi(i,:)];
  xfft_f2= abs(xfft_f1).*exp(angle(xfft_f1).*-1i);
  xfft_f2_corrected = fliplr(xfft_f2);
  xfft_2sided = [xfft_f1 xfft_f2_corrected(1:end-1)];
  xfft= (xfft_2sided);
  
  tmp(i,:)=ifft(xfft,2048);
  tmp1(i,:)=tmp(i,:);
  
  for j=floor(length(tmp(i,:))*alpha):length(tmp(i,:))
    tmp1(i,j) = 0;
  endfor
  
  csi_2sided(i,:)= fft(tmp1(i,:),512);
  csi_d(i,:) = csi_2sided(i,1:s);
    
endfor


figure(1)
plot((abs(csi_d(:,71))));

figure(2)
plot((abs(csi(:,70))));

figure(3)
plot(abs(tmp(i,:)));




