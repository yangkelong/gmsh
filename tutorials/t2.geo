// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 2
//
//  Transformations, extruded geometries, volumes
//  变换、拉伸几何体、体积
//
// -----------------------------------------------------------------------------

// We first include the previous tutorial file, in order to use it as a basis
// for this one. Including a file is equivalent to copy-pasting its contents:
// 我们首先包含之前的教程文件，以便将其作为本教程的基础。
// 包含一个文件等同于复制粘贴其内容：
Include "t1.geo";

// We can then add new points and curves in the same way as we did in `t1.geo':

Point(5) = {0, .4, 0, lc};
Line(5) = {4, 5};

// Gmsh also provides tools to transform (translate, rotate, etc.)
// elementary entities or copies of elementary entities. For example, point
// 5 can be moved by 0.02 to the left with:
// Gmsh 还提供了变换（平移、旋转等）基本实体或基本实体副本的工具。
// 点 5 向左移动 0.02：
Translate {-0.02, 0, 0} { Point{5}; }

// And it can be further rotated by -Pi/4 around (0, 0.3, 0) (with the rotation
// along the z axis) with:
// 围绕 (0, 0.3, 0) 旋转 -Pi/4（旋转沿 z 轴 {0,0,1}）：
Rotate {{0,0,1}, {0,0.3,0}, -Pi/4} { Point{5}; }

// Note that there are no units in Gmsh: coordinates are just numbers - it's up
// to the user to associate a meaning to them.

// Point 3 can be duplicated and translated by 0.05 along the y axis:
// 点 3 被复制并沿 y 轴平移 0.05：
Translate {0, 0.05, 0} { Duplicata{ Point{3}; } }

// This command created a new point with an automatically assigned tag. This tag
// can be obtained using the graphical user interface by hovering the mouse over
// the point: in this case, the new point has tag `6'.
// 该命令创建了一个新的点，其标签会自动分配。这个标签可以通过图形用户界面通过将鼠标悬停在点上来获得：在这种情况下，新点的标签为 6。
Line(7) = {3, 6};
Line(8) = {6, 5};
Curve Loop(10) = {5,-8,-7,3};
Plane Surface(11) = {10};

// To automate the workflow, instead of using the graphical user interface to
// obtain the tags of newly created entities, one can use the return value of
// the transformation commands directly. For example, the `Translate' command
// returns a list containing the tags of the translated entities. Let's
// translate copies of the two surfaces 1 and 11 to the right with the following
// command:
// 为了自动化工作流程，而不是使用图形用户界面来获取新创建实体的标签，可以直接使用变换命令的返回值。
// 例如，Translate 命令返回包含被平移实体标签的列表。让我们使用以下命令将两个表面 1 和 11 的副本向右平移：
my_new_surfs[] = Translate {0.12, 0, 0} { Duplicata{ Surface{1, 11}; } };

// my_new_surfs[] (note the square brackets, and the `;' at the end of the
// command) denotes a list, which contains the tags of the two new surfaces
// (check `Tools->Message console' to see the message):
// my_new_surfs[]（注意方括号和命令末尾的 ;）表示一个列表，其中包含两个新表面的标签（检查 Tools->Message console 以查看消息）：
Printf("New surfaces '%g' and '%g'", my_new_surfs[0], my_new_surfs[1]);

// In Gmsh lists use square brackets for their definition (mylist[] = {1, 2,
// 3};) as well as to access their elements (myotherlist[] = {mylist[0],
// mylist[2]}; mythirdlist[] = myotherlist[];), with list indexing starting at
// 0. To get the size of a list, use the hash (pound): len = #mylist[].
//
// Note that parentheses can also be used instead of square brackets, so that we
// could also write `myfourthlist() = {mylist(0), mylist(1)};'.

// Volumes are the fourth type of elementary entities in Gmsh. In the same way
// one defines curve loops to build surfaces, one has to define surface loops
// (i.e. `shells') to build volumes. The following volume does not have holes
// and thus consists of a single surface loop:
// 在 Gmsh 中，列表使用方括号定义（mylist[] = {1, 2, 3};）以及访问它们的元素（myotherlist[] = {mylist[0], mylist[2]}; mythirdlist[] = myotherlist[];），
// 列表索引从 0 开始。要获取列表的大小，使用井号（hash）：len = #mylist[]。
//
// 注意，也可以使用括号代替方括号，因此我们也可以写 `myfourthlist() = {mylist(0), mylist(1)};'。

// 体积是 Gmsh 中的第四种基本实体。与定义表面相同，定义曲线环来构建表面，必须定义表面环（即 shells）来构建体积。以下体积没有孔洞，因此由单个表面环组成：
Point(100) = {0., 0.3, 0.12, lc};  Point(101) = {0.1, 0.3, 0.12, lc};
Point(102) = {0.1, 0.35, 0.12, lc};

// 取点坐标 --> 列表
xyz[] = Point{5}; // Get coordinates of point 5
Point(103) = {xyz[0], xyz[1], 0.12, lc};

