// 机器人运动学笔记 · Shiroa / Typst
// 仅对实际被引用的标题设置 sec 标签；页内 #link，跨页 #cross-link。
// 插图源文件未随 ch1.md 提供，相关 #image 语句保留在注释中。
#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "坐标系、位姿与运动的描述")
#import "/utility/include.typ": *
#set math.mat(delim: "[")
#set math.vec(delim: "[")

= 坐标系、位姿与运动的描述

刚体的位置 \(Position) 与姿态 \(Orientation) 统称为位姿（Pose）

== 坐标系变换

=== 坐标系描述及其符号 <sec:坐标系描述及其符号>
==== 坐标系描述
一个坐标系 ${ bold(B) }$ 主要包含以下要素

- $x , y , z$ 三个坐标轴
  - 要求三个坐标轴相互正交且满足右手定则
  - 虽然称为轴, 但实际上仅表示方向而不是实际存在的点
- 坐标原点 $B_o$

因此只要确定了以上这四个要素, 即可唯一确定一个坐标系 \
注意, 如果要描述坐标系, 则至少要有两个坐标系, 除了被描述的坐标系 ${ bold(B) }$, 还应有另一坐标系 ${ bold(A) }$ 作为参考 \
因此, 所有坐标系的描述都是相对而言的

关于具体描述, 详见#link(<sec:描述坐标系的一般方法>)[描述坐标系的一般方法]

==== 名词解释
- #strong[观察坐标系] - 即该对象的坐标都是基于这一坐标系确定的, 通过参考坐标轴与其坐标值可唯一表示出该对象

==== 符号约定
- 对于特定参考系, 始终以符号 ${ bold(A) }$ 表示, 即一个包裹在 ${ }$ 内的粗体字母, 其中的字母即坐标系的代号
- 默认情况下, 总是以单个大写加粗字母 $bold(A)$ 表示矩阵, 以单个小写加粗字母 $bold(q)$ 表示矢量
- 使用 $c_alpha$ 简略表示 $cos alpha$, 同理使用 $s_alpha$ 简略表示 $sin alpha$
- 使用矩阵符号 $bold(R)$ 相对的小写字母 $r$ 以及双数字下标 $i j$ 组成的符号 $r_(i j)$ 表示矩阵第 $i$ 行 $j$ 列的元素 \(从 $1$ 开始索引)

==== 矢量的符号 <sec:矢量的符号>
规定以下矢量的符号

- 符号 $""^A bold(p)_N$ 表示一个矢量
  - $bold(p)$ 表明该矢量表示的是一个实际的点, 可用作#strong[位置矢量], 其坐标随参考系变换而改变；在标准齐次坐标中点的最后一个分量为 $w == 1$
  - $A$ 表示该矢量的坐标值是通过坐标系 ${ bold(A) }$ 描述的
  - $N$ 表示该矢量表示的点为 $N$, 特别地
    - 表示点的实质即表示线段 $O N$ 在坐标轴的投影 \($O$ 为坐标轴原点)
    - 使用两个字母时, 则强调为两点构成的线段
    - 为空时表示坐标系下的任意点
  - 该矢量可以是 \(笛卡尔坐标系) $3$ 或 \(齐次坐标系) $4$ 元素的列矢量
- 符号 $""^A bold(x)_B$ 表示一个矢量
  - $bold(x)$ 表明该矢量来自某一坐标系的 $x$ 轴, 类似的还有 $bold(y) , bold(z)$ \
    且该矢量表示的是一个不受约束的方向 \(#hl(2)[要求该向量的长度为 $1$]), 不受平移影响，但在更换参考坐标系时仍需随坐标轴旋转；其齐次坐标满足 $w == 0$, 也称为#strong[自由矢量]
  - $A$ 表示该矢量的坐标值是通过坐标系 ${ bold(A) }$ 描述的, $B$ 表示该矢量是坐标系 ${ bold(B) }$ 的一个坐标轴
  - 该矢量可以是 \(笛卡尔坐标系) $3$ 或 \(齐次坐标系) $4$ 元素的列矢量

==== 矩阵的符号 <sec:矩阵的符号>
规定以下矩阵的符号

- 符号 $""_B^A bold(R)$ 通常表示一个 $3 times 3$ 的矩阵, 其中
  - $bold(R)$ 表示该矩阵仅包含了坐标系的三个坐标轴方向矢量, 而不包含原点位置信息, 一般使用笛卡尔坐标系 \
    即有 $""_B^A bold(R) == mat(delim: "[", zws^A bold(x)_B, ""^A bold(y)_B, ""^A bold(z)_B)$ \
    因此该矩阵可描述刚体的姿态, 也称为#strong[姿态矩阵] \
  - $A$ 表示该矩阵的坐标值是通过坐标系 ${ bold(A) }$ 描述的, $B$ 表示该矩阵所描述的基底来自坐标系 ${ bold(B) }$
  - 关于该矩阵的性质见#link(<sec:姿态矩阵>)[姿态矩阵]
  - #hl(2)[组合 $mat(delim: "[", ""_B^A bold(R), ""^A bold(p)_(B_o))$ 可描述在坐标系 ${ bold(A) }$ 观察下的坐标系 ${ bold(B) }$]
- 符号 $""_B^A bold(T)$ 表示一个 $4 times 4$ 的矩阵, 其中
  - $bold(T)$ 表示该矩阵仅包含了坐标系的三个坐标轴方向矢量以及原点, 且一般使用齐次坐标系 \
    即有 $""_B^A bold(T) == mat(delim: "[", zws^A bold(x)_B, ""^A bold(y)_B, ""^A bold(z)_B, ""^A bold(p)_(B_o))$ \
    因此该矩阵可描述刚体的位姿, 也称为#strong[齐次矩阵]
  - $A$ 表示该矩阵的坐标值是通过坐标系 ${ bold(A) }$ 描述的
  - $B$ 表示该矩阵所描述的基底以及原点来自坐标系 ${ bold(B) }$
  - 易得该 $""_B^A bold(T)$ 与 $""_B^A bold(R)$ 存在关系 $""_B^A bold(T) == mat(delim: "[", zws_B^A bold(R), ""^A bold(p)_(B_o); bold(0), 1)$, 该#hl(2)[矩阵也可用于描述在坐标系 ${ bold(A) }$ 观察下的坐标系 ${ bold(B) }$]

=== 通过坐标系描述位姿
==== 刚体的坐标系 <sec:刚体的坐标系>
为刚体固连一个坐标系 ${ bold(B) }$（#emph[机体坐标系]），通常选其几何中心、质心或机构上的特征点为原点。三个坐标轴均取单位长度且相互正交，并满足右手定则。

#strong[三轴的具体朝向取决于应用约定]，并非总有某个轴必须朝上或朝前。例如在许多机器人坐标系约定中，以 $x$ 向前、$y$ 向左、$z$ 向上；具体使用时应以项目采用的坐标系约定为准。

习惯上：

- ${ bold(B) }$：机体坐标系（Body frame），随刚体移动。
- ${ bold(A) }$：用于描述位置和姿态的参考坐标系。
- ${ bold(W) }$：世界坐标系（World frame），常被选为固定参考系。

==== 坐标系变换与位姿
观察以上刚体的坐标系可得 \
该坐标系始终固连于刚体之上, 对于刚体上的任意一点 $N$, 无论刚体如何运动, 矢量 $""^B bold(p)_N$ 始终不变

仅需确定刚体的坐标系, 即可确定刚体的位姿, 因此可通过描述刚体的坐标系以表示刚体的位姿 \
下文中也默认#hl(2)[使用刚体坐标系 ${ bold(B) }$ 表示其位姿]

此外, 通过#link(<sec:坐标系变换方法>)[坐标系变换], 可得到刚体任意姿态下, 其上任意点 $N$ 在观察坐标系 ${ bold(A) }$ 的坐标

=== 描述坐标系的一般方法 <sec:描述坐标系的一般方法>

#figure()[#image("./res/pose_loaction.drawio.svg", width: 80%)
]

