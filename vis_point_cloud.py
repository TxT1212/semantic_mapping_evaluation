import open3d as o3d
import argparse


def remove_outliner(input_cloud, output_cloud, std_ratio, nb_neighbors):
    pcd = o3d.io.read_point_cloud(input_cloud)
    inliner_cloud, ind = pcd.remove_statistical_outlier(nb_neighbors=nb_neighbors, std_ratio=std_ratio)
    outliner_cloud = pcd.select_by_index(ind, True)
    o3d.io.write_point_cloud(output_cloud, inliner_cloud)
    o3d.io.write_point_cloud(output_cloud+"outliner.ply", outliner_cloud)

def remove_outliner_main():
    parser = argparse.ArgumentParser(description="remove point cloud outliner with open3d")
    parser.add_argument("--input_cloud", help="path to input pointcloud")
    parser.add_argument("--output_cloud", help="path to output pointcloud")
    parser.add_argument("--std_ratio", help="smaller std means more aggresive removal", default="2.0")
    parser.add_argument("--nb_neighbors", help="number of neighbors", default="20")
    args = parser.parse_args()
    remove_outliner(args.input_cloud, args.output_cloud, args.std_ratio, args.std_ratio)

if __name__ == "__main__":
    remove_outliner_main()

    