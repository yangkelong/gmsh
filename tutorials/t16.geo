// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 16
//
//  Constructive Solid Geometry, OpenCASCADE geometry kernel
//
// -----------------------------------------------------------------------------

// Instead of constructing a model in a bottom-up fashion with Gmsh's built-in
// geometry kernel, starting with version 3 Gmsh allows you to directly use
// alternative geometry kernels. Here we use the OpenCASCADE kernel:
// 从版本 3 开始，Gmsh 允许你直接使用替代的几何内核，而不仅仅是以自下而上的方
// 式使用 Gmsh 的内置几何内核构建模型。这里我们使用 OpenCASCADE 内核：

SetFactory("OpenCASCADE");

// Let's build the same model as in `t5.geo', but using constructive solid
// geometry.

// We first create two cubes:
Box(1) = {0,0,0, 1,1,1};
Box(2) = {0,0,0, 0.5,0.5,0.5};

// We apply a boolean difference to create the "cube minus one eighth" shape:
// 应用布尔差集来创建“立方体减去八分之一”的形状, (3): Volume index = 3：
BooleanDifference(3) = { Volume{1}; Delete; }{ Volume{2}; Delete; };

// Boolean operations with OpenCASCADE always create new entities. Adding
// `Delete' in the arguments allows to automatically delete the original
// entities.
// 使用 OpenCASCADE 的布尔运算总是创建新的实体。在参数中添加 `Delete` 允许自动删除原始实体。

// We then create the five spheres:
x = 0 ; y = 0.75 ; z = 0 ; r = 0.09 ;
For t In {1:5}
  x += 0.166 ;
  z += 0.166 ;
  Sphere(3 + t) = {x, y, z, r};
  Physical Volume(t) = {3 + t};  
EndFor

// If we had wanted five empty holes we would have used `BooleanDifference'
// again. Here we want five spherical inclusions, whose mesh should be conformal
// with the mesh of the cube: we thus use `BooleanFragments', which intersects
// all volumes in a conformal manner (without creating duplicate interfaces):
// 如果我们想要五个空孔，我们将再次使用 `BooleanDifference`。这里我们想要五个球形包
// 含物，其网格应与立方体的网格保持一致：因此我们使用 `BooleanFragments`，它以一致的方式
// 相交所有体积（不创建重复的界面）：
v() = BooleanFragments{ Volume{3}; Delete; }{ Volume{3 + 1 : 3 + 5}; Delete; };

// When the boolean operation leads to simple modifications of entities, and if
// one deletes the original entities with `Delete', Gmsh tries to assign the
// same tag to the new entities. (This behavior is governed by the
// `Geometry.OCCBooleanPreserveNumbering' option.)
// 当布尔运算导致实体的简单修改，并且如果使用 `Delete` 删除原始实体，Gmsh 会尝试为新实体分配
// 相同的标签。（这种行为由 `Geometry.OCCBooleanPreserveNumbering` 选项控制。）

// Here the `Physical Volume' definitions made above will thus still work, as
// the five spheres (volumes 4, 5, 6, 7 and 8), which will be deleted by the
// fragment operations, will be recreated identically (albeit with new surfaces)
// with the same tags.
// 因此，上述的 `Physical Volume` 定义将仍然有效，因为五个球体（volumes 4、5、6、7 和 8），将被片段操作删除，
// 将被重新创建（尽管有新的表面）具有相同的标签。

// The tag of the cube will change though, so we need to access it
// programmatically:
// 但是立方体的标签会改变，所以我们需要以编程方式访问它：
Printf("Geometry.OCCBooleanPreserveNumbering: '%g'", Geometry.OCCBooleanPreserveNumbering);
Printf("tag: '%g'", #v());
Physical Volume(10) = v(#v()-1);  // v(#v()-1) 访问 v 列表最后一个元素

// Creating entities using constructive solid geometry is very powerful, but can
// lead to practical issues for e.g. setting mesh sizes at points, or
// identifying boundaries.

// To identify points or other bounding entities you can take advantage of the
// `PointfsOf' (a special case of the more general `Boundary' command) and the
// `In BoundingBox' commands.
// 使用构造性实体几何创建实体非常强大，但可能会导致实际问题，例如在点上设置网格尺寸或识别边界。

// 要识别点或其他边界实体，可以利用 `PointsOf`（`Boundary` 命令的特殊情况）和 `In BoundingBox`命令。
lcar1 = .1;
lcar2 = .0005;
lcar3 = .055;
eps = 1e-3;

// Assign a mesh size to all the points of all the volumes:
// 为所有体积的所有点分配网格尺寸：
MeshSize{ PointsOf{ Volume{:}; } } = lcar1;

// Override this constraint on the points of the five spheres:
// 覆盖这五个球体的点上的约束：
MeshSize{ PointsOf{ Volume{3 + 1 : 3 + 5}; } } = lcar3;

// Select the corner point by searching for it geometrically:
// 通过几何搜索选择角点：
p() = Point In BoundingBox{0.5-eps, 0.5-eps, 0.5-eps,
                           0.5+eps, 0.5+eps, 0.5+eps};
MeshSize{ p() } = lcar2;

// Additional examples created with the OpenCASCADE geometry kernel are
// available in `t18.geo', `t19.geo' and `t20.geo', as well as in the
// `examples/boolean' directory.
// 使用 OpenCASCADE 几何内核创建的额外示例在 `t18.geo`、`t19.geo` 和 `t20.geo` 中可用，
// 以及在 `examples/boolean` 目录中。