// 线性代数笔记 · Shiroa / Typst
// 需要 /book.typ 与 /utility/include.typ。
#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "特征值")
#import "/utility/include.typ": *
#set math.mat(delim: "[")
#set math.vec(delim: "[")

= 特征值
#quote(block: true)[
参考教程 #link("https://www.bilibili.com/video/BV1zx411g7gq")[麻省理工公开课 线性代数] P21\~P25
]

== 特征值基础
=== 特征值与特征向量的定义 <sec:特征值与特征向量的定义>
特征值依然以方阵为讨论对象 \
对于一个 $n times n$ 的矩阵 $A$, 存在#hl(2)[某些方向的向量 $arrow(x)$] 在右乘 $A$ 后, 得到的结果仍然平行于 $arrow(x)$, 将具有这种特性的向量称为特征向量 $arrow(x)$, 而称相乘结果 $A arrow(x)$ 与原向量 $arrow(x)$ 之比 $lambda$ 为特征值, 有

$ A arrow(x) = lambda arrow(x) $

对于一个矩阵 $A$ 的特征向量 $arrow(x)$, 与其同一方向上所有向量均能作为特征向量, 一般仅使用其中一个非零向量代表这个方向

=== 特征值与特征向量的计算
在特征值与特征向量的定义式中, 存在着两个未知变量, 为此需要进行如下变形

$ A arrow(x) & = lambda arrow(x)\
(A - lambda I) arrow(x) & = arrow(0) $

此时, 仅当矩阵 $A - lambda I$ 为不可逆矩阵, 方程 $(A - lambda I) arrow(x) = arrow(0)$ 才会存在非零解 \
而要当矩阵 $A - lambda I$ 为不可逆矩阵时, 根据#cross-link("/Linear_Algebra/ch5.typ", reference: <sec:推论五>)[行列式的性质], 有

$ det (A - lambda I) = 0 $

上式可展开为一个关于 $lambda$ 的 $n$ 次方程, 称为*特征方程*, 因此#hl(2)[对于一个 $n times n$ 方阵, 其共有 $n$ 个特征值] \
并且其中可能存在多重根与复根, 因此也存在多重特征值与复数特征值的情况

得到特征值后可得, 对于任意一个特征值 $lambda$, 其有特征向量 $arrow(x)$ 有无数多个, 并且这些特征值均来自矩阵 $A - lambda I$ 的零空间 \
通常在计算出特征值后, 选择 $N (A - lambda I)$ 的一组基作为该特征的特定特征向量 \
注意, $N (A - lambda I)$ 的维数与 $lambda$ 的重数无关, 因此#hl(2)[有 $n$ 个特征值不代表有 $n$ 个不平行的特征向量 $arrow(x)$]

=== 特征值的特性 <sec:特征值的特性>
- 将方阵 $A$ 对角线上的元素之和称为*迹* $t r (A)$
  - 矩阵 $A$ 的迹等于其特征值之和, 可用该性质寻找最后一个特征值
  - 矩阵的迹的相反数等于其特征方程中的一次项系数
- 对于方阵 $A$ 的行列式
  - 矩阵 $A$ 的行列式等于其特征值之积
  - 矩阵的行列式也等于其特征方程中的常数项
- 对于矩阵 $A$ 有特征值 $lambda$, 则矩阵数乘 $k A$ 有特征值 $k lambda$
- 对于矩阵 $A$ 有特征值 $lambda$, 则矩阵与单位矩阵运算 $A + k I$ 有特征值 $lambda + k$, 且对应特征值的特征向量相同, 证明如下 \(注意对于任意两个矩阵 $A , B$, 其和与积的特征值不存在特殊性质)

$ (A + k I) arrow(x) = lambda arrow(x) + k arrow(x) = (lambda + k) arrow(x) $

