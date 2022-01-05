%% Get sound input

%t = 0:1e-5:2;
%x = chirp(t,2000,1,20000,'quadratic')';
[x, fs] = audioread("C:\Users\batuh\Desktop\My Desktop\Workspaces\MATLAB WORKSPACE\EE473\Project\sp10.wav");
%[x, fs] = audioread("C:\Users\batuh\Desktop\My Desktop\Workspaces\MATLAB WORKSPACE\EE473\Project\passerDomesticus.mp3");
%x = x(95000:110000,1);
figure(54)
plot(x);

%% Parameters

n_fft = 2048;
len_window = 256;
num_overlap = 128;
fs = 16000;

% Mel filterbank parameters
K = n_fft/2+1;
num_of_mels = 50;
freq_limiter = [0 fs];

% Mel-Hertz conversion formulas
hz2mel = @(hz)(1127*log(1+hz/700)); % Hertz to mel warping function
mel2hz = @(mel)(700*exp(mel/1127)-700); % mel to Hertz warping function

% Gammatone filterbank parameters
num_gfb = 25;
freq_limiter_gfb = [0 fs/2];

%% Calculate linear and power spectrogram

my_spect_matrix_linear = custom_spectrogram(x, len_window, num_overlap, n_fft, fs, 'linear');
my_spect_matrix_power = custom_spectrogram(x, len_window, num_overlap, n_fft, fs, 'power');
%my_spect_matrix_mel = custom_spectrogram(x, len_window, num_overlap, n_fft, fs, 'power');

figure(1)
subplot(1,3,1)
sh = surf(my_spect_matrix_linear);
view(0, 90)
axis tight
set(gca, 'YScale', 'linear')
set(sh, 'LineStyle','none')
colormap hot

%figure(2)
subplot(1,3,2)
sh = surf(my_spect_matrix_power);
view(0, 90)
axis tight
set(gca, 'YScale', 'log')
set(sh, 'LineStyle','none')
colormap hot

%% Calculate mel spectrogram

% Calculate mel filterbank
[ H1, freq ] = trifbank( num_of_mels, K, freq_limiter, fs, hz2mel, mel2hz );
my_spect_matrix_mel = H1*my_spect_matrix_linear;

% Plot mel filterbank
figure(10)
plot(freq, H1)

%figure(3)
figure(1)
subplot(1,3,3)
sh = surf(my_spect_matrix_mel);
view(0, 90)
axis tight
set(gca, 'YScale', 'log')
set(sh, 'LineStyle','none')
colormap hot

%% Calculate MFCC

% Take the log of the mel-filtered spectrogram
my_mfcc_log = log10(my_spect_matrix_mel);
% Apply discrete cosine transform (DCT) to the log transformed signal
my_mfcc = dct(my_mfcc_log,14);

% Plot the MFCC

figure(4)
subplot(1,2,1)
sh = surf(my_mfcc);
view(0, 90)
axis tight
set(gca, 'YScale', 'linear')
set(sh, 'LineStyle','none')
%imshow(imresize(my_spect_matrix_mel, spec_size))
colormap hot

%% Calculate GFCC

% Create a gammatone filter bank
H_gt = gammatoneFilterBank('FrequencyRange' , freq_limiter_gfb, 'SampleRate', fs, 'NumFilters', num_gfb);

% Plot gammatone filterbank
%subplot(1,4,3)
fvtool(H_gt);

% Apply the gammatone filterbank
my_spect_matrix_gt = abs(H_gt(my_spect_matrix_linear));

% Take the log of the gammatone-filtered spectrogram
size_my_spect_matrix_gt = size(my_spect_matrix_gt);

my_spect_matrix_gt = reshape(sum(my_spect_matrix_gt,1),[size_my_spect_matrix_gt(2) size_my_spect_matrix_gt(3)]);

my_gfcc_log = log10(my_spect_matrix_gt);
%my_gfcc_log = log10(reshape(my_spect_matrix_gt(n_fft/2+1,:,:),[size_my_spect_matrix_gt(2) size_my_spect_matrix_gt(3)] ) );

my_gfcc = dct(my_gfcc_log,14);

% Plot the GFCC
figure(4)
subplot(1,2,2)
sh = surf(my_gfcc);
view(0, 90)
axis tight
set(gca, 'YScale', 'linear')
set(sh, 'LineStyle','none')
%imshow(imresize(my_spect_matrix_mel, spec_size))
colormap hot

