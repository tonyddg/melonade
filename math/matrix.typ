#import "/book.typ": book-page, cross-link
#show: book-page.with(title: "矩阵论")

#import "/utility/widget.typ": *

= 矩阵论

== 线性空间

=== 线性空间定义

线性空间（也成为向量空间）定义为一个集合 $bb(V)(bb(F))$
- 向量需要#hl(1)[对线性组合运算封闭（数乘与加法）]，即空间内的任意两个向量的线性组合仍在此空间内
- 数乘与加法满足交换律、结合律、分配律
- 集合内通常有特定数域 $bb(F)$ 为前提（数乘值所在值域），一般为实数域 $bb(R)$ 或复数域 $bb(C)$（默认为实数域，省略 $(bb(F))$）
  - 即存在线性空间，向量以复数为元素 $bb(V)=bb(C)^n$，但限制数乘只能使用实数 $bb(F)=bb(R)$（依然属于实线性空间）
  - 因此完整的线性空间表示为 $bb(V)(bb(F))$

由此可得
- 所有以向量为元素的线性空间必须包含 $arrow(0)$ 向量（称为*零元* $bold(0)$）
  - 称空间的零元即 $bold(0)=0 dot a,a+bold(0)=a$，负元即 $a^-=-1 dot a,a^-+a=bold(0)$
- 向量以实数为元素 $bb(V)=bb(R)^n$，但限制数乘只能使用复数 $bb(F)=bb(C)$ 时，不满足数乘封闭要求
- 线性空间内不一定是向量，如最高次数为 $n$ 多项式 $f(t)=a_n t^n + dots + a_0$ 构成集合 $bb(P)_(n(t))$ 可构成线性空间 $bb(P)_(n(t))(bb(R))$
- 规定 $bb(V)=bb(R)_+,bb(F)=bb(R)$，元素加法与数乘满足 $a plus.circle b = a dot b,k times.circle a = a^k$，依然为线性空间，此时零元为 $1$，负元为 $-a = a^(-1)$

=== 线性相关性

将线性空间中的如下运算称为线性组合：

$arrow(x)=a_1 arrow(x)_1+a_2 arrow(x)_2+dots+a_n arrow(x)_n$

其中
- ${arrow(x)_1,arrow(x)_2,dots,arrow(x)_n}$ 为一个向量组
- 每组系数 ${a_i}$ 对应一种线性组合

对于一个向量组，当除了系数全为零（零组合）的情况下，向量组中的向量不存在任何线性组合能得到零向量 $arrow(0)$，则该*向量组线性无关*，否则线性相关
- 向量组线性相关的充要条件为：至少有一个向量可被其他向量线性表示
- 线性无关向量组的子向量组依然线性无关

=== 线性空间的维数

// 线性空间可以是集合 $bb(R)^n$ 的子集 $S$，线性空间的 $bb(V)=bb(S)$，

称最大线性无关向量组中向量个数为线性空间 $bb(V)$ 的维度，记为 $n=dim bb(V)$
- 长度为 $n$ 的实向量集合 $bb(R)^n$ 维度为 $n$
- 大小为 $m times n$ 的实矩阵集合 $bb(R)^(m times n)$ 维度为 $m dot n$
- 任意次多项式构成线性空间维度为无穷

=== 线性空间的基

线性空间 $bb(V)$ 中任意一组最大线性无关向量组可以构成一个基 $cal(B)={arrow(x)_1,arrow(x)_2,dots,arrow(x)_n}$。线性空间 $bb(V)$ 中任意元素都可以被基 $cal(B)$ 用*唯一的一组系数* ${a_i}$ 线性组合得到。

即对于基 $cal(B)={arrow(x)_1,arrow(x)_2,dots,arrow(x)_n}$ 与集合中的元素 $arrow(y) in bb(V)$ 存在唯一一组系数 ${a_i}$ 表示为：

$
arrow(y) = mat(arrow(x)_1,arrow(x)_2,dots,arrow(x)_n) mat(a_1;a_2;dots;a_n) = bm(X) arrow(a)
$

对于元素为向量的集合，可将系数 ${a_i}$ 视为向量 $arrow(a)$，基 $cal(B)={arrow(x)_1,arrow(x)_2,dots,arrow(x)_n}$ 视为*列向量沿行排列*得到的矩阵 $bm(X)$，可将向量 $arrow(a)$ 称为 $arrow(y)$ 在基 $bm(X)$ 下的坐标。

因此对于线性方程组 $arrow(b)=bm(A)arrow(x)$
- 方程组有解表明：向量 $arrow(b)$ 来自向量组 $bm(A)$ 构成的线性空间，即向量组 $[bm(A) arrow(b)]$ 线性相关
- 方程组有唯一解表明：向量组 $bm(A)$ 是一组基，即基向量组 $bm(A)$ 线性无关
- 解具有唯一解的线性方程组 $arrow(b)=bm(A)arrow(x)$ 可以认为是求同一向量空间下的向量 $arrow(b)$ 在基 $bm(A)$ 的坐标 $arrow(x)$。
