// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 21
//
//  Mesh partitioning
//  网格分区
// -----------------------------------------------------------------------------

// Gmsh can partition meshes using different algorithms, e.g. the graph
// partitioner Metis or the `SimplePartition' plugin. For all the partitioning
// algorithms, the relationship between mesh elements and mesh partitions is
// encoded through the creation of new (discrete) elementary entities, called
// "partition entities".
//
// Partition entities behave exactly like other discrete elementary entities;
// the only difference is that they keep track of both a mesh partition index
// and their parent elementary entity.
//
// The major advantage of this approach is that it allows to maintain a full
// boundary representation of the partition entities, which Gmsh creates
// automatically if `Mesh.PartitionCreateTopology' is set.

// Gmsh 可以使用不同的算法对网格进行分区，例如图形分割器 Metis 或 `SimplePartition` 插件。
// 对于所有的分割算法，网格元素与网格分区之间的关系是通过创建新的（离散的）基本实体来编码的，这些实体被称为“分区实体”。
//
// 分区实体的行为与其他离散基本实体完全相同；唯一的区别是它们既跟踪网格分区索引，也跟踪它们的父基本实体。
//
// 这种方法的主要优点是它允许保持分区实体的完整边界表示，如果设置了 
// `Mesh.PartitionCreateTopology`，Gmsh 会自动创建。

// Let us start by creating a simple geometry with two adjacent squares sharing
// an edge:
SetFactory("OpenCASCADE");
Rectangle(1) = {0, 0, 0, 1, 1};
Rectangle(2) = {1, 0, 0, 1, 1};
BooleanFragments{ Surface{1}; Delete; }{ Surface{2}; Delete; }
MeshSize {:} = 0.05;

// We create one physical group for each square, and we mesh the resulting
// geometry:
Physical Surface("Left", 100) = 1;
Physical Surface("Right", 200) = 2;
Mesh 2;

// We now define several constants to fine-tune how the mesh will be partitioned
DefineConstant[
  partitioner = {0, Choices{0="Metis", 1="SimplePartition"},
    Name "Parameters/0Mesh partitioner"}
  N = {3, Min 1, Max 256, Step 1,
    Name "Parameters/1Number of partitions"}
  topology = {1, Choices{0, 1},
    Name "Parameters/2Create partition topology (BRep)?"}
  ghosts = {0, Choices{0, 1},
    Name "Parameters/3Create ghost cells?"}
  physicals = {0, Choices{0, 1},
    Name "Parameters/3Create new physical groups?"}
  write = {1, Choices {0, 1},
    Name "Parameters/3Write file to disk?"}
  split = {0, Choices {0, 1},
    Name "Parameters/4Write one file per partition?"}
];

// Should we create the boundary representation of the partition entities?
Mesh.PartitionCreateTopology = topology;

// Should we create ghost cells?
Mesh.PartitionCreateGhostCells = ghosts;

// Should we automatically create new physical groups on the partition entities?
Mesh.PartitionCreatePhysicals = physicals;

// Should we keep backward compatibility with pre-Gmsh 4, e.g. to save the mesh
// in MSH2 format?
Mesh.PartitionOldStyleMsh2 = 0;

// Should we save one mesh file per partition?
// 我们应该每个分区保存一个网格文件吗？
Mesh.PartitionSplitMeshFiles = split;

If (partitioner == 0)
  // Use Metis to create N partitions
  // 使用 Metis 创建 N 个分区
  PartitionMesh N;
  // Several options can be set to control Metis: `Mesh.MetisAlgorithm' (1:
  // Recursive, 2: K-way), `Mesh.MetisObjective' (1: min. edge-cut, 2:
  // min. communication volume), `Mesh.PartitionTriWeight' (weight of
  // triangles), `Mesh.PartitionQuadWeight' (weight of quads), ...
  // 可以设置几个选项来控制 Metis：`Mesh.MetisAlgorithm' (1: 递归，2: K-way), 
  // `Mesh.MetisObjective' (1: 最小边割，2: 最小通信体积), `Mesh.PartitionTriWeight' (三角形权重), 
  // `Mesh.PartitionQuadWeight' (四边形权重)，...
Else
  // Use the `SimplePartition' plugin to create chessboard-like partitions
  Plugin(SimplePartition).NumSlicesX = N;
  Plugin(SimplePartition).NumSlicesY = 1;
  Plugin(SimplePartition).NumSlicesZ = 1;
  Plugin(SimplePartition).Run;
EndIf

// Save mesh file (or files, if `Mesh.PartitionSplitMeshFiles' is set):
// 使用 `SimplePartition` 插件创建棋盘式分区
If(write)
  Save "t21.msh";
EndIf