==== 基于观察坐标系直接描述 <sec:基于观察坐标系直接描述>
根据#link(<sec:矩阵的符号>)[坐标系的要素]可得, 描述坐标系的本质, 即在观察坐标系 ${ bold(A) }$ 下

- 找出被描述坐标系 ${ bold(B) }$ 三个坐标轴的方向 $""^A arrow(x)_B ,^A arrow(y)_B ,^A arrow(z)_B$ \
  可将 ${ bold(B) }$ 平移至 $A_o$ 易于求出坐标轴在 ${ bold(A) }$ 三个坐标轴的分量 \(也即投影)

- 找出观察坐标系 ${ bold(A) }$ 的原点到被描述坐标系 ${ bold(B) }$ 原点 $B_o$ 所构成的矢量 $""^A bold(p)_(A_o B_o)$ 在 ${ bold(A) }$ 三个坐标轴的分量 \(也即投影)

- 将以上四个要素组合, 即可得到坐标系描述的数学符号 $""_B^A bold(T)$

相反地, 根据#link(<sec:坐标系变换法则>)[坐标系变换法则], 先求出 $""_A^B bold(T)$, 再由矩阵的逆可得 $""_B^A bold(T) == zws_A^B bold(T)^(- 1)$

使用该方法时, 可通过检查齐次矩阵中的#link(<sec:矩阵的符号>)[姿态矩阵]是否满足两个约束条件以检查结果是否正确

==== 通过第三个坐标系描述
通过第三个绝对坐标系 ${ bold(W) }$, 使用#link(<sec:基于观察坐标系直接描述>)[基于观察坐标系直接描述]先求出 $zws_A^W bold(T)$ 与 $zws_B^W bold(T)$ \
根据#link(<sec:坐标系变换法则>)[坐标系变换法则]可得 $zws_B^A bold(T) == zws_A^W bold(T)^(- 1) zws_B^W bold(T)$

==== 通过坐标系运动表述
理论基础详见#link(<sec:运动算子与坐标变换的关联>)[运动算子与坐标变换的关联]

当两个坐标系是通过一系列运动描述, 从一个得到另一个时, 可采用此方法获取两坐标系其中一个对另一个的描述 \
但要明确被描述的坐标系与运动时基于的坐标系 \(是否与默认坐标系相同, 不同时应当通过#link(<sec:变换矩阵的观察坐标变换>)[此处]介绍的方法进行转化)

如果运动都是基于初始坐标系 ${ bold(A) }$, 则应当使用#link(<sec:基于观察坐标系的运动组合>)[从右到左的组合顺序] \
如果运动都是基于运动坐标系 ${ bold(A)_(N - 1) }$ , 则应当使用#link(<sec:基于运动坐标系的运动组合>)[从左到右的组合顺序]

=== 坐标系变换方法 <sec:坐标系变换方法>
坐标变换即已知空间上一个点 $N$ 在坐标系 ${ bold(B) }$ 中的坐标 \
现要求出该点在观察坐标系 ${ bold(A) }$ 中的坐标

==== 笛卡尔坐标系下的表示 <sec:笛卡尔坐标系下的表示>
由于#link(<sec:矩阵的符号>)[姿态矩阵] $""_B^A bold(R)$ 记录了坐标系 ${ bold(B) }$ 基底在观察坐标系 ${ bold(A) }$ 下的坐标值 \
向量 $""^B bold(p)_N$ 记录了组合得到点 $N$ 时, ${ bold(B) }$ 各基底的分量 \
因此运算 $""_B^A bold(R) zws^B bold(p)_N$ 将根据分量线性组合 $""_B^A bold(R)$ 各列, 得到向量 $""^A bold(p)_(B_o N)$ \
注意, 此时的结果#hl(2)[并非我们所期望的点 $""^A bold(p)_N == zws^A bold(p)_(A_o N)$, 而是线段 $B_o N$] \
因此#hl(2)[还需要补充剩余部分 $""^A bold(p)_N == zws^A bold(p)_(B_o) +^A bold(p)_(B_o N)$]

从上所述, 在笛卡尔坐标系下, 坐标系变换的一般公式为 \
$ zws^A bold(p)_N == zws_B^A bold(R) zws^B bold(p)_N + zws^A bold(p)_(B_o) $

需要特别指出, 对于#link(<sec:矢量的符号>)[自由矢量], 其表示的只是特定方向而非具体的点, 因此不会受平移的影响, 因此有 $ zws^A bold(n) == zws_B^A bold(R) zws^B bold(n) $

==== 齐次坐标系下的表示 <sec:齐次坐标系下的表示>
根据#link(<sec:矩阵的符号>)[齐次矩阵]的特点易得, #link(<sec:笛卡尔坐标系下的表示>)[变换公式]可等价表示为以下形式 \
即齐次坐标系下, 坐标系变换的一般公式

$ ""^A bold(p)_N == zws_B^A bold(T)^B bold(p)_N $

由此公式可得, 在齐次坐标系下, 仅通过矩阵的乘法即可表示出坐标系的变换 \
因此在公式推导中, 一般都采用齐次矩阵描述坐标系

#problem_box(
  title: [齐次坐标变换例题],
  problem: [
    坐标系 $B$ 相对于 $A$ 绕 $z$ 轴旋转 90°，原点 $B_o$ 在 $A$ 中的坐标为 $(2,0,0)$。点 $P$ 在 $B$ 中的坐标为 $(1,0,0)$。求点 $P$ 在 $A$ 中的坐标。
  ],
)[
取

$R=mat(0,-1,0;1,0,0;0,0,1),quad p=mat(2;0;0)$

按坐标变换公式

$attach(p, tl: A)_P == R attach(p, tl: B)_P +p =mat(0;1;0)+mat(2;0;0)=mat(2;1;0)$
]

==== 坐标系变换法则 <sec:坐标系变换法则>
- 对于多个坐标系之间的变换, 仅需保证左乘的矩阵的被描述坐标系为被乘矩阵的描述坐标系即可, 如 \
  $ ""_D^A bold(T) == zws_B^A bold(T) zws_C^B bold(T) zws_D^C bold(T) $

- 根据矩阵求逆的性质可得, 如果存在等式 $""^A bold(p)_N == zws_B^A bold(T)^B bold(p)_N$ 则有 $""_B^A bold(T)^(- 1) zws^A bold(p)_N == zws^B bold(p)_N$ \
  因此, 通过对齐次矩阵求逆即可交换观察与描述坐标系, 有 $ zws_B^A bold(T)^(- 1) == zws_A^B bold(T) $

