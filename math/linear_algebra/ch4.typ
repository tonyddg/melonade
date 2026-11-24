// 线性代数笔记 · Shiroa / Typst
// 需要 /book.typ 与 /utility/include.typ。
#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "正交性")
#import "/utility/include.typ": *
#set math.mat(delim: "[")
#set math.vec(delim: "[")

= 正交性
#quote(block: true)[
参考教程 #link("https://www.bilibili.com/video/BV1zx411g7gq")[麻省理工公开课 线性代数] P14\~P17
]

== 正交性的定义 Orthogonal
=== 向量的正交性
对于向量 $arrow(u) , arrow(v)$, 当两个向量满足

$ arrow(u)^T arrow(v) = 0 $

则称向量 $arrow(u)$ 与 $arrow(v)$ 正交

显然

- 零向量 $arrow(0)$ 与任何其他向量正交
- 向量 $arrow(u) , arrow(v)$ 均来自向量空间 $R^n$

=== 向量空间的正交性
有向量空间 $S , T$, 它们均为 $bb(R)^n$ 的子空间 \
当任意一个来自 $S$ 的向量与任意一个来自 $T$ 的向量#hl(2)[都满足正交性]时 \
则称向量空间 $S$ 与 $T$ 正交

显然

- 当向量空间 $S , T$ 正交时 $S inter T = arrow(0)$

== 基本子空间的正交性
=== 行空间与零空间正交性证明
对于 $m times n$ 的矩阵 $A$, 其行空间 $C (A^T)$ 与零空间 $N (A)$ 均为向量空间 $R^n$ 的子空间

根据#cross-link("/Linear_Algebra/ch2.typ", reference: <sec:零空间>)[零空间]的定义可得, 对于任意一个来自零空间 $N (A)$ 的向量 $arrow(x)$ 有

$ A arrow(x) & = arrow(0)\
mat(delim: "[", arrow(r)_1^T; arrow(r)_2^T; dots.v; arrow(r)_m^T) arrow(x) & = mat(delim: "[", 0; 0; dots.v; 0) $

将 $A$ 视为一个由行向量 $arrow(r)_i^T$ 组成的向量, $arrow(x)$ 视为一个 $n times 1$ 的矩阵, 则该等式表明, #hl(2)[$A$ 中的每一行均与 $arrow(x)$ 正交]

由于行空间 $C (A^T)$ 的一组基来自 $A$ 的主元行, 因此上式也表明 $arrow(x)$ 与行空间的一组基 $arrow(a)_k$ 正交, 有 $arrow(x)^T arrow(a)_k = arrow(0)$

因此对于来自行空间的任意向量 $arrow(a)$ 有

$ arrow(x)^T arrow(a) = arrow(x)^T (c_1 arrow(a)_1 + c_2 arrow(a)_2 + dots.h + c_r arrow(a)_r) = arrow(0) $

因此对于来自同一矩阵 $A$ 的#hl(2)[行空间与零空间具有正交性] \
同理可得, 来自同一矩阵 $A$ 的#hl(2)[列空间与左零空间具有正交性]

=== 正交补 <sec:正交补>
注意到, 行空间的维数 $d i m [C (A^T)] = r$, 零空间的维数 $d i m [N (A)] = n - r$, 这两个空间均为 $R^n$ 的子空间

由于行空间与零空间正交, 因此行空间与零空间分别完全占据了 $R^n$ 的两个维度 \
零空间不仅仅与行空间正交, 而且#hl(2)[零空间是与行空间正交的, 维数最大的向量空间] \
以此定义, #hl(2)[零空间为行空间的*正交补*]

同理, 左零空间为列空间的正交补

由此可得, 对于任意向量 $arrow(x) in R^n$, 必定可以分解为 $arrow(x) = arrow(a) + arrow(b)$, 其中 $arrow(a) in C (A^T) , arrow(b) in N (A)$ \
$arrow(x) in R^m$ 同理

== 投影矩阵 <sec:投影矩阵>
=== 向量投影 <sec:向量投影>
以二维空间举例, 现有二维空间中的向量 $arrow(a) , arrow(b)$

以 $arrow(a)$ 为基底构成以一个向量空间 $C (arrow(a))$, 这个空间在二维平面中即一条过原点的直线 \
在 $C (arrow(a))$ 中一定有一个#hl(2)[向量 $arrow(p) = x arrow(a)$, 使 $arrow(b)$ 与 $arrow(p)$ 距离最近] \
以此定义 $arrow(b)$ 在 $arrow(a)$ 上的*投影*为 $arrow(p)$

