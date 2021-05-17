import yaml
import os,sys
import glob2
import argparse
import cv2
import numpy as np
from tqdm import tqdm

def find_recursive(root_dir, ext='.jpg'):
    files = glob2.glob(os.path.join(root_dir, './**/*'+ext))
    return files

def convert_mask(map_path, map_list, result_path, mask_values, use_erosion = False, erosion_radius = 3):
    """转换semantic map到[0，1] mask
    推荐文件组织：
        images 原图像
        semantic 语义分割结果
        masks 0,1 mask
    
    Args:
        image_path ([type]): 语义map地址
        img_list ([type]): 语义map文件列表（abspath）
        result_path ([type]): 输出mask的path
        mask_values ([type]): 需要置为0的语义标签list
        use_erosion (bool, optional): 边缘膨胀？. Defaults to False.
        erosion_radius (int, optional): 膨胀半径，建议640图像3-5，其他图像等比缩放. Defaults to 3.
    """


    for img in tqdm(map_list):
        img_name = img.split('/')[-1]
        img_mat = cv2.imread(img, cv2.IMREAD_GRAYSCALE)
        assert(img_mat.size)
        print(img_mat.shape, img_mat.dtype)
        c=str.replace(img,map_path,result_path)
        c=str.replace(c,"_mask.png",".jpg.png")
        out_path=str.replace(c,"/./","/")
     #   print(c)

        for mask_value in mask_values:
            # print(mask_value)
            p=np.where((img_mat==mask_value))
            img_mat[p] = 0
        p=np.where(img_mat!=0)
        img_mat[p] = 255
        

        if use_erosion:
            kernel = np.ones((erosion_radius,erosion_radius),np.uint8)  
            erosion = cv2.erode(img_mat,kernel,iterations = 1)

            vis_debug = False
            if vis_debug:
                disp_erosion = cv2.resize(erosion, None, fx = 0.5, fy = 0.5)
                disp_img = cv2.resize(img_mat, None, fx = 0.5, fy = 0.5)
                cv2.imshow("orgmask", disp_img)
                cv2.imshow("erodemask", disp_erosion)
                k = cv2.waitKey(-1)
                if k==27:    # Esc key to stop
                    sys.exit()
                cv2.destroyAllWindows()
                print(img_mat.shape, img_mat.dtype)
        cv2.imwrite(out_path, img_mat)




if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="convert semantic map to binary mask"
    )
    parser.add_argument(
        "--input_path",
        required=True,
        type=str,
        help="semantic map paths, or a directory name"
    )
    parser.add_argument(
        "--output_path",
        required=True,
        type=str,
        help="mask paths, or a directory name"
    )
    parser.add_argument(
        "--erosion",
        action='store_true',help="use erosion"
    )
    parser.add_argument('--radius', type=int, default=5)

    args = parser.parse_args()

    # generate testing image list
    if os.path.isdir(args.input_path):
        for dirpath, dirnames, filenames in os.walk(args.input_path):
            imgs = find_recursive(args.input_path, 'mask.png')
            for dirname in dirnames:
                # print(os.path.join(dirpath, dirname))  
                # print(dirname)
                path = os.path.join(args.output_path, dirname)
                # print(path)
                os.makedirs(path, exist_ok=True)
    else:
        print("Error! input_path is not a path")
        sys.exit()
        
    assert len(imgs), "imgs should be a path to image (.jpg) or directory."

    if not os.path.isdir(args.output_path):
        os.makedirs(args.output_path)
    with open(os.path.dirname(os.path.realpath(__file__))+"/combine2images.yaml", 'r') as f:
        config = yaml.load(f.read(),  Loader=yaml.FullLoader)
    mask_value = config["mask_value"]

    print(mask_value)
    # print(imgs)
    convert_mask(args.input_path, imgs, args.output_path, mask_value, True, 10)

    


    # python combine2images.py --imgs /media/ezxr/data/tanksandtemples/Family/semantic/masks --result /media/ezxr/data/tanksandtemples/Family/semantic/erode_binary_mask
