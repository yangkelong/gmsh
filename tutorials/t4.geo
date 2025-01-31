// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 4
//
//  Built-in functions, holes in surfaces, annotations, entity colors
//  内置函数，表面上的孔洞，注释，实体颜色
//
// -----------------------------------------------------------------------------

// As usual, we start by defining some variables:
// 定义一些变量：

cm = 1e-02;
e1 = 4.5 * cm; e2 = 6 * cm / 2; e3 =  5 * cm / 2;
h1 = 5 * cm; h2 = 10 * cm; h3 = 5 * cm; h4 = 2 * cm; h5 = 4.5 * cm;
R1 = 1 * cm; R2 = 1.5 * cm; r = 1 * cm;
Lc1 = 0.01;
Lc2 = 0.003;

// We can use all the usual mathematical functions (note the capitalized first
// letters), plus some useful functions like Hypot(a, b) := Sqrt(a^2 + b^2):
// 可以使用所有常用的数学函数（注意首字母大写），加上一些有用的函数，如 Hypot(a, b) := Sqrt(a^2 + b^2)：
ccos = (-h5*R1 + e2 * Hypot(h5, Hypot(e2, R1))) / (h5^2 + e2^2);
ssin = Sqrt(1 - ccos^2);

// Then we define some points and some lines using these variables:

Point(1) = {-e1-e2, 0    , 0, Lc1}; Point(2) = {-e1-e2, h1   , 0, Lc1};
Point(3) = {-e3-r , h1   , 0, Lc2}; Point(4) = {-e3-r , h1+r , 0, Lc2};
Point(5) = {-e3   , h1+r , 0, Lc2}; Point(6) = {-e3   , h1+h2, 0, Lc1};
Point(7) = { e3   , h1+h2, 0, Lc1}; Point(8) = { e3   , h1+r , 0, Lc2};
Point(9) = { e3+r , h1+r , 0, Lc2}; Point(10)= { e3+r , h1   , 0, Lc2};
Point(11)= { e1+e2, h1   , 0, Lc1}; Point(12)= { e1+e2, 0    , 0, Lc1};
Point(13)= { e2   , 0    , 0, Lc1};

Point(14)= { R1 / ssin, h5+R1*ccos, 0, Lc2};
Point(15)= { 0        , h5        , 0, Lc2};
Point(16)= {-R1 / ssin, h5+R1*ccos, 0, Lc2};
Point(17)= {-e2       , 0.0       , 0, Lc1};

Point(18)= {-R2 , h1+h3   , 0, Lc2}; Point(19)= {-R2 , h1+h3+h4, 0, Lc2};
Point(20)= { 0  , h1+h3+h4, 0, Lc2}; Point(21)= { R2 , h1+h3+h4, 0, Lc2};
Point(22)= { R2 , h1+h3   , 0, Lc2}; Point(23)= { 0  , h1+h3   , 0, Lc2};

Point(24)= { 0, h1+h3+h4+R2, 0, Lc2}; Point(25)= { 0, h1+h3-R2,    0, Lc2};

Line(1)  = {1 , 17};
Line(2)  = {17, 16};

// Gmsh provides other curve primitives than straight lines: splines, B-splines,
// circle arcs, ellipse arcs, etc. Here we define a new circle arc, starting at
// point 14 and ending at point 16, with the circle's center being the point 15:
// Gmsh 提供了除直线以外的其他曲线原语：样条线、B样条线、圆弧、椭圆弧等。这里我们定义一个新的圆弧，从点 14 开始，到点 16 结束，圆心是点 15：
// 圆弧，从点 14 开始，到点 16 结束，圆心是点 15：
Circle(3) = {14,15,16};

// Note that, in Gmsh, circle arcs should always be smaller than Pi. The
// OpenCASCADE geometry kernel does not have this limitation.
// 注意，在 Gmsh 中，圆弧的半径总是小于 Pi。OpenCASCADE 几何内核没有这个限制。

// We can then define additional lines and circles, as well as a new surface:

Line(4)  = {14, 13}; Line(5)   = {13, 12};   Line(6)    = {12, 11};
Line(7)  = {11, 10}; Circle(8) = {8, 9, 10}; Line(9)    = {8, 7};
Line(10) = {7, 6};   Line(11)  = {6, 5};     Circle(12) = {3, 4, 5};
Line(13) = {3, 2};   Line(14)  = {2, 1};     Line(15)   = {18, 19};
Circle(16) = {21, 20, 24}; Circle(17) = {24, 20, 19};
Circle(18) = {18, 23, 25}; Circle(19) = {25, 23, 22};
Line(20) = {21,22};