==== 齐次矩阵求逆注意
对于任意齐次矩阵 $""_B^A bold(T)$, 均可表示为以下形式 \(公式右侧为#link(<sec:运动算子>)[运动算子]) $ zws_B^A bold(T) == mat(delim: "[", bold(I), zws^A bold(p)_(B_o); bold(0), 1) mat(delim: "[", zws_B^A bold(R), bold(0); bold(0), 1) == "Trans" (zws^A bold(p)_(B_o)) "Rot" (bold(k) , theta) $

显然, 矩阵的两部分分别有逆 \
$ "Trans" (zws^A bold(p)_(B_o))^(- 1) & == mat(delim: "[", bold(I), - zws^A bold(p)_(B_o); bold(0), 1)\
"Rot" (bold(k) , theta)^(- 1) & == mat(delim: "[", zws_B^A bold(R)^T, bold(0); bold(0), 1) $

因此齐次矩阵的逆为 \(注意#cross-link("/Linear_Algebra/ch1.typ", reference: <sec:矩阵求逆>)[矩阵求逆]的法则, 求逆时要交换运算顺序) $ zws_B^A bold(T)^(- 1) & == ["Trans" (zws^A bold(p)_(B_o)) "Rot" (bold(k) , theta)]^(- 1)\
 & == "Rot" (bold(k) , theta)^(- 1) "Trans" (zws^A bold(p)_(B_o))^(- 1)\
 & == mat(delim: "[", zws_B^A bold(R)^T, bold(0); bold(0), 1) mat(delim: "[", bold(I), - zws^A bold(p)_(B_o); bold(0), 1)\
 & == mat(delim: "[", zws_B^A bold(R)^T, - zws_B^A bold(R)^T zws^A bold(p)_(B_o); bold(0), 1) $

==== 坐标变换时的易错解析
- 仅齐次矩阵 $zws_B^A bold(T)$ 完整描述了坐标系 ${ B }$, 姿态矩阵 $zws_B^A bold(R)$ 无论是笛卡尔坐标系还是齐次坐标系, 该矩阵仅包含了坐标轴的方向信息, 因此除非指明 ${ A } , { B }$ 原点重合, 否则以下表达式均为错误的
  - $zws^B bold(p) == zws_A^B bold(R) zws^A bold(p)$
  - $zws_A^B bold(R)^(- 1) zws^B bold(p) == zws^A bold(p)$
  - $zws^B bold(p) == zws_B^A bold(R) zws_A^B bold(R) zws^B bold(p)$ 该表达式虽然不正确, 但由于姿态矩阵为标准正交矩阵, 因此等式成立

== 运动算子 <sec:运动算子>
=== 线性变换表示运动
通过齐次坐标系下的线性变换 \(由于在齐次坐标系下, 因此也称为齐次变换), 能够表示物体的平移与旋转运动 \
也将表示这两种运动的变换称为运动算子 \
#hl(2)[通过运动算子的运算 $zws^A bold(p)_(N 2) == "T" (zws^A bold(p)_(N 1))$ 可得到点 $N 1$ 经过运动 $"T"$ 后来到下一状态 $N 2$ 的坐标]

由#cross-link("/Linear_Algebra/ch8.typ", reference: <sec:使用矩阵表示线性变换>)[矩阵与线性变换]的内容可知, 线性变换均可表示为矩阵的形式, 且满足 $bold(p)_2 == "T" (bold(p)_1) == bold(T) bold(p)_1$ \
因此下文中也将默认将运动算子视为变换矩阵处理

==== 运动算子的符号表示
使用符号表示时, 可写为 $zws^A "T" (dots.h) bold(v)$ 或 $zws^A bold(T) bold(v)$

其中

- 上标 #hl(2)[$A$ 强调描述该运动算子的观察坐标系 ${ bold(A) }$], 若没有上标则#hl(2)[默认使用与被变换向量 $bold(p)$ 一致的坐标系] \
  根据#cross-link("/Linear_Algebra/ch8.typ", reference: <sec:使用矩阵表示线性变换>)[矩阵与线性变换]内容可知, 线性变换或者说运动算子的矩阵表示本质上也是一组特定坐标系观察下的坐标, #hl(2)[因此运动算子也存在观察坐标系, 且同样重要]

- 第一种形式, 即原始的运动算子, 可能带有一系列参数

- 第二种形式, 即强调以矩阵形式表示运动算子, 常用于理论推导, 参数可省略 \
  注意与#link(<sec:坐标系描述及其符号>)[坐标系变换]中的符号区分, #hl(2)[运动算子均不存在左下标], 这是区分两者最简单的标志

对于特定形式的运动算子表示如下

==== 旋转算子 <sec:旋转算子>
- 算子形式 $"Rot" (bold(k) , theta)$
- 矩阵形式 $bold(R) (bold(k) , theta)$, 也可写为 $bold(R)_(bold(k)) (theta)$
- 参数 $bold(k)$ 为单位矢量表示旋转轴, $theta$ 表示旋转角度
- 关于旋转算子的矩阵表示可参考#cross-link("/Linear_Algebra/ch9.typ", reference: <sec:绕坐标轴旋转矩阵>)[简单旋转变换]以及#cross-link("/Linear_Algebra/ch9.typ", reference: <sec:平移变换矩阵>)[齐次坐标系下的线性变换]

在笛卡尔坐标系中旋转算子可表示为 \(其中 $bold(P) == bold(k) bold(k)^T$, $[bold(k)]$ 为#cross-link("/Linear_Algebra/ch5.typ", reference: <sec:向量交叉积>)[交叉积矩阵]) \
$ bold(R) (bold(k) , theta) == bold(P) + (bold(I) - bold(P)) cos theta + [bold(k)] sin theta $

特别地, 当以三个坐标轴为转轴时 $ bold(R)_(bold(x)) (theta) == mat(delim: "[", 1, 0, 0; 0, cos theta, - sin theta; 0, sin theta, cos theta) thin bold(R)_(bold(y)) (theta) == mat(delim: "[", cos theta, 0, sin theta; 0, 1, 0; - sin theta, 0, cos theta) thin bold(R)_(bold(z)) (theta) == mat(delim: "[", cos theta, - sin theta, 0; sin theta, cos theta, 0; 0, 0, 1) $

在齐次坐标系中 $ "Rot" (bold(k) , theta) == mat(delim: "[", bold(R) prime (bold(k) , theta), bold(0); bold(0), 1) $

==== 平移算子 <sec:平移算子>
- 算子形式 $"Trans" (bold(p))$ 或 $"Trans" (bold(n) , q)$
- 矩阵形式 $bold(D) (bold(p))$ 或 $bold(D) (bold(n) , q)$, 也可写为 $bold(D)_(bold(n)) (q)$
- 参数 $bold(p)$ 表示位移矢量, $bold(n)$ 表示位移方向, $q$ 表示位移距离
- 关于平移算子的矩阵表示可参考#cross-link("/Linear_Algebra/ch9.typ", reference: <sec:平移变换矩阵>)[平移变换矩阵]

在笛卡尔坐标下平移是仿射变换，不能仅通过 $3 times 3$ 线性矩阵表示；使用齐次坐标后可写为矩阵乘法： $ "Trans" (bold(p)) == mat(delim: "[", I, bold(p); bold(0), 1) $

==== 运动算子的一般形式 <sec:运动算子的一般形式>
注意, 运动算子可通过#link(<sec:运动算子的组合>)[矩阵相乘]的方式组合 \
根据欧拉定律, 无论如何这些旋转与平移, 最终总能用一个旋转与一个平移运动表示

这也表明无论多么复杂的运动, 最终总能组合得到如下形式 $ bold(T) == "Trans" (bold(p)) "Rot" (bold(k) , theta) $

注意, 公式中的矢量 $bold(p) , bold(k)$ 所在的观察坐标系及该运动算子的观察坐标系

因此使用矩阵 $bold(T)$ 或算子 $"T"$ 表示一般的运动算子 \
特别地, 关于时间的矩阵函数 $bold(T) (t)$ 可用于描述特定点 \
关于#link(<sec:刚体的运动变换>)[刚体的运动变换]则可以使用 $zws^A bold(T)_(B_0 arrow.r B_1)$ 表示在观察坐标系 ${ bold(A) }$ \(此时这一坐标系应当被强调, 其强调了与之右乘的点应处于的观察坐标系) 下刚体从姿态 ${ bold(B)_0 }$ 到 ${ bold(B)_1 }$ 的运动

注意, 运动算子一般形式整理为相对观察坐标系先旋转再平移的方式, 正好与#link(<sec:矩阵的符号>)[齐次矩阵]相对应, 有 $ bold(T) == mat(delim: "[", bold(R) (bold(k) , theta), bold(p); bold(0), 1) $

根据#link(<sec:齐次坐标系下的表示>)[齐次坐标系下的坐标系表示]与#link(<sec:运动算子与坐标变换的关联>)[运动算子与坐标变换的关联] \
假设观察坐标系, 即运动起始位姿为 ${ bold(B)_0 }$, 运动后的位姿为 ${ bold(B)_1 }$

- $"Rot" (bold(k) , theta) == ""_(B_1)^(B_0) bold(R)$, 组合运动中的旋转运动效果即将刚体从观察坐标系姿态旋转至与描述坐标系姿态相同
- $bold(p) == ""^(B_0) bold(p)_(O B_1)$, 组合运动中的平移运动矢量与观察坐标系下, 描述坐标系的原点坐标

=== 运动算子的组合 <sec:运动算子的组合>
==== 基于观察坐标系的运动组合 <sec:基于观察坐标系的运动组合>
已知, 对于点 $zws^A bold(p)_(N 1)$, 通过左乘变换矩阵 $bold(T)$ 即可得到对应的运动后的点坐标 $zws^A bold(p)_(N 2) == bold(T) zws^A bold(p)_(N 1)$ \
因此只需要不断左乘新的变换矩阵, 即可实现点 $N$ 的连续运动

- 由于 $bold(T)$ 默认使用被变换对象的观察坐标系 ${ bold(A) }$ 为自己的观察坐标系, 因此变换 $bold(T)$ 将也基于观察坐标系 ${ bold(A) }$ \
  与坐标变换不同, 被变换对象经过运动后, 其结果依然以同一坐标系描述, 因此观察坐标系不因运动而改变, #hl(2)[这一系列的运动始终基于被变换对象的观察坐标系 ${ bold(A) }$]

- 根据#cross-link("/Linear_Algebra/ch1.typ", reference: <sec:乘法规则>)[矩阵乘法法则], 矩阵乘法不满足交换律, 因此#hl(2)[多个运动算子组合时, 必须按从右往左的顺序依次变换] \
  但是注意, 根据平移的特性易得, 对于连续的#link(<sec:平移算子>)[平移算子]相乘允许交换次序

- 虽然默认情况下认为变换矩阵的观察坐标系与被变换对象的坐标系一致, 但还是要#hl(2)[强调, 仅当被变换的向量与#link(<sec:刚体的运动变换>)[刚体姿态]或组合的变换矩阵具有#strong[同一观察坐标系时], 他们之间才能相乘], 并且变换结果依然在该坐标系中, 这点务必与#link(<sec:坐标系变换方法>)[坐标系变换]进行区分

因此 \
对于点 $zws^A bold(p)_(N 1)$ 经一系列运动后在同一观察坐标系下有 $ bold(T)_N dots.h bold(T)_2 bold(T)_1 zws^A bold(p)_(N 1) == zws^A bold(p)_(N 2) $

对于观察坐标系 ${ bold(A) }$ 下由初始姿态 ${ bold(B_0) }$ 经过一系列运动来到姿态 ${ bold(B_1) }$ 可表示为 $ bold(T)_N dots.h bold(T)_2 bold(T)_1 zws_(B_0)^A bold(T) == zws_(B_1)^A bold(T) $

其中, 将得到 $B_1$ 的一系列运动统称为 $ zws^A bold(T)_(B_0 arrow.r B_1) == bold(T)_N dots.h bold(T)_2 bold(T)_1 $

==== 变换矩阵的观察坐标变换 <sec:变换矩阵的观察坐标变换>
由#cross-link("/Linear_Algebra/ch8.typ", reference: <sec:使用矩阵表示线性变换>)[使用矩阵表示线性变换]部分的内容介绍可知, 即使是同一效果的线性变换, 如果所在的坐标系不同, 线性变换矩阵将完全不同

假设运动点所在的观察坐标系为 ${ bold(A) }$, 然而运动算子却是基于坐标系 ${ bold(B) }$ 描述的, 因此

- 在线性变换前, 需要将被变换点 $zws^A bold(p)$ 的坐标系转为 ${ bold(B) }$, 保证变换进行
- 在线性变换后, 由于结果仍在坐标系 ${ bold(B) }$ 下, 因此还需要将坐标系变换回 ${ bold(A) }$

由上可得, 对于与坐标系 ${ bold(B) }$ 为观察坐标系的变换 $zws^B bold(T)$, 转为以坐标系 ${ bold(A) }$ 为观察坐标系时有 $ zws^A bold(T) == zws_B^A bold(T) zws^B bold(T) zws_B^A bold(T)^(- 1) == zws_B^A bold(T) zws^B bold(T) zws_A^B bold(T) $

==== 基于运动坐标系的运动组合 <sec:基于运动坐标系的运动组合>
在部分情况下, 基于刚体当前的坐标系描述运动能带来许多便利 \
假设刚体从初始位姿 ${ bold(B)_0 }$ 开始, 进行了 $N$ 次运动, 且这 $N$ 次运动均基于运动前的坐标系描述 \(也称为#strong[运动坐标系]), 分别有变换矩阵 $zws^(B_0) bold(T)_1 , zws^(B_1) bold(T)_2 , dots.h , zws^(B_(N - 2)) bold(T)_(N - 1) , zws^(B_(N - 1)) bold(T)_N$

根据#link(<sec:变换矩阵的观察坐标变换>)[变换矩阵的观察坐标变换], 将第 $k$ 个运动的变换矩阵的观察坐标系转换为初始坐标系 ${ bold(B)_0 }$ \
$ zws^(B_0) bold(T)_k == zws_(B_(k - 1))^(B_0) bold(T) zws^(B_(k - 1)) bold(T)_k zws_(B_0)^(B_(k - 1)) bold(T) $

由#link(<sec:运动算子与坐标变换的关联>)[运动算子与坐标变换的关联]可以知道, 齐次矩阵 $zws_(B_(k - 1))^(B_0) bold(T)$ 可通过坐标系 ${ bold(B)_0 }$ 到 ${ bold(B)_(k - 1) }$ 的一系列运动算子的组合表示, 有 \
$ zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1)) == zws_(B_(k - 1))^(B_0) bold(T) == zws^(B_0) T_(k - 1) dots.h zws^(B_0) T_2 zws^(B_0) T_1 $

注意到, 前 $k - 1$ 次运动之积即 $zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1)) == zws_(B_(k - 1))^(B_0) bold(T)$ \
根据#link(<sec:坐标系变换法则>)[坐标系变换法则]中关于齐次矩阵的逆的性质可得 $zws_(B_0)^(B_(k - 1)) bold(T) zws_(B_(k - 1))^(B_0) bold(T) == I$ \
因此带入第 $k$ 次变换时有 \
$ zws^(B_0) bold(T)_(B_0 arrow.r B_k) & == zws^(B_0) bold(T)_k zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1))\
 & == (zws_(B_(k - 1))^(B_0) bold(T) zws^(B_(k - 1)) bold(T)_k zws_(B_0)^(B_(k - 1)) bold(T)) zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1))\
 & == zws_(B_(k - 1))^(B_0) bold(T) zws^(B_(k - 1)) bold(T)_k\
 & == zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1)) zws^(B_(k - 1)) bold(T)_k $

