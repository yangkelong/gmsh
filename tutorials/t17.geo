// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 17
//
//  Anisotropic background mesh
//  各向异性背景网格
// -----------------------------------------------------------------------------

// As seen in `t7.geo', mesh sizes can be specified very accurately by providing
// a background mesh, i.e., a post-processing view that contains the target mesh
// sizes.

// Here, the background mesh is represented as a metric tensor field defined on
// a square. One should use bamg as 2d mesh generator to enable anisotropic
// meshes in 2D.
// 如在 `t7.geo` 中所见，可以通过提供背景网格（即包含目标网格尺寸的后处理视图）来非常精确地指定网格尺寸。

// 这里，背景网格表示为定义在正方形上的度量张量场。为了在 2D 中启用各向异性网格，应使用 bamg 作为 2D 网格生成器

SetFactory("OpenCASCADE");

// Create a square
Rectangle(1) = {-2, -2, 0, 4, 4};  // 左下角坐标, x方向上的长度, y方向上的长度

// Merge a post-processing view containing the target anisotropic mesh sizes
Merge "t17_bgmesh.pos";

// Apply the view as the current background mesh
Background Mesh View[0];

// Use bamg
Mesh.SmoothRatio = 3;
Mesh.AnisoMax = 1000;
Mesh.Algorithm = 7;
