// 线性代数笔记 · Shiroa / Typst
// 需要 /book.typ 与 /utility/include.typ。
#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "正定性")
#import "/utility/include.typ": *
#set math.mat(delim: "[")
#set math.vec(delim: "[")

= 正定性
#quote(block: true)[
参考教程 #link("https://www.bilibili.com/video/BV1zx411g7gq")[麻省理工公开课 线性代数] P26\~P30, P34
]

== 对称矩阵的特性
=== 对称矩阵的特征值与特征向量 <sec:对称矩阵的特征值与特征向量>
对于一个#hl(2)[实对称矩阵], 其特征值与特征向量具有如下特征

- 实对称矩阵的全部特征值均为实数 \
  反之不成立：实矩阵即使全部特征值为实数，也未必对称。例如 $mat(delim: "[", 1, 1; 0, 2)$ 的特征值全为实数，但不是对称矩阵。

- 实对称矩阵必定能找到一组特征向量, 这组特征向量相互垂直 \(注意特征向量可以取任意长度, 只是一般取单位长度), 且能组成一个#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:标准正交矩阵>)[标准正交矩阵] \
  更一般地，满足 $A A^T = A^T A$ 的实正规矩阵可在复数域酉对角化；但只有实对称矩阵才能保证存在由实特征向量组成的正交特征向量基。

因此, 根据标准正交矩阵的特性 $Q^(- 1) = Q^T$ , 对角化实对称矩阵 $A$ 时有 \(以标准正交矩阵 $Q$ 表示其特征矩阵)

$ A = Q Lambda Q^T $

=== 特性的证明 <sec:特性的证明>
现证明实对称矩阵的全部特征值均为实数

使用标记 $A^(‾)$, 表示 $A$ 的共轭矩阵, 即将 $A$ 的所有元素取共轭复数 \
显然有

$ A arrow(x) = lambda arrow(x) arrow.r A^(‾) arrow(x)^(‾) = lambda^(‾) arrow(x)^(‾) $

将共轭的等式取转置有

$ arrow(x)^(‾)^T A^(‾)^T = lambda^(‾) arrow(x)^(‾)^T $

对于原式, 两侧左乘 $arrow(x)^(‾)^T$ 有 $arrow(x)^(‾)^T A arrow(x) = lambda arrow(x)^(‾)^T arrow(x)$ \
对于共轭转置式, 两侧右乘 $arrow(x)$ 有 $arrow(x)^(‾)^T A^(‾)^T arrow(x) = lambda^(‾) arrow(x)^(‾)^T arrow(x)$

对于实对称矩阵, 显然有 $A = A^(‾)^T$, 因此

$ lambda arrow(x)^(‾)^T arrow(x) & = lambda^(‾) arrow(x)^(‾)^T arrow(x)\
lambda & = lambda^(‾) $

==== 关于证明的补充说明
- 证明中出现的 $arrow(x)^(‾)^T arrow(x)$ 部分, 当 $arrow(x) eq.not arrow(0)$ 时, 结果必定为正数, 因此可以消去 \
  #hl(2)[$arrow(x)^(‾)^T arrow(x)$ 也是计算复数向量长度平方的公式]

- 证明也表明, 若 $A$ 为复数矩阵, 想要满足#link(<sec:对称矩阵的特征值与特征向量>)[以上特性], 则应有 $A = A^(‾)^T$, 并且对角线上的元素为实数

- 更多有关介绍见#link(<sec:复数矩阵与向量>)[复数矩阵与向量]

=== 对称矩阵的分解 <sec:对称矩阵的分解>
已知实对称矩阵有分解 $A = Q Lambda Q^T$, 进一步计算可得

$ A & = Q Lambda Q^T\
 & = mat(delim: "[", arrow(q_1), arrow(q_2), dots.h, arrow(q_n)) mat(delim: "[", lambda_1 arrow(q_1)^T; lambda_2 arrow(q_2)^T; dots.v; lambda_n arrow(q_n)^T)\
 & = sum_(i = 1)^n lambda_i arrow(q_i) arrow(q_i)^T $

注意到, 由于 $arrow(q_i)^T arrow(q_i) = 1$, 因此 $arrow(q_i) arrow(q_i)^T$ 即 $arrow(q_i)$ 方向的投影矩阵 \
由此可得出结论, $n times n$ 的实对称矩阵可分解为 $n$ 个相互垂直方向的投影矩阵的线性组合, 从该结论可引出谱定理

因此一个向量左乘一个对称矩阵 $A$ 后, 相当于将该向量沿 $A$ 相互正交的几个特征向量方向投影, 然后乘以对应的特征值并重新组合

=== 对称矩阵特征值与主元的关系
除了以上的特性, 对称矩阵 $A$ 大于 $0$ 的特征值数量与 $A$ 主元中大于 $0$ 的数量相同

