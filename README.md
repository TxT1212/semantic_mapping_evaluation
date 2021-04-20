

# aachen数据集+语义mask的colmap稀疏重建

@唐啸天

语义辅助建图、定位、稠密点云生成，测评相关结果

## 文件结构

```
├── database 
│   ├── scene_name.db
│   ├── database_true_intrinsics_XXX.db // 有且只有正确内参的db

├── semantic
│   ├── erode_binary_mask 
│   ├── images_masked // 查看mask加在rgb图像上的效果
│   ├── masks // 语义分割网络结果
│   └── org_binary_mask

├── images    // 图像与imagelist.txt 
│   ├── db
|   |   ├──1.jpg
|   |   └── ... 
│   ├──query // 还没用到
|   ├──aachen_a.txt //图像子集list
|   ├──...
|   └──aachen_cvpr2018_db.list.txt // 所有db图片


├── sparse
│   ├── scene_taskname_日期  // 模型

```

## 使用指导

1. 下载aachen数据集
2. 下载工程，复制.py文件到相应的文件夹
   1. calculate_error.py 依赖colmap中的 read_write_model.py 
   2. create_db_from_aachen.py 依赖colmap中的 database.py
   3. update_db_intrinsics_from_another_db.py 依赖hfnet的 internal.db_handling
3. 根据修改 run.sh 中的指导，修改run.sh中的几个变量，ren.sh中注释有具体说明。
4. 如果需要重建aachen的子数据集，需要将分割结果aachen_xxx.txt 放置在images/ 文件夹中。这些txt文件由老王的分割工具获得
5. 运行 ./aachen_colmap_sparse.sh

## 脚本说明

### 准备

准备部分只需要运行一次。

- mkdir建立文件结构
- 将3d-models中所有图像的aachen_cvpr2018_db.list.txt 复制到images文件夹下并重命名，作为所有db中图片的ImageReader.mask_path
- 根据groundtruth模型，得到所有图像的位姿，用于误差估计

### 获得有且只有正确内参的db

获得每个数据集内参正确的db，但是db中不包含任何特征点和匹配关系的信息，只有每张图片的内参。这些db命名为database_true_intrinsics_XXX.db，每次要用的时候复制一份，本身不做直接改动。

### 语义分割

运行semantic-segmentation-pytorch，得到每张db图像的语义map。


### map得到二值化mask

运行convert_sematic_map_to_binary_mask工程，在semantic_mapping_evaluation/semantic_mask/convert_sematic_map_to_binary_mask/combine2images.yaml中修改map中需要mask掉的数值

### 运行colmap系数重建并且测试指标

分以下步骤：

- 分别运行colmap加mask和不加mask的稀疏重建
- 重建结果和groundtruth模型进行对其
- 计算指标