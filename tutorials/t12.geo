// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 12
//
//  Cross-patch meshing with compounds
//  使用复合进行跨补丁网格生成
// -----------------------------------------------------------------------------

// 这段代码展示了如何使用 Gmsh 的复合网格约束来处理复杂的几何形状，特别是那些由多个表面或曲线组成的形状。通过将多个曲线或表面视为一个单一的复合曲线或复合表面，Gmsh 可以在这些曲线或表面之间生成网格，而不需要在它们的几何描述上进行网格化。

// 首先定义了一些点和线，并创建了曲线和表面。
// 使用 Compound Curve 指令将曲线 2、3 和 4 视为一个单一曲线进行网格化，这样在点 6 和 7 之间就可以进行网格化。
// 同样地，将曲线 6、7 和 8 视为一个单一曲线。
// 使用 Compound Surface 指令将表面 1、5 和 10 视为一个单一表面进行网格化，这样在曲线 9 和 10 之间就可以进行网格化。
// 这种方法特别适用于处理那些包含复杂小特征的 CAD 模型，因为这些小特征可能不适合直接网格化，但可以通过复合网格约束来处理。通过这种方式，可以在保持几何形状整体性的同时，对模型的特定部分进行更精细的网格控制。

// "Compound" meshing constraints allow to generate meshes across surface
// boundaries, which can be useful e.g. for imported CAD models (e.g. STEP) with
// undesired small features.
// “复合”网格约束允许在表面边界之间生成网格，这在例如导入的 CAD 模型（如 STEP）中包含不想要的小特征时非常有用。

// When a `Compound Curve' or `Compound Surface' meshing constraint is given,
// at mesh generation time Gmsh
//  1. meshes the underlying elementary geometrical entities, individually
//  2. creates a discrete entity that combines all the individual meshes
//  3. computes a discrete parametrization (i.e. a piece-wise linear mapping)
//     on this discrete entity
//  4. meshes the discrete entity using this discrete parametrization instead
//     of the underlying geometrical description of the underlying elementary
//     entities making up the compound
//  5. optionally, reclassifies the mesh elements and nodes on the original
//     entities
// 当给出 `复合曲线' 或 `复合表面' 网格约束时，在网格生成时 Gmsh
//  1. 单独网格化底层的基本几何实体
//  2. 创建一个离散实体，组合所有单独的网格
//  3. 在这个离散实体上计算离散参数化（即分段线性映射）
//  4. 使用这个离散参数化而不是底层基本实体的几何描述来网格化离散实体
//  5. 可选地，在原始实体上的网格元素和节点进行重新分类

// Step 3. above can only be performed if the mesh resulting from the
// combination of the individual meshes can be reparametrized, i.e. if the shape
// is "simple enough". If the shape is not amenable to reparametrization, you
// should create a full mesh of the geometry and first re-classify it to
// generate patches amenable to reparametrization (see `t13.geo').

// The mesh of the individual entities performed in Step 1. should usually be
// finer than the desired final mesh; this can be controlled with the
// `Mesh.CompoundMeshSizeFactor' option.

// The optional reclassification on the underlying elementary entities in Step
// 5. is governed by the `Mesh.CompoundClassify' option.
// 上述第 3 步只有在组合单独网格产生的结果可以重新参数化时才能执行，即如果形状“足够简单”。
// 如果形状不适合重新参数化，你应该首先创建完整的几何网格，然后重新分类它以生成适合重新参数化的补丁（见 `t13.geo'）。

// 在第 1 步中执行的单个实体的网格应该通常比最终期望的网格更细；这可以通过 `Mesh.CompoundMeshSizeFactor' 选项来控制。

// 第 5 步中在底层基本实体上的可选重新分类由 `Mesh.CompoundClassify' 选项控制。
lc = 0.1;

Point(1) = {0, 0, 0, lc};       Point(2) = {1, 0, 0, lc};
Point(3) = {1, 1, 0.5, lc};     Point(4) = {0, 1, 0.4, lc};
Point(5) = {0.3, 0.2, 0, lc};   Point(6) = {0, 0.01, 0.01, lc};
Point(7) = {0, 0.02, 0.02, lc}; Point(8) = {1, 0.05, 0.02, lc};
Point(9) = {1, 0.32, 0.02, lc};

Line(1) = {1, 2}; Line(2) = {2, 8}; Line(3) = {8, 9};
Line(4) = {9, 3}; Line(5) = {3, 4}; Line(6) = {4, 7};
Line(7) = {7, 6}; Line(8) = {6, 1}; Spline(9) = {7, 5, 9};
Line(10) = {6, 8};

Curve Loop(11) = {5, 6, 9, 4};     Surface(1) = {11};
Curve Loop(13) = {-9, 3, 10, 7}; Surface(5) = {13};
Curve Loop(15) = {-10, 2, 1, 8}; Surface(10) = {15};

// Treat curves 2, 3 and 4 as a single curve when meshing (i.e. mesh across points 6 and 7)
// 在网格生成时将曲线 2、3 和 4 视为单一曲线（即在点 6 和 7 之间网格化）
Compound Curve{2, 3, 4};

// Idem with curves 6, 7 and 8
Compound Curve{6, 7, 8};

// Treat surfaces 1, 5 and 10 as a single surface when meshing (i.e. mesh across
// curves 9 and 10)
// 在网格生成时将表面 1、5 和 10 视为单一表面（即在曲线 9 和 10 之间网格化）
Compound Surface{1, 5, 10};