由上可得出以下结论, #hl(2)[当观察坐标系 ${ bold(A) }$ 同时与初始姿态 ${ bold(B_0) }$ 重合时] \(在描述刚体运动时, 这一前提通常成立)

- 对于前 $k - 1$ 次运动有运动算子 $zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1))$

- 当第 $k$ 次运动的描述#hl(2)[基于#strong[观察坐标系]], 为 $zws^A bold(T)_k$, 则使用#link(<sec:基于观察坐标系的运动组合>)[一般规则]可得 \(这一规则在#hl(2)[任何情况下通用]) \
  #hl(2)[通过#strong[左乘]下一运动算子即可进行组合] $zws^(B_0) bold(T)_(B_0 arrow.r B_k) == zws^(B_0) bold(T)_k zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1))$

- 当第 $k$ 次运动的描述#hl(2)[基于#strong[运动坐标系]], 为 $zws^(B_(k - 1)) bold(T)_k$, 则使用上述结论可得 \(注意这一规则#hl(2)[有重合要求]) \
  #hl(2)[通过#strong[右乘]下一运动算子即可进行组合] $zws^(B_0) bold(T)_(B_0 arrow.r B_k) == zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1)) zws^(B_(k - 1)) bold(T)_k$

- 特别地, 当所有运动都基于运动坐标系时，依次把运动算子从右侧相乘，组合矩阵写为 $bold(T)_1 bold(T)_2 dots.h.c bold(T)_N$，即第一个运动位于最左侧。

