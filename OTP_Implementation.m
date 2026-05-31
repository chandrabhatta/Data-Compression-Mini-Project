clear;
close all;

%% Plaintext:
base = ['einstein rosen bridges or er bridges named after albert einstein and nathan rosen are connections'....
     'between areas of space that can be modeled as vacuum solutions to the einstein field equations and'.....
     'that are now understood to be intrinsic parts of the maximally extended version of the schwarzschild'.... 
     ' metric describing an eternal black hole with no charge and no rotation here maximally extended refers to the'.....
     'idea that the spacetime should not have any edges it should be possible to continue this path arbitrarily far'....
     'into the particles future or past for any possible trajectory of a free falling particle following a geodesic in'.....
     ' the spacetime in order to satisfy this requirement it turns out that in addition to the black hole interior region'.....
     'that particles enter when they fall through the event horizon from the outside there must be a separate white hole '.....
     'interior region that allows us to extrapolate the trajectories of particles that an outside observer sees rising up away'.....
     'from the event horizon and just as there are two separate interior regions of the maximally extended spacetime there are '.....
     'also two separate exterior regions sometimes called two different universes with the second universe allowing us to extrapolate'....
     'some possible particle trajectories in the two interior regions this means that the interior black hole region can contain a mix'....
     'of particles that fell in from either universe and likewise particles from the interior white hole region can escape into either'.....
     'universe all four regions can be seen in a spacetime diagram that uses kruskal szekeres coordinates in this spacetime it is possible'.....
     'to come up with coordinate systems such that if a hypersurface of constant time is picked and an embedding diagram is drawn depicting'......
     'the curvature of space at that time the embedding diagram will look like a tube connecting the two exterior regions known as an einstein'.....
     'rosen bridge the schwarzschild metric describes an idealized black hole that exists eternally from the perspective of external observers a more'.....
     'realistic black hole that forms from a collapsing star would require a different metric when infalling stellar matter is added to a diagram of a'....
     'black holes geometry it removes the part corresponding to the white hole region along with the other universe the einstein rosen bridge was discovered'.....
     'by ludwig flamm a few months after schwarzschild published his solution and was rediscovered by albert einstein and nathan rosen john archibald wheeler'.....
     'and robert fuller showed that this type of wormhole is unstable if it connects two parts of the same universe and it pinches off too quickly for light'....
     'that falls in from one region to reach the other region according to general relativity gravitational collapse of sufficiently compact mass forms a'....
     'singular schwarzschild black hole in the einstein cartan sciama kibble theory of gravity it forms a regular einstein rosen bridge this theory extends'.....
     'general relativity by treating torsion as a dynamic variable torsion accounts for intrinsic angular momentum of matter and generates a repulsive spin'....
     'spin interaction at extremely high densities this prevents formation of a gravitational singularity instead the collapsing matter reaches finite density'.....
     'and rebounds forming the other side of the bridge although schwarzschild wormholes are not traversable their existence inspired kip thorne to imagine'.....
     'traversable wormholes held open with exotic matter other non traversable wormholes include lorentzian wormholes wormholes creating spacetime foam'.....
     'in a general relativistic spacetime manifold and euclidean wormholes'];

txt = base;

%% Build the PMF of plaintext characters from character frequencies.

chars = char(txt);
symbs = unique(chars);

M = uint8(txt);
A = 0:255;

% Count the frequencies:

freqs = zeros(size(symbs));

for i = 1:length(symbs)
    freqs(i) = sum(chars == symbs(i));
end

% Frequency to Probability:

N = length(chars);

probs = freqs / N;


% Display the PMF:

T = table(cellstr(symbs'), freqs', probs', ...
    'VariableNames', {'Symbol','Frequency','Probability'});

disp(T);

% Plot the unconditional distribution:

figure;
stem(probs,'filled','LineWidth',1.5);

xticks(1:length(symbs));
xticklabels(cellstr(symbs'));

xlabel('Plaintext Character');
ylabel('Probability');
title('Unconditional Distribution P(M)');
grid on;

% Compute the entropy:

H_M = -sum(probs .* log2(probs));

%% Encrypt the plaintext with OTP:

N = length(M);

K = randi([0 255],1,N,'uint8');

C = bitxor(M,K);

%% Uniformity of key:

figure;
histogram(double(K),0:256,'Normalization','probability');

xlabel('Key Value');
ylabel('Probability');
title('Empirical Distribution of OTP Key');
grid on;

%% Choose c0 for conditional distrubution:

cipher_freq = histcounts(double(C),0:256);

[~,idx] = max(cipher_freq);

c0 = idx - 1;

fprintf('Chosen ciphertext symbol: %d\n',c0);
fprintf('Occurrences: %d\n',cipher_freq(idx));

%% Extract plaintext characters corresponding to C= c0:

positions = (C == c0);

plaintext_given_c = chars(positions);

%% Frequencies of plaintext characters in this subset:

cond_freqs = zeros(size(symbs));

for i = 1:length(symbs)
    cond_freqs(i) = sum(plaintext_given_c == symbs(i));
end

%% Convert to conditional probabilities:

cond_probs = cond_freqs / sum(cond_freqs);

%% Display conditional PMF tables:

T_cond = table(cellstr(symbs'), ...
               cond_freqs', ...
               cond_probs', ...
               'VariableNames', ...
               {'Symbol','Frequency','ConditionalProbability'});

disp(T_cond);

%% Plot unconditional distribution

figure;

stem(probs,'filled','LineWidth',1.5);

xticks(1:length(symbs));
xticklabels(cellstr(symbs'));

xlabel('Character');
ylabel('Probability');

title('Unconditional Distribution P(M)');

grid on;

%% Plot conditional distribution:

figure;

stem(cond_probs,'filled','LineWidth',1.5);

xticks(1:length(symbs));
xticklabels(cellstr(symbs'));

xlabel('Character');
ylabel('Probability');

title(['Conditional Distribution P(M|C=',num2str(c0),')']);

grid on;

%% Entropy of both distributions:

H_M = -sum(probs .* log2(probs + eps));

fprintf('H(M) = %.6f bits/symbol\n',H_M);

H_cond = -sum(cond_probs .* log2(cond_probs + eps));

fprintf('H(M|C=%d) = %.6f bits/symbol\n',c0,H_cond);

fprintf('Difference = %.6f bits\n',abs(H_M - H_cond));

%% VERSION 2

txt = repmat(base,1,2);   % version 2

%% Build the PMF of plaintext characters from character frequencies.

chars = char(txt);
symbs = unique(chars);

M = uint8(txt);
A = 0:255;

% Count the frequencies:

freqs = zeros(size(symbs));

for i = 1:length(symbs)
    freqs(i) = sum(chars == symbs(i));
end

% Frequency to Probability:

N = length(chars);

probs = freqs / N;


% Display the PMF:

T = table(cellstr(symbs'), freqs', probs', ...
    'VariableNames', {'Symbol','Frequency','Probability'});

disp(T);

% Plot the unconditional distribution:

figure;
stem(probs,'filled','LineWidth',1.5);

xticks(1:length(symbs));
xticklabels(cellstr(symbs'));

xlabel('Plaintext Character');
ylabel('Probability');
title('Unconditional Distribution P(M)');
grid on;

% Compute the entropy:

H_M = -sum(probs .* log2(probs));

%% Encrypt the plaintext with OTP:

N = length(M);

K = randi([0 255],1,N,'uint8');

C = bitxor(M,K);

%% Uniformity of key:

figure;
histogram(double(K),0:256,'Normalization','probability');

xlabel('Key Value');
ylabel('Probability');
title('Empirical Distribution of OTP Key');
grid on;

%% Choose c0 for conditional distrubution:

cipher_freq = histcounts(double(C),0:256);

[~,idx] = max(cipher_freq);

c0 = idx - 1;

fprintf('Chosen ciphertext symbol: %d\n',c0);
fprintf('Occurrences: %d\n',cipher_freq(idx));

%% Extract plaintext characters corresponding to C= c0:

positions = (C == c0);

plaintext_given_c = chars(positions);

%% Frequencies of plaintext characters in this subset:

cond_freqs = zeros(size(symbs));

for i = 1:length(symbs)
    cond_freqs(i) = sum(plaintext_given_c == symbs(i));
end

%% Convert to conditional probabilities:

cond_probs = cond_freqs / sum(cond_freqs);

%% Display conditional PMF tables:

T_cond = table(cellstr(symbs'), ...
               cond_freqs', ...
               cond_probs', ...
               'VariableNames', ...
               {'Symbol','Frequency','ConditionalProbability'});

disp(T_cond);

%% Plot unconditional distribution

figure;

stem(probs,'filled','LineWidth',1.5);

xticks(1:length(symbs));
xticklabels(cellstr(symbs'));

xlabel('Character');
ylabel('Probability');

title('Unconditional Distribution P(M)');

grid on;

%% Plot conditional distribution:

figure;

stem(cond_probs,'filled','LineWidth',1.5);

xticks(1:length(symbs));
xticklabels(cellstr(symbs'));

xlabel('Character');
ylabel('Probability');

title(['Conditional Distribution P(M|C=',num2str(c0),')']);

grid on;

%% Entropy of both distributions:

H_M = -sum(probs .* log2(probs + eps));

fprintf('H(M) = %.6f bits/symbol\n',H_M);

H_cond = -sum(cond_probs .* log2(cond_probs + eps));

fprintf('H(M|C=%d) = %.6f bits/symbol\n',c0,H_cond);

fprintf('Difference = %.6f bits\n',abs(H_M - H_cond));

%% VERSION 3

txt = repmat(base,1,4);

%% Build the PMF of plaintext characters from character frequencies.

chars = char(txt);
symbs = unique(chars);

M = uint8(txt);
A = 0:255;

% Count the frequencies:

freqs = zeros(size(symbs));

for i = 1:length(symbs)
    freqs(i) = sum(chars == symbs(i));
end

% Frequency to Probability:

N = length(chars);

probs = freqs / N;


% Display the PMF:

T = table(cellstr(symbs'), freqs', probs', ...
    'VariableNames', {'Symbol','Frequency','Probability'});

disp(T);

% Plot the unconditional distribution:

figure;
stem(probs,'filled','LineWidth',1.5);

xticks(1:length(symbs));
xticklabels(cellstr(symbs'));

xlabel('Plaintext Character');
ylabel('Probability');
title('Unconditional Distribution P(M)');
grid on;

% Compute the entropy:

H_M = -sum(probs .* log2(probs));

%% Encrypt the plaintext with OTP:

N = length(M);

K = randi([0 255],1,N,'uint8');

C = bitxor(M,K);

%% Uniformity of key:

figure;
histogram(double(K),0:256,'Normalization','probability');

xlabel('Key Value');
ylabel('Probability');
title('Empirical Distribution of OTP Key');
grid on;

%% Choose c0 for conditional distrubution:

cipher_freq = histcounts(double(C),0:256);

[~,idx] = max(cipher_freq);

c0 = idx - 1;

fprintf('Chosen ciphertext symbol: %d\n',c0);
fprintf('Occurrences: %d\n',cipher_freq(idx));

%% Extract plaintext characters corresponding to C= c0:

positions = (C == c0);

plaintext_given_c = chars(positions);

%% Frequencies of plaintext characters in this subset:

cond_freqs = zeros(size(symbs));

for i = 1:length(symbs)
    cond_freqs(i) = sum(plaintext_given_c == symbs(i));
end

%% Convert to conditional probabilities:

cond_probs = cond_freqs / sum(cond_freqs);

%% Display conditional PMF tables:

T_cond = table(cellstr(symbs'), ...
               cond_freqs', ...
               cond_probs', ...
               'VariableNames', ...
               {'Symbol','Frequency','ConditionalProbability'});

disp(T_cond);

%% Plot unconditional distribution

figure;

stem(probs,'filled','LineWidth',1.5);

xticks(1:length(symbs));
xticklabels(cellstr(symbs'));

xlabel('Character');
ylabel('Probability');

title('Unconditional Distribution P(M)');

grid on;

%% Plot conditional distribution:

figure;

stem(cond_probs,'filled','LineWidth',1.5);

xticks(1:length(symbs));
xticklabels(cellstr(symbs'));

xlabel('Character');
ylabel('Probability');

title(['Conditional Distribution P(M|C=',num2str(c0),')']);

grid on;

%% Entropy of both distributions:

H_M = -sum(probs .* log2(probs + eps));

fprintf('H(M) = %.6f bits/symbol\n',H_M);

H_cond = -sum(cond_probs .* log2(cond_probs + eps));

fprintf('H(M|C=%d) = %.6f bits/symbol\n',c0,H_cond);

fprintf('Difference = %.6f bits\n',abs(H_M - H_cond));