显然, 计算矩阵主元的计算量明显小于特征值, 因此可结合#cross-link("/Linear_Algebra/ch6.typ", reference: <sec:特征值的特性>)[特征值与单位矩阵的特性], 通过判断矩阵 $A$ 与 $A - t I$ 的大于 $0$ 的主元数, 当两个矩阵不同时, 表明 $0 tilde.op t$ 之间存在一个特征值 \
通过此方法可以快速地找出实对称的所有特征值而避免求解特征方程, 时高维对称矩阵寻找特征值的重要方法之一

== 复数矩阵与向量 <sec:复数矩阵与向量>
相对于实数域中的向量空间 $R^n$, 定义以复数为元素的向量属于复数域中的向量空间 $C^n$

=== 复数域下的向量长度
对于复数域中的向量 $arrow(x) in C^n , arrow(x) = mat(delim: "[", a_1 + b_1 i, a_2 + b_2 i, dots.h, a_n + b_n i)^T$ \
显然如果以实数域下相同的方法计算向量长度, 会有 $arrow(x)^T arrow(x) = (a_1^2 + b_1^2 + dots.h + a_n^2 + b_n^2) + 2 i (a_1 b_1 + dots.h + a_n b_n)$ \
显然这与绝对值必须大于等于 $0$ 的要求相违背

为了消去上述计算结果中的虚部, 可以对 $arrow(x)^T$ 取共轭, 得到 $arrow(x)^(‾)^T$ \
此时有

$ mat(delim: bar.double, arrow(x))^2 = arrow(x)^(‾)^T arrow(x) = (a_1^2 + b_1^2 + dots.h + a_n^2 + b_n^2) = mat(delim: bar.double, x_1)^2 + dots.h + mat(delim: bar.double, x_n)^2 $

=== 复数域下的向量点乘与正交
从复数域下的向量长度的计算推广可得, 对于 $arrow(x) , arrow(y) in C^n$, 复数域下的向量点乘运算为

$ arrow(y)^(‾)^T arrow(x) $

此时, 复数域下向量 $arrow(x) , arrow(y)$ 正交时有

$ arrow(y)^(‾)^T arrow(x) = 0 $

注意在此运算下, 结果不一定是实数, 也可能得到复数结果

=== 共轭转置
注意到, 在复数域中, 共轭转置运算有着重要作用, 因此使用符号 $H$ 代表共轭转置运算, 有

$ arrow(y)^H = arrow(y)^(‾)^T $

与#cross-link("/Linear_Algebra/ch1.typ", reference: <sec:转置运算>)[转置]的法则类似, 共轭转置运算有法则

- $(A + B)^H = A^H + B^H$
- $(A B)^H = B^H A^H$
- $(lambda A)^H = lambda^(‾) A^H$
- $(A^(- 1))^H = (A^H)^(- 1)$

因此复数域下的向量 $arrow(x) , arrow(y)$ 运算可表示为

- 向量点乘 $arrow(y)^H arrow(x)$
- 向量长度 $mat(delim: bar.double, arrow(x)) = sqrt(arrow(x)^H arrow(x))$
- 向量正交 $arrow(y)^H arrow(x) = 0$

=== 厄米矩阵（Hermitian）
在#link(<sec:特性的证明>)[关于对称矩阵特性的证明]中已经指出, 若复数矩阵 $A$ 要满足与实对称矩阵类似的特性, 则 #hl(2)[$A$ 对角线上的元素为实数], 并且有

$ A = A^(‾)^T = A^H $

也将满足这一性质的矩阵 $A$ 称为自共轭矩阵或 *Hermite \(埃米尔特) 阵*

注意, 埃米尔特矩阵虽然能找到一组特征向量 $arrow(q)_i$ 相互正交, 但时 $arrow(q)_i$ 为复数域中的向量

=== 酉矩阵
对于 $n$ 个向量 $arrow(q)_i in C^n$ 满足

