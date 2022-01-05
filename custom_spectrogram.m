function spect_matrix = custom_spectrogram(x, len_window, num_overlap, num_fft, fs, mode)

 % Make the audio signal mono, unless it's mono
 x = x(:,1);
 len_signal = length(x);
 
 % Calculate the hop length (how much the window is being moved to the RHS)
 len_hop = len_window - num_overlap;

 % Create and add a zero vector for zero-padding the signal
 my_pad = zeros((len_window - mod(len_signal, len_hop)),1);
 x_padded = cat(1, x, my_pad);

 % Calculate the number of iterations
 num_iter = floor((len_signal-len_window)/len_hop);
 
 % Create a zero matrix for the spectrogram image
 spect_matrix = zeros(num_fft/2+1, num_iter);

  % FOR THE FIRST TIME: applying Short-time Fourier Transform (STFT) of the given window
  x_padded_window = x_padded(1:len_window, 1);
  x_padded_window_hamm = x_padded_window.*hamming(length(x_padded_window));
  out = stft(x_padded_window_hamm, fs, 'FFTLength', num_fft, "FrequencyRange", "onesided");
  
  out_abs = abs(out(:,1));
    
for idx = 1:num_iter
    
    % Apply Short-time Fourier Transform (STFT) of the given window
    x_padded_window = x_padded(idx*len_hop:idx*len_hop+len_window, 1);
    x_padded_window_hamm = x_padded_window.*hamming(length(x_padded_window));
    
    % Take only the positive frequencies for the image (onesided)
    out = stft(x_padded_window_hamm, fs, 'FFTLength', num_fft, "FrequencyRange", "onesided");
    out_abs = abs(out(:,1));
  
    % Power spectrogram
    if strcmp(mode, 'power')
        out_abs = out_abs.^2;
    end
    spect_matrix(:,idx) = out_abs;
    
end     

end