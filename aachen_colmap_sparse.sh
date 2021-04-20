#!/bin/bash
###############################################################
###### 修改这些变量###############################################
################################################################
# 根文件夹
ws=/media/ezxr/data/Aachen-Day-Night/
# 日期
date=20210419
# 所需脚本位置
# 用于生成正确内参的db, create_db_from_aachen.py所在文件夹
create_db_from_aachen_py=/home/ezxr/semantic_mapping_evaluation/colmap_db_scripe/
# 用于计算估计的位姿精度
calculate_error_py=/home/ezxr/colmap/scripts/python/calculate_error.py
# colmap_export_geo.py位置， 用于生成gt位姿txt文件 camera_poses.txt
colmap_export_geo_position=/home/ezxr/colmap/scripts/sfm_toolkits/ezxr_sfm/colmap_process/

# 腐蚀语义mask的kernel大小
mask_erode_kernel_size=5
# 测评结果保存文件
evaluation_result=$ws/evaluation_result.txt
# ezxr-semantic-segmentation 文件夹位置, 用于语义分割
ezxr_semantic_segmentation=/home/ezxr/ezxr-semantic-segmentation/
# SemanticMap2mask 文件夹
SemanticMap2mask=/home/ezxr/Downloads/SemanticMap2mask/

# 需要重建的子目录
# 可选选项为 a b c d e f 和 all, all表示重建全部
# 需要读取 $ws/images 文件下的 aachen_SUBFILE_NAME.txt
# 其中， aachen_all.txt会自动复制
subfile=(a b c all) 
# subfile=(a b c d e f all) 


#############################################################
############ 以下脚本不需要修改#################################
#############################################################

##### 应该存在的文件：
aachen_gt_model=$ws/sparse/aachen_gt # 文件夹下有 points cameras images
database_intrinsics=$ws/3D-models/database_intrinsics.txt

# ### 准备
mkdir ${ws}/sparse
mkdir ${ws}/semantic/masks
mkdir ${ws}/semantic/images_masked
mkdir ${ws}/semantic/images_masked/db
mkdir ${ws}/semantic/org_binary_mask
mkdir ${ws}/semantic/org_binary_mask/db
mkdir ${ws}/semantic/erode_binary_mask
mkdir ${ws}/semantic/erode_binary_mask/db
mkdir ${ws}/databases
cd $colmap_export_geo_position
python $colmap_export_geo_position/colmap_export_geo.py --model $aachen_gt_model --output camera_poses.txt
camera_poses=$aachen_gt_model/camera_poses.txt
cp ${ws}/3D-models/aachen_cvpr2018_db.list.txt ${ws}/images/aachen_all.txt

function colmap_spase_aachen()
{
    DATASET_PATH=${1}
    data_base=${2}
    sparse_folder=${3}
    image_list_path=${4}
    mask_path=${5}
    echo $image_list_path

    colmap feature_extractor \
        --database_path $DATASET_PATH/databases/$data_base \
        --image_path $DATASET_PATH/images \
        --image_list_path $image_list_path \
        --ImageReader.mask_path 

    colmap exhaustive_matcher \
        --database_path $DATASET_PATH/databases/$data_base

    colmap mapper \
        --database_path $DATASET_PATH/databases/$data_base \
        --image_path $DATASET_PATH/images \
        --output_path $DATASET_PATH/sparse/$sparse_folder\
        --Mapper.ba_refine_focal_length 0 \
        --Mapper.ba_refine_principal_point 0 \
        --Mapper.ba_refine_extra_params 0    
}

#### 获得有且只有正确内参的db
for i in ${subfile[*]}; 
do
    DATASET_PATH=$ws
    frame_selected=$DATASET_PATH/images/aachen_$i.txt
    database_path=$DATASET_PATH/databases/database_true_intrinsics_${i}.db
    cd $create_db_from_aachen_py
    python $create_db_from_aachen_py/create_db_from_aachen.py \
    --frame_selected $frame_selected \
    --database_intrinsics $database_intrinsics \
    --database_path $database_path
done


