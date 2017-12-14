function [config, store] = tisisoInit(config)                              
% tisisoInit INITIALIZATION of the expLanes experiment timbralSimilaritySol
%    [config, store] = tisisoInit(config)                                  
%      - config : expLanes configuration state                             
%      -- store  : processing data to be saved for the other steps         
                                                                           
% Copyright: Mathieu Lagrange                                              
% Date: 09-Jan-2017                                                        
                                                                           
if nargin==0, timbralSimilaritySol(); return; else store=[];  end          
