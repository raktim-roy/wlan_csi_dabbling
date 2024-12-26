function [csi] = read_csi_data(wifi_data)
  
    CHIP = '43455c0';          % wifi chip (possible values 4339, 4358, 43455c0, 4366c0)
    BW = 80;                % bandwidth
    FILE = wifi_data;% capture file
    NPKTS_MAX = 10000;       % max number of UDPs to process

    %% read file
    HOFFSET = 16;           % header offset
    NFFT = BW*3.2;          % fft size
    p = readpcap();
    p.open(FILE);
    n = min(length(p.all()),NPKTS_MAX);
    %disp(n);
    p.from_start();
    csi_buff = complex(zeros(n,NFFT),0);
    k = 1;
    pilot_sc = [-128, -127, -126, -125, -124, -123, -1, 0, 1, 123, 124, 125, 126, 127];
    %&& abs(k) != 128 && abs(k) != 127 && abs(k) != 126 && abs(k) != 125 && abs(k) != 124 && abs(k) != 123 && abs(k) != 1 && abs(k) != 0
    while (k <= n )
        f = p.next();
        if isempty(f)
            disp('no more frames');
            break;
        end
        if f.header.orig_len-(HOFFSET-1)*4 ~= NFFT*4
            disp('skipped frame with incorrect size');
            continue;
        end
        payload = f.payload;
        H = payload(HOFFSET:HOFFSET+NFFT-1);
        if (strcmp(CHIP,'4339') || strcmp(CHIP,'43455c0'))
            Hout = typecast(H, 'int16');
        elseif (strcmp(CHIP,'4358'))
            Hout = unpack_float(int32(0), int32(NFFT), H);
        elseif (strcmp(CHIP,'4366c0'))
            Hout = unpack_float(int32(1), int32(NFFT), H);
        else
            disp('invalid CHIP');
            break;
        end
        Hout = reshape(Hout,2,[]).';
        cmplx = double(Hout(1:NFFT,1))+1j*double(Hout(1:NFFT,2));
        csi_buff(k,:) = cmplx.';
      %  disp(k);
        k = k + 1;
    end
    
    csi = csi_buff;
    
endfunction