Line(110) = {4, 100};   Line(111) = {3, 101};
Line(112) = {6, 102};   Line(113) = {5, 103};
Line(114) = {103, 100}; Line(115) = {100, 101};
Line(116) = {101, 102}; Line(117) = {102, 103};
// Note: 曲线环与表面不共享唯一索引
// 先定义中间结构 曲线环    再用曲线环定义 表面实体
Curve Loop(118) = {115, -111, 3, 110};  Plane Surface(119) = {118};
Curve Loop(120) = {111, 116, -112, -7}; Plane Surface(121) = {120};
Curve Loop(122) = {112, 117, -113, -8}; Plane Surface(123) = {122};
Curve Loop(124) = {114, -110, 5, 113};  Plane Surface(125) = {124};
Curve Loop(126) = {115, 116, 117, 114}; Plane Surface(127) = {126};
// 
// 先定义中间结构 表面环    再用表面环定义 体积实体
Surface Loop(128) = {127, 119, 121, 123, 125, 11};
Volume(129) = {128};

// When a volume can be extruded from a surface, it is usually easier to use the
// `Extrude' command directly instead of creating all the points, curves and
// surfaces by hand. For example, the following command extrudes the surface 11
// along the z axis and automatically creates a new volume (as well as all the
// needed points, curves and surfaces):
// 当一个体积可以从一个表面拉伸出来时，通常使用 Extrude 命令直接进行会更容易，而不是手动创建所有点、曲线和表面。
// 例如，以下命令沿 z 轴拉伸表面 11 长度: 0.12，并自动创建一个新体积（以及所有需要的点、曲线和表面）
Extrude {0, 0, 0.12} { Surface{my_new_surfs[1]};}
// The following command permits to manually assign a mesh size to some of the
// new points:
// 以下命令允许手动为一些新点分配网格大小：
MeshSize {103, 105, 109, 102, 28, 24, 6, 5} = lc * 3;

// We finally group volumes 129 and 130 in a single physical group with tag `1'
// and name "The volume":
// 最后，我们将体积 129 和 130 归入一个标签为 1 和名称为 "The volume" 的单个物理组：
Physical Volume("The volume", 1) = {129,130};

// Note that, if the transformation tools are handy to create complex
// geometries, it is also sometimes useful to generate the `flat' geometry, with
// an explicit representation of all the elementary entities.
//
// With the built-in geometry kernel, this can be achieved with `File->Export' by
// selecting the `Gmsh Unrolled GEO' format, or by adding
//
//   Save "file.geo_unrolled";
//
// in the script. It can also be achieved with `gmsh t2.geo -0' on the command
// line.
//
// With the OpenCASCADE geometry kernel, unrolling the geometry can be achieved
// with `File->Export' by selecting the `OpenCASCADE BRep' format, or by adding
//
//   Save "file.brep";
//
// in the script. (OpenCASCADE geometries can also be exported to STEP.)

// It is important to note that Gmsh never translates geometry data into a
// common representation: all the operations on a geometrical entity are
// performed natively with the associated geometry kernel. Consequently, one
// cannot export a geometry constructed with the built-in kernel as an
// OpenCASCADE BRep file; or export an OpenCASCADE model as an Unrolled GEO
// file.
// 注意，如果变换工具对于创建复杂几何体很有用，有时生成 flat 几何体也很有用，它具有所有基本实体的显式表示。
//
// 使用内置几何内核，这可以通过 文件->导出 通过选择 Gmsh Unrolled GEO 格式来实现，或者在脚本中添加
//
//   Save "file.geo_unrolled";
//
// 也可以通过命令行 gmsh t2.geo -0 实现。
//
// 使用 OpenCASCADE 几何内核，展开几何体可以通过 文件->导出 通过选择 OpenCASCADE BRep 格式来实现，或者在脚本中添加
//
//   Save "file.brep";
//
// （OpenCASCADE 几何体也可以导出到 STEP 格式）。

// 重要的是要注意 Gmsh 从不将几何数据转换为共同表示：所有对几何实体的操作都是使用相关几何内核本地执行的。
// 因此，不能将使用内置内核构建的几何体导出为 OpenCASCADE BRep 文件；或者将 OpenCASCADE 模型导出为 Unrolled GEO 文件。




// "Flat" 几何体在 Gmsh 中指的是一种几何体的表示方式，其中所有的几何实体（点、曲线、表面和体积）都以一种平面化或展开的形式存在。这种表示方式将三维几何体“压平”到二维空间中，使得几何体的所有元素都在一个单一的平面上表示，就像将一个三维物体展开成一个平面图一样。

// 在 Gmsh 中，"flat" 几何体的概念主要用于以下几个方面：

// 几何展开：将三维几何体展开到二维平面上，这在某些工程应用中非常有用，比如在制造领域，需要将三维模型展开以计算材料需求或指导制造过程。

// 数据交换：在不同的几何内核或软件之间交换数据时，"flat" 几何体提供了一种中间格式，使得数据可以被不同系统理解和处理。

// 几何分析：在进行几何分析时，"flat" 几何体可以简化问题，使得分析过程更加直观和容易处理。

// 可视化：在 Gmsh 的 GUI 中，"flat" 几何体可以用于更清晰地展示几何结构，尤其是在处理复杂的三维模型时。

// 在 Gmsh 中生成 "flat" 几何体可以通过以下方式：

// 使用 File->Export 菜单，选择 Gmsh Unrolled GEO 格式来导出 "flat" 几何体。
// 在 Gmsh 脚本中添加 Save "file.geo_unrolled"; 命令来保存 "flat" 几何体。
// 对于使用 OpenCASCADE 几何内核的模型，可以通过选择 OpenCASCADE BRep 格式来导出 "flat" 几何体，或者添加 Save "file.brep"; 命令。
// "Flat" 几何体是 Gmsh 提供的一种强大的工具，它允许用户以不同的方式查看和处理几何数据，以适应各种特定的需求和应用场景。






