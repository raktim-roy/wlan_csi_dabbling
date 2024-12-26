%Algorithm 1
pkg load signal;
%Read CSI data
close all;
clear all;
[csi] = read_csi_data('./txpower_30db_1.pcap');
csi = fliplr(csi);

csi_mag_in =abs(csi); # computing the magnitude of CSI data
csi_mag = resample(csi_mag_in,5,50); # Down sampled the data
csi_mag(:, ([1:6, 127:129, 252:256])) = []; #Remove pilot and Null subcarriers
##s=256;
p=length(csi);
##disp(p);
np=2^(log2(p));
alpha= 1;
window= 5;
overlap = 0;
n_frames = ceil(length(csi)/(window-overlap));

% filtering the data 
##
## sf = 50; sf2 = sf/2;
## [b,a]=butter ( 2, ([0.1 0.3])/sf2,"bandpass");
## csi_mag_filt = filter(b,a,csi_mag(:,71:95));
## var_avg =0;
## del_avg = 0;

 
for i=2:n_frames-5
  csi_opt = var(csi_mag((i)*(window-overlap):(i)*(window-overlap)+window,:));
  csi_var(i,:) = round(csi_opt * 10)/10; 
  median_variance = median(csi_var(i,:));
  index_median(i) = min(find(csi_var(i,:)== median_variance));
endfor

##figure();
##plot(csi_var);
##figure();
##plot(csi_mag_filt)
##figure();
##plot(var_csi)
##
##figure();
##plot( csi_mag_filt(:,1))