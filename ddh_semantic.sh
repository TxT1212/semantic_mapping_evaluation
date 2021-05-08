#!/bin/bash

ws=/data/largescene/ddhjng_part3/ddhjng_ddhyzbsc/
sub_ws=(ddhjng_ddhyzbsc_20210420_p-ddhyzbsc_r1_ff735d)
SemanticMap2mask=/home/mm/semantic_mapping_evaluation/semantic_mask/convert_sematic_map_to_binary_mask/

yaml=$SemanticMap2mask/combine2images.yaml
bin=$SemanticMap2mask/build/general_fuctions
DATASET_PATH=$ws
mkdir -p $DATASET_PATH/semantic/erode_binary_mask/${sub_ws}
mkdir -p $DATASET_PATH/semantic/images_masked/${sub_ws}
mkdir -p $DATASET_PATH/semantic/org_binary_mask/${sub_ws}

for image_choen in $DATASET_PATH/images/${sub_ws}/*.jpg
do
    num_chosen=${image_choen%*.jpg}
    num_chosen=${num_chosen#*${sub_ws}/}
    rgb=$image_choen
    mask=$DATASET_PATH/semantic/mask/${sub_ws}/${num_chosen}_mask.png
    mask_erode_out=$DATASET_PATH/semantic/erode_binary_mask/${sub_ws}/${num_chosen}.jpg.png
    image_out_path=$DATASET_PATH/semantic/images_masked/${sub_ws}/${num_chosen}.png
    mask_out=$DATASET_PATH/semantic/org_binary_mask/${sub_ws}/${num_chosen}.jpg.png
    sed -i "8c image_path: \"$rgb\""   $yaml
    sed -i "9c mask_path: \"$mask\""   $yaml
    sed -i "10c image_out_path: \"$image_out_path\""   $yaml
    sed -i "11c mask_out_path: \"$mask_out\""   $yaml
    sed -i "12c mask_erode_out: \"$mask_erode_out\""   $yaml
    $bin $yaml
done

