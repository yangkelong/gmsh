// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 3
//
//  Extruded meshes, ONELAB parameters, options
//  
// -----------------------------------------------------------------------------

// Again, we start by including the first tutorial:

Include "t1.geo";

// As in `t2.geo', we plan to perform an extrusion along the z axis.  But here,
// instead of only extruding the geometry, we also want to extrude the 2D
// mesh. This is done with the same `Extrude' command, but by specifying element
// 'Layers' (2 layers in this case, the first one with 8 subdivisions and the
// second one with 2 subdivisions, both with a height of h/2):
// 像在 t2.geo 中一样，我们计划沿 z 轴进行拉伸。但在这里，
// 我们不仅想要拉伸几何体，还想要拉伸 2D 网格。这可以通过相同的 Extrude 命令完成，
// 但通过指定元素 'Layers'（在本例中为 2 层，第一层有 8 个子网格，第二层有 2 个子网格，两者的高度都是 h/2）：
h = 0.1;
// 拉伸矢量: {0,0,h}   拉伸几何表面实体: Surface{1};   
// 网格拉伸控制参数: Layers{ {8,2}, {0.5,1} };  每层的子网格维度 , 每层的拉伸矢量 {0,0,h}*0.5  {0,0,h}*(1-0.5)
Extrude {0,0,h} {Surface{1}; Layers{ {8,2}, {0.5,1} };}

// The extrusion can also be performed with a rotation instead of a translation,
// and the resulting mesh can be recombined into prisms (we use only one layer
// here, with 7 subdivisions). All rotations are specified by an axis direction
// ({0,1,0}), an axis point ({-0.1,0,0.1}) and a rotation angle (-Pi/2):
// 拉伸也可以通过旋转而不是平移来执行，
// 并且得到的网格可以重新组合成棱柱（我们这里只使用一层，有 7 个子网格）。所有旋转都通过
// 轴方向({0,1,0})，轴点 ({-0.1,0,0.1}) 和旋转角度 (-Pi/2) 来指定：
Extrude { {0,1,0} , {-0.1,0,0.1} , -Pi/2 } {
  Surface{28}; Layers{7}; Recombine;
}

// Using the built-in geometry kernel, only rotations with angles < Pi are
// supported. To do a full turn, you will thus need to apply at least 3
// rotations. The OpenCASCADE geometry kernel does not have this limitation.

// Note that a translation ({-2*h,0,0}) and a rotation ({1,0,0}, {0,0.15,0.25},
// Pi/2) can also be combined to form a "twist". Here the angle is specified as
// a ONELAB parameter, using the `DefineConstant' syntax. ONELAB parameters can
// be modified interactively in the GUI, and can be exchanged with other codes
// connected to the same ONELAB database:
// 使用内置几何内核时，只支持角度 < Pi 的旋转。要做完整的旋转，你需要至少应用 3 次旋转。
// OpenCASCADE 几何内核没有这个限制。

// 注意，平移 ({-2*h,0,0}) 和旋转 ({1,0,0}, {0,0.15,0.25}, Pi/2) 也可以组合成一个“扭曲”。
// 这里的角度被指定为 ONELAB 参数，使用 DefineConstant 语法。
// ONELAB 参数可以在 GUI 中交互式修改，并且可以与连接到同一 ONELAB 数据库的其他代码交换
DefineConstant[ angle = {90, Min 0, Max 120, Step 1,
                         Name "Parameters/Twisting angle"} ];

// In more details, `DefineConstant' allows you to assign the value of the
// ONELAB parameter "Parameters/Twisting angle" to the variable `angle'. If the
// ONELAB parameter does not exist in the database, `DefineConstant' will create
// it and assign the default value `90'. Moreover, if the variable `angle' was
// defined before the call to `DefineConstant', the `DefineConstant' call would
// simply be skipped. This allows to build generic parametric models, whose
// parameters can be frozen from the outside - the parameters ceasing to be
// "parameters".
//
// An interesting use of this feature is in conjunction with the `-setnumber
// name value' command line switch, which defines a variable `name' with value
// `value'. Calling `gmsh t3.geo -setnumber angle 30' would define `angle'
// before the `DefineConstant', making `t3.geo' non-parametric
// ("Parameters/Twisting angle" will not be created in the ONELAB database and
// will not be available for modification in the graphical user interface).
// 更详细地说，DefineConstant 允许你将 ONELAB 参数 "Parameters/Twisting angle" 的值赋给变量 angle。
// 如果数据库中不存在 ONELAB 参数，则 DefineConstant 将创建它并分配默认值 90。
// 此外，如果变量 angle 在调用 DefineConstant 之前已经定义，DefineConstant 调用将被简单地跳过。
// 这允许构建通用的参数化模型，其参数可以从外部冻结 - 参数不再是“参数”。