- 矩阵 $A$ 以及其转置 $A^T$ 具有相同的特征值, 该性质由行列式的#cross-link("/Linear_Algebra/ch5.typ", reference: <sec:推论七>)[推论七]可得到
- 矩阵 $A$ 的逆 $A^(- 1)$ 的特征值为矩阵 $A$ 特征值 $lambda_i$ 的倒数 $1 / lambda_i$
- 对于矩阵 $A , B$, 其乘积 $A B$ 与 $B A$ 具有相同的特征值, 证明有 $(A B) arrow(x) = lambda arrow(x) arrow.r (B A) (B arrow(x)) = lambda (B arrow(x))$, 更多关于矩阵相乘与特征值的关系间#link("https://www.cnblogs.com/difdayddd/articles/17862060.html")[参考资料]

=== 特殊矩阵的特征值
==== 投影矩阵
对于投影矩阵 $P$, 根据#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:投影矩阵的实际意义>)[投影矩阵的性质]

- 对于 $arrow(x) in C (P)$, 此时有 $P arrow(x) = arrow(x)$, 因此认为投影矩阵列空间 $C (P)$ 中的任意向量均为 $P$ 的特征向量, 且有特征值 $lambda = 1$
- 对于 $arrow(x) tack.t C (P)$ \(与 $C (P)$ 中的所有向量正交), 此时有 $P arrow(x) = arrow(0)$, 即类似不可逆矩阵 $S$ 的情况, 对于这些向量 $arrow(x) in N (P)$, 也是 $P$ 的特征向量, 有特征值 $lambda = 0$
- 因此投影矩阵仅有特征值 $1$ 与 $0$

==== 标准正交矩阵
注意到对于任意向量 $arrow(x)$ 与标准正交矩阵 $Q$

$ mat(delim: bar.double, Q arrow(x)) = sum_(i = 1)^n lr(|x_i|) mat(delim: bar.double, arrow(q)_i) = mat(delim: bar.double, arrow(x)) $

因此标准正交矩阵不会改变向量的长度, 在求特征值时有 $mat(delim: bar.double, Q arrow(x)) = lr(|lambda|) mat(delim: bar.double, arrow(x)) arrow.r mat(delim: bar.double, lambda) = 1$

正交矩阵的特征值 $lambda$ 也可能为复数, 但绝对值必定为 $1$

==== 对称矩阵
对于对称矩阵, 其特征值全为实数, 且不同特征值的特征向量相互垂直

#problem_box(
  title: [对称矩阵的特征值与特征向量],
  problem: [
    求实对称矩阵 $S = mat(delim: "[", 3, 1; 1, 3)$ 的特征值及对应的特征向量。
  ],
)[

令特征方程的行列式为零：

$ mat(delim: bar.double, 3 - lambda, 1; 1, 3 - lambda) & = 0\
(3 - lambda)^2 - 1 & = 0\
lambda^2 - 6 lambda + 8 & = 0 $

解得其有特征值

- $lambda_1 = 2$, 对应特征向量 $arrow(x)_1 = mat(delim: "[", 1, - 1)^T$
- $lambda_2 = 4$, 对应特征向量 $arrow(x)_2 = mat(delim: "[", 1, 1)^T$

]

==== 反对称矩阵
对于反对称矩阵 \($A = - A^T$), 其特征值全为纯虚数

#problem_box(
  title: [反对称矩阵的复特征值],
  problem: [
    求反对称矩阵 $A = mat(delim: "[", 0, -1; 1, 0)$ 的特征值（该矩阵也表示平面旋转 $90^circle.stroked.tiny$）。
  ],
)[

写出特征方程：

$ mat(delim: bar.double, - lambda, - 1; 1, - lambda) & = 0\
lambda^2 + 1 & = 0\
lambda & = plus.minus i $

]

一般实矩阵的特征值可以是实数，也可以是共轭复数对；仅凭矩阵“接近对称”不能直接判断实特征值的数量。