以此规定

- 当运动算子是基于观察坐标系进行的, 则直接使用左上标 $s$, 表示 space \(可省略, 或使用 $B_0$) \
  如 $zws^(B_0) bold(T)_(B_0 arrow.r B_k) == zws^s bold(T)_k zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1))$

- 当运动算子是基于运动坐标系进行的, 则直接使用左上标 $b$, 表示 body \
  如 $zws^(B_0) bold(T)_(B_0 arrow.r B_k) == zws^(B_0) bold(T)_(B_0 arrow.r B_(k - 1)) zws^b bold(T)_k$

==== 绕任意点旋转运动
在观察坐标系 ${ bold(A) }$ 下刚体绕点 $M$ 以方向为 $bold(k)$ 的转轴旋转了 $theta$, 现希望求出该运动的矩阵形式 \
对于绕点 $M$ 的旋转运动, 如果以一个原点与 $M$ 重合的坐标系描述, 就是#link(<sec:旋转算子>)[绕过原点轴旋转], 而该运动的矩阵形式已知 \
如果在一个坐标轴与 ${ bold(A) }$ 平行, 原点位于 $M$ 的坐标系 ${ bold(A)_M }$ 下描述, 该运动有矩阵形式 $zws^(A_M) bold(T) == bold(R) (bold(k) , theta)$

可通过#link(<sec:变换矩阵的观察坐标变换>)[变换矩阵的观察坐标变换], 将上述的齐次矩阵的描述坐标系变换到观察坐标系 ${ bold(A) }$ 下有 $zws^A bold(T) == zws_(A_M)^A bold(T) zws^(A_M) bold(T) zws_(A_M)^A bold(T)^(- 1)$ \
由此可得到绕过点 $bold(p)$ 的轴 $bold(k)$ 旋转 $theta$ 的运动的矩阵形式为

$ bold(T) (bold(p) , bold(k) , theta) == bold(D) (bold(p)) bold(R) (bold(k) , theta) bold(D)^(- 1) (bold(p)) $

公式中 $bold(p) , bold(k)$ 的观察坐标系即该运动的观察坐标系

=== 通过运动描述位姿
==== 刚体的运动变换 <sec:刚体的运动变换>
已知#link(<sec:刚体的坐标系>)[刚体的位姿]可通过一个坐标系 ${ bold(B) }$ 表示, 在观察坐标系 ${ bold(A) }$ 下, 该坐标系 ${ bold(B) }$ 可使用一个齐次矩阵 $zws_B^A bold(T)$ 描述 \
该齐次矩阵的本质即三个自由矢量与一个点组合而成的序列 $zws_B^A bold(T) == mat(delim: "[", zws^A bold(x), zws^A bold(y), zws^A bold(z), zws^A bold(p)_(B o))$ \
根据矩阵乘法可知, $zws_B^A bold(T) (t) == bold(T) (t) zws_B^A bold(T) (0) == mat(delim: "[", bold(T) (t) zws^A bold(x), bold(T) (t) zws^A bold(y), bold(T) (t) zws^A bold(z), bold(T) (t) zws^A bold(p)_(B o))$

因此将描述刚体坐标系的齐次矩阵左乘运动算子, 即可得到刚体经过一系列运动后的位姿, 也使用如下的矩阵函数表示 $zws_B^A bold(T) (t)$

在刚体的运动变换中注意, 当刚体原点与观察坐标系原点不重合时, 绕观察坐标系轴旋转时, 除了原点绕刚体旋转, 刚体坐标系的三个坐标轴也将随之旋转

==== 运动算子与坐标变换的关联 <sec:运动算子与坐标变换的关联>
- 由#link(<sec:基于观察坐标系直接描述>)[坐标系描述]可得, 当使用任意坐标系 ${ bold(A) }$ 描述自身时, 必然有齐次矩阵 $zws_A^A bold(T) == bold(I)$
- #link(<sec:运动算子的一般形式>)[运动算子的一般形式]与#link(<sec:矩阵的符号>)[矩阵的符号]具有相同的形式, 均为由一个旋转矩阵 $bold(R)$, 一个平移列向量 $bold(p)$ 组成的 $4 times 4$ 的齐次坐标系下的矩阵
- 乘以运动算子进行变换, 并#hl(2)[不会改变观察坐标系, 只会改变齐次矩阵所描述的姿态] \(因此不能以坐标系变换的方式进行理解)

由以上两点可得, 对于观察坐标系 ${ bold(A) }$ 描述下的坐标系 ${ bold(B) }$ 有 \(注意左侧等式两侧应当基于同一观察坐标系, 因此使用的是 $zws_A^A bold(T) == bold(I)$) $ zws_B^A bold(T) == (zws^s bold(T)_N dots.h zws^s bold(T)_2 zws^s bold(T)_1) zws_A^A bold(T) == zws^s bold(T)_N dots.h zws^s bold(T)_2 zws^s bold(T)_1 $

类似地, 当#link(<sec:基于运动坐标系的运动组合>)[基于运动坐标系的运动组合]时有 $ zws_B^A bold(T) == zws_A^A bold(T) (zws^b bold(T)_1 zws^b bold(T)_2 dots.h zws^b bold(T)_N) == zws^b bold(T)_1 zws^b bold(T)_2 dots.h zws^b bold(T)_N $

由此可得, 齐次矩阵 $zws_B^A bold(T)$ 除了描述坐标系, 还可以表示通过观察坐标系 ${ bold(A) }$ 到被描述坐标系 ${ bold(B) }$ 所经历的一系列运动的组合 \
而这也是#link(<sec:描述坐标系的一般方法>)[描述坐标系]的另一重要方法

如果视 ${ bold(A) }$ 与 ${ bold(B) }$ 为刚体运动的两个状态, 以上等式与描述在本质上表示的是 $zws^A bold(T)_(A arrow.r B)$ \(注意观察坐标系) \
因此, 部分情况下也会用符号 $zws_B^A bold(T)$ 表示#hl(2)[以初始位姿 ${ bold(A) }$ 为观察参考系时], 刚体位姿 $A arrow.r B$ 的运动 $zws^A bold(T)_(A arrow.r B)$

当刚体的位姿相对时间 $t$ 变化时, 也简记为 $bold(T) (t)$, 表示 $zws^(B_0) bold(T)_(B_0 arrow.r B_t) == zws_(B_t)^(B_0) bold(T) == bold(T) (t)$ \
但是要始终明确, 位姿 $bold(T) (t)$ 是以起始位姿 ${ bold(B)_0 }$ 作为描述坐标系, 如果希望#link(<sec:坐标系变换方法>)[变换坐标系], 则应当右乘相应的齐次矩阵 $zws_(B_0)^A bold(T)$, 并以左上标强调 $zws^A bold(T) (t)$

==== 运动算子与坐标变换的异同
- 在应用上, 运动算子主要用于描述两个刚体之间的运动, 而坐标系变换则用于描述各个坐标系之间的关系
- 两者在描述时都需要借助观察坐标系, 但运动算子的描述对象是两个姿态间的运动 $B_0 arrow.r B_1$, 而坐标系变换则是被描述坐标系 $B$
- 运动算子与坐标系描述都可使用 $4 times 4$ 的, 齐次空间中的矩阵描述

== 姿态或旋转的描述
确定姿态对于描述刚体的位姿与运动具有重要意义 \
除了姿态矩阵外还有众多关于姿态的表示方式, 这些表示方式可在不同场合下用于表示姿态

此外, 由#link(<sec:运动算子与坐标变换的关联>)[运动算子与坐标变换的关联]可知, 除了描述姿态, 也可用于描述旋转运动