// 这个特性与 -setnumber name value 命令行开关结合使用时很有趣，
// 它定义了一个变量 name 并赋值 value。调用 gmsh t3.geo -setnumber angle 30 会在 DefineConstant 之前定义 angle，
// 使得 t3.geo 非参数化（"Parameters/Twisting angle" 不会在 ONELAB 数据库中创建，也不会在图形用户界面中提供修改）。
out[] = Extrude { {-2*h,0,0}, {1,0,0} , {0,0.15,0.25} , angle * Pi / 180 } {
  Surface{50}; Layers{10}; Recombine;
};

// In this last extrusion command we retrieved the volume number
// programmatically by using the return value (a list) of the `Extrude'
// command. This list contains the "top" of the extruded surface (in `out[0]'),
// the newly created volume (in `out[1]') and the tags of the lateral surfaces
// (in `out[2]', `out[3]', ...).

// We can then define a new physical volume (with tag 101) to group all the
// elementary volumes:
// 在这个最后的拉伸命令中，我们通过使用 Extrude 命令的返回值（一个列表）来程序性地检索体积编号。
// 这个列表包含了拉伸表面的“顶部”（在 out[0] 中），新创建的体积（在 out[1] 中）和侧面的标签
// （在 out[2], out[3], ... 中）。

// 然后我们可以定义一个新的物理体积（标签为 101）来组合所有的基本体积：
Physical Volume(101) = {1, 2, out[1]};

// Let us now change some options... Since all interactive options are
// accessible in Gmsh's scripting language, we can for example make point tags
// visible or redefine some colors directly in the input file:
// 现在让我们改变一些选项... 由于所有交互式选项都可以在 Gmsh 的脚本语言中访问，
// 例如，我们可以在输入文件中直接使点标签可见或重新定义一些颜色：
Geometry.PointNumbers = 1;  // 点标签可见性
Geometry.CurveNumbers = 1;
Geometry.SurfaceNumbers = 1;
Geometry.VolumeNumbers = 1;
Geometry.Color.Points = Orange;  // 几何实体 Point 颜色
General.Color.Text = White;  //
Mesh.Color.Points = {255, 0, 0};  // 网格 Node 颜色

// Note that all colors can be defined literally or numerically, i.e.
// `Mesh.Color.Points = Red' is equivalent to `Mesh.Color.Points = {255,0,0}';
// and also note that, as with user-defined variables, the options can be used
// either as right or left hand sides, so that the following command will set
// the surface color to the same color as the points:
// 注意，所有颜色可以文字或数字定义，即 Mesh.Color.Points = Red' 等同于 Mesh.Color.Points = {255,0,0}'；
// 还请注意，与用户定义的变量一样，选项可以用作右侧或左侧的值，
// 因此以下命令将设置表面颜色与点相同的颜色：
Geometry.Color.Surfaces = Geometry.Color.Points;

// You can use the `Help->Current Options and Workspace' menu to see the current
// values of all options. To save all the options in a file, use
// `File->Export->Gmsh Options'. To associate the current options with the
// current file use `File->Save Model Options'. To save the current options for
// all future Gmsh sessions use `File->Save Options As Default'.
// 您可以使用 帮助->当前选项和工作空间' 菜单查看所有选项的当前值。 // 要将所有选项保存到文件中，使用 文件->导出->Gmsh 选项'。
// 要将当前选项与当前文件关联，请使用 文件->保存模型选项'。 // 要将当前选项保存为所有未来 Gmsh 会话的默认值，请使用 文件->保存选项为默认值'。