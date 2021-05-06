import open3d as o3d
import argparse


def remove_outliner(input_cloud, output_cloud, nb_neighbors, std_ratio):
    pcd = o3d.io.read_point_cloud(input_cloud)
    inliner_cloud, ind = pcd.remove_statistical_outlier(nb_neighbors=nb_neighbors, std_ratio=std_ratio)
    outliner_cloud = pcd.select_by_index(ind, True)
    o3d.io.write_point_cloud(output_cloud, inliner_cloud)
    o3d.io.write_point_cloud(output_cloud+"outliner.ply", outliner_cloud)

def remove_outliner_main():
    parser = argparse.ArgumentParser(description="remove point cloud outliner with open3d")
    parser.add_argument("--input_cloud", help="path to input pointcloud")
    parser.add_argument("--output_cloud", help="path to output pointcloud")
    parser.add_argument("--std_ratio", help="smaller std means more aggresive removal", type=float, default=2.0)
    parser.add_argument("--nb_neighbors", help="number of neighbors", type=int, default=20)
    args = parser.parse_args()
    print(args)
    remove_outliner(args.input_cloud, args.output_cloud, args.nb_neighbors, args.std_ratio)

def poisson_point_cloud(input_cloud_with_normal, input_depth):
    pcd = o3d.io.read_point_cloud(input_cloud_with_normal)
    with o3d.utility.VerbosityContextManager(o3d.utility.VerbosityLevel.Debug) as cm:
        mesh, densities = o3d.geometry.TriangleMesh.create_from_point_cloud_poisson(pcd, depth=input_depth)
    print(mesh)
    o3d.io.write_triangle_mesh(input_cloud_with_normal+"_mesh.ply", mesh)
 #   o3d.visualization.draw_geometries([mesh])

# attention: no surface trimmer in open3d's poisson
def poisson_point_cloud_main():
    parser = argparse.ArgumentParser(description="poisson with open3d")
    parser.add_argument("--input_cloud", help="path to input pointcloud")
    parser.add_argument("--depth", help="smaller std means more aggresive removal", type=int, default=9)
    args = parser.parse_args()
    print(args)
    poisson_point_cloud(args.input_cloud, args.depth)


if __name__ == "__main__":
   remove_outliner_main()
   #poisson_point_cloud_main()

    