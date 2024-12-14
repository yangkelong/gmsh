// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 19
//
//  Thrusections, fillets, pipes, mesh size from curvature
//  贯穿体、倒圆角、管道、基于曲率的网格尺寸
// -----------------------------------------------------------------------------

// The OpenCASCADE geometry kernel supports several useful features for solid modelling.

SetFactory("OpenCASCADE");

// Volumes can be constructed from (closed) curve loops thanks to the `ThruSections' command
// 可以通过 `ThruSections` 命令从（封闭的）曲线环构建体积
Circle(1) = {0,0,0, 0.5};       Curve Loop(1) = 1;
Circle(2) = {0.1,0.05,1, 0.1};  Curve Loop(2) = 2;
Circle(3) = {-0.1,-0.1,2, 0.3}; Curve Loop(3) = 3;
ThruSections(1) = {1:3};

// With `Ruled ThruSections' you can force the use of ruled surfaces:
// 使用 `Ruled ThruSections` 可以强制使用直纹表面：
Circle(11) = {2+0,0,0, 0.5};      Curve Loop(11) = 11;
Circle(12) = {2+0.1,0.05,1, 0.1}; Curve Loop(12) = 12;
Circle(13) = {2-0.1,-0.1,2, 0.3}; Curve Loop(13) = 13;
Ruled ThruSections(11) = {11:13};

// We copy the first volume, and fillet all its edges:
// 我们复制第一个体积，并对其所有边进行倒圆角：
v() = Translate{4, 0, 0} { Duplicata{ Volume{1}; } };
f() = Abs(Boundary{ Volume{v(0)}; });
e() = Unique(Abs(Boundary{ Surface{f()}; }));
Fillet{v(0)}{e()}{0.1}

// OpenCASCADE also allows general extrusions along a smooth path. Let's first
// define a spline curve:
// OpenCASCADE 还允许沿平滑路径进行一般挤出。首先定义一个样条曲线：
nturns = 1;
npts = 20;
r = 1;
h = 1 * nturns;
For i In {0 : npts - 1}
  theta = i * 2*Pi*nturns/npts;
  Point(1000 + i) = {r * Cos(theta), r * Sin(theta), i * h/npts};
EndFor
Spline(1000) = {1000 : 1000 + npts - 1};

// A wire is like a curve loop, but open:
// 线框类似于曲线环，但是是开放的：
Wire(1000) = {1000};

// We define the shape we would like to extrude along the spline (a disk):
// 我们定义沿样条曲线挤出的形状（一个圆盘）：
Disk(1000) = {1,0,0, 0.2};
Rotate {{1, 0, 0}, {0, 0, 0}, Pi/2} { Surface{1000}; }

// We extrude the disk along the spline to create a pipe:
// 我们沿样条曲线挤出圆盘以创建一个管道：
Extrude { Surface{1000}; } Using Wire {1000}

// We delete the source surface, and increase the number of sub-edges for a
// nicer display of the geometry:
// 我们删除源表面，并增加子边的数量以更好地显示几何体：
Delete{ Surface{1000}; }
Geometry.NumSubEdges = 1000;

// We can activate the calculation of mesh element sizes based on curvature
// (here with a target of 20 elements per 2*Pi radians):
// 我们可以激活基于曲率的网格元素尺寸计算（这里的目标是每 2*Pi 弧度 20 个元素）：
Mesh.MeshSizeFromCurvature = 20;

// We can constraint the min and max element sizes to stay within reasonnable
// values (see `t10.geo' for more details):
// 我们可以限制最小和最大元素尺寸以保持合理的值（更多细节见 `t10.geo`）：
Mesh.MeshSizeMin = 0.001;
Mesh.MeshSizeMax = 0.3;