==== 上三角矩阵 <sec:上三角矩阵>
对于上三角矩阵, 其对角线上的值即其特征值 \(根据#cross-link("/Linear_Algebra/ch5.typ", reference: <sec:推论四>)[行列式的性质]易得)

#problem_box(
  title: [重特征值与不可对角化矩阵],
  problem: [
    求上三角矩阵 $U = mat(delim: "[", 3, 1; 0, 3)$ 的特征值及特征空间维数，并判断其能否对角化。
  ],
)[

根据上三角矩阵的性质计算：

$ mat(delim: bar.double, 3 - lambda, 1; 0, 3 - lambda) & = 0\
(3 - lambda)^2 & = 0\
lambda & = 3 $

解得该矩阵有特征根 $lambda = 3$, 且为二重特征根 \
此外, 对于 $U - 3 I = mat(delim: "[", 0, 1; 0, 0)$, 该矩阵的零空间维数 $d i m [N (U - 3 I)] = 2 - r = 1$, 因此零空间为一维 \
这表明该矩阵仅有一个方向的特征向量 $arrow(x) = mat(delim: "[", 1, 0)^T$

由于重根 $3$ 对应的特征空间只有一维，因此该二阶矩阵无法对角化。

]

== 对角化
=== 对角化分解
对于一个 $n times n$ 的矩阵 $A$, 将其任意 $n$ 个特征向量 $arrow(x)_k$ 组成特征矩阵 $S$ \
根据#link(<sec:特征值与特征向量的定义>)[特征值与特征向量的定义], 矩阵 $A$ 与其特征矩阵 $S$ 相乘时有

$ A S & = A mat(delim: "[", arrow(x)_1, arrow(x)_2, dots.h, arrow(x)_n)\
 & = mat(delim: "[", lambda_1 arrow(x)_1, lambda_2 arrow(x)_2, dots.h, lambda_n arrow(x)_n)\
 & = mat(delim: "[", arrow(x)_1, arrow(x)_2, dots.h, arrow(x)_n) mat(delim: "[", lambda_1, 0, 0, 0; 0, lambda_2, 0, 0; dots.v, , , dots.v; 0, 0, 0, lambda_n)\
 & = S Lambda $

其中矩阵 $Lambda$ 为一个以 $A$ 的特征值组成的对角矩阵

当这 $n$ 个特征向量#hl(2)[不平行且非 $0$] 时, 矩阵 $S$ 可逆, 因此有对角化分解

$ A = S Lambda S^(- 1) $

=== 对角化矩阵的条件 <sec:对角化矩阵的条件>
易得, 当一个矩阵具有 $n$ 个不同的特征值 $lambda$ 时, 各个特征值都将对应一个方向的特征向量, 且这些特征向量互相平行, 因此该矩阵能够对角化

但是当一个矩阵的特征值中有重根时, 其重根不一定对应与根的重数相同的, 互不平行的特征向量, 因此有可能无法对角化, 如#link(<sec:上三角矩阵>)[前文的例子] \(注意没有重根仅是可对角化的充分条件, 存在重根时仍有可能可以对角化)

但在一般情况下, 对于绝大部分的矩阵均能对角化, 对于不可对角化的矩阵可参见#cross-link("/Linear_Algebra/ch7.typ", reference: <sec:若尔当定理>)[若尔当定理]

=== 矩阵的幂
当矩阵满足对角化条件并对角化后, 对于矩阵的 $k$ 次幂有

$ A^k = S Lambda^k S^(- 1) $

根据#cross-link("/Linear_Algebra/ch1.typ", reference: <sec:对角矩阵>)[对角矩阵]的特性, 对于矩阵的任意次幂, 其特征向量不变, 特征值变为原矩阵的 $k$ 次 $lambda prime = lambda^k$

当矩阵所有特征值满足 $mat(delim: bar.double, lambda) < 1$, 有 $lim_(k arrow.r oo) A^k = 0$

