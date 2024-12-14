// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 9
//
//  Plugins  插件
//
// -----------------------------------------------------------------------------
// 这段代码是 Gmsh 的 GEO 脚本的一部分，它展示了如何使用 Gmsh 的插件系统。Gmsh 允许用户通过插件来扩展其功能，比如后处理插件可以修改或创建视图。

// Include "view3.pos"; 这一行代码包含了一个名为 "view3.pos" 的文件，这个文件可能包含了一些视图设置。

// Plugin(Isosurface).Value = 0.67; 设置了 Isosurface 插件的等值面级别，这里的值是 0.67。

// Plugin(Isosurface).View = 0; 指定了 Isosurface 插件将作用于第一个视图（View[0]）。

// Plugin(Isosurface).Run; 运行 Isosurface 插件。

// Plugin(CutPlane) 系列的设置定义了一个切割平面，用于在3D视图中创建截面。

// Plugin(Annotate) 系列的设置用于在视图中添加标题和副标题。Text 设置了要显示的文本，X 和 Y 设置了文本的位置，Font 和 FontSize 设置了字体和字体大小，Align 设置了文本的对齐方式。

// View[0].Light = 1; 等设置调整了视图的显示属性，比如光照、等值面间隔类型、等值面数量和法线平滑。

// 总的来说，这段代码展示了如何在 Gmsh 中通过插件来处理和显示3D数据，包括提取等值面、创建截面和添加注释。


// Plugins can be added to Gmsh in order to extend its capabilities. For
// example, post-processing plugins can modify views, or create new views based
// on previously loaded views. Several default plugins are statically linked
// with Gmsh, e.g. Isosurface, CutPlane, CutSphere, Skin, Transform or Smooth.
//
// Plugins can be controlled in the same way as other options: either from the
// graphical interface (right click on the view button, then `Plugins'), or from
// the command file.

// Let us for example include a three-dimensional scalar view:
// 插件可以被添加到 Gmsh 中以扩展其功能。例如，后处理插件可以修改视图，或者基于之前加载的视图创建新视图。
// 几个默认插件与 Gmsh 静态链接，例如 Isosurface、CutPlane、CutSphere、Skin、Transform 或 Smooth。
//
// 插件可以像其他选项一样被控制：要么从图形界面（右键点击视图按钮，然后“插件”），要么从命令文件中。

// 例如，我们包含一个三维标量视图：

Include "view3.pos" ;

// We then set some options for the `Isosurface' plugin (which extracts an
// isosurface from a 3D scalar view), and run it:

Plugin(Isosurface).Value = 0.67 ; // Iso-value level
Plugin(Isosurface).View = 0 ; // Source view is View[0]
Plugin(Isosurface).Run ; // Run the plugin!

// We also set some options for the `CutPlane' plugin (which computes a section
// of a 3D view using the plane A*x+B*y+C*z+D=0), and then run it:

Plugin(CutPlane).A = 0 ;
Plugin(CutPlane).B = 0.2 ;
Plugin(CutPlane).C = 1 ;
Plugin(CutPlane).D = 0 ;
Plugin(CutPlane).View = 0 ;
Plugin(CutPlane).Run ;

// Add a title (By convention, for window coordinates a value greater than 99999
// represents the center. We could also use `General.GraphicsWidth / 2', but
// that would only center the string for the current window size.):

Plugin(Annotate).Text = "A nice title" ;
Plugin(Annotate).X = 1.e5;
Plugin(Annotate).Y = 50 ;
Plugin(Annotate).Font = "Times-BoldItalic" ;
Plugin(Annotate).FontSize = 28 ;
Plugin(Annotate).Align = "Center" ;
Plugin(Annotate).View = 0 ;
Plugin(Annotate).Run ;

Plugin(Annotate).Text = "(and a small subtitle)" ;
Plugin(Annotate).Y = 70 ;
Plugin(Annotate).Font = "Times-Roman" ;
Plugin(Annotate).FontSize = 12 ;
Plugin(Annotate).Run ;

// We finish by setting some options:

View[0].Light = 1;
View[0].IntervalsType = 1;
View[0].NbIso = 6;
View[0].SmoothNormals = 1;
View[1].IntervalsType = 2;
View[2].IntervalsType = 2;
