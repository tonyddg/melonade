#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "相机成像原理")

#import "/utility/widget.typ": *
#import "@preview/cetz:0.4.1"

#let fig1() = cetz.canvas({
  import cetz.draw: *
  let u(x) = x * 1.5cm

  // 相机坐标系
  let al = 1.2

  line((0, 0, 0), (u(al), 0, 0), mark: (end: ">"))
  anchor("Z_c", (u(al), 0, 0))
  content("Z_c", [$Z_c$], anchor: "north-west", padding: .1)

  line((0, 0, 0), (0, u(al), 0), mark: (end: ">"))
  anchor("X_c", (0, u(al), 0))
  content("X_c", [$X_c$], anchor: "south-east", padding: .1)

  line((0, 0, 0), (0, 0, u(al)), mark: (end: ">"))
  anchor("Y_c", (0, 0, u(al)))
  content("Y_c", [$Y_c$], anchor: "north", padding: .1)

  anchor("O_c", (0, 0, u(0)))
  content("O_c", [$O_c$], anchor: "south-east", padding: .1)

  // 像平面
  let f = 3
  let w = 4
  let h = 2.5

  line((u(f), u(-h/2), u(w/2)), (u(f), u(h/2), u(w/2)))
  line((u(f), u(h/2), u(-w/2)), (u(f), u(h/2), u(w/2)))
  line((u(f), u(-h/2), u(-w/2)), (u(f), u(h/2), u(-w/2)))
  line((u(f), u(-h/2), u(-w/2)), (u(f), u(-h/2), u(w/2)))

  line((u(f), 0, 0), (u(f), u(h/2), 0), mark: (end: ">"))
  anchor("X_p", (u(f), u(h/2), 0))
  content("X_p", [$X_p$], anchor: "south-east", padding: .1)

  line((u(f), 0, 0), (u(f), 0, u(w/2)), mark: (end: ">"))
  anchor("Y_p", (u(f), 0, u(w/2)))
  content("Y_p", [$Y_p$], anchor: "north-east", padding: .1)

  anchor("O_p", (u(f), 0, 0))
  content("O_p", [$O_p$], anchor: "north-west", padding: .1)

  // 空间点
  let x = 2
  let z = 10

  circle((u(z), u(x)), radius: 2pt, fill: gray)

  anchor("P_c", (u(z), u(x)))
  content("P_c", [$attach(bold(p), tl: c)$], anchor: "north-west", padding: .1)

  circle((u(f), u(x / z * f)), radius: 2pt, fill: gray)
  anchor("P_p", (u(f), u(x / z * f)))
  content("P_p", [$attach(bold(p), tl: p)$], anchor: "north-west", padding: .1)

  circle((u(z), 0), radius: 2pt, fill: gray)
  anchor("O'", (u(z), 0))
  content("O'", [$O'$], anchor: "north-west", padding: .1)

  line((0, 0, 0), (u(z), u(x)), stroke: (dash: "dashed"))
  line((0, 0, 0), (u(z), 0), stroke: (dash: "dashed"))
  line((u(z), 0), (u(z), u(x)), stroke: (dash: "dashed"))

  // 标尺
  let offset = 2.5
  let gap = 0.5
  let inc = 0.2

  line((0, u(offset)), (u(f), u(offset)), mark: (end: ">", start: ">"))
  line((0, u(offset + gap)), (u(z), u(offset + gap)), mark: (end: ">", start: ">"))

  line((0, u(al)), (0, u(offset + gap + inc)))
  line((u(f), u(h/2)), (u(f), u(offset + inc)))
  line((u(z), u(x)), (u(z), u(offset + gap + inc)))

  anchor("f", (u(f / 2), u(offset)))
  content("f", [$f$], anchor: "north", padding: .1)
  anchor("p_z", (u(z / 2), u(offset + gap)))
  content("p_z", [$p_z$], anchor: "north", padding: .1)

  // 像素坐标系

  let ul = 0.8
  line((u(f), u(-h/2), u(-w/2)), (u(f), u(ul - h/2), u(-w/2)), mark: (end: ">"))
  line((u(f), u(-h/2), u(-w/2)), (u(f), u(-h/2), u(ul - w/2)), mark: (end: ">"))

  anchor("u", (u(f), u(ul - h/2), u(-w/2)))
  content("u", [$u$], anchor: "south-west", padding: .1)
  anchor("v", (u(f), u(-h/2), u(ul - w/2)))
  content("v", [$v$], anchor: "north-west", padding: .1)
  anchor("o", (u(f), u(-h/2), u(-w/2)))
  content("o", [$o$], anchor: "mid-west", padding: .1)

  // 世界坐标系
  let wl = 1.2
  let wx = -1.6
  let wz = 8

  line((u(wz), u(wx), 0), (u(al) + u(wz), u(wx), 0), mark: (end: ">"))
  anchor("Z_w", (u(al) + u(wz), u(wx), 0))
  content("Z_w", [$Z_w$], anchor: "north-west", padding: .1)

  line((u(wz), u(wx), 0), (u(wz), u(al) + u(wx), 0), mark: (end: ">"))
  anchor("X_w", (u(wz), u(al) + u(wx), 0))
  content("X_w", [$X_w$], anchor: "south-east", padding: .1)

  line((u(wz), u(wx), 0), (u(wz), u(wx), u(al)), mark: (end: ">"))
  anchor("Y_w", (u(wz), u(wx), u(al)))
  content("Y_w", [$Y_w$], anchor: "north", padding: .1)

  anchor("O_w", (u(wz), u(wx), u(0)))
  content("O_w", [$O_w$], anchor: "south-east", padding: .1)

})

