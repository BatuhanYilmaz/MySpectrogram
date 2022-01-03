function spect_matrix = custom_spectrogram(x, len_window, num_overlap, num_fft, f_s, mode)

 % Make the audio signal mono, unless it's mono
 x = x(:,1);
 len_signal = length(x);
 
 % Calculate the hop length (how much the window is being moved to the RHS)
 len_hop = len_window - num_overlap;

 % Create and add a zero vector for zero-padding the signal
 my_pad = zeros((len_window - mod(len_signal, len_hop)),1);
 x_padded = cat(1, x, my_pad);

 % Calculate the number of iterations
 num_iter = floor((len_signal-len_window)/len_hop)+1;
 
 % Create a zero matrix for the spectrogram image
 spect_matrix = zeros(num_fft/2, num_iter);
 
for idx = 1:num_iter
    
    % applying Short-time Fourier Transform (STFT) of the given window
    out = stft(x_padded(idx*len_hop:idx*len_hop+len_window, 1), f_s, 'FFTLength', num_fft);
    
    % Only taking the positive frequencies for the image
    out = abs(out(1:num_fft/2,1));
    
    % Choose mode for which type of spectrogram will be calculated (linear by default)
    
    % Power spectrogram
    if strcmp(mode, 'power')
        %out = out.^2;

        out = (log(out) - log(min(out))) ./ (log(max(out)) - log(min(out)));
    
    % Mel-spectrogram
    elseif strcmp(mode, 'mel')
        %out = hz2mel(out);
    end
    %out = 2595 .* log10(out/700 + 1);
    size(out);
    
    spect_matrix(:,idx) = out;
    
end

end