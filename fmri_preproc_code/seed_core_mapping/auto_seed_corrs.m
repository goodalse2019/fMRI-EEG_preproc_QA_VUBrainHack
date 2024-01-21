% % % to do before calling script
% % % (1) prepare .txt list of filenames for preprocessed data. Begin each name w/ "subjIdntifier-"
% % % (2) prepare another .txt with one file location for each file listed above
% % % No empty lines

% % % % CALL THIS SCRIPT LIKE FOLLOWS:
% % % matlab -nodisplay -nosplash -r "auto_seed_corrs('vol_filelocations.txt','vol_filenames.txt'); quit;"
%^adapted from sample code platypus_preproc_echo2.sh and https://stackoverflow.com/questions/6657005/matlab-running-an-m-file-from-command-line

function seed_corrs(txt_filelocations,txt_filenames)

% % % %SETUP REMAINING PARAMS 
nth_slices=5; %display every nth slice
atlas_filelocation="/home/liaoe2/brainhacks_files";
atlas_filename='shen_2mm_268_parcellation.nii.gz';
seed_id=223; %id of seed in atlas, 223 for pcc

% Calculate and display seed corr maps:
vol_filelocations=readlines(txt_filelocations);
vol_filenames=readlines(txt_filenames);
vol_atlas = niftiread(atlas_filename);
output_names = strcat(extractBefore(vol_filenames,"-"),"_seed_corrs.png");
%Calculate correlations to seed (adapted from sample code Ex_4.m):
parfor ii=1:length(vol_filenames)
cd(vol_filelocations(ii)); 
vol_preprocessed = niftiread(vol_filenames(ii));
vol_reshaped = reshape(vol_preprocessed, numel(vol_preprocessed(:,:,:,1)), size(vol_preprocessed,4));
inds = find(vol_atlas==seed_id); 
seed_timeseries = mean(vol_reshaped(inds,:),1);
seed_corr_map_voxels = reshape(corr(seed_timeseries',vol_reshaped'), size(vol_preprocessed,1:3)); %reshape to a 3D volume
figure;
montage(seed_corr_map_voxels(:,:,1:nth_slices:end)); colormap parula;
exportgraphics(gcf,output_names(ii))
end
end