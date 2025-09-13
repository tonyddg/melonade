#import "/book.typ": book-page, cross-link
#show: book-page.with(title: "矩阵论")

#import "/utility/widget.typ": *
#set math.mat(delim: "[")
#set math.vec(delim: "[")

= 矩阵论

== 线性空间

=== 线性空间定义

线性空间（也成为向量空间）定义为一个集合 $bold(V)(bb(F))$
- 向量需要#hl(1)[对线性组合运算封闭（数乘与加法）]，即空间内的任意两个向量的线性组合仍在此空间内
- 数乘与加法满足交换律、结合律、分配律
- 与简答集合不同，线性空间还需要规定数域 $bb(F)$ 为前提（数乘值所在值域），一般为实数域 $bb(R)$ 或复数域 $bb(C)$（默认与集合内向量元素来自同一域，可省略 $bb(F)$）
  - 即存在线性空间，向量以复数为元素 $bold(V)=bb(C)^n$，但限制数乘只能使用实数 $bb(F)=bb(R)$（依然属于实线性空间）
  - 因此完整的线性空间表示为 $bold(V)(bb(F))$

由此可得
- 所有以向量为元素的线性空间必须包含 $arrow(0)$ 向量（称为*零元* $bold(0)$）
  - 称空间的零元即 $bold(0)=0 dot a,a+bold(0)=a$，负元即 $a^-=-1 dot a,a^-+a=bold(0)$
- 向量以实数为元素 $bold(V)=bb(R)^n$，但限制数乘只能使用复数 $bb(F)=bb(C)$ 时，不满足数乘封闭要求
- 线性空间内不一定是向量，如最高次数为 $n$ 多项式 $f(t)=a_n t^n + dots + a_0$ 构成集合 $bb(P)_(n(t))$ 可构成线性空间 $bb(P)_(n(t))(bb(R))$
- 规定 $bold(V)=bb(R)_+,bb(F)=bb(R)$，元素加法与数乘满足 $a plus.circle b = a dot b,k times.circle a = a^k$，依然为线性空间，此时零元为 $1$，负元为 $-a = a^(-1)$

=== 线性相关性

将线性空间中的如下运算称为线性组合：

$
arrow(b)=x_1 arrow(a)_1+x_2 arrow(a)_2+dots+x_n arrow(a)_n
$

其中
- ${arrow(a)_1,arrow(a)_2,dots,arrow(a)_n}$ 为一个向量组
- 每组系数 ${x_i}$ 对应一种线性组合

对于一个向量组，当除了系数全为零（零组合）的情况下，向量组中的向量不存在任何线性组合能得到零向量 $arrow(0)$，则该*向量组线性无关*，否则线性相关
- 向量组线性相关的充要条件为：至少有一个向量可被其他向量线性表示
- 线性无关向量组的子向量组依然线性无关

=== 线性空间的维数

// 线性空间可以是集合 $bb(R)^n$ 的子集 $S$，线性空间的 $bold(V)=bb(S)$，

称最大线性无关向量组中向量个数为线性空间 $bold(V)$ 的维度，记为 $n=dim bold(V)$
- 长度为 $n$ 的实向量集合 $bb(R)^n$ 维度为 $n$
- 大小为 $m times n$ 的实矩阵集合 $bb(R)^(m times n)$ 维度为 $m dot n$
- 任意次多项式构成线性空间维度为无穷

对于同一集合，数域不同对应线性空间的维度可能不同
- 线形空间 $bb(C)(bb(R))$ 的维度为 2，具有如 ${1,i}$ 的基
- 线形空间 $bb(C)(bb(C))$ 的维度为 1


=== 线性空间的基

线性空间 $bold(V)$ 中任意一组最大线性无关向量组可以构成一个基 ${arrow(a)_i}={arrow(a)_1,arrow(a)_2,dots,arrow(a)_n}$。线性空间 $bold(V)$ 中任意元素都可以被基 ${arrow(a)_i}$ 用*唯一的一组系数* ${x_i}$ 线性组合得到。

即对于基 ${arrow(a)_i}={arrow(a)_1,arrow(a)_2,dots,arrow(a)_n}$ 与集合中的元素 $arrow(y) in bold(V)$ 存在唯一一组系数 ${x_i}$ 表示为：

$
arrow(b) = mat(arrow(a)_1,arrow(a)_2,dots,arrow(a)_n) mat(x_1;x_2;dots;x_n) = bm(A) arrow(x)
$

对于元素为向量的集合，可简单地将系数 ${x_i}$ 视为数域中的向量 $arrow(x)$，基 ${arrow(a)_i}={arrow(a)_1,arrow(a)_2,dots,arrow(a)_n}$ 中的列向量沿行排列得到的矩阵 $bm(A)$，可将向量 $arrow(x)$ 称为 $arrow(b)$ 在基 $bm(A)$ 下的坐标。

因此对于线性方程组 $arrow(b)=bm(A)arrow(x)$
- 方程组有解表明：向量 $arrow(b)$ 来自向量组 $bm(A)$ 构成的线性空间，即向量组 $[bm(A) arrow(b)]$ 线性相关
- 方程组有唯一解表明：向量组 $bm(A)$ 是一组基，即基向量组 $bm(A)$ 线性无关
- 解具有唯一解的线性方程组 $arrow(b)=bm(A)arrow(x)$ 可以认为是求同一向量空间下的向量 $arrow(b)$ 在基 $bm(A)$ 的坐标 $arrow(x)$。