=== 姿态矩阵 <sec:姿态矩阵>
用于表示旋转运动时, 也称之为#strong[旋转矩阵] \
该矩阵为一个 $3 times 3$ 的矩阵, 表示了刚体坐标系中三个坐标轴的方向 $""_B^A bold(R) == mat(delim: "[", zws^A bold(x)_B, ""^A bold(y)_B, ""^A bold(z)_B)$

==== 姿态矩阵的约束条件
一个合法的姿态矩阵应当满足以下约束条件

- #strong[正交性] 该性质表明姿态矩阵是一个#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:标准正交矩阵>)[标准正交矩阵], 满足 $bold(R)^T == bold(R)^(- 1)$
- #strong[特殊条件] 姿态矩阵的三个列向量以此表示 $x , y , z$ 轴, 且始终表示右手系, 满足 $det (R) == 1$

以上约束条件共限制了矩阵 $9$ 个元素中的 $6$ 个, 因此实际上最少只需要三个参数即可表示一个姿态矩阵

==== 姿态矩阵的标准化 <sec:姿态矩阵的标准化>
计算机运算中的舍入误差可能使旋转矩阵 $bold(R) prime$ 不再严格满足 $bold(R) prime^T bold(R) prime == bold(I)$ 与 $det (bold(R) prime) == 1$。一种常用恢复办法是基于#cross-link("/Linear_Algebra/ch7.typ", reference: <sec:奇异值分解>)[奇异值分解]：

$ bold(R) prime == bold(U) bold(Sigma) bold(V)^T $

取 $bold(D) == "diag" (1 , 1 , det (bold(U) bold(V)^T))$，令

$ bold(R) == bold(U) bold(D) bold(V)^T $

所得 $bold(R)$ 是距离 $bold(R) prime$ 最近的正旋转矩阵之一（按 Frobenius 范数）；当 $det (bold(U) bold(V)^T) == 1$ 时，可简化为 $bold(R) == bold(U) bold(V)^T$。#strong[不能只令全部奇异值为 $1$ 而忽略行列式符号]，否则可能得到反射矩阵。

==== 姿态矩阵的特点
姿态矩阵有优点

- 如果要具体刚体上的点在运动后的坐标, 必须借助包含姿态矩阵的齐次矩阵进行坐标变换
- 通过矩阵的相乘能够很好地与其他运动组合

姿态矩阵有缺点

- 直接使用姿态矩阵表示方位时, 一个姿态需要 $9$ 个参数, 然而实际有 $3$ 个独立的参数
- 姿态矩阵可能因浮点误差导致旋转矩阵蠕变, 使矩阵包含了额外的缩放或表示的姿态发生偏差, 需要通过#link(<sec:姿态矩阵的标准化>)[姿态矩阵的标准化]补救

=== 欧拉角与固定角
欧拉角与固定角的本质为通过三个绕坐标轴旋转的#link(<sec:旋转算子>)[旋转算子]来表示姿态 \
只需明确组合的约定, 三次旋转轴以及三个旋转角度即可表示姿态

易得欧拉角或固定角共有 $12$ 种不同的约定, 分别为六种 $x y z$ 的排列以及六种 $x y x$ 的排列

==== 欧拉角与固定角的表示符号
为了避免不同教材的命名冲突，下文统一采用如下约定：#strong[主动旋转、右手系、列向量、矩阵左乘]。

- #emph[固定角（外禀旋转）]：旋转轴始终固定在参考系中。例如按 $x arrow.r y arrow.r z$ 顺序依次旋转 $phi.alt , theta , psi$，对应矩阵 $bold(R) == bold(R)_z (psi) bold(R)_y (theta) bold(R)_x (phi.alt)$。
- #emph[欧拉角（内禀旋转）]：每次绕旋转后的机体坐标轴旋转。按 $z arrow.r y prime arrow.r x prime.double$ 顺序旋转 $psi , theta , phi.alt$，得到相同的总旋转矩阵。

轴序列可分为三个轴互不相同的 Tait–Bryan 角，以及首尾轴相同的经典欧拉角；每类常见序列有 $6$ 种。因此#strong[明确旋转轴顺序及内禀／外禀约定比只说“欧拉角”更重要]。

==== 常用的欧拉角约定
- #strong[RPY（Roll–Pitch–Yaw）角]：绕 $x , y , z$ 轴分别定义滚转 $phi.alt$（roll）、俯仰 $theta$（pitch）、偏航 $psi$（yaw）。在上述固定轴 $X Y Z$ 约定下，按 $x arrow.r y arrow.r z$ 旋转： $ bold(R) == bold(R)_z (psi) bold(R)_y (theta) bold(R)_x (phi.alt) $

- #strong[内禀 $Z Y X$ 角]：绕运动轴按 $z arrow.r y prime arrow.r x prime.double$ 旋转 $psi , theta , phi.alt$，与上述外禀 $X Y Z$ 的最终姿态相同。

- #strong[内禀 $Z Y Z$ 角]：依次绕机体的 $z , y prime , z prime.double$ 轴旋转，常用于机器人运动学。

注意同名 RPY 或 Euler 角在不同软件包中的矩阵乘法约定、主动／被动变换约定可能不同，需以其文档为准。

==== 由欧拉角得到姿态矩阵
以固定轴 $X Y Z$ 的 RPY 约定为例，设 $c_phi.alt == cos phi.alt$、$s_phi.alt == sin phi.alt$，其他角同理，则

$ bold(R) & == bold(R)_z (psi) bold(R)_y (theta) bold(R)_x (phi.alt)\
 & == mat(delim: "[", c_psi c_theta, c_psi s_theta s_phi.alt - s_psi c_phi.alt, c_psi s_theta c_phi.alt + s_psi s_phi.alt; s_psi c_theta, s_psi s_theta s_phi.alt + c_psi c_phi.alt, s_psi s_theta c_phi.alt - c_psi s_phi.alt; - s_theta, c_theta s_phi.alt, c_theta c_phi.alt) $

可用 $phi.alt == theta == 0$、$psi == 90^circle.stroked.tiny$ 验证：结果应为绕 $z$ 轴旋转 $90^circle.stroked.tiny$ 的矩阵。

==== 由姿态矩阵得到欧拉角
给定上述 RPY 约定的姿态矩阵 $bold(R) == (r_(i j))$，在非奇异情形 $cos theta eq.not 0$ 下，取 $theta in [- 90^circle.stroked.tiny , 90^circle.stroked.tiny]$，可以计算

