// -----------------------------------------------------------------------------
//
//  Gmsh GEO tutorial 8
//
//  Post-processing, image export and animations
//  后处理，图像导出和动画
// -----------------------------------------------------------------------------
// 这段文本是 Gmsh GEO 教程的第八部分，介绍了如何进行后处理、图像导出和创建动画。

// 后处理数据集：GEO 脚本可以用来操作后处理数据集，这些数据集在 Gmsh 中被称为“视图”。

// 包含文件：教程中包含了几何定义文件和后处理视图文件。

// 设置通用选项：设置了一些影响整个 Gmsh 会话的通用选项，如背景颜色、前景颜色、文本颜色等。

// 设置后处理视图选项：为每个后处理视图设置了特定的选项，如时间步、颜色表、ISO线数量等。

// 保存 MPEG 电影：在 Gmsh 的 GUI 中，可以直接导出 MPEG 格式的电影。

// 创建复杂动画：使用脚本在运行时更改选项并重新渲染图形，以创建更复杂的动画。每个帧可以保存为图像文件，然后编码成电影。

// 自定义动画示例：提供了一个自定义动画的示例，其中在循环中更改视图的时间步、提升视图、旋转场景，并在特定条件下保存帧为图像文件。

// 生成电影：在循环结束后，可以使用系统命令（如 ffmpeg）来生成电影。
// In addition to creating geometries and meshes, GEO scripts can also be used
// to manipulate post-processing datasets (called "views" in Gmsh).

// We first include `t1.geo' as well as some post-processing views:

Include "t1.geo";
Include "view1.pos";
Include "view1.pos";
Include "view4.pos";

// Gmsh can read post-processing views in various formats. Here the `view1.pos'
// and `view4.pos' files are in the Gmsh "parsed" format, which is interpreted
// directly by the GEO script parser. The parsed format should only be used for
// relatively small datasets of course: for larger datasets using e.g. MSH files
// is much more efficient.

// We then set some general options:

General.Trackball = 0;
General.RotationX = 0; General.RotationY = 0; General.RotationZ = 0;
General.Color.Background = White; General.Color.Foreground = Black;
General.Color.Text = Black;
General.Orthographic = 0;
General.Axes = 0; General.SmallAxes = 0;

// We also set some options for each post-processing view:

v0 = PostProcessing.NbViews-4;
v1 = v0+1; v2 = v0+2; v3 = v0+3;

View[v0].IntervalsType = 2;
View[v0].OffsetZ = 0.05;
View[v0].RaiseZ = 0;
View[v0].Light = 1;
View[v0].ShowScale = 0;
View[v0].SmoothNormals = 1;

View[v1].IntervalsType = 1;
View[v1].ColorTable = { Green, Blue };
View[v1].NbIso = 10;
View[v1].ShowScale = 0;

View[v2].Name = "Test...";
View[v2].Axes = 1;
View[v2].Color.Axes = Black;
View[v2].IntervalsType = 2;
View[v2].Type = 2;
View[v2].AutoPosition = 0;
View[v2].PositionX = 85;
View[v2].PositionY = 50;
View[v2].Width = 200;
View[v2].Height = 130;

View[v3].Visible = 0;

// You can save an MPEG movie directly by selecting `File->Export' in the
// GUI. Several predefined animations are setup, for looping on all the time
// steps in views, or for looping between views.

// But a script can be used to build much more complex animations, by changing
// options at run-time and re-rendering the graphics. Each frame can then be
// saved to disk as an image, and multiple frames can be encoded to form a
// movie. Below is an example of such a custom animation.

t = 0; // Initial step

// Loop on num from 1 to 3
For num In {1:3}

  View[v0].TimeStep = t; // Set time step
  View[v1].TimeStep = t;
  View[v2].TimeStep = t;
  View[v3].TimeStep = t;

  t = (View[v0].TimeStep < View[v0].NbTimeStep-1) ? t+1 : 0; // Increment

  View[v0].RaiseZ += 0.01/View[v0].Max * t; // Raise view v0

  If (num == 3)
    // Resize the graphics when num == 3, to create 640x480 frames
    General.GraphicsWidth = General.MenuWidth + 640;
    General.GraphicsHeight = 480;
  EndIf

  frames = 50;

  // Loop on num2 from 1 to frames
  For num2 In {1:frames}

    // Incrementally rotate the scene
    General.RotationX += 10;
    General.RotationY = General.RotationX / 3;
    General.RotationZ += 0.1;

    // Sleep for 0.01 second
    Sleep 0.01;

    // Draw the scene (one could use `DrawForceChanged' instead to force the
    // reconstruction of the vertex arrays, e.g. if changing element clipping)
    Draw;

    If (num == 3)
      // Uncomment the following lines to save each frame to an image file (the
      // `Print' command saves the graphical window; the `Sprintf' function
      // permits to create the file names on the fly):

      // Print Sprintf("t8-%g.gif", num2);
      // Print Sprintf("t8-%g.ppm", num2);
      // Print Sprintf("t8-%g.jpg", num2);
    EndIf

  EndFor

  If(num == 3)
    // Here we could make a system call to generate a movie. For example, with
    // ffmpeg:

    // System "ffmpeg -i t8-%d.jpg t8.mpg"
  EndIf

EndFor
