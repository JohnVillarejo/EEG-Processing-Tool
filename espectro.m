function [eje_f,mag_ss]=espectro(s,fs,flag)
% s: signal
% fs: sampling frequency
% flag: 1 to plot the result, 0 to no plot

mag_ss=abs(ifft(s)); %magnitud del espectro de s 
[nm,nc]=size(mag_ss); %numero de muestras 
mag_ss=mag_ss(1:round(nm/2),:);
delta=fs/nm; 
eje_f= 0:delta:fs/2-delta; 
eje_t= 1/fs:1/fs:length(s)/fs; 

if flag
figure
subplot(211)
plot(eje_t,s)
title('Frequency spectrum')
xlabel('Time [s]')
ylabel('Amplitude [uV]')

subplot(212)
if nc==1
    plot(eje_f,mag_ss(1:length(eje_f)),'r')
else
    plot(eje_f,mag_ss(1:length(eje_f)))
end
xlabel('Frequency [Hz]')
ylabel('Power Spectrum')
end