$ {theta == "atan2" (- r_31 , sqrt(r_11^2 + r_21^2))\
phi.alt == "atan2" (r_32 , r_33)\
psi == "atan2" (r_21 , r_11) $

其中 $"atan2" (y , x)$ 使用通常的“纵坐标在前、横坐标在后”参数顺序。

若 $cos theta == 0$，即 $theta == plus.minus 90^circle.stroked.tiny$，出现#emph[万向锁]：只能从旋转矩阵求出 $phi.alt$ 与 $psi$ 的某种组合，而不能分别唯一确定两者。实际计算可选定其中一个角（例如 $phi.alt == 0$），再求另一个角；程序实现需处理数值容差。

==== 欧拉角的特点
欧拉角的优点是只需三个实数且直观；但其表示#emph[不唯一]、受轴序列和旋转约定影响，而且存在万向锁。直接逐分量插值三个角还可能走不期望的路径（例如从 $350^circle.stroked.tiny$ 到 $10^circle.stroked.tiny$ 可能走长弧）。

RPY 的常用主值范围可选 $phi.alt , psi in \( - 180^circle.stroked.tiny , 180^circle.stroked.tiny \]$、$theta in [- 90^circle.stroked.tiny , 90^circle.stroked.tiny]$；这是表示约定，并不消除万向锁。需要平滑姿态插值时，通常优先采用单位四元数。

=== 轴角对与四元数
根据欧拉定理, 任意绕过原点轴的旋转的组合均能表示为单个绕过原点轴的旋转 \
因此仅需给出轴方向 $zws^A bold(k)$ \(下文省略观察方向) 与旋转角度 $theta$ 即可表示任意姿态

关于四元数的基础见#link(<sec:四元数表示与基本性质>)[四元数的基础介绍], 根据#link(<sec:四元数与轴角对的性质>)[四元数转为轴角对], 即可将二者相互转换

- $w == cos (theta \/ 2)$
- $sin (theta \/ 2) == sqrt(x^2 + y^2 + z^2) == sqrt(1 - w^2)$
- $k_x == frac(x, sin (theta \/ 2)) == x / sqrt(x^2 + y^2 + z^2)$, $k_y , k_z$ 类似

注意轴角对与四元数各有约束条件

- 要求轴角对的轴方向 $bold(k)$ 为单位矢量
- 要求四元数表示姿态时, 为#link(<sec:四元数与轴角对的性质>)[单位四元数], 满足 $w^2 + x^2 + y^2 + z^2 == 1$

==== 由轴角对或四元数得到姿态矩阵
通过#cross-link("/Linear_Algebra/ch9.typ", reference: <sec:绕任意轴旋转矩阵>)[绕任意轴旋转矩阵]即可将轴角对转为旋转矩阵 \
$ bold(R) (bold(k) , theta) == bold(P) + (bold(I) - bold(P)) cos theta + [tilde(k)] sin theta $

带入轴角对与四元数的关系可得 $ bold(R) (q) == mat(delim: "[", 1 - 2 y^2 - 2 z^2, 2 x y - 2 w z, 2 x z + 2 w y; 2 x y + 2 w z, 1 - 2 x^2 - 2 z^2, 2 y z - 2 w x; 2 x z - 2 w y, 2 y z + 2 w x, 1 - 2 x^2 - 2 y^2) $

==== 由姿态矩阵得到轴角对
根据 Rodrigues 公式，旋转矩阵 $bold(R) (bold(k) , theta)$ 的迹满足

$ "tr" (bold(R)) == 1 + 2 cos theta $

在 $0 < theta < pi$ 的一般情形下，可以求得

$ theta == arccos (frac("tr" (bold(R)) - 1, 2)) $

$ bold(k) == frac(1, 2 sin theta) mat(delim: "[", r_32 - r_23; r_13 - r_31; r_21 - r_12) $

当 $theta approx 0$ 时旋转轴不唯一；当 $theta approx pi$ 时上述公式因 $sin theta approx 0$ 不稳定。实现时通常用对角线／特征向量方法或先转换成四元数，并处理数值误差。

==== 由姿态矩阵得到四元数
根据单位四元数的特点, 通过不同方式组合姿态矩阵对角线上的元素有 $ r_11 + r_22 + r_33 & == 4 w^2 - 1\
r_11 - r_22 - r_33 & == 4 x^2 - 1\
- r_11 + r_22 - r_33 & == 4 y^2 - 1\
- r_11 - r_22 + r_33 & == 4 z^2 - 1 $

注意, 以上公式无法判断系数的正负负号, 因此一般仅用以上公式计算求出其中一个系数 \
实际使用中, 将计算四个系数中, 绝对值最大的一个 \(即 $4 m^2 - 1$ 最大, 比较时不需要具体确定系数值)

之后, 通过将姿态矩阵相对对角线对称的两个元素相加或相减, 即可得到任意两个四元数元素之积, 通过此方法求出剩余系数

==== 四元数的特点
四元数表示旋转的优点包括：

- 用 $4$ 个分量表达 $3$ 维旋转，并且便于通过乘法组合旋转。
- 单位四元数可以用 Slerp 实现角速度恒定的短弧插值。
- 与欧拉角不同，不存在万向锁；数值运算后只需适当归一化。

其限制包括：

- 必须保持单位长度；$q$ 与 $- q$ 表示同一旋转，因此不是唯一表示。
- 不如欧拉角直观；不同库可能采用标量在前／在后以及 Hamilton／JPL 等不同的乘法约定。

#strong[四元数本身并不限制旋转必须相对于固定坐标系或运动坐标系]；具体组合顺序由约定决定。

== 附录: 四元数介绍
=== 四元数表示与基本性质 <sec:四元数表示与基本性质>
==== 四元数基本运算法则
四元数与复数类似, 但存在三个虚数单位 $bold(i) , bold(j) , bold(k)$, 并且有运算法则 $  & bold(i)^2 == bold(j)^2 == bold(k)^2 == - 1\
 & bold(i) bold(j) == bold(k) , bold(j) bold(i) == - bold(k)\
 & bold(j) bold(k) == bold(i) , bold(k) bold(j) == - bold(i)\
 & bold(k) bold(i) == bold(j) , bold(i) bold(k) == - bold(j) $

==== 四元数表示方式
由三个虚数单位分别乘以一个实数, 并与一个实数共同组成四元数 $ q == w + x bold(i) + y bold(j) + z bold(k) $

此外也常用如下方式表示一个四元数 $ q == mat(delim: "[", w, \( x, y, z \)) == mat(delim: "[", w, arrow(v)) $

在部分标准下, 使用如下方式表示四元数 $ q == mat(delim: "[", \( x, y, z \), w) == mat(delim: "[", arrow(v), w) $

=== 四元数与轴角对的关系
==== 轴角对
欧拉已经证明, 任意三维中的旋转组合, 均等价于一个#cross-link("/Linear_Algebra/ch9.typ", reference: <sec:绕任意轴旋转矩阵>)[绕特定轴的旋转] \
因此可使用旋转轴方向的#hl(2)[单位向量 $arrow(n)$] 与旋转角度 $theta$ 表示旋转变换 \
四元数也可视为轴角对的一种特殊表示方式 \
其与轴角对的参数 $theta , arrow(n)$ 之间满足 $ q == mat(delim: "[", cos (theta \/ 2), \( sin (theta \/ 2) n_x, sin (theta \/ 2) n_y, sin (theta \/ 2) n_z \)) == mat(delim: "[", cos (theta \/ 2), sin (theta \/ 2) arrow(n)) $

在使用#link(<sec:四元数两点插值与样条插值>)[四元数插值]时，若先选择端点 $q$ 或 $- q$ 中使点积非负的表示，Slerp 将沿较短旋转弧插值。例如目标姿态可表示为绕同一轴正向旋转 $240^circle.stroked.tiny$，也可表示为反向旋转 $120^circle.stroked.tiny$，短弧插值会选择后者。

==== 共轭四元数
四元数 $q == w + x bold(i) + y bold(j) + z bold(k)$ 的共轭与模长定义为

$ q^* == w - x bold(i) - y bold(j) - z bold(k) $

$ parallel q parallel == sqrt(w^2 + x^2 + y^2 + z^2) $

对于单位旋转四元数 $q == cos (theta \/ 2) + bold(n) sin (theta \/ 2)$（其中 $parallel bold(n) parallel == 1$），有 $parallel q parallel == 1$。并且

$ q q^* == q^* q == parallel q parallel^2 $

==== 四元数与轴角对的性质 <sec:四元数与轴角对的性质>
- 表示三维旋转的四元数必须是#strong[单位四元数] $parallel q parallel == 1$。
- 对单位四元数，$q^* == q^(- 1)$ 表示逆旋转。
- $q$ 与 $- q$ 表示同一个旋转，这称为四元数的#strong[双重覆盖性]。进行插值前常据此调整符号。
- 当 $theta == 0$ 时，表示恒等旋转的四元数可取 $q == (1 , 0 , 0 , 0)$；同一旋转也由 $(- 1 , 0 , 0 , 0)$ 表示。
- 在 $sin (theta \/ 2) == 0$ 时，无法由虚部唯一恢复旋转轴；轴角对本身也有等价表示。

=== 四元数乘法运算
==== 标准乘法定义
选用常见的 #strong[Hamilton 四元数乘法]。记 $q_i == (w_i , bold(v)_i)$，其中 $bold(v)_i == (x_i , y_i , z_i)$，则

$ q_1 q_2 == (w_1 w_2 - bold(v)_1 dot.op bold(v)_2 , quad w_1 bold(v)_2 + w_2 bold(v)_1 + bold(v)_1 times bold(v)_2) $

乘法满足结合律但通常不满足交换律。结合下文的 $bold(v) prime == q bold(v) q^(- 1)$ 旋转约定，乘积 $q_2 q_1$ 表示#strong[先做 $q_1$ 旋转，再做 $q_2$ 旋转]。

应注意另一类文献会采用相反叉积号或不同的坐标变换定义，不能混用两套公式。

==== 四元数标准乘法的运算法则
由标准乘法中涉及到的#cross-link("/Linear_Algebra/ch5.typ", reference: <sec:向量交叉积>)[叉乘]可得, 四元数的标准乘法满足结合律, 但不满足交换律 $ cases(delim: "{",  & (q_1 q_2) q_3 == q_1 (q_2 q_3),  & q_1 q_2 eq.not q_2 q_1) $

易得, 四元数乘积的模长等于两个四元数模长的乘积 $ mat(delim: bar.double, q_1 q_2) == mat(delim: bar.double, q_1) mat(delim: bar.double, q_2) $

==== 四元数的逆与方位间角位移
由 $q q^* == parallel q parallel^2$ 可得，对任何非零四元数

$ q^(- 1) == frac(q^*, parallel q parallel^2) $

只有当 $q$ 是单位四元数时，才有 $q^(- 1) == q^*$。多个四元数乘积的逆需#strong[逆序]：

$ (q_1 q_2)^(- 1) == q_2^(- 1) q_1^(- 1) $

若采用固定坐标系的主动旋转约定，旋转 $d$ 左乘初始姿态 $q_1$ 得到 $q_2$，则

$ d q_1 == q_2 , #h(2em) d == q_2 q_1^(- 1) $

若使用机体坐标系右乘增量，表达式相应改变。

==== 四元数与旋转
将空间向量 $bold(v)$ 写为纯虚四元数 $p_v == (0 , bold(v))$，使用单位四元数 $q$ 对其进行主动旋转：

$ p_u == q p_v q^(- 1) $

若先以 $q_a$ 旋转，再以 $q_b$ 旋转，则

$ p prime == q_b q_a thin p_v thin (q_b q_a)^(- 1) $

可见在这一约定下，四元数旋转的组合与主动旋转矩阵一样，#strong[右侧的旋转先执行]。不应在同一套推导中随意更换 Hamilton 乘法的叉积符号。

=== 四元数的其他运算
==== 四元数的点乘
将四元数视为 $bb(R)^4$ 中的向量，点积定义为

$ q_1 dot.op q_2 == w_1 w_2 + bold(v)_1 dot.op bold(v)_2 $

若 $q_1 , q_2$ 均为单位四元数，则点积位于 $[- 1 , 1]$。由于 $q$ 与 $- q$ 表示相同旋转，可使用 $lr(|q_1 dot.op q_2|)$ 衡量两姿态间的接近程度。

==== 四元数的对数函数
与复数的对数运算类似, 对于#link(<sec:四元数与轴角对的性质>)[单位四元数] $q == mat(delim: "[", cos (theta \/ 2), sin (theta \/ 2) arrow(n))$, 其对数函数满足 $ log q == mat(delim: "[", 0, theta / 2 arrow(n)) $

单位四元数经过对数函数, 能够提取四元数中的轴角对信息

==== 四元数的指数函数
四元数的指数函数即对数函数的逆运算, 对于 $w == 0$ 的四元数 $q == mat(delim: "[", 0, theta / 2 arrow(n))$, 其指数函数满足 $ exp q == mat(delim: "[", cos (theta / 2), sin (theta / 2) arrow(n)) $

$w == 0$ 的四元数 \(轴角对) 经过指数函数, 能够转换为单位四元数

==== 四元数的幂
已知四元数的对数与指数函数后, 根据对数与指数函数的性质, 即可定义四元数的幂满足 $ q^k == exp (k log q) $

由此可得, 与复数类似, 对于四元数 $q$ 的 $k$ 次幂相当于将原旋转角度乘以 $k$ 倍 \
注意 $k$ 可以是任意实数, 如 $q^(- 1 \/ 3)$ 将表示一个绕相同轴的旋转, 但旋转角度为原来的 $1 / 3$, 且旋转方向相反

=== 四元数两点插值与样条插值 <sec:四元数两点插值与样条插值>
==== 四元数插值 Slerp

#figure()[#image("./res/pose_slerp.drawio.svg", width: 50%)
]

