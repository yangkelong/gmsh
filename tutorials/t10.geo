// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 10
//
//  Mesh size fields
//  网格尺寸场
// -----------------------------------------------------------------------------

// In addition to specifying target mesh sizes at the points of the geometry
// (see `t1.geo') or using a background mesh (see `t7.geo'), you can use general
// mesh size "Fields".
// 除了在几何点上指定目标网格尺寸（见 `t1.geo'）或使用背景网格（见 `t7.geo'），还可以使用一般的网格尺寸“场”。
// Let's create a simple rectangular geometry
lc = .15;
Point(1) = {0.0,0.0,0,lc}; Point(2) = {1,0.0,0,lc};
Point(3) = {1,1,0,lc};     Point(4) = {0,1,0,lc};
Point(5) = {0.2,.5,0,lc};

Line(1) = {1,2}; Line(2) = {2,3}; Line(3) = {3,4}; Line(4) = {4,1};

Curve Loop(5) = {1,2,3,4}; Plane Surface(6) = {5};

// Say we would like to obtain mesh elements with size lc/30 near curve 2 and
// point 5, and size lc elsewhere. To achieve this, we can use two fields:
// "Distance", and "Threshold". We first define a Distance field (`Field[1]') on
// points 5 and on curve 2. This field returns the distance to point 5 and to
// (100 equidistant points on) curve 2.
// 假设我们希望在曲线 2 和点 5 附近获得 lc/30 尺寸的网格元素，其他地方使用 lc 尺寸。
// 为了实现这一点，我们可以使用两个场：“Distance” 和 “Threshold”。
// 在点 5 和 曲线 2 上定义一个距离场（`Field[1]`）。这个场返回到点 5 和（曲线 2 上的 100 个等距点）的距离。
Field[1] = Distance;
Field[1].PointsList = {5};
Field[1].CurvesList = {2};
Field[1].Sampling = 100;


// We then define a `Threshold' field, which uses the return value of the
// `Distance' field 1 in order to define a simple change in element size
// depending on the computed distances
// 然后定义一个 `Threshold` 场，它使用 `Distance` 场 1 的返回值来定义一个简单的元素尺寸变化，这取决于计算出的距离
//
// SizeMax -                     /------------------
//                              /
//                             /
//                            /
// SizeMin -o----------------/
//          |                |    |
//        Point         DistMin  DistMax
Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = lc / 30;
Field[2].SizeMax = lc;
Field[2].DistMin = 0.15;
Field[2].DistMax = 0.5;

// Say we want to modulate the mesh element sizes using a mathematical function
// of the spatial coordinates. We can do this with the MathEval field:
// 假设我们想使用空间坐标的数学函数来调节网格元素尺寸。我们可以使用 MathEval 场来实现：
Field[3] = MathEval;
Field[3].F = "cos(4*3.14*x) * sin(4*3.14*y) / 10 + 0.101";

// We could also combine MathEval with values coming from other fields. For
// example, let's define a `Distance' field around point 1
// 我们还可以将 MathEval 与其他场的值结合起来。例如，我们定义一个围绕点 1 的 `Distance` 场
Field[4] = Distance;
Field[4].PointsList = {1};

// We can then create a `MathEval' field with a function that depends on the
// return value of the `Distance' field 4, i.e., depending on the distance to
// point 1 (here using a cubic law, with minimum element size = lc / 100)
// 然后我们可以创建一个依赖于 `Distance` 场 4 的返回值的 `MathEval` 场，即，取决于到点 1 的距离（这里使用三次方定律，最小元素尺寸 = lc / 100）
Field[5] = MathEval;
Field[5].F = Sprintf("F4^3 + %g", lc / 100);

// We could also use a `Box' field to impose a step change in element sizes
// inside a box
// 还可以使用 `Box` 场在盒子内部强制改变元素尺寸
Field[6] = Box;
Field[6].VIn = lc / 15;
Field[6].VOut = lc;
Field[6].XMin = 0.3;
Field[6].XMax = 0.6;
Field[6].YMin = 0.3;
Field[6].YMax = 0.6;
Field[6].Thickness = 0.3;

// Many other types of fields are available: see the reference manual for a
// complete list. You can also create fields directly in the graphical user
// interface by selecting `Define->Size fields' in the `Mesh' module.
// 许多其他类型的场都是可用的：参见参考手册以获得完整列表。你还可以在使用图形用户界面时
// 直接在 `Mesh` 模块中选择 `Define->Size fields` 来创建场。
// Let's use the minimum of all the fields as the background mesh size field
Field[7] = Min;
Field[7].FieldsList = {2, 3, 5, 6};
// 使用所有场的最小值作为背景网格尺寸场
Background Field = 7;

// To determine the size of mesh elements, Gmsh locally computes the minimum of
//
// 1) the size of the model bounding box;
// 2) if `Mesh.MeshSizeFromPoints' is set, the mesh size specified at
//    geometrical points;
// 3) if `Mesh.MeshSizeFromCurvature' is positive, the mesh size based on
//    curvature (the value specifying the number of elements per 2 * pi rad);
// 4) the background mesh size field;
// 5) any per-entity mesh size constraint.
//
// This value is then constrained in the interval [`Mesh.MeshSizeMin',
// `Mesh.MeshSizeMax'] and multiplied by `Mesh.MeshSizeFactor'. In addition,
// boundary mesh sizes are interpolated inside surfaces and/or volumes depending
// on the value of `Mesh.MeshSizeExtendFromBoundary' (which is set by default).
//
// When the element size is fully specified by a mesh size field (as it is in
// this example), it is thus often desirable to set
// 为了确定网格元素的尺寸，Gmsh 会本地计算以下最小值：
//
// 1) 模型边界框的尺寸；
// 2) 如果 `Mesh.MeshSizeFromPoints` 被设置，几何点上指定的网格尺寸；
// 3) 如果 `Mesh.MeshSizeFromCurvature` 是正数，基于曲率的网格尺寸（该值指定了每 2 * pi 弧度的元素数量）；
// 4) 背景网格尺寸场；
// 5) 任何每个实体的网格尺寸约束。
//
// 然后这个值会在区间 [`Mesh.MeshSizeMin', `Mesh.MeshSizeMax'] 中被限制，并乘以 `Mesh.MeshSizeFactor'。此外，边界网格尺寸会根据 `Mesh.MeshSizeExtendFromBoundary' 的值在表面和/或体积内部进行插值（默认设置）。
//
// 当元素尺寸完全由网格尺寸场指定时（如本例中的情况），通常希望设置
Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;

// This will prevent over-refinement due to small mesh sizes on the boundary.
// 这将防止由于边界上的小网格尺寸而导致的过度细化。
// Finally, while the default "Frontal-Delaunay" 2D meshing algorithm
// (Mesh.Algorithm = 6) usually leads to the highest quality meshes, the
// "Delaunay" algorithm (Mesh.Algorithm = 5) will handle complex mesh size
// fields better - in particular size fields with large element size gradients:
// 最后，虽然默认的 "Frontal-Delaunay" 2D 网格算法（Mesh.Algorithm = 6）通常会产生最高质量的网格，
// 但 "Delaunay" 算法（Mesh.Algorithm = 5）会更好地处理复杂的网格尺寸场——特别是具有大元素尺寸梯度的尺寸场：
Mesh.Algorithm = 5;  // "Delaunay" 算法, 更好地处理复杂的网格尺寸场——特别是具有大元素尺寸梯度的尺寸场
// Mesh.Algorithm = 6;  // "Frontal-Delaunay" 2D 网格算法, 通常会产生最高质量的网格



