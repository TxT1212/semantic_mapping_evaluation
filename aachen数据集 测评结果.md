# aachen数据集 测评结果



| 场景       | org  0.25m, 2°      | org 0.5m, 5°        | org 5m, 10°         | mask 0.25m, 2°     | mask 0.5m, 5°     | mask 5m, 10°        |
| ---------- | ------------------- | ------------------- | ------------------- | ------------------ | ----------------- | ------------------- |
| aachen_a   | 275 / 636   0.432   | 297 / 636   0.467   | 627 / 636   0.986   | 358 / 709  0.505   | 447 / 709 0.630   | 634 / 709 0.894     |
| aachen_b   | 1709 / 2025   0.844 | 1778 / 2025   0.878 | 1957 / 2025   0.966 | 1735 / 2014 0.861  | 1807 / 2014 0.897 | 1956 / 2014 0.971   |
| aachen_c   |                     |                     |                     |                    |                   |                     |
| aachen_d_0 | 601 / 734   0.819   | 733 / 734   0.999   | 734 / 734   1.000   | 392 / 733   0.535  | 637 / 733   0.869 | 733 / 733   1.000   |
| aachen_d_1 | 463 / 467   0.991   | 466 / 467   0.998   | 467 / 467   1.000   | 464 / 467 0.994    | 467 / 467 1.000   | 467/ 467 1.000      |
| aachen_e   | 218 / 276   0.790   | 273 / 276   0.989   | 274 / 276   0.993   | 248 / 276   0.898  | 275 / 276   0.996 | 275 / 276   0.996   |
| aachen_f   | 930 / 1013   0.918  | 942 / 1013   0.930  | 1010 / 1013   0.997 | 912 / 1012   0.901 | 944 / 1012 0.932  | 1002 / 1012   0.990 |



0.25m, 2°: 392 / 733   0.5347885402455662
0.5m, 5°: 637 / 733   0.869031377899045
5m, 10°: 733 / 733   1.0

# aachen子数据集错位原因

之前使用默认参数时，a c d出现错位的情况。

1. a左下角区域和其他区域overlap比较小，多次运行出现不同地方错位和不错位的情况，不错位时会裂开。测评时选用裂开的model。

<img src="/media/ezxr/data/Aachen-Day-Night/images/aachen_ZX_polygon_a.png" style="zoom:55%;" />

2. c 和 d在同样的地方错位


<figure class="half">
<img src="/media/ezxr/data/Aachen-Day-Night/images/aachen_ZX_polygon_c.png "  style="zoom:55%;"/>
<img src="/media/ezxr/data/Aachen-Day-Night/images/aachen_ZX_polygon_d.png" style="zoom:55%;" />
<figure class="half">


原因是重复纹理，下图的大窗，两个场景相同

 <img src="/media/ezxr/data/Aachen-Day-Night/sparse/aachen_d_mask_erode5pixel_part_start2gooff/0/wrong_match.png" style="zoom:35%;" />

调整inliner数量要求为300，去除了错位

使用hierarchical_mapper**不解决**错位

