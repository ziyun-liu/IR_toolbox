function [  ] = peek_IRD_cell( IRD , oct_sm)
% Take a peek of IR and its freq response

for i=1:size(IRD.IR,1)
    for j=1:size(IRD.IR,2)
        idx = (i-1)*size(IRD.IR,2)+j;
        IR(:,idx) = IRD.IR{i,j}; 
        [ mag_dB(:,idx), f_lin ] = ir2mag_dB(IR(:,idx), IRD.fs, IRD.length);
        mag_dB_sm(:,idx) = smoothSpectrum(mag_dB(:,idx),f_lin',oct_sm);
    end
end
figure;
subplot(2,1,1);
plot(IR);
subplot(2,1,2);
semilogx(f_lin,mag_dB_sm);xlim([20 20000]);

end

