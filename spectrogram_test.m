%% Parameters

n_fft = 8192;
len_window = 256;
num_overlap = 128;
fs = 44100;

% Mel filterbank parameters

K = n_fft/2;
num_of_mels = 512;
freq_limiter = [0 fs/2];

hz2mel = @(hz)(1127*log(1+hz/700)); % Hertz to mel warping function
mel2hz = @(mel)(700*exp(mel/1127)-700); % mel to Hertz warping function


%%
%t = 0:1e-5:2;
%x = chirp(t,2000,1,20000,'quadratic')';
x = audioread("C:\Users\batuh\Desktop\My Desktop\Workspaces\MATLAB WORKSPACE\EE473\Project\sp10.wav");
%x = audioread("C:\Users\batuh\Desktop\My Desktop\Workspaces\MATLAB WORKSPACE\EE473\Project\passerDomesticus.mp3");

my_spect_matrix_linear = custom_spectrogram(x, len_window, num_overlap, n_fft, fs, 'linear');
my_spect_matrix_power = custom_spectrogram(x, len_window, num_overlap, n_fft, fs, 'power');
%my_spect_matrix_mel = custom_spectrogram(x, len_window, num_overlap, n_fft, fs, 'power');


[ H1, freq ] = trifbank( num_of_mels, K, freq_limiter, fs, hz2mel, mel2hz );
my_spect_matrix_mel = H1*my_spect_matrix_linear;

spec_size = [200 200];

figure(1)
%subplot(1,3,1)
sh = surf(flipud(my_spect_matrix_linear));
view(0, 90)
axis tight
set(gca, 'YScale', 'linear')
set(sh, 'LineStyle','none')
%imshow(imresize(my_spect_matrix_mel, spec_size))
%colormap jet

figure(2)
%subplot(1,3,2)
sh = surf(flipud(my_spect_matrix_power));
view(0, 90)
axis tight
set(gca, 'YScale', 'log')
set(sh, 'LineStyle','none')
%imshow(imresize(my_spect_matrix_mel, spec_size))
%colormap jet

figure(3)
%subplot(1,3,3)
sh = surf(flipud(my_spect_matrix_mel));
view(0, 90)
axis tight
set(gca, 'YScale', 'log')
set(sh, 'LineStyle','none')
%imshow(imresize(my_spect_matrix_mel, spec_size))
%colormap jet

