import yaml
import os
import glob2
import argparse
import cv2
import numpy as np
def find_recursive(root_dir, ext='.jpg'):
    files = glob2.glob(os.path.join(root_dir, './**/*'+ext))
    return files

def main(path, imgs, result, mask_values):
    for img in imgs:
        img_name = img.split('/')[-1]
        img_mat = cv2.imread(img, cv2.IMREAD_GRAYSCALE)
        assert(img_mat.size)
        print(img_mat.shape, img_mat.dtype)
        c=str.replace(img,path,result)
        c=str.replace(c,"_mask.png",".jpg.png")
        out_path=str.replace(c,"/./","/")
        print(c)

        for mask_value in mask_values:
            # print(mask_value)
            p=np.where((img_mat==mask_value))
            img_mat[p] = 0
        p=np.where(img_mat!=0)
        img_mat[p] = 255
        print(img_mat.shape, img_mat.dtype)
        cv2.imwrite(out_path, img_mat)




if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="convert semantic map to binary mask"
    )
    parser.add_argument(
        "--imgs",
        required=True,
        type=str,
        help="an image paths, or a directory name"
    )
    parser.add_argument(
        "--result",
        required=True,
        type=str,
        help="an image paths, or a directory name"
    )
    args = parser.parse_args()



    # generate testing image list
    if os.path.isdir(args.imgs):
        for dirpath, dirnames, filenames in os.walk(args.imgs):
            imgs = find_recursive(args.imgs, 'mask.png')
            for dirname in dirnames:
                # print(os.path.join(dirpath, dirname))  
                # print(dirname)
                path = os.path.join(args.result, dirname)
                # print(path)
                os.makedirs(path, exist_ok=True)
    else:
        imgs = [args.imgs]
    assert len(imgs), "imgs should be a path to image (.jpg) or directory."

    if not os.path.isdir(args.result):
        os.makedirs(args.result)
    with open("/home/ezxr/semantic_mapping_evaluation/semantic_mask/convert_sematic_map_to_binary_mask/combine2images.yaml", 'r') as f:
        config = yaml.load(f.read(),  Loader=yaml.FullLoader)
    mask_value = config["mask_value"]

    print(mask_value)
    # print(imgs)
    main(args.imgs, imgs, args.result, mask_value)

    


    # python combine2images.py --imgs /media/ezxr/data/tanksandtemples/Family/semantic/masks --result /media/ezxr/data/tanksandtemples/Family/semantic/erode_binary_mask