### 语义分割模型 
cd ${ezxr_semantic_segmentation}
MODEL_PATH=${ezxr_semantic_segmentation}/TrainedModels/ade20k-hrnetv2-c1
IMAGE_PATH=$ws/images/db/
gpu=0  ## gpu idsubfile
  --is_save_view 1 \
  --is_save_json 0 \
  DIR $MODEL_PATH \
  TEST.result $RESULT_PATH \
  TEST.checkpoint epoch_30.pth \
  DATASET.isRotation 0 \
  DATASET.downsample 1 \

# ## 语义map转二值化mask
# yaml=$SemanticMap2mask/combine2images.yaml
# bin=$SemanticMap2mask/build/general_fuctions
# DATASET_PATH=$ws
# for image_choen in $DATASET_PATH/semantic/masks/*_color.png
# do
#     num_chosen=${image_choen%*_color.png}
#     num_chosen=${num_chosen#*masks/}subfilenum_chosen}.jpg.png
#     mask_erode_out=$DATASET_PATH/semantic/erode_binary_mask/db/${num_chosen}.jpg.png
#     image_out_path=$DATASET_PATH/semantic/images_masked/db/${num_chosen}.png
#     sed -i "8c image_path: \"$rgb\""   $yaml
#     sed -i "9c mask_path: \"$mask\""   $yaml
#     sed -i "10c image_out_path: \"$image_out_path\""   $yaml
#     sed -i "11c mask_out_path: \"$mask_out\""   $yaml
#     sed -i "12c mask_erode_out: \"$mask_erode_out\""   $yaml
#     $bin $yaml
# done


# # run colamp with and without segmantic mask
# for i in ${subfile[*]}; do
    
#     DATASET_PATH=$ws
#     image_list_path=${DATASET_PATH}images/aachen_${i}.txt
#     data_base_true_intrinsics=$DATASET_PATH/databases/database_true_intrinsics_${i}.db
    
#     ###### run colamp original(no mask)-aachen
#     sparse_folder=aachen_org_${i}_${date}
#     mkdir $DATASET_PATH/sparse/$sparse_folder
#     data_base=aachen_org_${i}.db
#     cp $data_base_true_intrinsics $DATASET_PATH/databases/$data_base
#     mask_path=$DATASET_PATH/databases #dummy path
#     colmap_spase_aachen $DATASET_PATH $data_base $sparse_folder $image_list_path $mask_path
#     colmap model_aligner \
#     --input_path $DATASET_PATH$sparse_folder/0 \
#     --output_path $DATASET_PATH$sparse_folder/0 \
#     --ref_images_path $camera_poses \
#     --robust_alignment_max_error 0.01
#     echo "result of ${sparse_folder}: \n" >> $evaluation_result
#     python $calculate_error_py \
#     --input_model $DATASET_PATH$sparse_folder/0 \
#     --input_model_gt $aachen_gt_model >> $evaluation_result


#     ###### run colamp segmatic(have mask)-aachen
#     sparse_folder=aachen_mask_erode${mask_erode_kernel_size}pixel_${i}_${date}
#     mkdir $DATASET_PATH/sparse/$sparse_folder
#     data_base=aachen_mask_erode${mask_erode_kernel_size}pixel_$i.db
#     cp $data_base_true_intrinsics $DATASET_PATH/databases/$data_base
#     mask_path=$DATASET_PATH/semantic/erode_binary_mask
#     colmap_spase_aachen $DATASET_PATH $data_base $sparse_folder $image_list_path $mask_path
#     colmap model_aligner \
#     --input_path $DATASET_PATH/sparse/$sparse_folder/0 \
#     --output_path $DATASET_PATH/sparse/$sparse_folder/0 \
#     --ref_images_path $camera_poses \
#     --robust_alignment_max_error 0.01
#     echo "result of ${sparse_folder}: \n" >> $evaluation_result
#     python $calculate_error_py \
#     --input_model $DATASET_PATH/sparse/$sparse_folder/0 \
#     --input_model_gt $aachen_gt_model >> $evaluation_result
# done




