% Load the audio signals
audio1 = audioread('data/posture1_UMA8SP_audio.wav');
audio2 = audioread('data/posture2_UMA8SP_audio.wav');
audio3 = audioread('data/posture3_UMA8SP_audio.wav');

% Convert audio signals to spectrograms
spectrogram1 = abs(spectrogram(audio1));
spectrogram2 = abs(spectrogram(audio2));
spectrogram3 = abs(spectrogram(audio3));

% Apply PCA to reduce dimensionality
[coeff1, ~, ~, ~, ~] = pca(spectrogram1);
[coeff2, ~, ~, ~, ~] = pca(spectrogram2);
[coeff3, ~, ~, ~, ~] = pca(spectrogram3);

% Use the first three principal components
num_components = 3;
vector1_pca = spectrogram1 * coeff1(:,1:num_components);
vector2_pca = spectrogram2 * coeff2(:,1:num_components);
vector3_pca = spectrogram3 * coeff3(:,1:num_components);

% Apply K-means clustering
k = 3; % Number of clusters
[idx1, ~] = kmeans(vector1_pca, k, 'MaxIter', 1000);
[idx2, ~] = kmeans(vector2_pca, k, 'MaxIter', 1000);
[idx3, ~] = kmeans(vector3_pca, k, 'MaxIter', 1000);

% Plot K-means clustering results for audio 1
figure;
scatter3(vector1_pca(:,1), vector1_pca(:,2), vector1_pca(:,3), 10, idx1, 'filled');
title('K-means Clustering - Posture1');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
zlabel('Principal Component 3');
colorbar;

% Plot K-means clustering results for audio 2
figure;
scatter3(vector2_pca(:,1), vector2_pca(:,2), vector2_pca(:,3), 10, idx2, 'filled');
title('K-means Clustering - Posture2');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
zlabel('Principal Component 3');
colorbar;

% Plot K-means clustering results for audio 3
figure;
scatter3(vector3_pca(:,1), vector3_pca(:,2), vector3_pca(:,3), 10, idx3, 'filled');
title('K-means Clustering - Posture3');
xlabel('Principal Component 1');
ylabel('Principal Component 2');
zlabel('Principal Component 3');
colorbar;