Slerp（Spherical Linear Interpolation，球面线性插值）用于两个单位四元数之间沿球面大圆弧进行插值。设 $q_0 , q_1$ 为端点，$t in [0 , 1]$。

先计算点积 $d == q_0 dot.op q_1$。为确保在旋转空间取较短路径，若 $d < 0$，可将 $q_1$ 改为 $- q_1$，然后将点积限制在 $[- 1 , 1]$ 并取 $omega == arccos (d)$。

当 $sin omega$ 不接近零时，#strong[正确的权重]为

$ "Slerp" (q_0 , q_1 , t) == frac(sin ((1 - t) omega), sin omega) q_0 + frac(sin (t omega), sin omega) q_1 $

可以直接验证端点条件 $t == 0$ 得 $q_0$，$t == 1$ 得 $q_1$。沿给定的最短旋转弧进行插值时，角速度大小保持恒定。

当 $q_0 , q_1$ 很接近时，上式会遇到除以很小的 $sin omega$ 的数值问题，可以改用归一化线性插值（Nlerp）：

$ q (t) == frac((1 - t) q_0 + t q_1, parallel (1 - t) q_0 + t q_1 parallel) $

另一种等价写法（采用本笔记的固定参考系左乘约定）是：

$ "Slerp" (q_0 , q_1 , t) == (q_1 q_0^(- 1))^t q_0 $

上述指数写法需选择与短弧相应的四元数分支。

#problem_box(
  title: [Slerp 姿态插值例题],
  problem: [
    从恒等旋转插值到绕 $z$ 轴旋转 90°，取标量在前的单位四元数表示。求中点 $t=1/2$ 的插值四元数及对应旋转角度。
  ],
)[
初始和终止姿态分别为

$q_0=(1,0,0,0),quad q_1=(sqrt(2)/2,0,0,sqrt(2)/2)$

二者点积为 $sqrt(2)/2$，故 $omega=pi/4$。代入 Slerp 公式可得

$q_(1/2)=(cos(pi/8),0,0,sin(pi/8))$

此时四元数的旋转角为 $2 dot pi/8=pi/4$，即绕 $z$ 轴旋转 45°。
]

==== 四元数样条 Squad
当有多个关键姿态 $q_1 , q_2 , dots.h , q_n$ 时，直接逐段 Slerp 只能保证姿态连续，不一定能让相邻段的角速度连续。Squad（Spherical and Quadrangle）利用辅助控制点平滑连接各段。

先保证相邻单位四元数的符号连续，并定义内点的辅助控制四元数

$ s_i == q_i exp (- frac(log (q_i^(- 1) q_(i + 1)) + log (q_i^(- 1) q_(i - 1)), 4)) $

对相邻姿态 $q_i , q_(i + 1)$，以 $h in [0 , 1]$ 插值：

$ "Squad" (q_i , q_(i + 1) , h) == "Slerp" ("Slerp" (q_i , q_(i + 1) , h) , "Slerp" (s_i , s_(i + 1) , h) , 2 h (1 - h)) $

端点 $s_1 , s_n$ 需要采用单独的边界条件（例如复制首尾关键姿态或给定端点角速度）。在合理的控制点与符号约定下，该方法可获得更平滑的角速度连接。