= 相机成像原理

== 单目相机

参考
- #link("https://zhaoxuhui.top/blog/2018/04/17/CameraCalibration.html")
- #link("https://zhuanlan.zhihu.com/p/335644665")

一般的单目相机成像即将空间点经过透镜投影到成像平面上，在这个过程中将涉及如#ref(<fig:projection>) 四个坐标：
- 世界坐标系 ${W}$：描述空间物体的参考坐标系
- 相机坐标系 ${C}$：以相机的光心为原点的坐标系，其中 $Z_c$ 轴指向相机拍摄方向，$X_c,Y_c$ 轴平行于成像平面，从光心往成像平面看 $X_c$ 轴垂直与图像的宽且方向朝上
- 像平面坐标系 ${P}$：建立在成像平面上的二维坐标系，成像平面以相机坐标系的 $Z_c$ 轴为法向量，向前偏移焦距 $f$ 确定
- 像素坐标系 ${I}$：相机拍摄图片中，每个像素点所在的坐标系，与上述坐标系不同，该坐标系的单位为像素而不是米，且习惯使用 $u,v$ 表示 $X,Y$ 轴

相机成像的过程即，对于给定世界坐标系下空间点 $attach(bold(p), tl: w)$，确定其在像素坐标系下的坐标 $attach(bold(p), tl: i)$

以下成像过程将使用齐次坐标系，注意齐次坐标中以下坐标表示同一点：

$
vec(x,y,z,w)=vec(x\/w,y\/w,z\/w,1), vec(x,y,w)=vec(x\/w,y\/w,1)
$

=== 单目相机成像

首先要将世界坐标系下描述的点转移到相机坐标系下描述才能进行后续的投影

$
  attach(bold(p), tl: c) = attach(bm(T), tl: c, bl: w)attach(bold(p), tl: w)
$

矩阵 $attach(bm(T), tl: c, bl: w)$ 描述了相机与世界坐标系的关系（相机坐标系描述下的世界坐标系），称为外参矩阵或 Extrinsic Matrix

#figure(
  fig1(), caption: [空间点到成像平面的投影]
) <fig:projection>

仅考虑 $X_c O_c Z_c$ 平面，相机光心与空间构成的三角形 $Delta O_c attach(P, tl: c) O'$ 和相机光心与投影点构成的三角形 $Delta O_c attach(P, tl: p) O'$ 相似，因此可以确定投影点的 x 坐标满足：

$
  attach(p, tl: p, br: x) = attach(p, tl: c, br: x) dot f / attach(p, tl: c, br: z)
$

对于 y 坐标有同样的相似三角形关系，利用齐次坐标的特性可将上述运算表示为

$
  attach(bold(p), tl: p) = vec(attach(p, tl: p, br: x), attach(p, tl: p, br: y), 1) = mat(
    f, 0, 0, 0; 0, f, 0, 0; 0, 0, 1, 0
  ) vec(attach(p, tl: c, br: x), attach(p, tl: c, br: y), attach(p, tl: c, br: z), 1)
$

从成像平面到图像像素则还需要经过（不考虑切向畸变）
- 尺寸缩放，将长度单位由米转为像素，其中 $d_x,d_y$ 米分别对应 XY 方向的一像素
- 平移变换，将圆心从平面中心平移到图像角点，其中成像平面中心对应的像素坐标为 $u_0,v_0$

两个变换对应如下的变换矩阵

$
  attach(bold(p), tl: i) = mat(1/d_x, 0, u_0; 0, 1/d_y, v_0; 0, 0, 1)vec(attach(p, tl: p, br: x), attach(p, tl: p, br: y), 1)
$

将平面投影与到图像像素的变化结合得到的矩阵称为内参矩阵 Intrinsic Matrix

$
  bm(K)=attach(bm(M), tl: i, bl: c)=mat(
    f/d_x, 0, u_0, 0; 0, f/d_y, v_0, 0; 0, 0, 1, 0
  )
$

=== 单目相机畸变
