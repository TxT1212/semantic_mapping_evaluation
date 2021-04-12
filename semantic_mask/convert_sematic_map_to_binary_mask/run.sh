#!/bin/bash
# for i in Barn Caterpillar Courthouse Family Horse Francis Palace
# do
#     DATASET_PATH=/media/ezxr/data/tanksandtemples/$i
#     # mkdir $DATASET_PATH/semantic
#     # mkdir $DATASET_PATH/semantic/org_binary_mask
#     # mkdir $DATASET_PATH/semantic/images_masked

#     echo $DATASET_PATH/
#     for rgb in $DATASET_PATH/images/*
#     do
#         num_chosen=${rgb%*.jpg}
#         num_chosen=${num_chosen#*images/}
#         # num_chosen=${rgb#*rgb_mask/}

#         mask=$DATASET_PATH/masks/${num_chosen}_mask.png
#         mask_out=$DATASET_PATH/semantic/org_binary_mask/00${num_chosen}.jpg.png
#         out=$DATASET_PATH/semantic/images_masked/00${num_chosen}.png

#         sed -i "8c image_path: \"$rgb\""   ~/general_fuctions/combine2images.yaml
#         sed -i "9c mask_path: \"$mask\""   ~/general_fuctions/combine2images.yaml
#         sed -i "10c image_out_path: \"$out\""   ~/general_fuctions/combine2images.yaml
#         sed -i "11c mask_out_path: \"$mask_out\""   ~/general_fuctions/combine2images.yaml

#         ~/general_fuctions/build/general_fuctions ~/general_fuctions/combine2images.yaml


#     done
# done

ws=/media/ezxr/data/Aachen-Day-Night/aachen_parts/
for i in a b c d e f # Barn Caterpillar Courthouse Family Horse Francis Palace
do
    DATASET_PATH=$ws/$i
    # mkdir $DATASET_PATH/semantic
    # mkdir $DATASET_PATH/semantic/org_binary_mask
    # mkdir $DATASET_PATH/semantic/images_masked

    echo $DATASET_PATH/
    for rgb in $DATASET_PATH/images/*
    do
        num_chosen=${rgb%*.jpg}
        num_chosen=${num_chosen#*images/}
        # num_chosen=${rgb#*rgb_mask/}

        mask=$DATASET_PATH/masks/${num_chosen}_mask.png
        mask_out=$DATASET_PATH/semantic/org_binary_mask/${num_chosen}.jpg.png
        # mv $mask_out $DATASET_PATH/semantic/org_binary_mask/${num_chosen}.jpg.png
        out=$DATASET_PATH/semantic/images_masked/${num_chosen}.png

        sed -i "8c image_path: \"$rgb\""   ~/general_fuctions/combine2images.yaml
        sed -i "9c mask_path: \"$mask\""   ~/general_fuctions/combine2images.yaml
        sed -i "10c image_out_path: \"$out\""   ~/general_fuctions/combine2images.yaml
        sed -i "11c mask_out_path: \"$mask_out\""   ~/general_fuctions/combine2images.yaml

        ~/general_fuctions/build/general_fuctions ~/general_fuctions/combine2images.yaml


    done
done