$ arrow(q)_i^H arrow(q)_j = {0 , i eq.not j\
1 , i = j $

则定义矩阵 $Q = mat(delim: "[", arrow(q)_1, arrow(q)_2, dots.h, arrow(q)_n)$ 为*酉矩阵* \(Unitary)

类似#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:标准正交矩阵>)[标准正交矩阵], 对于酉矩阵有

$ Q = Q^H $

显然, 埃米尔特矩阵存在一组特征矩阵 $Q$ 满足酉矩阵的要求 \
因此, 根据酉矩阵的特性, 对角化埃米尔特矩阵 $A$ 时有

$ A = Q Lambda Q^H $

=== 傅里叶矩阵 <sec:傅里叶矩阵>
傅里叶矩阵 $F_n$ 的基本形式为

$ F_n = mat(delim: "[", 1, 1, 1, dots.h, 1; 1, w^1, w^2, dots.h, w^(n - 1); 1, w^2, w^4, dots.h, w^(2 (n - 1)); dots.v, dots.v, dots.v, dots.down, dots.v; 1, w^(n - 1), w^(2 (n - 1)), dots.h, w^((n - 1) (n - 1))) $

其中 $w = e^(2 pi \/ n)$, 矩阵的第 $i , j$ 项满足 ${ F_n } = w^(i j)$

虽然傅里叶矩阵满足对称矩阵的要求, 但是不是埃米尔特矩阵 \
但是傅里叶矩阵的各列在归一化 \(即乘以系数 $1 / sqrt(n)$) 后满足酉矩阵的要求 \
因此有 $F_n^(- 1) = 1 / n F_n^H$, 其中 $F_n^(- 1)$ 即为傅里叶逆变换矩阵

对于由采样信号序列排列组成的向量 $arrow(x) = mat(delim: "[", x [0], x [1], dots.h, x [n - 1])$ \
其#link("/course/machine/cybernetics/fft.md#离散傅里叶变换-dft")[离散傅里叶变换];结果即 $arrow(X) = F_n arrow(x)$

通过分解 $F_n$, 可将计算 $F_n arrow(x)$ 的时间复杂度由 $O (n^2)$ 降低为 $O (n log n)$, 具体算法详见其他资料

== 二次型
对于对称的系数矩阵 $A$ 与由自变量组成的向量 $arrow(x)$, 运算 $arrow(x)^T A arrow(x)$ 将能得到一个各项次数均为二的多项式 \
以二维为例有

$ mat(delim: "[", x, y) mat(delim: "[", a, b; c, d) mat(delim: "[", x; y) = a x^2 + 2 b x y + c y^2 = f (x , y) $

=== 二次型曲面
当 $A$ 为#link(<sec:正定矩阵>)[正定矩阵]时, 除了点 $(0 , 0)$, 对于任意点有 $f (x , y) > 0$ \
曲面有最低点 $(0 , 0)$ , 此外沿任意远离远点的方向快速上升 此时的 $f (x , y)$ 为一个椭圆抛物面, 曲线 $f (x , y) = z$ 为一个椭圆, 如图所示

#align(center)[#image("./src/positive_define.svg", width: 70%)]
当 $A$ 不为正定矩阵时, 存在 $f (x , y) < 0$ \
曲面沿特定方向快速上升, 又沿其他方向快速下降 \
此时的 $f (x , y)$ 为一个鞍面, 曲线 $f (x , y) = z$ 为一个双曲线, 如图所示

#align(center)[#image("./src/saddle.svg", width: 70%)]
当 $A$ 为半正定矩阵时, 存在特定方向有 $f (x , y) = 0$ \
$f (x , y) = 0$ 的方向为一条与 $x y$ 平面相切的直线 \
此时的 $f (x , y)$ 为一个平行抛物面, 如图所示

#align(center)[#image("./src/critical.svg", width: 70%)]
=== 多项式化简
将二次型化简为多个参数和的平方的形式

$ f (arrow(x)) = sum_(i = 1)^n b_i (sum_(j = 1)^(n - i + 1) a_(j i) x_j)^2 $

对于系数矩阵 $A$ 的 #cross-link("/Linear_Algebra/ch1.typ", reference: <sec:LU分解>)[$L U$ 分解]得到的矩阵 $A = L U$, 易得

$ b_i = { U }_(i i) quad a_(j i) = { L }_(j i) $

注意到 $b_i$ 即矩阵 $A$ 的主元, $a_(j i)$ 即各列的消元系数 \
当任意 $b_i > 0$, $f (arrow(x))$ 便可化简为一系列平方和, 除了 $arrow(x) = arrow(0)$, 显然有 $f (arrow(x)) > 0$ \
因此以此也可以此证明#link(<sec:正定矩阵的基本性质>)[正定矩阵的基本性质]中, 正定矩阵的主元必须大于零的性质

=== 椭圆主轴
通过令 $f (arrow(x)) = z$ 截取二次型, 能得到一个类椭球体 \
易得, 当 $A$ 为对角矩阵时, 其二次型为 $f (arrow(x)) sum a_(i i) x_i^2$, 因此 \
在两个参数的二维平面中为一个以 $x , y$ 轴为长短轴的正椭圆 \
在三个参数的三维空间中为一个以 $x , y , z$ 轴为长, 中, 端轴的正椭球 \
系数 $a_(i i)$ 反映了对应轴的长度, 其中 $a_(i i)$ 最大的轴为长轴, 剩余按 $a_(i i)$ 的顺序排列

由于要求了 $A$ 为一个实对称矩阵, 根据#link(<sec:对称矩阵的分解>)[实对称矩阵的分解], 有

$ f (arrow(x)) = (Q arrow(x))^T Lambda (Q arrow(x)) $

对于一般二次型截取得到的椭球体, 相当于以 $Q$ 为基底的正椭球体 \
因此, 二次型所表达的椭球体中, 以其系数矩阵的特征值为椭球体轴的长度, 特征向量为对应轴的方向

=== 导数矩阵与极值
对于二阶可微的多元函数 $f (arrow(x))$, 将其所有二阶导数使用如下方式组成导数矩阵

$ F prime.double = mat(delim: "[", frac(partial^2 f, partial x_1^2), frac(partial^2 f, partial x_1 x_2), dots.h, frac(partial^2 f, partial x_1 x_n); frac(partial^2 f, partial x_2 x_1), frac(partial^2 f, partial x_2^2), dots.h, frac(partial^2 f, partial x_2 x_n); dots.v, dots.v, dots.down, dots.v; frac(partial^2 f, partial x_n x_1), frac(partial^2 f, partial x_n x_2), dots.h, frac(partial^2 f, partial x_n^2)) $

注意, 二阶可微的多元函数有 $frac(partial^2 f, partial x partial y) = frac(partial^2 f, partial y partial x)$, 在此条件下, 导数矩阵为实对称矩阵

当在点 $arrow(x prime)$ 上, 对于任意自变量 $x_i$ 的一阶导数均为零, 即 $frac(partial f, partial x_i) #scale(x: 120%, y: 120%)[\|]_(arrow(x prime)) = 0$ 时 \
多元函数$arrow(x prime)$ 处的微元区域内, $f (arrow(x))$ 可视为一个二次型 \
因此当 $f (arrow(x))$ 在 $arrow(x prime)$ 处取得最小值时, 导数矩阵 $F prime.double$ 为正定矩阵

因此多元函数在点 $arrow(x prime)$ 取得最小值的条件为

- 在该点的任意一阶导数为 $0$ \(梯度为 $arrow(0)$)
- 在该该点的导数矩阵 $F prime.double$ 为正定矩阵

当 $n = 1$, 即退化为一般一元函数取得最小值的条件

== 正定矩阵 <sec:正定矩阵>
=== 正定矩阵的定义 <sec:正定矩阵的定义>
定义对于一个实对称矩阵 $A$, 给定任意 $arrow(x) eq.not arrow(0)$ 满足以下条件时

$ arrow(x)^T A arrow(x) > 0 $

称该实对称矩阵为*正定矩阵*

当存在 $arrow(x prime) , arrow(x prime)^T A arrow(x prime) = 0$ 时, 则称 $A$ 为*半正定矩阵*

=== 正定矩阵的基本性质 <sec:正定矩阵的基本性质>
根据正定矩阵的定义, 其满足以下基本性质, 当矩阵满足任意一条基本性质, 也可说明其为正定矩阵

+ 矩阵的所有特征值大于 $0$
+ 矩阵可逆且所有主元大于 $0$
+ 矩阵的所有顺序主子式大于 $0$ \
  顺序主子式即矩阵左上角 $k$ 行 $k$ 列的子矩阵的行列式, 根据行列式的#cross-link("/Linear_Algebra/ch5.typ", reference: <sec:推论四>)[推论]可得 \
  使用 $det (A_k)$ 表示矩阵 $A$ 在 $k$ 行 $k$ 列的顺序主子式, 设 $det (A_0) = 0$ \
  矩阵的主元满足 $p_k = frac(det (A_k), det (A_(k - 1)))$

=== 正定矩阵的性质推论 <sec:正定矩阵的性质推论>
以下是关于正定矩阵性质的重要推论

+ 由#cross-link("/Linear_Algebra/ch6.typ", reference: <sec:特征值的特性>)[特征值的特性]可得, 矩阵的逆的特征值为原矩阵的倒数, 因此当矩阵 $A$ 为正定矩阵时, 其逆 $A^(- 1)$ 也是正定矩阵
+ 从#link(<sec:正定矩阵的定义>)[正定矩阵的定义]出发, 当矩阵 $A , B$ 均为正定矩阵时, 有 $arrow(x)^T (A + B) arrow(x) = arrow(x)^T A arrow(x) + arrow(x)^T B arrow(x) > 0$, 因此矩阵 $A + B$ 也是正定矩阵
+ 对于 $n times m$ 的矩形阵 $A$, 当 $A$ #cross-link("/Linear_Algebra/ch2.typ", reference: <sec:列满秩>)[列满秩]时, 最小二乘法中的矩阵 $A^T A$ 为正定矩阵 \(该条件与#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:正规方程>)[正规方程]有解的条件一致), 证明可参考#cross-link("/Linear_Algebra/ch2.typ", reference: <sec:矩阵与其转置之积的秩>)[矩阵与其转置之积的秩] \
  以上三个性质体现了正定矩阵与正数的相似性

此外, 当矩阵 $A$ 为正定矩阵时, $A$ 的#cross-link("/Linear_Algebra/ch1.typ", reference: <sec:LU分解>)[$L U$ 分解]不需要行交换

== 相似矩阵 <sec:相似矩阵>
对于任意的方阵 $A , B$, 当存在一个可逆矩阵 $M$ 满足 $B = M^(- 1) A M$, 则称矩阵 $A$ 与 $B$ *相似*

=== 可对角化矩阵的相似性
当方阵 $A , B$ 相似且可对角化时有 \(假设 $B = M^(- 1) A M$)

$ A arrow(x) & = lambda arrow(x)\
A M M^(- 1) arrow(x) & = lambda arrow(x)\
M^(- 1) A M M^(- 1) arrow(x) & = lambda M^(- 1) arrow(x)\
B (M^(- 1) arrow(x)) & = lambda (M^(- 1) arrow(x)) $

因此当 $A , B$ 相似, 表明矩阵 $A , B$ 具有相同的特征值, 但特征向量不同 \
并且对于所有与矩阵 $A$ 相似的矩阵构成的集合中, 对角化得到的对角矩阵 $Lambda$ 是其中最简洁的矩阵

=== 不可对角化矩阵的相似性
当矩阵不满足#cross-link("/Linear_Algebra/ch6.typ", reference: <sec:对角化矩阵的条件>)[对角化条件]时, 两个矩阵即使有相同的特征值, 也不一定相似 \
现已二维的情况为例, 对于矩阵 $Lambda = 4 I = mat(delim: "[", 4, 0; 0, 4)$ 与任意可逆矩阵 $M$ 有

$ M^(- 1) Lambda M = M^(- 1) 4 I M = 4 I $

因此矩阵 $Lambda$ 除了自身外, 不存在任何相似矩阵, 而其他与 $Lambda$ 一样具有特征值 $lambda_1 = lambda_2 = 4$ 的矩阵如 $mat(delim: "[", 4, 5; 0, 4) , mat(delim: "[", 5, 1; - 1, 3)$

但是上述的两个矩阵, 以及其他具有特征值 $lambda_1 = lambda_2 = 4$ 且仅有一个特征向量的矩阵相似 \
以此引出矩阵相似的另一性质, 矩阵相似时, 其特征值相同, 不同方向的特征向量相同

=== 若尔当定理 <sec:若尔当定理>
定义若尔当矩阵 $J (lambda , n)$ 有如下基本形式

$ J (lambda , n) = mat(delim: "[", lambda, underline(1), 0, dots.h, 0; 0, lambda, underline(0), dots.h, 0; 0, 0, lambda, dots.h, 0; dots.v, dots.v, dots.v, dots.down, dots.v; 0, 0, 0, dots.h, lambda) $

其中

- 参数 $lambda$ 即矩阵中的 $lambda$
- 参数 $n$ 为方阵的长度
- 上对角线即上式中有下划线的位置 \(部分数中使用下对角线) 可为 $0$ 或 $1$

易得, 若尔当矩阵 $J$ 为一个不可对角化矩阵, 且有 $n$ 重特征值 $lambda$, 上对角线 $1$ 的数量则反映了其特征向量的个数 \
规定若尔当矩阵时所有与之相似矩阵中, 最简洁的矩阵

依照对角化矩阵的思想, 对于所有不可对角化的矩阵 $A$ , 都可以转化如下为若尔当型 \(转化方法可查找有关资料), 且所有与 $A$ 相似的矩阵中, 认为其若尔当型是最简洁的矩阵

$ A = M^(- 1) mat(delim: "[", J (lambda_1 , n_1), , , ; #none, J (lambda_2 , n_2), , ; #none, , dots.down, ; #none, , , J (lambda_m , n_m)) M $

其中

- 若尔当型为一个由若尔当矩阵组成的分块矩阵, 其余空白处使用零矩阵填充
- $lambda_i$ 即矩阵 $A$ 第 $i$ 个不同的特征值
- $n_i$ 即矩阵 $A$ 特征值 $lambda_i$ 的重数
- $J (lambda_i , n_i)$ 中上对角线 $1$ 的数量需要在转化时确定
- 对角矩阵即一类 $n_i = 1$ 的特殊若尔当型

== 奇异值分解 <sec:奇异值分解>
=== 奇异值分解的定义
对于任意 $m times n$ 的矩阵 $A$, 取向量 $arrow(v) in R^n$, 通过 $A arrow(v) = arrow(u)$ 可得到一个向量 $arrow(u) in R^m$ \
现希望找到一组 $R^n$ 的标准正交基 $V = mat(delim: "[", arrow(v)_1, arrow(v)_2, dots.h, arrow(v)_n)$, 通过 $A arrow(v)_i = sigma_i arrow(u)_i$ \
可得到一组 $R^m$ 的标准正交基 $U = mat(delim: "[", arrow(u)_1, arrow(u)_2, dots.h, arrow(u)_m)$ \
以此可得 $n times n$ 的标准正交矩阵 $V$ 与 $m times m$ 的标准正交矩阵 $U$

注意到, 当 $m eq.not n$ 时, 并不是每个 $arrow(u)_i$ 都能与一个 $arrow(v)_i$ 相对应, 因此关系式 $A arrow(v)_i = sigma_i arrow(u)_i$ 的数量由 $n , m$ 中较小的一个决定 \
使用矩阵表示则有

$ A V & = {mat(delim: "[", sigma_1 arrow(u)_1, sigma_2 arrow(u)_2, dots.h, sigma_m arrow(u)_m, arrow(0), dots.h, arrow(0)) , m < n\
mat(delim: "[", sigma_1 arrow(u)_1, sigma_2 arrow(u)_2, dots.h, sigma_m arrow(u)_m) , m = n\
mat(delim: "[", sigma_1 arrow(u)_1, sigma_2 arrow(u)_2, dots.h, sigma_n arrow(u)_n) , m > n\
A V & = U Sigma\
A & = U Sigma V^T\
A & = mat(delim: "[", arrow(u)_1, arrow(u)_2, dots.h, arrow(u)_m) mat(delim: "[", sigma_1, 0, dots.h, 0; 0, sigma_2, dots.h, 0; dots.v, dots.v, dots.down, dots.v) mat(delim: "[", arrow(v)_1^T; arrow(v)_2^T; dots.h; arrow(v)_n^T) $

其中

- 矩阵 $A$ 为任意矩阵

- 矩阵 $U , V$ 为#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:标准正交矩阵>)[标准正交矩阵], 有 $V^(- 1) = V^T , U^(- 1) = U^T$

- 矩阵 $Sigma$ 为 $n times m$ 的矩阵, 且第 $i$ 对角位置上的值为 $sigma_i$ \
  一般按从大到小的顺序排列 $Sigma$ 对角线上的元素 \
  #hl(2)[注意$Sigma$ 不一定是方阵], 其形状与 $A$ 一致

- 定义分解 $A = U Sigma V^T$ 即为*奇异值分解*

可得, 正定矩阵的对角化是一种特殊的奇异值分解

=== 奇异值分解过程
直接求解矩阵 $U , V$ 难度较高, 可通过矩阵 $A^T A$ 间接求解

$ A^T A & = (U Sigma V^T)^T U Sigma V^T\
A^T A & = V Sigma^T Sigma V^T $

由#link(<sec:正定矩阵的性质推论>)[正定矩阵的性质推论]可得, $A^T A$ 为正定矩阵 \(或半正定矩阵), 因此仅需要对角化矩阵 $A^T A$ 即可得到标准正交矩阵 $V$ \
矩阵 $A^T A$ 的特征量与 $sigma$ 之间满足 $lambda_i = sigma_i^2$, 习惯上取 $sigma_i gt.eq 0$

之后通过 $A A^T$ 使用类似的方法即可求出 $U$, 有 $A A^T = U Sigma Sigma^T U^T$ \
其中 $Sigma$ 与 $A A^T$ 的特征值已知, 但还需要通过 $A arrow(v)_i = sigma_i arrow(u)_i$ 进一步确定 $U$ 中向量的方向

注意 $arrow(v)_i , lambda_i , sigma_i , arrow(u)_i$ 之间需要一一对应

#problem_box(
  title: [可逆矩阵的奇异值分解],
  problem: [
    对于 $A = mat(delim: "[", 4, 4; -3, 3)$，求其奇异值分解 $A = U Sigma V^T$，并保证奇异值非负、从大到小排列。
  ],
)[

首先计算 $A^T A$

$ A^T A & = mat(delim: "[", 4, - 3; 4, 3) mat(delim: "[", 4, 4; - 3, 3)\
 & = mat(delim: "[", 25, 7; 7, 25) $

计算可得 $A^T A$ 有特征值 $lambda_1 = 32 , lambda_2 = 18$, 有特征向量 $arrow(x)_1 = mat(delim: "[", 1, 1)^T , arrow(x)_2 = mat(delim: "[", 1, - 1)^T$

将特征向量标准化可得 $V = mat(delim: "[", 1 \/ sqrt(2), 1 \/ sqrt(2); 1 \/ sqrt(2), - 1 \/ sqrt(2))$, 将特征值开方可得 $Sigma = mat(delim: "[", sqrt(32), 0; 0, sqrt(18))$

根据推导可知 $A A^T$ 与 $A^T A$ 具有相同的特征值 $lambda_1 = 32 , lambda_2 = 18$, 仅需找出特征向量 $arrow(u)_1 = mat(delim: "[", 1, 0)^T , arrow(u)_2 = mat(delim: "[", 0, 1)^T$

由 $A arrow(v)_2 = - sqrt(18) mat(delim: "[", 0; 1)$ 可知，应选取 $arrow(u)_2 = mat(delim: "[", 0, -1)^T$，使 $A arrow(v)_2 = sigma_2 arrow(u)_2$。

因此矩阵 $A$ 有奇异值分解

$ A = U Sigma V^T = mat(delim: "[", 1, 0; 0, - 1) mat(delim: "[", sqrt(32), 0; 0, sqrt(18)) mat(delim: "[", 1 \/ sqrt(2), 1 \/ sqrt(2); 1 \/ sqrt(2), - 1 \/ sqrt(2)) $

]

#problem_box(
  title: [秩一矩阵的奇异值分解],
  problem: [
    对于 $A = mat(delim: "[", 4, 3; 8, 6)$，求其奇异值分解 $A = U Sigma V^T$，并指出四个基本子空间各由哪些奇异向量张成。
  ],
)[

首先计算 $A^T A = mat(delim: "[", 80, 60; 60, 45)$

由于 $A^T A$ 不可逆, 属于半正定矩阵, 因此其有特征值 $lambda_1 = 80 + 45 = 125 , lambda_2 = 0$, 有标准化特征向量 $arrow(v)_1 = mat(delim: "[", 0.8, 0.6)^T , arrow(v)_2 = mat(delim: "[", 0.6, - 0.8)^T$

$A A^T$ 与 $A^T A$ 具有相同的特征值 $lambda_1 = 125 , lambda_2 = 0$, 仅需找出特征向量 $arrow(u)_1 = mat(delim: "[", 1 \/ sqrt(5), 2 \/ sqrt(5))^T , arrow(u)_2 = mat(delim: "[", - 2 \/ sqrt(5), 1 \/ sqrt(5))^T$

因此矩阵 $A$ 有奇异值分解

$ A = U Sigma V^T = mat(delim: "[", 1 \/ sqrt(5), - 2 \/ sqrt(5); 2 \/ sqrt(5), 1 \/ sqrt(5)) mat(delim: "[", sqrt(125), 0; 0, 0) mat(delim: "[", 0.8, 0.6; 0.6, - 0.8) $

注意到 $arrow(v)_1$ 为行空间 $C (A^T)$ 的基, $arrow(v)_2$ 为零空间 $N (A)$ 的基, $arrow(u)_1$ 为列空间 $C (A)$ 的基, $arrow(u)_2$ 为左零空间 $N (A^T)$ 的基

]

=== 奇异值分解与基本子空间
称 $sigma_i$ 为矩阵 $A$ 的奇异值, 其中奇异值必定有 $sigma gt.eq 0$, 并且非零奇异值的个数即矩阵的秩

实际上, 对于任意矩阵 $A$, 经奇异值分解得到的标准正交矩阵 $V , U$ 中

- $mat(delim: "[", arrow(v)_1, arrow(v)_2, dots.h, arrow(v)_r)$ 为行空间 $C (A^T)$ 的一组标准正交基
- $mat(delim: "[", arrow(v)_(r + 1), arrow(v)_(r + 2), dots.h, arrow(v)_n)$ 为零空间 $N (A)$ 的一组标准正交基
- $mat(delim: "[", arrow(u)_1, arrow(u)_2, dots.h, arrow(u)_r)$ 为列空间 $C (A)$ 的一组标准正交基
- $mat(delim: "[", arrow(u)_(r + 1), arrow(u)_(r + 2), dots.h, arrow(u)_m)$ 为左零空间 $N (A^T)$ 的一组标准正交基

这一特性反映了两个空间间#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:正交补>)[正交补] \
并且来自奇异值分解的, 行空间与列空间的基是所有基中最特殊的, 这两个基之间通过 $sigma_i$ 相互对应, 耦合最少

== 左右逆与伪逆
对于一般的可逆矩阵 $A$ , 总是存在 $A^(- 1) A = A A^(- 1) = I$ \
由于 $A$ 满秩, $C (A) = C (A^T) = R^n$, 因此总是存在线性组合得到 $I$ 的各列 / 各行

而对于#cross-link("/Linear_Algebra/ch2.typ", reference: <sec:列满秩>)[列满秩]或#cross-link("/Linear_Algebra/ch2.typ", reference: <sec:行满秩>)[行满秩]的矩阵 $A$, 希望能找到特定的矩阵 $A_l prime$ 或 $A_r prime$, 与 $A$ 相乘得到单位矩阵 $I$ \
称 $A_l prime$ 与 $A_r prime$ 为*左逆*与*右逆*

=== 左逆
对于一个 $m times n$ 的矩阵 $A$ \
当矩阵列满秩时, 表明其#cross-link("/Linear_Algebra/ch3.typ", reference: <sec:行空间>)[行空间] $C (A^T) = R^n$, 显然存在对于行的线性组合得到单位矩阵 $I$ 的各列 \
因此#hl(2)[列满秩的矩阵存在左逆 $A_l prime$]

注意到, 由#cross-link("/Linear_Algebra/ch2.typ", reference: <sec:矩阵与其转置之积的秩>)[矩阵与其转置之积的秩]可得 $A^T A$ 为可逆矩阵, 因此存在 $(A^T A)^(- 1)$, 基于这一特点, 可以构造 $(A^T A)^(- 1) A^T A = I$, 由此可得矩阵的左逆满足

$ A_l prime = (A^T A)^(- 1) A^T $

必须指出, 由于 $A$ 的行向量中存在自由向量, 因此方程 $A^T arrow(y) = arrow(0)$ 存在无数多解, 即存在无数矩阵满足左逆矩阵的要求, 但以上公式得出的是其中最优的一个

对于运算 $A A_l prime = A (A^T A)^(- 1) A^T$ 则可得到一个投影到 $A$ 各列的#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:投影矩阵>)[投影矩阵] $P$

=== 右逆
使用相同的方法可得 \
行满秩的矩阵存在右逆 $A_r prime$, 矩阵的右逆满足

$ A_l prime = A^T (A A^T)^(- 1) $

同样, 存在无数矩阵满足右逆的要求, 以上公式仅是最优的一个

对于运算 $A_r prime A = A^T (A A^T)^(- 1) A$ 则可得到一个投影到 $A$ 各行的#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:投影矩阵>)[投影矩阵] $P$

=== 行空间与列空间的关系
对于 $m times n$ 的矩阵 $A$

现有任意两个向量 $arrow(x) , arrow(y) in C (A^T)$ 且 $arrow(x) eq.not arrow(y)$ \
分别左乘 $A$ 可得到两个向量 $A arrow(x) , A arrow(y) in C (A)$ \
现证明 $A arrow(x) eq.not A arrow(y)$

假设 $A arrow(x) = A arrow(y)$, 则有 $A (arrow(x) - arrow(y)) = arrow(0)$ \
此时 $(arrow(x) - arrow(y)) in N (A)$, 又根据向量空间#cross-link("/Linear_Algebra/ch2.typ", reference: <sec:向量空间>)[线性组合]的要求有 $arrow(x) - arrow(y) in C (A^T)$

然而, 行空间与零空间是一对#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:正交补>)[正交补], 除了 $arrow(0)$ 外不存在任何公共向量, 因此不存在 $A (arrow(x) - arrow(y)) = arrow(0)$

由以上关系可知, 行空间 $C (A^T)$ 与列空间 $C (A)$ 之间的向量存在一种一一对应的关系, 并且行空间中的向量通过左乘 $A$ 即可唯一地映射到列空间 \
现定义矩阵 $A$ 的*伪逆* $A^(+)$, 列空间的向量通过左乘伪逆 $A^(+)$ 可唯一地映射到行空间 \
即对于 $A arrow(x) = arrow(y)$ 有 $A^(+) arrow(y) = arrow(x)$

与此同时, 对于零空间中的向量 $arrow(x) in N (A)$, 经过左乘 $A$ 仅能得到 $arrow(0)$ \
对于伪逆类似的有对于左零空间中的向量 $arrow(x) in N (A^T)$, 经过左乘 $A^(+)$ 仅能得到 $arrow(0)$ \
又根据#cross-link("/Linear_Algebra/ch4.typ", reference: <sec:正交补>)[正交补]的关系, 对于任意向量 $arrow(x) in R^n$ 分解为 $C (A^T)$ 与 $N (T)$ 中的两个向量, 则其左乘 $A$ 也将映射到 $C (A)$ 中, 反之对于 $A^(+)$ 同理

=== 矩阵的伪逆
基于奇异值分解来求解 $m times n$ 的矩阵 $A$ 的伪逆 $A^(+)$

对于奇异值分解中的奇异值矩阵 $Sigma$, 为一个 $m times n$ 的矩形矩阵, 第 $i$ 个对角线上的元素为奇异值 $sigma_i$, 其余元素均为 $0$

易得, 奇异值矩阵的伪逆 $Sigma^(+)$ 为一个 $n times m$ 的矩形矩阵, 第 $i$ 个对角线上的元素为 $1 / sigma_i$, 其余元素均为 $0$

而矩阵 $A$ 经过奇异值分解后有 $A = U Sigma V^T$, 与求逆的规则类似, 对整体求伪逆即可得到伪逆满足

$ A^(+) = V Sigma^(+) U^T $

可得

- 任何矩阵都有伪逆, 可逆矩阵的伪逆即 $A^(- 1)$
- 矩阵的伪逆 $A^(+)$ 为一个 $n times m$ 的矩阵
- $A^(+) A$ 是 $n times n$ 的正交投影矩阵，投影到 $A$ 的行空间 $C (A^T)$；$A A^(+)$ 是 $m times m$ 的正交投影矩阵，投影到列空间 $C (A)$。它们一般并非对角矩阵；在奇异向量基下才具有对角块 $upright(d i a g) (I_r , 0)$ 的表示。
- 对任意 $arrow(b)$，$arrow(x) = A^(+) arrow(b)$ 都是最小二乘问题 $min_x parallel A arrow(x) - arrow(b) parallel_2$ 的最小范数解；当 $arrow(b) in C (A)$ 时，它同时是原方程的最小范数精确解。 \
- 伪逆满足 Moore–Penrose 条件：$A A^(+) A = A$、$A^(+) A A^(+) = A^(+)$，且 $A A^(+)$ 与 $A^(+) A$ 均为对称矩阵。其中 $A^(+) A$ 会去除输入向量在 $N (A)$ 中的分量，而 $A A^(+)$ 会去除输出向量在 $N (A^T)$ 中的分量。