显然直线 $B P$ 为 $C (arrow(a))$ 的一条垂线, 向量 $arrow(e) = arrow(b) - arrow(p)$ 与向量 $arrow(a)$ 正交, 因此

$ arrow(a)^T (arrow(b) - arrow(p)) & = arrow(0)\
x arrow(a)^T arrow(a) & = arrow(a)^T arrow(b)\
x & = frac(arrow(a)^T arrow(b), arrow(a)^T arrow(a))\
arrow(p) & = arrow(a) frac(arrow(a)^T arrow(b), arrow(a)^T arrow(a)) $

根据 $arrow(p)$ 的表达式可知

+ 即使 $arrow(a)$ 乘上任意倍数, 投影 $arrow(p)$ 不变
+ 当 $arrow(b)$ 乘上 $k$ 倍, 则投影 $arrow(p)$ 也将乘上 $k$ 倍

==== 向量投影矩阵 <sec:向量投影矩阵>
在投影向量的推导中, $arrow(a)^T arrow(a)$ 得到一个数, 而 $arrow(a) arrow(a)^T$ 得到一个方阵

$ arrow(p) & = frac(arrow(a) arrow(a)^T, arrow(a)^T arrow(a)) arrow(b)\
arrow(p) & = P arrow(b) $

因此可将获得 $arrow(b)$ 在 $C (arrow(a))$ 上的投影运算使用 $arrow(b)$ 与投影矩阵 $P$ 的相乘表示

==== 向量投影矩阵的性质
+ 投影矩阵来自两个向量相乘, 因此投影矩阵为一个秩一矩阵, 有 $r = 1$
+ 将向量 $arrow(a)$ 视为矩阵, 则可以知道, #hl(2)[投影矩阵为一个对称矩阵], 有 $P = P^T$
+ 当 $arrow(b)$ 投影到 $arrow(p)$, 显然向量空间 $C (arrow(a))$ 上离 $arrow(p)$ 最近的点即 $arrow(p)$ 自身 \
  因此可以推出#hl(2)[投影矩阵满足 $P^2 = P$]

=== 一般投影 <sec:一般投影>
在 $R^n$ 空间中有 \
向量 $arrow(b)$, 在 $R^n$ 空间中体现为一条直线 \
向量空间 $C (A)$ 在 $R^n$ 空间中体现为一个多维平面

