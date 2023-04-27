clear
clc
%Shown on FS5
% Load ROIIndex on fsaverage5
GrpInPath = '/Templates/GrpTemplate_Patches_116_FS5';

k = 0;
for net_i = 1:18
    lh = load_mgh([GrpInPath '/lh_network_' num2str(net_i+1) '_asym_fs5_Patch.mgh']);
    ROIsNum = max(lh);
    for roi_i = 1:ROIsNum
        k = k+1;
        Index = find(lh==roi_i);
        ROI_Ind_Big_fs5_lh{k} = Index;
    end
end

k = 0;
for net_i = 1:18
    rh = load_mgh([GrpInPath '/rh_network_' num2str(net_i+1) '_asym_fs5_Patch.mgh']);
    ROIsNum = max(rh);
    for roi_i = 1:ROIsNum
        k = k+1;
        Index = find(rh==roi_i);
        ROI_Ind_Big_fs5_rh{k} = Index;
    end
end

load('AllSelected_Patches_lh.mat')
sp_lh = AllSelected_Patches;
load('AllSelected_Patches_rh.mat')
sp_rh = AllSelected_Patches;

sp_all = sp_lh + sp_rh;
sp = [];
for i = 1:18
    sp = [sp repmat(sp_all(i),1,sp_all(i))];
end

mask_between = ones(116,116);
sp_sum = 0;
for i = 1:18
    
    mask_between(sp_sum+1:sp_sum+sp_all(i),sp_sum+1:sp_sum+sp_all(i))=0;    
    sp_sum = sp_all(i) + sp_sum;
    
end
mask_between = logical(mask_between);
mask_within = ~mask_between;

% network value
load('data.mat');
subj = cell2mat(data(2:236,1));
for k = 1:235
    
    load(['/FC_Indiv/' 'sub_' num2str(subj(k)) '_big_corr.mat']);
    Indi_Corr = abs(CorrMat);
    for i = 1:116
        Indi_Corr_wtn(:,i) = sum(Indi_Corr(:,i).*mask_within(:,i))/sp(i);
        Indi_Corr_btw(:,i) = sum(Indi_Corr(:,i).*mask_between(:,i))/(116-sp(i));
    end
    num_all = 0;
    for i = 1:18
        
        sub_indi_net_btw(k,i) = sum(Indi_Corr_btw(num_all+1:num_all+sp_all(i)))/sp_all(i);    
        sub_indi_net_wtn(k,i) = sum(Indi_Corr_wtn(num_all+1:num_all+sp_all(i)))/sp_all(i); 
        num_all = sp_all(i)+num_all;
        
    end
    
    load(['/FC_Atlas/' 'sub_' num2str(subj(k)) '_big_corr.mat']);
    Atlas_Corr = abs(CorrMat);
    for i = 1:116
        Atlas_Corr_wtn(:,i) = sum(Atlas_Corr(:,i).*mask_within(:,i))/sp(i);
        Atlas_Corr_btw(:,i) = sum(Atlas_Corr(:,i).*mask_between(:,i))/(116-sp(i));
    end
    num_all = 0;
    for i = 1:18
        
        sub_atlas_net_btw(k,i) = sum(Atlas_Corr_btw(num_all+1:num_all+sp_all(i)))/sp_all(i);    
        sub_atlas_net_wtn(k,i) = sum(Atlas_Corr_wtn(num_all+1:num_all+sp_all(i)))/sp_all(i); 
        num_all = sp_all(i)+num_all;
        
    end
    
end
