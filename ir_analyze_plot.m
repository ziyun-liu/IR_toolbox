function [  ] = ir_analyze_plot( IR_original , oct_sm, n_trim, pre_delay, mic_sen_mkp,fs)
% Take a peek of IR and its freq response

% Change Log:
% 2020-03-02    First Ed. by Liu Ziyun

if nargin < 6
    fs = 48e3;
    if nargin < 5
        mic_sen_mkp = 0;

        if nargin < 4
            pre_delay = 16;

            if nargin < 3
                n_trim = 8192;

                if nargin < 2
                    oct_sm = 3;
                end

            end
        end
    end
end
        
fl = 20;

for idx = 1:size(IR_original,2)
    if n_trim > 0
        IR(:,idx) = ir_trim ( IR_original(:,idx), n_trim, pre_delay); 
        nfft = n_trim;
    else
        IR(:,idx) = IR_original(:,idx);
        nfft = size(IR(:,idx),1);
    end

    [ mag(:,idx), phase(:,idx), f_lin ] = ir2magphase(IR(:,idx), fs, nfft);
    fl_idx = find(f_lin>fl,1,'first');

%     phase(1:fl_idx,idx) = 0;
    
    mag_dB(:,idx) = db(mag(:,idx));    
    mag_dB_sm(:,idx) = smoothSpectrum(mag_dB(:,idx),f_lin',oct_sm);
    mag_dB_sm(:,idx) = mag_dB_sm(:,idx)+mic_sen_mkp;
    
    [phd(:,idx), w] = phasedelay(IR(:,idx),1,nfft,fs);
    phd(:,idx) = phd(:,idx)./(2*pi);
    pha(:,idx) = unwrap(phase(:,idx));
    pha_sm(:,idx) = smoothSpectrum(pha(:,idx),f_lin',oct_sm);

end

figure;
subplot(3,2,1);
plot(IR_original);
title('IR Original');

subplot(3,2,2);
plot(IR);
title('IR Trimed');

subplot(3,2,3);
semilogx(f_lin,mag_dB_sm);xlim([0 20000]);
title('Mag dB sm');

subplot(3,2,4);
semilogx(f_lin,phase);xlim([0 20000]);
title('Phase');
ylim([-pi pi]);

subplot(3,2,5);
semilogx(w,phd);xlim([0 20000]);
title('Phase Delay');

subplot(3,2,6);
semilogx(f_lin',pha);xlim([20 20000]);
title('Phase sm ');



end

