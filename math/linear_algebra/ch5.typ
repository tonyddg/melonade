// 线性代数笔记 · Shiroa / Typst
// 需要 /book.typ 与 /utility/include.typ。
#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "行列式")
#import "/utility/include.typ": *
#set math.mat(delim: "[")
#set math.vec(delim: "[")

= 行列式
#quote(block: true)[
参考教程 #link("https://www.bilibili.com/video/BV1zx411g7gq")[麻省理工公开课 线性代数] P18\~P20
]

== 行列式基础
行列式为所有#hl(2)[方阵]都具有的一个特殊值 \
使用 $det (A)$ 或 $lr(|A|)$ 表示方阵 $A$ 的行列式 \
当 $det (A) = 0$ 表示矩阵不可逆

=== 行列式的基本性质 <sec:行列式的基本性质>
行列式具有以下四个基本性质

==== 基本性质一
对于任意单位矩阵 $I$, 其行列式为 $1$

$ det (I) = 1 $

==== 基本性质二 <sec:基本性质二>
当矩阵内的两行被交换后, 其行列式的值取反

- 注意该性质表明, 无法通过奇数次行交换得到与偶数次行交换相同的结果

$ mat(delim: bar.double, a, b; c, d) = - mat(delim: bar.double, c, d; a, b) $

==== 基本性质三 <sec:基本性质三>
当矩阵内的任意一行乘上系数 $k$, 其行列式的值也乘上该系数 $k$

$ mat(delim: bar.double, k a, k b; c, d) = k mat(delim: bar.double, a, b; c, d) $

==== 基本性质四
当两个除特定一行不同, 其余相同的两个矩阵的行列式之和, 等于该行系数相加, 其余不变的矩阵的行列式

$ mat(delim: bar.double, a + u, b + v; c, d) = mat(delim: bar.double, a, b; c, d) + mat(delim: bar.double, u, v; c, d) $

最后两个性质表明, #hl(2)[行列式不满足线性性, 但行列式每一行单独满足线性性]

=== 重要推论 <sec:重要推论>
根据行列式的基本性质, 可得出以下推论

==== 推论一
当矩阵中有两个相同的行, 则该矩阵的行列式为 $0$ \
该推论可由基本性质 $2$ 得到, 因为行交换后符号取反但矩阵不变, 行列式仅能是 $0$

$ mat(delim: bar.double, a, b; a, b) = 0 $

==== 推论二
矩阵的第 $i$ 行乘上系数 $k$ 减去第 $j$ 行, 行列式不变 \
该推论可由推论 $1$ 与基本性质 $3 , 4$ 得到

$ mat(delim: bar.double, a, b; c - k a, d - k b) = mat(delim: bar.double, a, b; c, d) - k mat(delim: bar.double, a, b; a, b) = mat(delim: bar.double, a, b; c, d) $

==== 推论三 <sec:推论三>
当矩阵有一行全为 $0$, 则该矩阵的行列式为 $0$ \
该推论可由基本性质 $3$ 得到, 全为 $0$ 相当于对一行乘上系数 $0$, 得到的行列式为 $0$

$ mat(delim: bar.double, a, b; 0, 0) = 0 $

==== 推论四 <sec:推论四>
对于上三角方阵 $U$, 其行列式为对角线上的#hl(2)[元素 \(主元) 之积]

- 首先 $U$ 可通过推论 $2$ 化简为对角线方阵 $D$
- 然后根据基本性质 $3$ 提取各行的对角线上的系数得到的单位矩阵 $I$
- 最后根据基本性质 $1$, 可得矩阵的行列式即对角线上的元素之积
- 由此可得计算行列式的基本方法为通过#cross-link("/Linear_Algebra/ch1.typ", reference: <sec:高斯消元法>)[消元法]得到矩阵的所有主元, 将主元相乘得到行列式

$ mat(delim: bar.double, d_1, \*, \*; 0, d_2, \*; 0, 0, d_3) = d_1 d_2 d_3 $

==== 推论五 <sec:推论五>
当 $n times n$ 矩阵的秩 $r < n$, 即矩阵不可逆时, 该矩阵的行列式为 $0$ \
也可以认为, #hl(2)[当矩阵可逆时, 其行列式 $eq.not 0$] 根据推论 $4$ 可得, $r < n$ 表明对角线上存在 $0$, 因此行列式为 $0$