注意坐标 $arrow(x)$ 与线性空间元素（如向量 $arrow(b)$）的关系
- 线性空间的坐标本质为数域 $bb(F)$ 上长度为 $dim bold(V)$ 的向量
- 线性空间中元素的数乘与加法对应数域中坐标的数乘与加法

=== 基变换

对于两组基按列向量排列得到矩阵 $attach(bm(M), bl: a),attach(bm(M), bl: b)$，显然可以找到 $attach(bm(M), bl: b)$ 的每一列向量 $attach(arrow(m), tl: b)_i$ 在基 $attach(bm(M), bl: a)$ 中的坐标 $attach(arrow(p), bl: b, tl: a)_i$。按列排列这些坐标得到数域下的矩阵 $attach(bm(P), bl: b, tl: a)$，因此两个基有关系

$
  attach(bm(M), bl: b)=attach(bm(M), bl: a) attach(bm(P), bl: b, tl: a)
$

称 $attach(bm(P), bl: b, tl: a)$ 为基变换矩阵，对于向量 $arrow(p)$ 在两个基中分别有坐标 $attach(arrow(p), tl: a),attach(arrow(p), tl: b)$，则有

$
  attach(bm(M), bl: b)attach(arrow(p), tl: b)&=attach(bm(M), bl: a)attach(arrow(p), tl: a)\ 
  attach(bm(M), bl: a) attach(bm(P), bl: b, tl: a)attach(arrow(p), tl: b)&=attach(bm(M), bl: a)attach(arrow(p), tl: a)\ 
  attach(bm(P), bl: b, tl: a)attach(arrow(p), tl: b)&=attach(arrow(p), tl: a)
$

=== 基本子空间

对于线性空间 $bold(V)$ 与集合 $bb(A)$，当满足以下条件称 $bb(A)$ 为线性空间 $bold(V)$ 的子空间
- $bb(A) subset.eq bold(V)$
- $bb(A)$ 与 $bold(V)$ 对数乘与加法的定义相同
- $bb(A)$ 满足线性空间要求

对于矩阵 $bm(A) in bb(R)^(m times n)$ 可以定义两个子空间：

*零空间*（Null Space）$N(bm(A))={arrow(x)in bb(R)^n|bm(A)arrow(x)=arrow(0)}$
- 属于 $bb(R)^n$ 的子空间
- 方程 $bm(A)arrow(x)=arrow(0)$ 解构成的集合
- 维度为 $dim N(bm(A))=n-r(bm(A))$

*列空间*（Column Space）$C(bm(A))={arrow(y)in bb(R)^m|bm(A)arrow(x)=arrow(y),arrow(x)in bb(R)^n}$
- 属于 $bb(R)^m$ 的子空间
- 矩阵 $bm(A)$ 列向量的所有线性组合
- 维度为 $dim R(bm(A))=r(bm(A))$

=== 子空间运算

子空间间可以进行求交和求和运算后依然为子空间

*和运算* $bold(V)_1 + bold(V)_2={arrow(x)_1+arrow(x)_2|arrow(x)_1 in bold(V)_1,arrow(x)_2 in bold(V)_2}$
- 和空间相当于将两个线性空间的基混合，因此和空间的维度满足 $ dim{C(bm(A))+C(bm(B))}=dim{C([bm(A) space bm(B)])} $
- 当 $dim bold(V)_1 + dim bold(V)_2 = dim(bold(V)_1 + bold(V)_2)$ 称为直和，记为 $dim bold(V)_1 plus.circle dim bold(V)_2$，此时 $dim(bold(V)_1 sect.big bold(V)_2)=0$
- 对于 $bb(R)^n$ 的子空间 $bold(V)_i$，定义补空间 $bold(V)^L_i$ 满足 $bold(V)^L_i plus.circle bold(V)_i = bb(R)^n$

*交运算* $bold(V)_1 sect.big bold(V)_2={arrow(x)|arrow(x) in bold(V)_1 and arrow(x) in bold(V)_2}$
- 交空间要求向量同时存在于两个子空间，即对于 $C(bm(A)) sect.big C(bm(B))$ 满足 $ arrow(p)=bm(A)arrow(x)=bm(B)arrow(y) arrow mat(bm(A),-bm(B))mat(arrow(x); arrow(y))=arrow(0) $
- 可得，交空间的维度满足 $ dim{C(bm(A)) sect.big C(bm(B))}=dim{N([bm(A) space bm(B)])} $
- 和空间维度反映两个子空间独立维度的个数，交空间反映两个子空间重叠维度的格式，因此 $ dim(bold(V)_1 + bold(V)_2)+dim(bold(V)_1 sect.big bold(V)_2)=dim(bold(V)_1)+dim(bold(V)_2) $

需要注意的是，子空间求并后不一定是线性空间，如子空间 $R(mat(1, 0)^T),R(mat(0, 1)^T)$ 的并集包含向量 $mat(1, 0)^T,mat(0, 1)^T$, 但不包含 $mat(1, 1)^T$，显然不对加法封闭

== 线性变换

=== 线性变换的定义

对于线性变换 $T$ 具有特点
- 线性变换的输入 $arrow(a)$ 为*原像*，来自线性空间 $bold(A)^n$，输出 $arrow(b)$ 为 $a$ 在 $T$ 下的*像*，来自线性空间 $bold(B)^m$。线性变换仅保证变换的输入与输出元素均来自线性空间，但不一定来自同一线性空间。
- 线性变换的线性性还要求原像的线性组合等于像的同一线性组合，即 $ T(k_1 arrow(a)_1+k_2 arrow(a)_2)=k_1 T(arrow(a)_1)+k_2 T(arrow(a)_2) $
