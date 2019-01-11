
 [a,sr] = audioread('TpC-slap-G3-p.wav');
  setting.sct = 1000;
  addpath(genpath('../libs/scatnet'))
scat_opt.M = 2;
scat_opt.oversampling = 1;
scat_opt.path_margin = 1;

tm_filt_opt = struct();
tm_filt_opt.Q = [12 1];
tm_filt_opt.J = T_to_J(sr*setting.sct/1000, tm_filt_opt);

% NOTE: The parameter `fr_filt_opt.J` controls the largest scale
% along the frequency axis as a power of two. For `J = 4`, this
% means a largest frequency scale of `2^4 = 16`, which is equal to
% 1.5 octaves since `Q = 12`.
fr_filt_opt = struct();
fr_filt_opt.J = 4;

Wop = joint_tf_wavelet_factory_1d(size(a, 1), tm_filt_opt, ...
    fr_filt_opt, scat_opt);

S = scat(a(:,1), Wop);