== 状态方程
=== 离散差分状态方程 <sec:离散差分状态方程>
对于一个具有 $n$ 个参数的线性系统, 可以使用一个向量 $arrow(u)$ 表示这些参数, 并以此体现系统的状态 \
系统中相邻的两个时刻的状态之间满足线性方程组 $arrow(u)_(i + 1) = A arrow(u)_i$

因此对于初态为 $arrow(u)_0$ 的系统在第 $k$ 个时刻下, 系统的状态为 $arrow(u)_k = A^k arrow(u)_0$

通过求解 $arrow(u)_0 = S arrow(c)$ 可得到向量 $arrow(u)_0$ 关于特征矩阵各列的分量 $arrow(c)$, 此时

$ arrow(u)_k = A^k arrow(u)_0 = S Lambda^k S S^(- 1) arrow(c) = S Lambda^k arrow(c) = sum_(i = 1)^n arrow(x)_i lambda_i^k c_i $

对于 $arrow(u)_k$ 的第 $j$ 个分量 ${ arrow(u)_k }_j$ 有 \($a_(j i)$ 为待定系数, 可通过代回状态方程或投影具体求解)

$ { arrow(u)_k }_j = sum_(i = 1)^n a_(j i) lambda_i^k $

当 $k arrow.r oo$ 时

- 对于 $mat(delim: bar.double, lambda_i) < 1$, $arrow(u)_k$ 中在 $arrow(x)_i$ 方向上的分量将逐渐趋近于 $0$, 而对结果没有影响

- 对于 $lambda_i = 1$, $arrow(u)_k$ 中在 $arrow(x)_i$ 方向上的分量始终不变

- 对于 $lambda_i = e^(i 2 pi \/ n)$, $arrow(u)_k$ 中在 $arrow(x)_i$ 方向上的分量可能 $n$ 为周期变化, 当所有特征值都满足这一特点时, 存在特定次幂 $k$ 使 $A^k = I$

- 当所有特征量 $mat(delim: bar.double, lambda_i) < 1$, $arrow(u)_k$ 将逐渐趋于 $0$, 系统趋于稳定 \
  反之, 当存在 $mat(delim: bar.double, lambda_i) > 1$, 系统的参数将逐渐发散

- 当 $lambda_i$ 为特征值中的最大值, 且 $mat(delim: bar.double, lambda_i) > 1$, 则认为 $k$ 时刻下系统的参数 $arrow(u)_k approx arrow(x)_i lambda_i^k c_i$