==== 推论六
两个方阵相乘的行列式, 等于两个矩阵分别计算行列式后相乘, 即 $det (A B) = det (A) dot.op det (B) = det (B A)$ \(证明略)

- 该推论可推出结论, 对于可逆矩阵 $A$, 其逆的行列式为自身行列式的倒数 $det (A^(- 1)) = 1 \/ det (A)$
- 矩阵平方的行列式等于其行列式的平方 $det (A^2) = det^2 (A)$
- 注意矩阵的数乘 $k$ 相当于对各列乘以系数 $k$, 因此, 对于 $n times n$ 的矩阵 $A$ 根据性质 $3$, $k dot.op det (A) = k^n det (A)$
- 若 $A , B$ 不为方阵, 则该推论不成立

==== 推论七 <sec:推论七>
矩阵的转置的行列式与未转置的行列式相同 $det (A) = det (A^T)$ \(证明略)

- 该推论表明与行有关的性质 $2 , 3 , 4$ 以及推论 $1 , 2 , 3$ 对于列同样成立

== 行列式的计算
=== 二乘二矩阵的行列式
现有 $2 times 2$ 的任意矩阵, 推导其行列式的一般计算方法

$ mat(delim: bar.double, a, b; c, d) & = mat(delim: bar.double, a, 0; c, d) + mat(delim: bar.double, 0, b; c, d)\
 & = mat(delim: bar.double, a, 0; c, 0) + mat(delim: bar.double, a, 0; 0, d) + mat(delim: bar.double, 0, b; c, 0) + mat(delim: bar.double, 0, b; 0, d)\
 & = mat(delim: bar.double, a, 0; 0, d) - mat(delim: bar.double, b, 0; 0, c)\
 & = a d - b c $

=== 一般矩阵的行列式 <sec:一般矩阵的行列式>
对于 $n times n$ 的任意行列式 \
根据 $2 times 2$ 矩阵行列式计算公式可得, 其最终都可利用#link(<sec:基本性质三>)[基本性质三]拆分为 $n^n$ 个, 每行仅有一个元素的行列式 \
这些被拆分的行列式中, 又仅有 $n !$ 个行列式每列仅有一个元素, 根据#link(<sec:推论三>)[推论三]与#link(<sec:推论七>)[推论七] 其余的行列式为 $0$ \
最终剩余的 $n !$ 个行列式每列仅有一个元素, 可通过#link(<sec:基本性质二>)[基本性质二]进行行交换, 转换为对角线矩阵 \
因此一般矩阵的行列式即 \(注意正负号需要根据行交换的次数决定)

$ lr(|A|) = sum_(k = 1)^(n !) plus.minus product_(i = 1)^n a_(i m) $

=== 代数余子式 <sec:代数余子式>
对于 $n times n$ 的任意行列式 $lr(|A|)$ , 取其中任意一个元素 $a_(i j)$ \
将行列式的第 $i$ 行与第 $j$ 列的元素去除, 将余下的元素组成一个新的行列式 $lr(|A prime_(i j)|)$ , 将该行列式的值称为*余子式*

当 $i + j$ 为奇数时, 将行列式的值乘以 $- 1$, 将此时的结果称为*代数余子式*, 对于 $a_(i j)$ 的代数余子式 $c_(i j)$ 满足

$ c_(i j) = cases(delim: "{", lr(|A prime_(i j)|) & , i + j upright("为偶数"), - lr(|A prime_(i j)|) & , i + j upright("为奇数")) $

易得, 代数余子式 $c_(i j)$ 的本质即#link(<sec:一般矩阵的行列式>)[一般矩阵的行列式]中, 所有包含 $a_(i j)$ 的项提出 $a_(i j)$ 后的和

因此, 对于第 $k$ 行的元素, 矩阵的行列式满足

$ lr(|A|) = sum_(i = 1)^n a_(k i) c_(k i) $

其中

- 一般取 $k = 1$ 或矩阵中 $0$ 最多的行使用代数余子式计算行列式
- 根据公式可得, #hl(2)[使用新的系数 $b_(k i)$ 代替原系数 $a_(k i)$, 就能得到将原矩阵中的第 $k$ 行换为 $arrow(b)$ 后的行列式]
- 根据#link(<sec:重要推论>)[推论 $7$] 可得, 取矩阵的第 $k$ 列也能得到相同形式的行列式计算公式

