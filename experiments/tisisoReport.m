function config = tisisoReport(config)
% tisisoReport REPORTING of the expLanes experiment timbralSimilaritySol
%    config = tisisoInitReport(config)
%       config : expLanes configuration state

% Copyright: Mathieu Lagrange
% Date: 09-Jan-2017

if nargin==0, timbralSimilaritySol('report', 'r', 'reportName', 'tt'); return; end

switch config.reportName
    case 'tt'
        % full
        mask = {4, 5, 2, 1, 2, 5, 1, 1, 2, 2, 2, 2, 1, 2, 1};
        config = expExpose(config, 'l', 'save', ['tt0'], 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'highlight', 0, 'precision', 3);
        mask = {4, 5, 2, 2, 2, 5, 1, 1, 2, 2, 2, 2, 1, 2, 1};
        factors  =   [1 7 3 3 2 1 1];
        modalities = [4 2 3 1 1 3 2];
        captions = {'split', 'random', 'lda', 'nolearning', '25ms', 'separable', 'mfcc', 'monomials'};
        for k=1:length(factors)
            k
            captions{k}
            mk=mask;
            mk{factors(k)}= modalities(k)
            if k==4
                mk{14}=1;
            end
            config = expExpose(config, 'l', 'save', ['tt' num2str(k)], 'step', 3, 'mask', mk, 'percent', 0, 'obs', 'p', 'highlight', 0, 'precision', 3);
        end
         % monomials
         captions{end}
        mask = {2, 5, 2, 2, 2, 5, 1, 2, 2, 2, 2, 2, 1, 2, 1};
        config = expExpose(config, 'l', 'save', ['tt' num2str(length(factors)+1)], 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'highlight', 0, 'precision', 3);
      
    case 'dg'
    mask =   {[2  3  4], 5, 1, 1, 1, 5, 1, 1, 0, 0, 0, 0, 1, 1, 1};
        caption = ' post processing of features';
        config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'precision', 3, 'expand', 'split', 'uncertainty', -1, 'highlight', -1, 'caption', caption, 'save', 'cs1');
       
    case 'cSlides'
        % post processing of features
        mask =   {[2  3  4], 5, 1, 1, 1, 5, 1, 1, 0, 0, 0, 0, 1, 1, 1};
        caption = ' post processing of features';
        config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'precision', 3, 'expand', 'split', 'uncertainty', -1, 'highlight', -1, 'caption', caption, 'save', 'cs2');
   
        % expand
        mask = {2:4, 5, [1  2], 2, 2, 5, 1, 0, 2, 2, 2, 2, 1, 1, 1};
        caption = 'expand mfccs using monomials up to the dimensionality of the scattering';
        config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'precision', 3, 'highlight', -1, 'caption', caption, 'save', 'cs3');    
        
        % randomize
        mask = {[2  3  4], 5, [1  2], 2, 2, 5, 2, 1, 2, 2, 2, 2, 1, 1, 1};
        caption = 'randomize features to check effect of learning';
        config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'precision', 3, 'highlight', -1, 'caption', caption, 'save', 'cs4');
        
        % train / test
        mask = {[2:4], 5, [1 2], 2, 0, 5, 1, 1, 2, 2, 2, 2, 1, 1, 1};
        caption = 'split dataset randomly 50 / 50 not preserving structure (0 train, 1 test)';
        config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'precision', 3, 'expand', 'test', 'uncertainty', -1, 'highlight', -1, 'caption', caption, 'save', 'cs4');
            
        % complete / test
        mask = {[2:4], 5, [1 2], [1 2], 2, 5, 1, 1, 2, 2, 2, 2, 1, 1, 1};
        caption = 'compare performances on complete and split dataset randomly 50 (50 test part, none complete)';
        config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'precision', 3, 'expand', 'split', 'uncertainty', -1, 'highlight', -1, 'caption', caption, 'save', 'cs4');
        
        % lmnn vs lda
        mask = {[2 3 4], [5], [2 3], 1, 2, 5, 1, 1, 2, 2, 2, 2, 1, 2};
        caption = 'lmnn vs lda';
        config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'highlight', 0, 'precision', 4, 'uncertainty', -1, 'caption', caption, 'save', 'cs5');
    
        % consensus vs averaging
        mask = {2:4, 5, 2, 1, 2, 5, 1, 1, 2, 2, 2, 2, 1, 0};
        caption = 'consensus vs averaging';
        config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'precision', 3, 'expand', 'split', 'uncertainty', -1, 'highlight', -1, 'caption', caption);  
        
        % complete
        mask = {[2 3 4], [0], [1 2], 2, 2, 5, 1, 1, 2, 2, 2, 2, 1};
        config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'highlight', 0, 'precision', 3, 'expand', 'sct', 'shortFactors', 1, 'uncertainty', -1, 'save', 'cs6');
        config = expExpose(config, 'p', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 'p', 'highlight', 0, 'precision', 4, 'expand', 'sct', 'uncertainty', -1);
        
    case 'splitSlides'
        
        %none
        mask = {[2  3  4], 1, 1, [2  3  4], 0, 5, 1, 1, 2, 2, 2, 2, 1, 1, 1};
        % config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 1, 'highlight', 0, 'precision', 3, 'uncertainty', -1, 'expand', 'test');
        
        % lmnn
        mask = {2:4, 1, 1:2, 2:4, 0, 5, 1, 1, 2, 2, 2, 2, 1, 1, 1};
        config = expExpose(config, 'p', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 1, 'highlight', 0, 'precision', 4, 'expand', 'split', 'uncertainty', -1);
        %   config = expExpose(config, 'l', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 1, 'highlight', 0, 'precision', 4, 'expand', 'split', 'shortFactors', -1, 'uncertainty', -1);
        
        mask = {2:4, 1, 1:2, 1:2, 2, 5, 1, 1, 2, 2, 2, 2, 1, 1, 1};
        config = expExpose(config, 'p', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 1, 'highlight', 0, 'precision', 4, 'expand', 'split', 'uncertainty', -1);
        
        
    case 'perceptualProjectionSlides'
        
        %         mask = {[2  3], 0, 0, 1, 2, 6, 1, 1, 2, 2, 2, 2, 1, 2};
        %         config = expExpose(config, 'p', 'step', 3, 'mask', mask, 'expand', 'sct', 'percent', 0, 'obs', 1, 'highlight', 0, 'uncertainty', -1);
        %
        
        mask = {[2 3], 1, 0, 1, 2, 5, 1, 1, 2, 2, 2, 2, 1};
        mask = {[3 4], 1, 0, 1, 2, 5, 1, 1, 2, 0, 0, 0, 1};
        
        mask = {[3], 1, 1, 1, 2, 5, 1, 1, 2, 0, 0, 0, 1};
        config = expExpose(config, 'l', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 1, 'highlight', 0, 'precision', 4, 'visible', 0);
        mask{1} = 4;
        config = expExpose(config, 'l', 'step', 3, 'mergeDisplay', 'h', 'mask', mask, 'percent', 0, 'obs', 1, 'highlight', 0, 'precision', 4, 'noFactor', 1);
        
        mask = {[3], 1, 0, 1, 2, 5, 1, 1, 2, 2, 2, 2, 1};
        config = expExpose(config, 'l', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 1, 'highlight', 0, 'precision', 4, 'visible', 0, 'shortFactors', 1);
        mask{1} = 4;
        config = expExpose(config, 'l', 'step', 3, 'mergeDisplay', 'h', 'mask', mask, 'percent', 0, 'obs', 1, 'highlight', 0, 'precision', 4, 'noFactor', 1);
        
        
        mask = {[2 3 4], 0, 0, 1, 2, 5, 1, 1, 2, 2, 2, 2, 1};
        %    config = expExpose(config, 'p', 'step', 3, 'mask', mask, 'expand', 'sct', 'percent', 0, 'obs', 1, 'highlight', 0, 'precision', 4, 'uncertainty', -1);
        
    case 'scatteringTechniqueSlides'
        
        % database description
        config = expExpose(config, 't', 'obs', [6 5 7 8 9], 'step', 1, 'mask', {4, 1}, 'orientation', 'vi', 'caption', 'Sol db', 'precision', 0, 'highlight', -1);
        config = expExpose(config, 't', 'obs', [1:4], 'step', 1, 'mask', {4, 1}, 'orientation', 'vi', 'caption', 'Sol db', 'precision', 0, 'highlight', -1);
        
        
        gt = [1 4];
        %% mfcc parametrization
        for k=1:length(gt)
            config = expExpose(config, 't', 'obs', 1, 'step', 3, 'mask', {[1 2] 1 1 1 0 gt(k) 1 1 0 1 1 0}, 'percent', 0, 'caption', 'Mel / mfcc: +');
        end
        
        %% scattering parametrization
        for k=1:length(gt)
            config = expExpose(config, 't', 'obs', 1, 'step', 3, 'mask', {3 1 1 1 0 gt(k) 1 1 1 0 0 0}, 'percent', 0, 'caption', 'Scattering: +');
        end
        
        %% projection comparison (lmnn / lda)
        for k=1:length(gt)
            mask = {[2 3] 1 0 1 0 gt(k) 1 1 2 2 2 2};
            config = expExpose(config, 't', 'step', 3, 'mask', mask, 'percent', 0, 'obs', 1, 'expand', 'projection', 'highlight', -1, 'caption', 'Projection: +', 'orientation', 'vi');
        end
        
        %% projection control
        for k=1:length(gt)
            mask = {[2 3] 1 0 1 0 gt(k) 0 [1 2] 2 2 2 2};
            config = expExpose(config, 't', 'step', 3, 'mask', mask, 'expand', 'projection', 'percent', 0, 'obs', 1, 'highlight', -1, 'caption', 'Control learning: +');
        end
        
        %% split
        gt = [1 4];
        for k=1:length(gt)
            mask = {[2 3] 1 0 [1 2 3 5] 2 gt(k) 1 1 2 2 2 2};
            config = expExpose(config, 'p', 'step', 3, 'mask', mask, 'expand', 'projection', 'percent', 0, 'obs', 1, 'highlight', -1, 'caption', 'db splitting: +');
        end
        %% frame size
        
        
        methods = {{2 0 0}, {3 0 0}, {[2 3] 0 0}};
        for k=1:length(gt)
            for m=1:size(methods, 2)
                mask = {methods{m}{:}, [1], 0, gt(k), 1, 1, 2, 2, 2, 2};
                config = expExpose(config, 'p', 'step', 3, 'mask', mask, 'expand', 'sct', 'percent', 0, 'obs', 1, 'orderFactor', [1 6 3 2], 'tight', 0, 'caption', 'T: +');
            end
        end
        
        %% final
        
        mask = {[2  3], 0, 0, 1, 0, [1  4], 1, 1, 2, 2, 2, 2};
        config = expExpose(config, 'p', 'step', 3, 'mask', mask, 'expand', 'sct', 'percent', 0, 'obs', 1, 'tight', 0, 'caption', 'conclusion: +', 'shortFactors', 0);
        
    otherwise
end