==== 差分方程求解示例 <sec:差分方程求解示例>
#problem_box(
  title: [斐波那契数列的通项公式],
  problem: [
    斐波那契数列满足 $f_0=0$、$f_1=1$ 及 $f_(k+2)=f_(k+1)+f_k$。使用矩阵特征值与特征向量求其通项公式 $f_k$。
  ],
)[

为将递推关系写成状态方程，令参数向量 $arrow(u) = mat(delim: "[", f_(k + 1), f_k)^T$ \
同时补充方程 $f_(k + 1) = f_(k + 1)$, 使参数与方程数相当 \
此时有状态方程

$ {f_(k + 2) = f_(k + 1) + f_k\
f_(k + 1) = f_(k + 1) arrow.r arrow(u)_(k + 1) = mat(delim: "[", 1, 1; 1, 0) arrow(u)_k $

对于状态方程中的矩阵 $A = mat(delim: "[", 1, 1; 1, 0)$, 求该矩阵的特征值

$ mat(delim: bar.double, 1 - lambda, 1; 1, - lambda) & = 0\
lambda^2 - lambda - 1 & = 0 $

解得

$ lambda_1 = frac(1 + sqrt(5), 2) approx 1.618 quad lambda_2 = frac(1 - sqrt(5), 2) approx - 0.618 $

其中 $mat(delim: bar.double, lambda_1) > 1$, $mat(delim: bar.double, lambda_2) < 1$, 因此当 $k$ 足够大时, $f_k approx C dot.op 1.618^k$

通过具体求解可得两个特征值分别对应特征向量

$ arrow(x)_1 = mat(delim: "[", frac(1 + sqrt(5), 2); 1) quad arrow(x)_2 = mat(delim: "[", frac(1 - sqrt(5), 2); 1) $

通过 $S arrow(c) = arrow(u)_0$ 求解分量 $arrow(c)$ 可得, 对于两个特征向量, 有线性组合

$ arrow(u)_0 = 1 / sqrt(5) arrow(x)_1 - 1 / sqrt(5) arrow(x)_2 $

最终解得数列的通项公式为

$ f_k = 1 / sqrt(5) (frac(1 + sqrt(5), 2))^k - 1 / sqrt(5) (frac(1 - sqrt(5), 2))^k $

]

=== 连续微分状态方程 <sec:连续微分状态方程>
同样以向量 $arrow(u)$ 表示系统特定状态下的一组参数 \
此时系统关于时间连续, 系统各个参数的变化量满足线性微分方程组

$ frac(upright(d) arrow(u), upright(d) t) = A arrow(u) $

注意, 此时 $arrow(u)$ 是一个关于时间 $t$ 的函数, 且通常有确定的初态 $arrow(u) (0)$ \
将 $arrow(u) (t)$ 投影到特征矩阵 $S$ 上, 得到投影分量 $arrow(v) (t)$, 令 $arrow(u) (t) = S arrow(v)$, 此时方程有

$ frac(upright(d) arrow(u), upright(d) t) & = A arrow(u)\
S frac(upright(d) arrow(v), upright(d) t) & = S Lambda S^(- 1) S arrow(v) (t)\
frac(upright(d) arrow(v), upright(d) t) & = Lambda arrow(v) (t) $

通过变形后, 方程各个变量被解耦为 $n$ 个仅与 $v_i (t)$ 有关的一阶微分方程 $frac(upright(d) v_i, upright(d) t) = lambda_i v_i (t)$ \
对于这类微分方程解的一般形式即 $v_i (t) = C_i e^(lambda_i t)$ \
因此方程的解为

$ arrow(u) (t) = S arrow(v) (t) = sum_(i = 1)^n C_i arrow(x)_i e^(lambda_i t) $

当 $t arrow.r oo$ 时, 认为系统达到稳态

- 对于 $R e [lambda_i] < 0$, 分量 $mat(delim: bar.double, e^(lambda_i t)) = mat(delim: bar.double, e^(- a_i t)) mat(delim: bar.double, e^(i b t)) = mat(delim: bar.double, e^(- a_i t)) dot.op 1 arrow.r 0$ \
  该分量的效果会随时间不断减弱, 并在稳态消失

- 对于 $lambda_i = 0$, 其在 $arrow(u)$ 中为一个不随时间变化的常数项

- 对于 $R e [lambda] > 0$, 相反此分量将 $mat(delim: bar.double, e^(lambda_i t)) arrow.r oo$ \

- 因此#hl(2)[仅当矩阵的任意特征值满足 $R e [lambda_i] < 0$ 或 $lambda_i = 0$], 系统才能收敛于一个有限的状态, 即#hl(2)[系统稳定]的条件

#problem_box(
  title: [二维线性微分方程组],
  problem: [
    给定初态 $arrow(u)(0)=mat(delim: "[", 1; 0)$，求微分方程组 $frac(upright(d) arrow(u), upright(d)t) = mat(delim: "[", -1, 2; 1, -2) arrow(u)$ 的解 $arrow(u)(t)$，并分析其稳态。
  ],
)[

首先计算状态矩阵 $A = mat(delim: "[", -1, 2; 1, -2)$ 的特征值：

$ mat(delim: bar.double, - 1 - lambda, 2; 1, - 2 - lambda) & = 0\
lambda^2 + 3 lambda & = 0 $

解得

$ lambda_1 = 0 quad lambda_2 = - 3 $

其中 $lambda_1 = 0$, $lambda_2 < 0$, 因此当 $t$ 足够大时, $lambda_2$ 的影响将逐渐消失, 系统将趋近于稳态 $C_1 arrow(x)_1$

通过具体求解可得两个特征值分别对应特征向量与解的形式

$  & arrow(x)_1 = mat(delim: "[", 2; 1) quad arrow(x)_2 = mat(delim: "[", 1; - 1)\
 & arrow(u) (t) = C_1 mat(delim: "[", 2; 1) + C_2 e^(- 3 t) mat(delim: "[", 1; - 1) $

通过初态条有

$ C_1 mat(delim: "[", 2; 1) + C_2 mat(delim: "[", 1; - 1) = mat(delim: "[", 2, 1; 1, - 1) mat(delim: "[", C_1; C_2) = mat(delim: "[", 1; 0) = arrow(u) (0) $

解出待定常数 $C_1 , C_2$ 可得

$ arrow(u) (t) = 1 / 3 mat(delim: "[", 2; 1) + 1 / 3 e^(- 3 t) mat(delim: "[", 1; - 1) $

]

