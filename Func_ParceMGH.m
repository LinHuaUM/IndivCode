sublist = importdata('/Users/Selven/Desktop/AD_DATA/SubList.txt');
parce_bold_path = '/Users/Selven/Desktop/Parce_InputData/BOLD_DATA'; 

for i = 1:length(sublist)
    
    strsub = sublist{i};
    sub(i) = str2num(strsub(5:9));

end

for j = 1:length(sublist)
    
    clear vol M mr_parms volsz
    [vol, M, mr_parms, volsz] = load_mgh([parce_bold_path '/' num2str(sub(j)) '/lh.rfMRI_4D_Preprocessed_FS4.mgh']);
    vol=reshape(vol,[size(vol,1)*size(vol,2)*size(vol,3), size(vol,4)]);
    save_mgh(vol,[parce_bold_path '/' num2str(sub(j)) '/lh.rfMRI_Preprocessed_FS4.mgh'],M,mr_parms);
    delete([parce_bold_path '/' num2str(sub(j)) '/lh.rfMRI_4D_Preprocessed_FS4.mgh']);
    
    clear vol M mr_parms volsz
    [vol, M, mr_parms, volsz] = load_mgh([parce_bold_path '/' num2str(sub(j)) '/rh.rfMRI_4D_Preprocessed_FS4.mgh']);
    vol=reshape(vol,[size(vol,1)*size(vol,2)*size(vol,3), size(vol,4)]);
    save_mgh(vol,[parce_bold_path '/' num2str(sub(j)) '/rh.rfMRI_Preprocessed_FS4.mgh'],M,mr_parms);
    delete([parce_bold_path '/' num2str(sub(j)) '/rh.rfMRI_4D_Preprocessed_FS4.mgh']);
    
end