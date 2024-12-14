// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 1
//
//  Geometry basics, elementary entities, physical groups
//
// -----------------------------------------------------------------------------

// The simplest construction in Gmsh's scripting language is the
// `affectation'（赋值）. The following command defines a new variable `lc':

lc = 1e-2;

// This variable can then be used in the definition of Gmsh's simplest
// `elementary entity', a `Point'. A Point is uniquely identified by a tag (a
// strictly positive integer; here `1') and defined by a list of four numbers:
// three coordinates (X, Y and Z) and the target mesh size (lc) close to the
// 定义一个点，标签（tag为一个严格正整形）为1，坐标为(0, 0, 0)，网格尺寸参数为 lc = 1e-2
Point(1) = {0, 0, 0, lc};

// The distribution of the mesh element sizes will then be obtained by
// interpolation of these mesh sizes throughout the geometry. Another method to
// specify mesh sizes is to use general mesh size Fields (see `t10.geo'). A
// particular case is the use of a background mesh (see `t7.geo').

// If no target mesh size of provided, a default uniform coarse size will be
// used for the model, based on the overall model size.

// We can then define some additional points. All points should have different
// tags:

// 网格元素尺寸的分布将通过对整个几何体点上网格尺寸分布(mesh size 在点中定义)进行
// 插值得到。另一种指定网格尺寸的方法是使用通用的网格尺寸场（参见 t10.geo）。一个特殊情况是使用背景网格（参见 t7.geo）。
// 如果没有提供目标网格尺寸，将基于整个模型的尺寸使用默认的均匀粗糙尺寸来处理模型。
// 然后我们可以定义一些额外的点。所有点都应该有不同的标签：

Point(2) = {.1, 0,  0, lc};
Point(3) = {.1, .3, 0, lc};
Point(4) = {0,  .3, 0, lc};

// Curves are Gmsh's second type of elementary entities, and, amongst curves,
// straight lines are the simplest. A straight line is identified by a tag and
// is defined by a list of two point tags. In the commands below, for example,
// the line 1 starts at point 1 and ends at point 2.
//
// Note that curve tags are separate from point tags - hence we can reuse tag
// `1' for our first curve. And as a general rule, elementary entity tags in
// Gmsh have to be unique per geometrical dimension.
// 曲线是 Gmsh 的第二种基本实体，而在曲线中，直线是最简单的。一条直线由一个标签标识，并且由两个点的标签列表定义。在下面的命令中，例如，线 1 从点 1 开始，到点 2 结束。
//
// 注意，曲线标签是独立于点标签的——因此我们可以重用标签 1 作为我们的第一个曲线。而且作为一般规则，在 Gmsh 中，基本实体的标签在每个几何维度上必须是唯一的。
// 定义线
Line(1) = {1, 2};
Line(2) = {3, 2};
Line(3) = {3, 4};
Line(4) = {4, 1};

// The third elementary entity is the surface. In order to define a simple
// rectangular surface from the four curves defined above, a curve loop has
// first to be defined. A curve loop is also identified by a tag (unique amongst
// curve loops) and defined by an ordered list of connected curves, a sign being
// associated with each curve (depending on the orientation of the curve to form
// a loop):
// 第三种基本实体是表面。为了从上面定义的四条曲线定义一个简单的矩形表面，首先需要定义一个曲线环。
// 曲线环也由一个标签（在曲线环中唯一）标识，并通过一个有序连接的曲线列表来定义，每个曲线都与一个符号相关联（这取决于曲线的朝向以形成一个环）：
Curve Loop(1) = {4, 1, -2, 3};  // 符号表示曲线的方向

// We can then define the surface as a list of curve loops (only one here,
// representing the external contour, since there are no holes--see `t4.geo' for
// an example of a surface with a hole):
// 然后我们可以将表面定义为曲线环的列表（这里只有一个，代表外部轮廓，因为没有孔洞——参见 t4.geo 以了解带有孔洞的表面的示例）：
// 在更复杂的表面中，可能还会有内部的孔洞，这些孔洞也会由曲线环来定义。
Plane Surface(1) = {1};

