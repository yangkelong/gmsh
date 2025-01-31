// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 18
//
//  Periodic meshes
//  周期性网格
// -----------------------------------------------------------------------------

// Periodic meshing constraints can be imposed on surfaces and curves.
// 周期性网格约束可以施加在表面和曲线上
// Let's use the OpenCASCADE geometry kernel to build two geometries.

SetFactory("OpenCASCADE");

// The first geometry is very simple: a unit cube with a non-uniform mesh size
// constraint (set on purpose to be able to verify visually that the periodicity
// constraint works!):
// 第一个几何体非常简单：一个单位立方体，具有非均匀网格尺寸约束（特意设置以便直观验证周期性约束是否有效）：

Box(1) = {0, 0, 0, 1, 1, 1};
MeshSize {:} = 0.1;
MeshSize {1} = 0.02;

// To impose that the mesh on surface 2 (the right side of the cube) should
// match the mesh from surface 1 (the left side), the following periodicity
// constraint is set:
// 为了强制立方体表面 2（右侧）的网格与表面 1（左侧）的网格相匹配，我们设置以下周期性约束：
Periodic Surface {2} = {1} Translate {1, 0, 0};

// During mesh generation, the mesh on surface 2 will be created by copying the
// mesh from surface 1.  Periodicity constraints can be specified with a
// `Translation', a `Rotation' or a general `Affine' transform.
// 在网格生成过程中，表面 2 上的网格将通过复制表面 1 上的网格来创建。周期性约束可以通过 `Translation'、`Rotation' 或一般的 `Affine' 变换来指定。

// Multiple periodicities can be imposed in the same way:
Periodic Surface {6} = {5} Translate {0, 0, 1};
Periodic Surface {4} = {3} Translate {0, 1, 0};

// For more complicated cases, finding the corresponding surfaces by hand can be
// tedious, especially when geometries are created through solid
// modelling. Let's construct a slightly more complicated geometry.

// We start with a cube and some spheres:
Box(10) = {2, 0, 0, 1, 1, 1};
x = 2-0.3; y = 0; z = 0;
Sphere(11) = {x, y, z, 0.35};
Sphere(12) = {x+1, y, z, 0.35};
Sphere(13) = {x, y+1, z, 0.35};
Sphere(14) = {x, y, z+1, 0.35};
Sphere(15) = {x+1, y+1, z, 0.35};
Sphere(16) = {x, y+1, z+1, 0.35};
Sphere(17) = {x+1, y, z+1, 0.35};
Sphere(18) = {x+1, y+1, z+1, 0.35};

// We first fragment all the volumes, which will leave parts of spheres
// protruding outside the cube:
v() = BooleanFragments { Volume{10}; Delete; }{ Volume{11:18}; Delete; };

// Ask OpenCASCADE to compute more accurate bounding boxes of entities using the STL mesh:
// 要求 OpenCASCADE 使用 STL 网格计算实体的更精确的边界框：
Geometry.OCCBoundsUseStl = 1;

// We then retrieve all the volumes in the bounding box of the original cube,
// and delete all the parts outside it:
// 然后我们检索原始立方体内边界框内的所有体积，并删除外部的所有部分：

eps = 1e-3;
vin() = Volume In BoundingBox {2-eps,-eps,-eps, 2+1+eps,1+eps,1+eps};
v() -= vin();
Recursive Delete{ Volume{v()}; }

// We now set a non-uniform mesh size constraint (again to check results visually):
// 我们现在设置一个非均匀网格尺寸约束（再次为了直观检查结果）：
MeshSize { PointsOf{ Volume{vin()}; }} = 0.1;
p() = Point In BoundingBox{2-eps, -eps, -eps, 2+eps, eps, eps};
MeshSize {p()} = 0.001;

// We now identify corresponding surfaces on the left and right sides of the
// geometry automatically.

// First we get all surfaces on the left:
// 我们现在自动识别几何体左侧和右侧的对应表面。
// 首先，我们获取左侧的所有表面：
Sxmin() = Surface In BoundingBox{2-eps, -eps, -eps, 2+eps, 1+eps, 1+eps};

For i In {0:#Sxmin()-1}
  // Then we get the bounding box of each left surface
  bb() = BoundingBox Surface { Sxmin(i) };
  // We translate the bounding box to the right and look for surfaces inside it:
  Sxmax() = Surface In BoundingBox { bb(0)-eps+1, bb(1)-eps, bb(2)-eps,
                                     bb(3)+eps+1, bb(4)+eps, bb(5)+eps };
  // For all the matches, we compare the corresponding bounding boxes...
  For j In {0:#Sxmax()-1}
    bb2() = BoundingBox Surface { Sxmax(j) };
    bb2(0) -= 1;
    bb2(3) -= 1;
    // ...and if they match, we apply the periodicity constraint
    // ...如果它们匹配，我们应用周期性约束
    If(Fabs(bb2(0)-bb(0)) < eps && Fabs(bb2(1)-bb(1)) < eps &&
       Fabs(bb2(2)-bb(2)) < eps && Fabs(bb2(3)-bb(3)) < eps &&
       Fabs(bb2(4)-bb(4)) < eps && Fabs(bb2(5)-bb(5)) < eps)
      Periodic Surface {Sxmax(j)} = {Sxmin(i)} Translate {1,0,0};
    EndIf
  EndFor
EndFor