==== 高阶微分量的处理
类似#link(<sec:差分方程求解示例>)[差分方程中的处理]

当连续微分状态方程中出现了高阶微分量如 $u_1^((m)) = frac(upright(d)^m u_1, upright(d) t^m)$ \
可将阶数低于 $m$ 的微分量视为独立的参数, 并补充方程 $frac(upright(d), upright(d) t) [u_1^((i))] = u_1^((i + 1))$

例如常系数微分方程 $y prime.triple + a y prime.double + b y prime.double + c y = 0$ 有最高阶微分量 $y prime.triple$, 因此将剩余参数与微分量视为独立的参数 $u_3 = y #h(0em) u_2 = y prime ; u_1 = y prime.double$ \
此时有状态方程

$ frac(upright(d) arrow(u), upright(d) t) = mat(delim: "[", y prime.triple; y prime.double; y prime) = mat(delim: "[", - a, - b, - c; 1, 0, 0; 0, 1, 0) mat(delim: "[", y prime.double; y prime; y) $

对于多个参数的处理方式相同

==== 系统稳定判据
对于二参数的系统, 有系数矩阵 $A = mat(delim: "[", a, b; c, d)$ \
根据#link(<sec:连续微分状态方程>)[稳定性]的要求有 $R e [lambda_1] , R e [lambda_2] < 0$

由#link(<sec:特征值的特性>)[特征值的特性]可得, 此时