// At this level, Gmsh knows everything to display the rectangular surface 1 and
// to mesh it. An optional step is needed if we want to group elementary
// geometrical entities into more meaningful groups, e.g. to define some
// mathematical ("domain", "boundary"), functional ("left wing", "fuselage") or
// material ("steel", "carbon") properties.
//
// Such groups are called "Physical Groups" in Gmsh. By default, if physical
// groups are defined, Gmsh will export in output files only mesh elements that
// belong to at least one physical group. (To force Gmsh to save all elements,
// whether they belong to physical groups or not, set `Mesh.SaveAll=1;', or
// specify `-save_all' on the command line.) Physical groups are also identified
// by tags, i.e. strictly positive integers, that should be unique per dimension
// (0D, 1D, 2D or 3D). Physical groups can also be given names.
//
// Here we define a physical curve that groups the left, bottom and right curves
// in a single group (with prescribed tag 5); and a physical surface with name
// "My surface" (with an automatic tag) containing the geometrical surface 1:

// 在这个阶段，Gmsh 已经知道如何显示矩形表面 1 并对其进行网格划分。如果我们要将基本几何实体分组到更有意义的组中，
// 例如定义一些数学（“域”，“边界”）、功能（“左翼”，“机身”）或材料（“钢”，“碳”）属性，需要一个可选步骤。
//
// 这样的组在 Gmsh 中被称为“物理组”。默认情况下，如果定义了物理组，Gmsh 将在输出文件中只导出属于至少一个物理组的网格元素。
//（要强制 Gmsh 保存所有元素，无论它们是否属于物理组，可以设置 Mesh.SaveAll=1;，或在命令行中指定 -save_all。）物理组也
// 通过标签来识别，即严格正整数，这些标签在每个维度（0D、1D、2D 或 3D）中应该是唯一的。物理组也可以被赋予名称。
//
// 这里我们定义了一个物理曲线，它将左侧、底部和右侧曲线分组到一个组中（指定标签为 5）；
// 以及一个名为“My surface”的物理表面（自动分配标签）包含几何表面 1：

// 解释：
// 物理组的目的：物理组允许用户将基本几何实体（如点、曲线、表面）组合成更有意义的组，以便于管理和应用特定的属性或条件。
// 物理组的默认行为：如果定义了物理组，Gmsh 默认只会在输出文件中导出属于至少一个物理组的网格元素。这是一个有用的功能，因为它可以减少输出文件的大小，只包含用户感兴趣的部分。
// 强制保存所有元素：如果用户想要 Gmsh 保存所有网格元素，无论它们是否属于任何物理组，可以通过设置 Mesh.SaveAll=1; 或在命令行中使用 -save_all 选项来实现。
// 物理组的识别：物理组通过标签识别，这些标签是严格正整数，并且在每个维度（0D、1D、2D 或 3D）中必须是唯一的。这意味着在同一个维度内，不能有两个物理组有相同的标签。
// 物理组的命名：除了标签，物理组还可以被赋予名称，这使得在复杂的模型中更容易识别和引用特定的组。
// 定义物理组：示例中展示了如何定义一个物理曲线和一个物理表面。物理曲线将左侧、底部和右侧的曲线组合到一个标签为 5 的组中，而物理表面“My surface”包含几何表面 1，并且会自动分配一个标签。
// 通过使用物理组，用户可以在 Gmsh 中更有效地组织和管理复杂的几何模型，并为后续的网格划分和模拟设置提供便利。
// 将基本几何实体（如点、曲线、表面）组合成物理组
Physical Curve(5) = {1, 2, 4};
Physical Surface("My surface") = {1};

