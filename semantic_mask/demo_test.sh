#!/bin/bash

# Model names
MODEL_PATH=TrainedModels/ade20k-hrnetv2-c1
ENCODER=$MODEL_PATH/encoder_epoch_30.pth
DECODER=$MODEL_PATH/decoder_epoch_30.pth

# Image names
IMAGE_PATH=/media/ezxr/data/Aachen-Day-Night/aachen_parts/
# IMAGE_PATH=/media/ezxr/data/tanksandtemples/
#TEST_IMG=$IMAGE_PATH/C6_part_F1N_RGBD_tearoom_20201027084953_scale0.500000_rgb/rgb/
#RESULT_PATH=$IMAGE_PATH/C6_part_F1N_RGBD_tearoom_20201027084953_scale0.500000_rgb/mask_adjust

#TEST_IMG=$IMAGE_PATH/outdoor_test/rgb/
#RESULT_PATH=$IMAGE_PATH/outdoor_test/masks/

#TEST_IMG=$IMAGE_PATH/ARLargeScene/images/xixi_goldfish/1599555145676/
#RESULT_PATH=$IMAGE_PATH/ARLargeScene/masks/xixi_goldfish/1599555145676

# TEST_IMG=$IMAGE_PATH/Courthouse/images/
# RESULT_PATH=$IMAGE_PATH/Courthouse/masks/

# Remember to rotate and resize
isRotation=0  ## whether rotate
downsample=1  ## downsample rate  2
gpu=0  ## gpu id
is_save_mask=1  ## whether save mask
is_save_view=1  ## whether save mask for view
is_save_json=0  ## whether save json

color_mat_name=data/adjust_color150.mat  # data/color150.mat used for src semantic, ata/adjust_color150.mat used for indoor wall/floor/...
# for i in Caterpillar Family Horse Fr?ancis Palace
for i in c d e f
do
  TEST_IMG=$IMAGE_PATH/$i/images/
  RESULT_PATH=$IMAGE_PATH/$i/masks/
# Inference
python3 -u test.py \
  --imgs $TEST_IMG \
  --cfg config/ade20k-hrnetv2.yaml \
  --gpu $gpu \
  --is_save_mask $is_save_mask \
  --is_save_view $is_save_view \
  --is_save_json $is_save_json \
  DIR $MODEL_PATH \
  TEST.result $RESULT_PATH \
  TEST.checkpoint epoch_30.pth \
  DATASET.isRotation $isRotation \
  DATASET.downsample $downsample \
  # --color_mat_name $color_mat_name
done