== 行列式的应用
=== 矩阵求逆公式
根据#link(<sec:代数余子式>)[代数余子式]的特点, 可以得到如下矩阵求逆的通用公式

$ A^(- 1) = frac(C^T, det (A)) $

其中 $C$ 为代数余子式矩阵, 即 $c_(i j)$ 对应矩阵 $A$ 中元素 $a_(i j)$ 的代数余子式 \
称其转置 $C^T$ 为*伴随矩阵*

证明如下 \
上述命题等价于

$ A C^T = mat(delim: "[", a_11, a_12, dots.h, a_(1 n); dots.v, dots.v, , dots.v; a_(n 1), a_(n 2), dots.h, a_(n n)) mat(delim: "[", c_11, dots.h, c_(n 1); c_12, dots.h, c_(n 2); dots.v, , dots.v; c_(1 n), dots.h, c_(n n)) = det (A) I $

根据矩阵乘法法则, 矩阵 $A$ 与 $C^T$ 相乘的结果 $B$ 中, 第 $u$ 行 $v$ 列元素 $b_(u v)$ 来自 $A$ 的第 $u$ 行与 $C^T$ 的第 $v$ 列相乘

- 当 $u = v$, $b_(u u) = sum_(i = 1)^n a_(u i) c_(u i)$ 即 $det (A)$ 行列式的计算公式, 因此 $b_(u v) = det (A)$
- 当 $u eq.not v$, 认为 $b_(u v) = sum_(i = 1)^n a_(u i) c_(v i)$ 为行列式 $det (A_s)$ 的计算公式, 但是 $A_s$ 中的第 $v$ 行被替换成了 $A$ 中的第 $u$ 行, 此时 $A_s$ 中有两行相等, 显然 $b_(u v) = det (A_s) = 0$

因此公式成立

=== 克拉默法则
在得到矩阵的求逆公式后, 将其用于含可逆矩阵的线性方程组求解, 有

$ A arrow(x) & = arrow(b)\
arrow(x) & = frac(1, det (A)) C^T arrow(b) $

根据变形结果可得, 对于方程的解 $x_k$ 满足

$ x_k = frac(sum_(i = 1)^n b_i c_(i k), det (A)) = frac(det (B_k), det (A)) $

对比代数余子式下的#link(<sec:代数余子式>)[矩阵行列式公式], $sum_(i = 1)^n b_i c_(i k)$ 相当于#hl(2)[将 $A$ 的第 $k$ 列替换为 $arrow(b)$] 的矩阵 $B_k$ \
因此可将含可逆矩阵的线性方程组求解转换为行列式的代数表达式, 称为*克莱姆法则*

== 体积与行列式 <sec:体积与行列式>
=== 等价证明
将行列式的 $n$ 列视为 $n$ 条边, 以原点为一个顶点, 构成一个具有 $2 n$ 条边的平行体 \
而行列式的绝对值即该平行体的体积 \(行列式的符号反应边之间的顺序)

以三维的情况为例, 行列式的值反映了一个平行六面体的体积 \
现对照行列式的#link(<sec:行列式的基本性质>)[四个基本性质]来证明这一命题

+ 对于单位矩阵 $I$, 其三个列反应了一个三维空间中的一个体积为 $1$ 的单位立方体, 与行列式相同

  - 对于正交矩阵 $Q$, 由于 $Q^T Q = I$, 有 $1 = det (Q^T Q) = det (Q^T) det (Q) = det^2 (Q)$ \
    可得, $det (Q) = plus.minus 1$ 因此正交矩阵的三列反映了一个旋转了一定角度的单位立方体

+ 对于任意矩阵 $A$, 该矩阵的行交换相当于其转置 $A^T$ 的列交换, 行列式的绝对值始终不变 \
  对于体积, 边的顺序对体积没有影响, 因此体积的特性也符合该性质

+ 当平行六面体的一条边伸长 $k$ 倍, 显然其体积也将增大 $k$ 倍, 该性质与行列式的基本性质 $3$ 相符合

