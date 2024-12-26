%Algorithm 1
pkg load signal;
%Read CSI data
close all;
clear all;
[csi] = read_csi_data('./txpower_30db_1.pcap');
csi = fliplr(csi);
csi_mag =abs(csi);
s=256;
p=length(csi);
np=2^(log2(p));
alpha= 1;
window= 50;
overlap = 0;
n_frames = ceil(length(csi)/(window-overlap));

% filtering the data 

 sf = 50; sf2 = sf/2;
 [b,a]=butter ( 2, ([0.1 0.3])/sf2,"bandpass");
 csi_mag_filt = filter(b,a,csi_mag(:,71:95));
 var_avg =0;
 del_avg = 0;
 
for i=2:n_frames-1
  csi_var(i) = std(csi_mag_filt((i)*(window-overlap):(i)*(window-overlap)+window)); 
  var_avg = (var_avg + csi_var(i) )/2;
  var_csi(i) =var_avg;
  del_csi(i)= var_csi(i) - var_csi(i-1);
  del_avg = (del_avg + del_csi(i))/2;
  del(i) = del_avg;
endfor

figure();
plot(csi_var);
figure();
plot(csi_mag_filt)
figure();
plot(var_csi)

figure();
plot( csi_mag_filt(:,1))