#!/bin/bash

ws=/media/ezxr/data/ezxrsales_wh-jgs_20210429_jgsykzx_R3_d235f2
# 外点滤除python脚本路径
vis_point_cloud_py_path=/home/ezxr/semantic_mapping_evaluation/vis_point_cloud.py
# 日期
date=20210510

# 腐蚀语义mask的kernel大小
mask_erode_kernel_size=5
# 测评结果保存文件
evaluation_result=$ws/evaluation_result.txt
# ezxr-semantic-segmentation 文件夹位置, 用于语义分割
ezxr_semantic_segmentation=/home/ezxr/ezxr-semantic-segmentation/
# SemanticMap2mask 文件夹
SemanticMap2mask=/home/ezxr/semantic_mapping_evaluation/semantic_mask/convert_sematic_map_to_binary_mask/
# mkdir ${ws}/sparse
# mkdir ${ws}/sparse/mask_erode0pixel
# mkdir ${ws}/semantic_crf/
# mkdir ${ws}/semantic_crf/masks
# mkdir ${ws}/semantic_crf/images_masked
# mkdir ${ws}/semantic_crf/org_binary_mask
# mkdir ${ws}/semantic_crf/erode_binary_mask
# # mkdir ${ws}/databases
# # mkdir ${ws}/dense
# # mkdir ${ws}/dense/mask_erode0pixel

# ## 语义分割模型 
# cd ${ezxr_semantic_segmentation}
# MODEL_PATH=${ezxr_semantic_segmentation}/TrainedModels/ade20k-hrnetv2-c1
# IMAGE_PATH=$ws/images/
# RESULT_PATH=$ws/semantic_crf/masks/
# gpu=0  ## gpu idsubfile
# python3 -u test.py \
#   --imgs $IMAGE_PATH \
#   --cfg config/ade20k-hrnetv2.yaml \
#   --gpu $gpu \
#   --is_save_mask 1 \
#   --is_save_view 1 \
#   --is_save_json 0 \
#   DIR $MODEL_PATH \
#   TEST.result $RESULT_PATH \
#   TEST.checkpoint epoch_30.pth \
#   DATASET.isRotation 1 \
#   DATASET.downsample 1 \

# ## 语义map转二值化mask
yaml=$SemanticMap2mask/combine2images.yaml
bin=$SemanticMap2mask/build/general_fuctions
DATASET_PATH=$ws
for image_choen in $DATASET_PATH/semantic_crf/masks/*_color.png
do
    num_chosen=${image_choen%*_color.png}
    num_chosen=${num_chosen#*masks/}
    # echo $num_chosen
    mask_erode_out=$DATASET_PATH/semantic_crf/erode_binary_mask/${num_chosen}.jpg.png
    image_out_path=$DATASET_PATH/semantic_crf/images_masked/${num_chosen}.png
    rgb=$DATASET_PATH/images/${num_chosen}.jpg
    mask_path=$DATASET_PATH/semantic_crf/masks/${num_chosen}_mask.png
    mask_out=$DATASET_PATH/semantic_crf/org_binary_mask/${num_chosen}.jpg.png
    sed -i "8c image_path: \"$rgb\""   $yaml
    sed -i "9c mask_path: \"$mask_path\""   $yaml
    sed -i "10c image_out_path: \"$image_out_path\""   $yaml
    sed -i "11c mask_out_path: \"$mask_out\""   $yaml
    sed -i "12c mask_erode_out: \"$mask_erode_out\""   $yaml
    $bin $yaml
done

# colmap feature_extractor --database_path ${ws}/databases/mask_erode0pixel.db --image_path $DATASET_PATH/images/ --ImageReader.mask_path $DATASET_PATH/semantic/org_binary_mask/ --ImageReader.single_camera 1
# colmap exhaustive_matcher --database_path  ${ws}/databases/mask_erode0pixel.db
# colmap mapper --database_path ${ws}/databases/mask_erode0pixel.db --image_path $DATASET_PATH/images/ --output_path  $DATASET_PATH/sparse/mask_erode0pixel
# colmap image_undistorter \
#     --image_path $DATASET_PATH/images \
#     --input_path $DATASET_PATH/sparse/mask_erode0pixel/0 \
#     --output_path $DATASET_PATH/dense/mask_erode0pixel \

# colmap  patch_match_stereo --workspace_path ${ws}/dense/mask_erode0pixel 
colmap stereo_fusion   --output_path ${ws}/dense/mask_erode0pixel/mask_crf.ply --workspace_path ${ws}/dense/mask_erode0pixel --StereoFusion.mask_path  $DATASET_PATH/semantic_crf/org_binary_mask/
python $vis_point_cloud_py_path --input_cloud  ${ws}/dense/mask_erode0pixel/mask_crf.ply --output_cloud  ${ws}/dense/mask_erode0pixel/mask_crf_clean_std1.ply --std_ratio 1

