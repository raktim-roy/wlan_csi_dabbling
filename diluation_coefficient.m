% Input: Cd; S; P;Cl;CU;Mc;D.
pkg load signal;
%Read CSI data
close all;
clear all;
[csi] = read_csi_data('./txpower_10db_1.pcap');
csi = fliplr(csi); # correcting the index of subcarrier
csi_mag_in =abs(csi); # computing the magnitude of CSI data
csi_mag = resample(csi_mag_in,5,50); # Down sampled the data
csi_angle = angle(csi); # computing the angle of CSI data

% filtering the data 
##sf = 5; sf2 = sf/2;
##[b,a]=butter ( 2, ([0.1 0.3])/sf2,"bandpass");
##csi_mag_filt = filter(b,a,csi_mag(:,71:95));
##csi_mag_filt= csi_mag_filt';

% Without filter 
csi_mag_filt= csi_mag(:,71:95)'; # For Making the calculation as in base paper Mc x P
# converting the row to column

# PEM computation 

# Input for PEM computation 

for n_d=1

  p=5; # No of CSI packtes (Frame size)
  D=2+(n_d-1)*5; # Dilation coefficient
  Mc=25; # No of sub carriers 
  s=25; # S and Mc are same 
  t_frame= ceil(length(csi_mag)/p); # Comuting total number of frame
  csi_trunc=[]; # CSI data visualization - Temp / dummy variable
  #cu=2500; # Max value of CSI data - Normalization factor
  #cl=0; # Min value of CSI data - Normalization factor

  # PEM algorithm 

  for n_frame =0:t_frame-2
    #tic (); # For computing loop time
    csi_frame = csi_mag_filt(:,n_frame*p+1:n_frame*p+p); # Pick a frame
    csi_trunc = [csi_trunc csi_frame]; # Storing in a dummy variable for visualization
    cu=max(max(csi_frame));
    cl=min(min(csi_frame));

    for i=1:s
      
      M=zeros(Mc,p); # CSI matrix - Single frame data
      
      for j=1:p
        #cu=max((csi_frame(i,:)));
        #cl=min((csi_frame(i,:)));
        k=floor((abs((csi_frame(i,j)-cl)/(cu-cl))*(Mc-1)))+1; # K is Row number of M
        %k=round((((csi_frame(i,j))/(cu-cl))*(Mc-1))+1);
        K(i,j)= k; # Dummy variable to verify k value 
        
        # Dilate the M matrix
        # For D =1 , there will be 8 surrounding elements
       
        for u=-D:D # column number
          for v=-D:D # Row number
            
            if (k+v>=1 && k+v <= Mc && j+u >= 1 && j+u <= p)
              # M(Row,Column) is replaced with 1
              M(k+v,j+u)=1;
             
            endif
        
          endfor
        endfor
          
      
      endfor
    
      t_ones = sum(sum(M)); # Counting the number of 1

      pem(n_frame+1,i) = t_ones / (p*Mc) ; # Coumputing the percentage of non zero element 
      
      
    endfor
    
    #elapsed_time = toc (); # getting the total loop time
  endfor
  
  pem_nd(:,n_d)=pem(:,5);
  
endfor 

# Additional step
# Averaging the PEM data 

pem_avg = zeros(1,s);

for i=2:length(pem)-1
  pem_avg = (pem_avg + pem(i,:) )/2;
  pem_csi(i,:) =pem_avg;
  d_pem_csi(i,:) = pem_avg - pem_csi(i-1,:);
endfor

# Plotting the PEM data for the complete data 

csi_trunc= csi_trunc';
t= (0:1:length(pem)-2);
figure()
#plot(t,pem_csi(:,15))
avg=sum(pem_csi')/25;
plot(t,avg);
xlabel('Time');
ylabel('PEM');

# Plotting the CSI data for the complete data 

t= (0:1:length(csi_trunc)-1);
figure()
plot(t,csi_trunc(:,1))
xlabel('Time');
ylabel('CSI');

# Plotting the delta of average PEM data for the complete data 
##figure()
##plot(t,abs(d_pem_csi(:,1)))