#align(center)[#image("src/det_volume.drawio.svg", width: 50%)]
对于性质 $4$, 可用二维情况下的如图所示的平行四边形表示 \
如图所示, 对于同一斜边 $arrow(b)$, 以 $arrow(a)_1$ 和以 $arrow(a)_2$ 为斜边的两个平行四边形面积之和等于以 $arrow(a)_1 + arrow(a)_2$ 为斜边的平行四边形面积 \
推广到高维依然成立, 因此体积的该性质与行列式的基本性质 $4$ 一致

=== 三角形面积
当三角形的三个顶点 $(x_k , y_k) , k = 1 , 2 , 3$ 已知, 可通过如下行列式求出三角形的面积

$ S = 1 / 2 mat(delim: bar.double, x_1, y_1, 1; x_2, y_2, 1; x_3, y_3, 1) $

通过消元法消去右下角的两个 $1$, 在最后一列以代数余子式的方式展开时, 仅剩下右上角的 $1$ 乘以下方的行列式 \
该行列式的两行即将第一点移动至原点后三角形另外两边 \
通过乘以 $1 / 2$, 将平行四边形, 三角形的面积即该平行四边形面积 \(行列式) 的一半

=== 向量交叉积 <sec:向量交叉积>
定义三维空间中两个向量 $arrow(u) , arrow(v)$ 的交叉积为 $arrow(u) times arrow(v)$, 满足

$ arrow(u) times arrow(v) = mat(delim: bar.double, arrow(i), arrow(j), arrow(k); u_1, u_2, u_3; v_1, v_2, v_3) $

交叉积具有以下性质

+ $arrow(u) times arrow(v) = - arrow(v) times arrow(u)$

+ 交叉积的结果与向量 $arrow(u) , arrow(v)$ 正交, 因此 $arrow(u) dot.op (arrow(u) times arrow(v)) = 0$, 且满足右手定则

+ 两个同方向向量的交叉积结果为向量 $arrow(0)$, 即 $(k arrow(u)) times arrow(u) = 0$ \
  因此对于任意两个向量 $arrow(u) , arrow(v)$ 叉乘, 可将 $arrow(v)$ 分解为相对 $arrow(u)$ 的垂直分量 $arrow(v)_tack.t$ 与平行分量 $arrow(v)_parallel$, 有 $arrow(u) times arrow(v)_tack.t = arrow(u) times arrow(v)$

+ 交叉积结果的绝对值为以 $arrow(u) , arrow(v)$ 为边的平行四边形的面积, 因此 $lr(|arrow(u) times arrow(v)|) = lr(|arrow(u)|) lr(|arrow(v)|) lr(|sin theta|)$

=== 交叉积矩阵
当固定向量 $arrow(u)$ 在左侧, 并在右侧乘以向量 $arrow(v)$, 则可等价为向量 $arrow(v)$ 左乘#link("https://sat.huijiwiki.com/wiki/%E5%8F%89%E4%B9%98%E7%9F%A9%E9%98%B5")[叉乘矩阵] $[tilde(u)]$ \(也写作 $[arrow(u)]$), 叉乘矩阵满足

$ [tilde(u)] = mat(delim: "[", 0, - u_z, u_y; u_z, 0, - u_x; - u_y, u_x, 0) , quad arrow(u) times arrow(v) = [tilde(u)] arrow(v) = - arrow(v)^T [tilde(u)] $

可得 $[tilde(u)]$ 为一个对角线为 $0$ 的反对称矩阵 \
而对于这类矩阵 $A$, 定义运算 $[tilde(u)] = A^or = arrow(u)$ 可将叉乘矩阵转化为向量

=== 混合积
对于三维空间中的三个向量 $arrow(u) , arrow(v) , arrow(w)$ 定义混合积 \(也称为三重积) 运算满足

$ [arrow(u) arrow(v) arrow(w)] = (arrow(u) times arrow(v)) dot.op arrow(w) = mat(delim: bar.double, u_1, u_2, u_3; v_1, v_2, v_3; w_1, w_2, w_3) $

混合积具有以下性质

- 由行列式#link(<sec:基本性质二>)[基本性质二], 交换混合积中任意两个向量的位置, 结果取反
- 由行列式性质#link(<sec:推论四>)[推论四], 当三个向量位于同一平面时, 运算结果为 0
- 由#link(<sec:体积与行列式>)[体积与行列式]关系可得, 混合积的结果为三个向量为棱边组成的平行六面体体积