// Now that the geometry is complete, you can
// - either open this file with Gmsh and select `2D' in the `Mesh' module to
//   create a mesh; then select `Save' to save it to disk in the default format
//   (or use `File->Export' to export in other formats);
// - or run `gmsh t1.geo -2` to mesh in batch mode on the command line.
// 现在几何体已经完成，您可以
// - 要么用 Gmsh 打开这个文件，在 网格 模块中选择 2D 来创建网格；然后选择 保存 将其保存到磁盘上，默认格式（或者使用 文件->导出 导出到其他格式）；
// - 或者在命令行中运行 gmsh t1.geo -2 以批量模式进行网格划分。
// You could also uncomment the following lines in this script:
// 创建网格划分 & 导出
Mesh 2;
Save "t1.msh";
//
// which would lead Gmsh to mesh and save the mesh every time the file is
// parsed. (To simply parse the file from the command line, you can use `gmsh
// t1.geo -')
// 这将导致 Gmsh 在每次解析文件时都进行网格划分并保存网格。（要从命令行简单地解析文件，您可以使用 `gmsh t1.geo -'）

// By default, Gmsh saves meshes in the latest version of the Gmsh mesh file
// format (the `MSH' format). You can save meshes in other mesh formats by
// specifying a filename with a different extension in the GUI, on the command
// line or in scripts. For example
// 默认情况下，Gmsh 会以最新版本的 Gmsh 网格文件格式（MSH 格式）保存网格。您可以通过在 GUI、命令行或脚本中指定带有不同扩展名的文件名来保存其他网格格式的网格。例如：
//
//   Save "t1.unv";
//
// will save the mesh in the UNV format. You can also save the mesh in older
// versions of the MSH format:
//
// 将保存网格为 UNV 格式。您还可以保存网格为 MSH 格式的旧版本：
//
// - In the GUI: open `File->Export', enter your `filename.msh' and then pick
//   the version in the dropdown menu.
// - On the command line: use the `-format' option (e.g. `gmsh file.geo -format
//   msh2 -2').
// - In a `.geo' script: add `Mesh.MshFileVersion = x.y;' for any version
//   number `x.y'.
// - As an alternative method, you can also not specify the format explicitly,
//   and just choose a filename with the `.msh2' or `.msh4' extension.
//
// - 在 GUI 中：打开 文件->导出，输入您的 filename.msh 然后从下拉菜单中选择版本。
// - 在命令行中：使用 -format 选项（例如 gmsh file.geo -format msh2 -2）。
// - 在 .geo 脚本中：添加 Mesh.MshFileVersion = x.y; 来指定任何版本号 x.y。
// - 作为另一种方法，您也可以不明确指定格式，只需选择带有 .msh2 或 .msh4 扩展名的文件名。
//
// Note that starting with Gmsh 3.0, models can be built using other geometry
// kernels than the default built-in kernel. By specifying
//
// 注意，从 Gmsh 3.0 开始，可以使用除默认内置内核之外的其他几何内核来构建模型。通过指定
//
//   SetFactory("OpenCASCADE");
//
// any subsequent command in the `.geo' file would be handled by the OpenCASCADE
// geometry kernel instead of the built-in kernel. Different geometry kernels
// have different features. With OpenCASCADE, instead of defining the surface by
// successively defining 4 points, 4 curves and 1 curve loop, one can define the
// rectangular surface directly with
// .geo 文件中的任何后续命令将由 OpenCASCADE 几何内核处理，而不是内置内核。不同的几何内核有不同的特性。
// 使用 OpenCASCADE，不是通过连续定义 4 个点、4 条曲线和 1 个曲线环来定义表面，而是可以直接定义矩形表面为
//
//   Rectangle(2) = {.2, 0, 0, .1, .3};
//
// The underlying curves and points could be accessed with the `Boundary' or
// `CombinedBoundary' operators.
// 可以使用 Boundary 或 CombinedBoundary 操作符访问底层的曲线和点。
// 
// See e.g. `t16.geo', `t18.geo', `t19.geo' or `t20.geo' for complete examples
// based on OpenCASCADE, and `examples/boolean' for more.
// 参见例如 t16.geo、t18.geo、t19.geo 或 t20.geo 基于 OpenCASCADE 的完整示例，以及 examples/boolean 中的更多示例。