$ {t r (A) = lambda_1 + lambda_2 < 0\
det (A) = lambda_1 lambda_2 > 0 arrow.r {t r (A) = a + d < 0\
det (A) = a d - c b > 0 $

=== 矩阵指数
为了求解#link(<sec:连续微分状态方程>)[连续微分状态方程], 还有另一思路, 即直接计算矩阵指数 $e^(A t)$

首先将 $e^(A t)$ 以泰勒级数的方式展开有 \(注意, #hl(2)[$t$ 为一个标量])

$ e^(A t) & = lim_(j arrow.r oo) sum_(i = 0)^j frac((A t)^i, i !)\
 & = lim_(j arrow.r oo) sum_(i = 0)^j frac(S Lambda^i S^(- 1) t^i, i !)\
 & = lim_(j arrow.r oo) S #scale(x: 180%, y: 180%)[\(] sum_(i = 0)^j frac(Lambda^i t^i, i !) #scale(x: 180%, y: 180%)[\)] S^(- 1)\
 & = S e^(Lambda t) S^(- 1) $

其中根据#cross-link("/Linear_Algebra/ch1.typ", reference: <sec:对角矩阵>)[对角矩阵]的特性, $e^(Lambda t)$ 满足

$ S e^(Lambda t) S^(- 1) & = lim_(j arrow.r oo) S mat(delim: "[", sum_(i = 0)^j frac((lambda_1 t)^i, i !), 0, dots.h, 0; 0, dots.down, , 0; dots.v, , dots.down, dots.v; 0, 0, dots.h, sum_(i = 0)^j frac((lambda_n t)^i, i !)) S^(- 1)\
 & = lim_(j arrow.r oo) S mat(delim: "[", e^(lambda_1 t), 0, dots.h, 0; 0, dots.down, , 0; dots.v, , dots.down, dots.v; 0, 0, dots.h, e^(lambda_n t)) S^(- 1) $

因此连续微分状态方程 $frac(upright(d) arrow(u), upright(d) t) = A arrow(u)$ 的解 $arrow(u) (t)$ 满足 \(使用#link(<sec:连续微分状态方程>)[此处的推导]也能得到同样的结果)

$ arrow(u) (t) = e^(A t) arrow(u) (0) = S e^(Lambda t) S^(- 1) arrow(u) (t) $

但是注意, 结论 $e^(A t) = S e^(Lambda t) S^(- 1)$ 仅在 $A$ 满足#link(<sec:对角化矩阵的条件>)[对角化的条件]下成立

=== 马尔可夫矩阵
马尔科夫矩阵是#link(<sec:离散差分状态方程>)[离散差分状态方程]中一类特殊的系数矩阵

定义当 $n times n$ 的方阵 $A$ 满足以下条件时, 称之为马尔可夫矩阵

- 矩阵的各列元素之和等于 $1$
- 矩阵的各个元素大于等于 $0$

马尔可夫矩阵的特征值将具有以下特性

+ 马尔可夫矩阵的任意特征值满足 $mat(delim: bar.double, lambda_i) lt.eq 1$
+ 马尔可夫矩阵存在至少一个特征值满足 $lambda_k = 1$ \
+ 马尔科夫矩阵的任意次幂依然是马尔科夫矩阵

由马尔可夫矩阵的特性与离散差分状态方程稳态与 $lambda$ 的关系可得, 当系统的系数矩阵为马尔科夫矩阵时, 如果除 $lambda=1$ 外的全部特征值均满足 $mat(delim: bar.double, lambda_i) < 1$，当 $k$ 足够大时，系统会趋于由特征值 $1$ 对应特征向量决定的稳态。马尔可夫矩阵保证状态参数之和始终不变，但周期性系统未必收敛。

现就特性二给出证明 \
由于矩阵各列元素之和为 $1$, 因此矩阵 $A - I$ 的各列元素之和为 $0$ \
这表明矩阵行向量之和为零, 即左零空间 $N [(A - I)^T]$ 中存在向量 $mat(delim: "[", 1, 1, dots.h, 1)$ \
因此矩阵的秩 $r < n$, 不可逆, 有 $det (A - I) = 0$

#problem_box(
  title: [双城市人口迁移模型],
  problem: [
    两座城市的总人口为 $1000$，初始人口分别为 $u_A(0)=0$、$u_B(0)=1000$。每年 $A$ 城有 $90 %$ 留在本城、$10 %$ 迁往 $B$ 城；$B$ 城有 $80 %$ 留在本城、$20 %$ 迁往 $A$ 城。建立马尔可夫状态方程并求第 $k$ 年两城的人口。
  ],
)[

根据每年的迁移比例建立离散状态方程：

$ mat(delim: "[", u_A; u_B)_(k + 1) = mat(delim: "[", 0.9, 0.2; 0.1, 0.8) mat(delim: "[", u_A; u_B)_k $

求解状态递推式可得

$ mat(delim: "[", u_A; u_B)_k = 1000 / 3 mat(delim: "[", 2; 1) + 2000 / 3 (0.7)^k mat(delim: "[", - 1; 1) $

]

