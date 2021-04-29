 
 dense_ws=/media/ezxr/data/tanksandtemples/Family/dense/mask
 save_ply=fused_mask_erode7pixel.ply
 mask_path=/media/ezxr/data/tanksandtemples/Family/semantic/erode_binary_mask_15/
 
 colmap stereo_fusion \
 --workspace_path ${dense_ws} \
 --output_path ${dense_ws}/${save_ply} \
 --StereoFusion.mask_path ${mask_path}