在 $C (A)$ 中一定有一个#hl(2)[向量 $arrow(p) = A arrow(x)$, 使 $arrow(b)$ 与 $arrow(p)$ 距离最近] \
以此定义 #hl(2)[$arrow(b)$ 在向量空间 $C (A)$ 上的*投影*为 $arrow(p)$] \
\(注意向量 $arrow(x)$ 为线性组合得到 $arrow(p)$ 的系数, 因此 #hl(2)[$arrow(x)$ 反映了 $arrow(b)$ 投影到 $C (A)$ 各个方向的分量])

显然误差向量 $arrow(e) = arrow(b) - arrow(p)$ 与向量空间 $C (A)$ 中的任意向量正交 \(直线 $B P$ 垂直于多维平面 $C (A)$)

根据#link(<sec:正交补>)[正交补]的概念可得, $arrow(e)$ 必定属于 $C (A)$ 的正交补 $N (A^T)$ \
根据左零空间 $N (A^T)$ 的性质可得 $arrow(e)$ 满足

$ A^T arrow(e) & = arrow(0)\
A^T (arrow(b) - A arrow(x)) & = arrow(0)\
A^T A arrow(x) & = A^T arrow(b)\
arrow(x) & = (A^T A)^(- 1) A^T arrow(b)\
arrow(p) & = A (A^T A)^(- 1) A^T arrow(b) $

其中

- $arrow(p) = A (A^T A)^(- 1) A^T arrow(b) = P arrow(b)$ 可计算向量 $arrow(b)$ 在列空间 $C (A)$ 上的投影
- $arrow(x) = (A^T A)^(- 1) A^T arrow(b)$ 可计算 $P arrow(b)$ 关于矩阵 $A$ 各列的分量 \
  \(实际上, 如果 $arrow(b)$ 在向量空间 $C (A)$ 中时, 仅需求解线性方程组 $A arrow(x) = arrow(b)$ 即可得到 $arrow(b)$ 相对 $C (A)$ 各列的分量 $arrow(x)$, 并不需要投影)

==== 一般投影矩阵 <sec:一般投影矩阵>
根据高维投影向量 $arrow(p)$ 的推导可得, 一般情况下的投影矩阵满足

$ P = A (A^T A)^(- 1) A^T $

对于一般投影矩阵可以得到以下性质

+ 由于 $A$ 不一定是可逆矩阵, 因此其中的 $(A^T A)^(- 1)$ 不能消去 \
  但当 $A$ 为可逆矩阵时, 有 $P = I$, 表明 $arrow(b)$ 在 $R^n$ 的投影即 $arrow(b)$ 自身

+ 投影矩阵 #hl(2)[$P$ 为对称矩阵]

+ 投影矩阵 #hl(2)[$P$ 满足 $P^2 = P$]

注意

- 矩阵 $A$ 的各列必须线性无关, 即矩阵应当列满秩 $m = r$
- 当 $A$ 为可逆矩阵时, 必定有 $P = I$ \(证明略)
- 当 $A$ 为不可逆矩阵, 则应取其中的主元列计算 $P$, 而不能直接使用公式

==== 投影矩阵的实际意义 <sec:投影矩阵的实际意义>
- 假设 #hl(2)[$arrow(b)$ 垂直于空间 $C (A)$] \($arrow(b)$ 与 $C (A)$ 中的每个向量正交), 因此 $arrow(b) in N (A^T)$, $A^T arrow(b) = arrow(0)$ \
  此时 $P arrow(b) = A (A^T A)^(- 1) A^T arrow(b) = A (A^T A)^(- 1) arrow(0) = arrow(0)$ \
  因此 #hl(2)[$P arrow(b) = arrow(0)$], $arrow(b)$ 在 $C (A)$ 中不存在任何分量

- 假设 #hl(2)[$arrow(b)$ 在空间 $C (A)$ 内] , 因此存在 $arrow(x)$ 满足 $A arrow(x) = arrow(b)$ \
  此时 $P arrow(b) = A (A^T A)^(- 1) A^T arrow(b) = A (A^T A)^(- 1) A^T A arrow(x) = arrow(b)$ \
  因此 #hl(2)[$P arrow(b) = arrow(b)$], $arrow(b)$ 的分量均来自 $A$

有上可得, 投影矩阵 $P$ 的本质为去除所有垂直于 $C (A)$ 的分量, 并保留平行于 $C (A)$ 的分量 \
由此也可知, 来自 $A$ 的投影矩阵的列空间 $C (P)$ 与 $A$ 的列空间 $C (A)$ 相同

#align(center)[#image("./src/projection.drawio.svg", width: 20%)]
由于误差向量满足 $arrow(e) = arrow(b) - arrow(p)$, 通过运算, 接受了所有投影到 $C (A)$ 过程中被剔除的向量 \
如图所示, 显然 $arrow(e)$ 也为一个投影, 是 $arrow(b)$ 在 $C (A)$ 的#link(<sec:正交补>)[正交补] $N (A^T)$ 上的投影 \
因此 $arrow(e) = P prime arrow(b) = (I - P) arrow(b)$ 中 #hl(2)[$P prime = (I - P)$ 是一个投影到空间 $N (A^T)$ 的投影矩阵] \
同样满足#link(<sec:一般投影矩阵>)[一般投影矩阵的性质] $(I - P)^2 = (I - P)$ 与 $(I - P)^T = (I - P)^T$

=== 最小二乘法与正规方程
==== 正规方程 <sec:正规方程>
对于线性方程组 $A arrow(x) = arrow(b)$, 其中 $A$ 为 $m times n$ 的矩阵

按行来看, 其表明了系统在条件 $a_(i 1) , a_(i 2) , dots.h , a_(i n)$ 下有测量值 $b_i$ \
向量 $arrow(x)$ 则为系统的参数 \
以线性系统为例, 对于自变量 $t$, 系统满足 $f (t) = x_2 t + x_1$ \
因此此时条件为 $a_(i 2) = t$, $a_(i 1) = 1$ \(条件之间可能有关或完全无关)

由于 $b_i$ 或 $A$ 存在误差, 一般无法通过直接求解方程得到 $arrow(x)$ \(假设测量大于未知参数, $m > n$) \
因此退而求其次, 寻找一个最优解 $arrow(hat(x))$ \
显然, 这个最有解 $A arrow(hat(x)) = arrow(p)$ 对于各个测量值 $arrow(b)$ 存在误差 $arrow(e) = arrow(b) - arrow(p)$ \
要求最优解能够使误差的平方和 $arrow(e)^2 = (arrow(b) - A arrow(hat(x)))^2$ 最小 \(也称为最小二乘)

按列来看, 各个同类的参数分别构成了 $A$ 的各列, 并生成 $R^m$ 下的子空间 $C (A)$ \
可以发现, 待求的 $arrow(p)$ 即 $arrow(b)$ 在 $C (A)$ #link(<sec:一般投影>)[投影]

因此

$ arrow(p) = A arrow(hat(x)) & = P arrow(b)\
A arrow(hat(x)) & = A (A^T A)^(- 1) A^T arrow(b)\
A^T A arrow(hat(x)) & = A^T arrow(b) $

由此也可得, 对于 $m > n$, 即方程数大于未知数的无解线性方程, 通过两侧乘上 $A^T$, 即可得到误差平方和最小的最优解 $arrow(hat(x))$ \
也将方程 $A^T A arrow(hat(x)) = A^T arrow(b)$ 称为*正规方程*

通过对 $f (arrow(x)) = (arrow(b) - A arrow(hat(x)))^2$ 分别对 $x_i$ 求偏导并令偏导为 $0$ 可得到相同的结果

#problem_box(
  title: [最小二乘直线拟合],
  problem: [
    测得 $f(1)=1$、$f(2)=2$、$f(3)=2$。若用直线 $hat(f)(t)=x_1+x_2 t$ 拟合数据，使用最小二乘法求 $x_1$ 与 $x_2$。
  ],
)[

由测量值构造超定方程组：

$ mat(delim: "[", 1, 1; 1, 2; 1, 3; #none) mat(delim: "[", x_1; x_2; #none) = mat(delim: "[", 1; 2; 2) $

显然方程无解, 设系数矩阵 $A$, 测量向量 $arrow(b)$, 使用最小二乘法求出最优解 $arrow(hat(x))$ 有

$ A^T mat(delim: "[", A #scale(x: 180%, y: 180%)[\|] arrow(b)) & = mat(delim: "[", 1, 1, 1; 1, 2, 3; #none) mat(delim: "[", 1, 1, #scale(x: 120%, y: 120%)[\|], 1; 1, 2, #scale(x: 120%, y: 120%)[\|], 2; 1, 3, #scale(x: 120%, y: 120%)[\|], 2; #none)\
 & = mat(delim: "[", 3, 6, #scale(x: 120%, y: 120%)[\|], 5; 6, 14, #scale(x: 120%, y: 120%)[\|], 11; #none)\
 & arrow.r arrow(hat(x)) = mat(delim: "[", 2 \/ 3; 1 \/ 2) $

因此拟合直线为 $hat(f)(t) = 2 / 3 + 1 / 2 t$。

]

=== 关于投影矩阵的补充说明
注意到, 无论是最小二乘法, 还是投影矩阵 $P$ 的导出中, 都要求方阵 $A^T A$ 为可逆矩阵

由#cross-link("/Linear_Algebra/ch2.typ", reference: <sec:矩阵与其转置之积的秩>)[矩阵与其转置之积的秩]可得, 为了满足此条件, #hl(2)[要求 $A$ 的各列线性无关], 仅有在此条件下 $A^T A$ 可逆, 存在投影矩阵 $P$

== 标准正交（Orthonormal）
=== 标准正交基
对于一系列属于 $R^m$ 空间的向量 ${ arrow(q) }$ 满足

$ cases(delim: "{", arrow(q)_i^T dot.op arrow(q)_j = 0 , & i eq.not j, arrow(q)_i^T dot.op arrow(q)_j = 1 , & i = j) $

第一行的条件表明, $arrow(q)_i$ 与组内的其他向量正交 \
第二行的条件表明, $arrow(q)_i$ 的长度为 $1$ \
则称 ${ arrow(q) }$ 为一组标准正交基

==== 标准正交矩阵 <sec:标准正交矩阵>
以标准正交基为列, 可得到一个 $m times n$ 的矩阵 $Q = mat(delim: "[", arrow(q)_1, arrow(q)_2, dots.h, arrow(q)_n)$

根据标准正交基的性质可得

$ Q^T Q = mat(delim: "[", arrow(q)_1^T; arrow(q)_2^T; dots.h; arrow(q)_n^T) mat(delim: "[", arrow(q)_1, arrow(q)_2, dots.h, arrow(q)_n) = I_(n times n) $

特别地, 当 $n = m$, $Q$ 为一个方阵, 此时称 $Q$ 为*标准正交矩阵*, 简称正交矩阵 \
可得, #hl(2)[标准正交矩阵有性质: 标准正交矩阵为可逆矩阵且 $Q^T = Q^(- 1)$]

==== 对标准正交基的投影
对于以标准正交基为列的 $m times n$ 矩阵 $Q$ \(注意 $Q$ 可能是长方形矩阵, 不存在 $Q^(- 1)$, 且没有性质 $Q Q^T = I$), 其有投影矩阵

$ P = Q (Q^T Q)^(- 1) Q^T = Q (I)^(- 1) Q^T = Q Q^T $

而在正规方程中

$ Q^T Q arrow(x) & = Q^T arrow(b)\
arrow(x) & = Q^T arrow(b) $

因此#hl(2)[仅需计算 $Q^T arrow(b)$, 即可得到 $arrow(b)$ 在标准正交基 ${ arrow(q) }$ 上的分量 $arrow(x)$]

=== Gram-Schmidt 正交化 <sec:Gram-Schmidt正交化>
现有矩阵 $A = mat(delim: "[", arrow(a)_1, arrow(a)_2, dots.h, arrow(a)_n)$, 通过 Gram-Schmidt 正交化, 可得到一组标准正交基组成的矩阵 $Q = mat(delim: "[", arrow(q)_1, arrow(q)_2, dots.h, arrow(q)_n)$ \
同时两个矩阵 $C (A) = C (Q)$ 具有相同的列空间

假定 $A$ 列满秩, 其各列 $arrow(a)_i$ 即子空间 $C (A)$ 的一组基

==== 正交化过程
首先对向量集 ${ arrow(a) }$ 进行逐个正交化, 得到相互正交且标准的向量集 ${ arrow(h) }$, 然后将 ${ arrow(h) }$ 标准化, 得到待求的标准正交基 ${ arrow(q) }$

- 为了保证 $arrow(h)_i$ 与其余向量正交, 可以令 $arrow(h)_i$ 与 $arrow(h)_1 , dots.h , arrow(h)_(i - 1)$ 正交
- 为了保证 $C (A) = C (H)$, 可以令 $arrow(h)_i$ 来自 $arrow(a)_1 , dots.h , arrow(a)_i$ 的线性组合, 注意该条件也等价于 $arrow(h)_i$ 来自 $arrow(q)_1 , dots.h , arrow(q)_(i - 1)$ 与 $arrow(a)_i$ 的线性组合

对于取出的第一个向量 $arrow(a)_1$ \
由于此时 ${ arrow(h) }$ 中没有其他向量, 因此 $arrow(h)_1 = arrow(a)_1$

对于取出的第二个向量 $arrow(a)_2$ \
根据#link(<sec:向量投影>)[向量投影的特点]可以发现, 在获取误差向量 $arrow(e)$ 的过程中, 误差向量 $arrow(e)$ 即满足 $arrow(h)_2$ 的两个要求 \(首先计算 $arrow(h)_1^T arrow(a)_2$ 得到一个数, 使矢量相乘变为数乘, 从而交换向量 $arrow(h)$ 到右侧)

$ arrow(h)_2 = arrow(e) = arrow(a)_2 - frac(arrow(h)_1 arrow(h)_1^T, arrow(h)_1^T arrow(h)_1) arrow(a)_2 = arrow(a)_2 - frac(arrow(h)_1^T arrow(a)_2, arrow(h)_1^T arrow(h)_1) arrow(h)_1 $

对于取出的第 $k$ 个向量 $arrow(a)_k$ \
根据#link(<sec:投影矩阵的实际意义>)[一般投影的特点]可以发现, 在获取误差向量 $arrow(e)$ 的过程中, 误差向量满足 $arrow(e)$ 即满足 $arrow(h)_i$ 的两个要求 \
令 $H = mat(delim: "[", arrow(h)_1, arrow(h)_2, dots.h, arrow(h)_(k - 1))$, 根据 $arrow(h)$ 的正交性, $H^T H$ 将得到一个对角矩阵, 根据#cross-link("/Linear_Algebra/ch1.typ", reference: <sec:对角矩阵>)[对角矩阵]与#cross-link("/Linear_Algebra/ch1.typ", reference: <sec:叠加法>)[矩阵乘法中的叠加法]可得

$ arrow(h)_k = arrow(e) & = arrow(a)_k - H (H^T H)^(- 1) H^T arrow(a)_k\
 & = arrow(a)_k - sum_(i = 1)^(k - 1) frac(arrow(h)_i^T arrow(a)_k, arrow(h)_i^T arrow(h)_i) arrow(h)_i $

最后将计算得到的 ${ arrow(h) }$ 标准化, 即对每个 $arrow(h)_k$ 有

$ arrow(q)_k = arrow(h) / sqrt(arrow(h)_k^T arrow(h)_k) $

#problem_box(
  title: [Gram–Schmidt 正交化],
  problem: [
    给定 $A = mat(delim: "[", 1, 2, 1; 1, 1, 2; 2, 1, 1)$。对其列向量做 Gram–Schmidt 正交化，求列空间 $C(A)$ 的一组标准正交基，并写出矩阵 $Q$。
  ],
)[

对于第一列向量有 $arrow(h)_1 = arrow(a)_1$

对于第二列向量 $arrow(a)_2$ 有

$ arrow(h)_2 & = arrow(a)_2 - frac(arrow(h)_1^T arrow(a)_2, arrow(h)_1^T arrow(h)_1) arrow(h)_1\
 & = mat(delim: "[", 2; 1; 1) - 5 / 6 mat(delim: "[", 1; 1; 2)\
 & = 1 / 6 mat(delim: "[", 7; 1; - 4) $

对于第三列向量 $arrow(a)_3$ 有 \(注意到 $arrow(h)_2$ 的提出数乘部分对结果没有影响)

$ arrow(h)_3 & = arrow(a)_3 - frac(arrow(h)_1^T arrow(a)_3, arrow(h)_1^T arrow(h)_1) arrow(h)_1 - frac(arrow(h)_2^T arrow(a)_3, arrow(h)_2^T arrow(h)_2) arrow(h)_2\
 & = mat(delim: "[", 1; 2; 1) - 5 / 6 mat(delim: "[", 1; 1; 2) - dot.op 5 / 66 mat(delim: "[", 7; 1; - 4)\
 & = 4 / 11 mat(delim: "[", - 1; 3; - 1) $

因此经标准化后, 有由正交基组成的矩阵 $Q$ 满足

$ Q = mat(delim: "[", 1 / sqrt(6), 7 / sqrt(66), frac(- 1, sqrt(11)); 1 / sqrt(6), 1 / sqrt(66), 3 / sqrt(11); 2 / sqrt(6), frac(- 4, sqrt(66)), frac(- 1, sqrt(11))) $

]

==== QR 分解
类似 $L U$ 分解, 使用矩阵的方式描述 Gram-Schmidt 正交化可得, 正交化的本质即将原矩阵 $A$ 分解为一个标准正交基组成的矩阵 $Q$ \(注意 $A$ 不一定是方阵) 与一个变形矩阵 $R$ \
因此也称为 $Q R$ 分解, 有

$ A = Q R $

根据 Gram-Schmidt 正交化的公式可知, 简单变形后也可视为 $arrow(a)_k$ 来自 $arrow(h)_1 dots.h arrow(h)_k$ 的线性组合, 将系数提取即可组成矩阵 $R$ 的各列 \
因此对于 $m times n$ 的矩阵 $A$, #hl(2)[$R$ 为一个 $n times n$ 的上三角矩阵]满足

$ R = mat(delim: "[", lr(|arrow(h)_1|), arrow(q)_1^T arrow(a)_2, arrow(q)_1^T arrow(a)_3, dots.h, arrow(q)_1^T arrow(a)_n; 0, lr(|arrow(h)_2|), arrow(q)_2^T arrow(a)_3, dots.h, arrow(q)_2^T arrow(a)_n; 0, 0, lr(|arrow(h)_3|), dots.h, arrow(q)_3^T arrow(a)_n; dots.v, , , , dots.v; 0, 0, 0, lr(|arrow(h)_(n - 1)|), arrow(q)_(n - 1)^T arrow(a)_n; 0, 0, 0, 0, lr(|arrow(h)_n|)) $

除此之外, 根据#link(<sec:标准正交矩阵>)[以标准正交基构成的矩阵]的特点可得

$ Q^T A = Q^T Q R = R $
