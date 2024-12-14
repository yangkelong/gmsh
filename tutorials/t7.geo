// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 7
//
//  Background meshes
//  背景网格
// -----------------------------------------------------------------------------

// Mesh sizes can be specified very accurately by providing a background mesh,
// i.e., a post-processing view that contains the target mesh sizes.

// Merge a list-based post-processing view containing the target mesh sizes:

// 通过提供背景网格，即包含目标网格尺寸的后处理视图，可以非常精确地指定网格尺寸。
// 合并包含目标网格尺寸的基于列表的后处理视图：
Merge "t7_bgmesh.pos";

// If the post-processing view was model-based instead of list-based (i.e. if it
// was based on an actual mesh), we would need to create a new model to contain
// the geometry so that meshing it does not destroy the background mesh. It's
// not necessary here since the view is list-based, but it does no harm:
// 如果后处理视图是基于模型的而不是基于列表的（即如果它是基于实际网格的），我们将需要创建一个新的模型来包含几何体，
// 以便网格化它不会破坏背景网格。由于视图是基于列表的，这里没有必要这样做，但这样做也无害：
NewModel;

// Merge the first tutorial geometry:
// 合并第一个教程的几何体：
Merge "t1.geo";

// Apply the view as the current background mesh size field:
// 将视图应用为当前背景网格尺寸场：
Background Mesh View[0];

// In order to compute the mesh sizes from the background mesh only, and
// disregard any other size constraints, one can set:
// 为了仅从背景网格计算网格尺寸，并忽略任何其他尺寸约束，可以设置：
Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;

// See `t10.geo' for additional information: background meshes are actually a
// particular case of general "mesh size fields".
// 有关更多信息，请参见 t10.geo：背景网格实际上是一般“网格尺寸场”的一个特例。
