// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 11
//
//  Unstructured quadrangular meshes
//  非结构化四边形网格
// -----------------------------------------------------------------------------

// We have seen in tutorials `t3.geo' and `t6.geo' that extruded and transfinite
// meshes can be "recombined" into quads, prisms or hexahedra by using the
// "Recombine" keyword. Unstructured meshes can be recombined in the same
// way. Let's define a simple geometry with an analytical mesh size field:
// 在教程 `t3.geo` 和 `t6.geo` 中看到，通过使用 "Recombine" 关键字，可以将拉伸和有限元网格“重组”成四边形、
// 棱柱或六面体。非结构化网格也可以以相同的方式重组。我们来定义一个带有解析网格尺寸场的简单几何体：
Point(1) = {-1.25, -.5, 0}; Point(2) = {1.25, -.5, 0};
Point(3) = {1.25, 1.25, 0};  Point(4) = {-1.25, 1.25, 0};

Line(1) = {1, 2}; Line(2) = {2, 3};
Line(3) = {3, 4}; Line(4) = {4, 1};

Curve Loop(4) = {1, 2, 3, 4}; Plane Surface(100) = {4};

Field[1] = MathEval;
Field[1].F = "0.01*(1.0+30.*(y-x*x)*(y-x*x) + (1-x)*(1-x))";
Background Field = 1;

// To generate quadrangles instead of triangles, we can simply add
// 生成四边形网格
Recombine Surface{100};
// If we'd had several surfaces, we could have used `Recombine Surface {:};'.
// Yet another way would be to specify the global option "Mesh.RecombineAll =
// 1;".
// 如果我们有几个表面，我们可以使用 `Recombine Surface {:};`
// 另一种方式是指定全局选项 "Mesh.RecombineAll = 1;"

// The default recombination algorithm is called "Blossom": it uses a minimum
// cost perfect matching algorithm to generate fully quadrilateral meshes from
// triangulations. More details about the algorithm can be found in the
// following paper: J.-F. Remacle, J. Lambrechts, B. Seny, E. Marchandise,
// A. Johnen and C. Geuzaine, "Blossom-Quad: a non-uniform quadrilateral mesh
// generator using a minimum cost perfect matching algorithm", International
// Journal for Numerical Methods in Engineering 89, pp. 1102-1119, 2012.
// 默认的重组算法称为 "Blossom"：它使用最小成本完美匹配算法从三角剖分生成完全四边形网格。
// 关于算法的更多细节可以在以下论文中找到：...

// For even better 2D (planar) quadrilateral meshes, you can try the
// experimental "Frontal-Delaunay for quads" meshing algorithm, which is a
// triangulation algorithm that enables to create right triangles almost
// everywhere: J.-F. Remacle, F. Henrotte, T. Carrier-Baudouin, E. Bechet,
// E. Marchandise, C. Geuzaine and T. Mouton. A frontal Delaunay quad mesh
// generator using the L^inf norm. International Journal for Numerical Methods
// in Engineering, 94, pp. 494-512, 2013. Uncomment the following line to try
// the Frontal-Delaunay algorithms for quads:
//
// 为了获得更好的 2D（平面）四边形网格，你可以尝试实验性的 "Frontal-Delaunay for quads" 网格算法，
// 这是一个三角剖分算法，它几乎可以在任何地方创建直角三角形：... 取消注释以下行以尝试 Frontal-Delaunay 算法用于四边形：
Mesh.Algorithm = 8;  // "Frontal-Delaunay for quads" 网格算法

// The default recombination algorithm might leave some triangles in the mesh,
// if recombining all the triangles leads to badly shaped quads. In such cases,
// to generate full-quad meshes, you can either subdivide the resulting hybrid
// mesh (with Mesh.SubdivisionAlgorithm = 1), or use the full-quad recombination
// algorithm, which will automatically perform a coarser mesh followed by
// recombination, smoothing and subdivision. Uncomment the following line to try
// the full-quad algorithm:
// 默认的重组算法可能会在网格中留下一些三角形，如果重组所有三角形会导致形状不佳的四边形。
// 在这种情况下，要生成全四边形网格，你可以细分结果的混合网格（使用 Mesh.SubdivisionAlgorithm = 1），
// 或者使用全四边形重组算法，它将自动执行粗网格、重组、平滑和细分。取消注释以下行以尝试全四边形算法：
// Mesh.RecombinationAlgorithm = 2; // or 3

// Note that you could also apply the recombination algorithm and/or the
// subdivision step explicitly after meshing, as follows:
// 注意，你还可以在网格生成后显式应用重组算法和/或细分步骤，如下：
// Mesh 2;
// RecombineMesh;
// Mesh.SubdivisionAlgorithm = 1;
// RefineMesh;