Curve Loop(21) = {17, -15, 18, 19, -20, 16};
Plane Surface(22) = {21};

// But we still need to define the exterior surface. Since this surface has a
// hole, its definition now requires two curves loops:
// 但我们仍然需要定义外表面。由于这个表面有一个孔洞，其定义现在需要两个曲线环：21 23

Curve Loop(23) = {11, -12, 13, 14, 1, 2, -3, 4, 5, 6, 7, -8, 9, 10};
Plane Surface(24) = {23, 21};

// As a general rule, if a surface has N holes, it is defined by N+1 curve loops:
// the first loop defines the exterior boundary; the other loops define the
// boundaries of the holes.
// 通常，如果一个表面有 N 个孔洞，它由 N+1 个曲线环定义：第一个环定义外部边界；其他环定义孔洞的边界。
// Finally, we can add some comments by embedding a post-processing view
// containing some strings:
// 最后，我们可以添加一些注释，通过嵌入一个包含一些字符串的后处理视图：

View "comments" {
  // Add a text string in window coordinates, 10 pixels from the left and 10
  // pixels from the bottom, using the `StrCat' function to concatenate strings:
  // 在窗口坐标中添加一个文本字符串，距离左侧和底部各 10 像素，使用 StrCat 函数连接字符串：
  T2(10, -10, 0){ StrCat("Created on ", Today, " with Gmsh") };

  // Add a text string in model coordinates centered at (X,Y,Z) = (0, 0.11, 0):
  // 在模型坐标中添加一个文本字符串，以 (X,Y,Z) = (0, 0.11, 0) 为中心：
  T3(0, 0.11, 0, TextAttributes("Align", "Center", "Font", "Helvetica")){
    "Hole"
  };

  // If a string starts with `file://', the rest is interpreted as an image
  // file. For 3D annotations, the size in model coordinates can be specified
  // after a `@' symbol in the form `widthxheight' (if one of `width' or
  // `height' is zero, natural scaling is used; if both are zero, original image
  // dimensions in pixels are used):
  // 如果一个字符串以 file:// 开头，其余部分被解释为图像文件。对于 3D 注释，模型坐标中的
  // 大小可以在 @ 符号后以 widthxheight 的形式指定（如果 width 或 height 中的一个为零，
  // 则使用自然缩放；如果两者都为零，则使用原始图像尺寸，以像素为单位）：
  T3(0, 0.09, 0, TextAttributes("Align", "Center")){
    "file://t4_image.png@0.01x0"
  };

  // The 3D orientation of the image can be specified by proving the direction
  // of the bottom and left edge of the image in model space:
  T3(-0.01, 0.09, 0, 0){ "file://t4_image.png@0.01x0,0,0,1,0,1,0" };

  // The image can also be drawn in "billboard" mode, i.e. always parallel to
  // the camera, by using the `#' symbol:
  T3(0, 0.12, 0, TextAttributes("Align", "Center")){
    "file://t4_image.png@0.01x0#"
  };

  // The size of 2D annotations is given directly in pixels:
  T2(350, -7, 0){ "file://t4_image.png@20x0" };
};

// This post-processing view is in the "parsed" format, i.e. it is interpreted
// using the same parser as the `.geo' file. For large post-processing datasets,
// that contain actual field values defined on a mesh, you should use the MSH
// file format instead, which allows to efficiently store continuous or
// discontinuous scalar, vector and tensor fields, or arbitrary polynomial
// order.

// Views and geometrical entities can be made to respond to double-click events,
// here to print some messages to the console:

View[0].DoubleClickedCommand = "Printf('View[0] has been double-clicked!');";
Geometry.DoubleClickedCurveCommand = "Printf('Curve %g has been double-clicked!',
  Geometry.DoubleClickedEntityTag);";

// We can also change the color of some entities:
// 改变一些实体的颜色：
Color Grey50{ Surface{ 22 }; }
Color Purple{ Surface{ 24 }; }
Color Red{ Curve{ 1:14 }; }
Color Yellow{ Curve{ 15:20 }; }
