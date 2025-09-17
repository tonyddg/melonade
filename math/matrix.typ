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
- 线性空间内不一定是向量，如最高次数为 $n$ 多项式 $f(t)=a_n t^n + dots + a_0$ 构成集合 $bold(P)_(n(t))$ 可构成线性空间 $bold(P)_(n(t))(bb(R))$
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

除此之外，使用记号 $"span"{arrow(a)_i}$ 表示由向量组 ${arrow(a)_i}$ 中的向量任意组合张成线性空间。

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
- 根据原像与像所在线性空间，称线性变换具体描述为（原像所在空间）到（像所在线性空间）的线性变换，如果原像与像集合相同，则成为（线性空间）上的线性变换

线性变换的具体形式可以是千变万化的，例如
- 最典型的线性变换及矩阵向量相乘
- 给定矩阵 $bm(P)in bold(V)^(m times m),bm(Q)in bold(V)^(n times n)$，可以定义 $bold(V)^(m times n)$ 上的线性变换 $T(bm(X)) = bm(P)bm(X)bm(Q),forall bm(X) in bold(V)^(m times n)$
- 多项式求导运算 $d/(d t)$ 同样属于线性变换

关于线性变换有以下推论
- 将零元或负元作为原像，得到的为对应线性空间的零元或负元
- 一组线性相关的向量，经过线性变换后的像依然线性相关（反之不一定）

=== 线性变换与矩阵

设 $T$ 是 $bold(A)^n$ 到 $bold(B)^m$ 的线性变换，两个线性空间分别有一组基 ${arrow(alpha)_i}_n$ 与 ${arrow(beta)_i}_m$。因此对于线性变换的输入（原像）$arrow(a)$ 对应的输出（像）$T(arrow(a))$ 可以表示为基 ${arrow(beta)_i}_m$ 下的一组坐标 $arrow(x)$：

$
  T(arrow(a))=mat(arrow(beta)_1,dots,arrow(beta)_m) mat(x_1;dots;x_m)
$

将 $bold(A)^n$ 的基 ${arrow(alpha)_i}_n$ 作为像分别求其原像在基 ${arrow(beta)_i}_m$ 的坐标，按列排列可得到矩阵 $bm(X)$（根据线性组合不变性可将线性变换 $T$ 视为一种矩阵）：

$
  mat(T(arrow(alpha)_1),dots,T(arrow(alpha)_m)) &= mat(arrow(beta)_1,dots,arrow(beta)_m) mat(x_(1,1),dots,x_(1,n);dots.v,,dots.v;x_(m,1),dots,x_(m,n))_(m,n)\ 
  mat(T(arrow(alpha)_1),dots,T(arrow(alpha)_m))_(m,n)&=bm(B)_(m,m)bm(X)_(m,n)\ 
  T bm(A)_(n,n)&=bm(B)_(m,m)bm(X)_(m,n)
$

根据线性变换后，原像与像线性组合不变的性质，如果已知原像 $arrow(a)$ 在基 ${arrow(alpha)_i}_n$ 的坐标 $arrow(x)_n$，就可以得到其经过线性变换的像 $arrow(b)$ 在基 ${arrow(beta)_i}_m$ 下的一组坐标 $arrow(y)_m$

$
  T(arrow(a))=mat(T(arrow(alpha)_1),dots,T(arrow(alpha)_m))arrow(x)_n=bm(B)_(m,m)bm(X)_(m,n)arrow(x)_n=bm(B)_(m,m)arrow(y)_m
$

称 $bm(X)_(m,n)$ 为线性变换 $T$ 在基偶 ${bm(A)_(n,n),bm(B)_(m,m)}$ 的矩阵，简称线性变换矩阵，这一表示是唯一的。#hl(2)[由原像在基 $bm(A)$ 下的坐标 $arrow(x)$ 右乘线性变换矩阵 $bm(X)$ 便得到线性变换的像在基 $bm(B)$ 下的坐标 $arrow(y)$]（注意两个坐标对应的基不同）。

注意，此处将线性变换 $T$ 记为矩阵 $bm(T)$ 只是为了方便利用线性变换的性质，线性变换不一定是矩阵相乘，也可能是其他运算。

=== 线性变换矩阵表示的特性

同一前提下，假设基 ${arrow(alpha)_i}_n$ 与基 ${arrow(alpha)'_i}_n$ 有基变换矩阵 $attach(bm(P), bl: alpha', tl: alpha)$；基 ${arrow(beta)_i}_m$ 与基 ${arrow(beta)'_i}_m$ 有基变换矩阵 $attach(bm(Q), bl: beta', tl: beta)$，$T$ 在基偶 ${bm(A),bm(B)}$ 与 ${bm(A)',bm(B)'}$ 的矩阵为 $bm(X),bm(X)'$，此时有

$
attach(bm(A), bl: alpha')=attach(bm(A), bl: alpha)attach(bm(P), bl: alpha', tl: alpha),attach(bm(B), bl: beta')=attach(bm(B), bl: beta)attach(bm(Q), bl: beta', tl: beta)\ 
bm(T)attach(bm(A), bl: alpha)=attach(bm(B), bl: beta)bm(X),bm(T)attach(bm(A), bl: alpha')=attach(bm(B), bl: beta')bm(X)'
$

两者存在关系

$
  bm(T)attach(bm(A), bl: alpha')&=attach(bm(B), bl: beta')bm(X)'\ 
  bm(T)attach(bm(A), bl: alpha)attach(bm(P), bl: alpha', tl: alpha)&=attach(bm(B), bl: beta)attach(bm(Q), bl: beta', tl: beta)bm(X)'\ 
  attach(bm(B), bl: beta)bm(X)attach(bm(P), bl: alpha', tl: alpha)&=attach(bm(B), bl: beta)attach(bm(Q), bl: beta', tl: beta)bm(X)'\ 
  bm(X)&=attach(bm(Q), bl: beta', tl: beta)bm(X)'attach(bm(P), bl: alpha', tl: alpha)^(-1)
$

将矩阵间 $bm(Y)=bm(Q) bm(X) bm(P),bm(Q)in bold(V)^(n times n),bm(P)in bold(V)^(m times m)$ 的关系称为矩阵 $bm(Y),bm(X)$ *相抵*（或*等价*）。因此同一线性变换在不同基偶下的矩阵表示间是*相抵*的。

假设 $T$ 就是向量空间 $bold(V)^(n times n)$ 的线性变换，令 ${arrow(alpha)_i}_n={arrow(beta)_i}_n,{arrow(alpha')_i}_n={arrow(beta')_i}_n$（#hl(2)[即同一向量空间中的线性变换，通常令像与原像的坐标使用同一组基]），此时 $attach(bm(P), bl: alpha', tl: alpha)=attach(bm(Q), bl: beta', tl: beta)$。此时线性变换矩阵为 $n times n$ 的方阵，运算 $bm(X)arrow(x)=arrow(y)$ 中 $arrow(x),arrow(y)$ 表示了 $bold(V)^(n times n)$ 中的向量 $bm(A)arrow(x)$ 的原像与像在基 ${arrow(alpha)_i}_n$ 的坐标。

此时线性变换矩阵间满足：

$
  bm(X)&=attach(bm(Q), bl: beta', tl: beta)bm(X)'attach(bm(P), bl: alpha', tl: alpha)^(-1)\ 
  bm(X)&=attach(bm(P), bl: alpha', tl: alpha)bm(X)'attach(bm(P), bl: alpha', tl: alpha)^(-1)
$

将矩阵间 $bm(Y)=bm(P) bm(X) bm(P)^(-1),bm(P),bm(X),bm(Y) in bold(V)^(n times n)$ 的关系称为矩阵 $bm(Y),bm(X)$ *相似*。因此当线性变换的像与原像所在线性空间相同，则同一线性变换在不同基偶下的矩阵表示间是*相似*的。

因此寻找最简线性变换矩阵的问题等价于
- 矩阵 $bm(A)in bold(V)^(m times n)$ 相抵0的矩阵中，最简的是什么
- 矩阵 $bm(A)in bold(V)^(n times n)$ 相似的矩阵中，最简的是什么

=== 线性变换的子空间

与基于矩阵的子空间类似，对于从 $bold(V)^n$ 到 $bold(V)^m$ 的线性变换 $T$ 也可以划分为两个子空间：
- 线性变换的*值域*：$R(T)={arrow(b)|arrow(b)=T(arrow(a)),arrow(a)in bold(V)^n}$
  - $R(T)$ 为 $bold(V)^m$ 的子空间
  - 称 $R(T)$ 的维度为线性变换 $T$ 的*秩* $"rank" T$
- 线性变换的*核*：$N(T)={arrow(a)|T(arrow(a))=arrow(0)}$
  - $N(T)$ 为 $bold(V)^n$ 的子空间
  - 称 $N(T)$ 的维度为线性变换 $T$ 的*零度* $"null" T$
- 根据定义可推论值域与核有如下关系：
  - 根据线性组合特性，线性变换中像一组基中的每个向量对应原像的一个向量，且这些向量必然相互独立。因此秩反映了原像自由度中，对线性变换独立起作用部分的维度。
  - $bold(V)^n$ 中其余部分则对于线性变换的像没有帮助，即这些部分的像为零元 $arrow(0)$，这些部分构成的线性空间就是线性变换的核。
  - 因此线性空间的秩与零度有关系 $"rank" T+"null" T = n$
  - 但是注意，线性变换的值域与核没有直接关系，两者分别来自 $bold(V)^m$ 与 $bold(V)^n$。即使是同一线性空间下的线性变换，一个是变换结果的像一个是特殊的原像；，两者依然没有直接关系 $R(T)+N(T) eq.not bold(V)^n$。

对于 $bold(V)^n$ 上的线性变换 $T$，还可以定义*不变子空间* $bold(W)={arrow(a)|arrow(a)=T arrow(b),arrow(b)in bold(W)}$，即不变空间中的元素经过线性变换后依然在不变空间内。显然，线性变换的核（变换结果 $arrow(0)$ 总在线性空间中）与值域（值域已经包含了所有线性变换结果）均为不变子空间。

=== 线性变换的特征值

对角矩阵是方阵中最简单的，而由特征值的性质可以知道，相似矩阵有着相同的特征值（与特征多项式）。因此对于定义在 $bold(V)^n$ 上的线性变换矩阵中，最简的矩阵即线性变换矩阵特征值构成的对角矩阵。

由此，对于定义在 $bold(V)^n$ 上的线性变换 $T$，可以定义线性变换中与特征值相关的概念：如果存在 $lambda_0 in bold(F),arrow(xi) in bold(V)^n$ 使得 $T(arrow(xi))=lambda_0 arrow(xi)$，称 $lambda_0$ 为线性变换 $T$ 的一个特征值，$arrow(xi)$ 为线性变换 $T$ 在特征值 $lambda_0$ 下任意一个特征向量。

易得，对于任给一组 $bold(V)^(n times n)$ 下的一组基 $bm(A)$ 与相应线性变换矩阵 $bm(X)$。线性变换的特征值即矩阵 $bm(X)$ 的特征值，线性变换的特征向量在基 $bm(A)$ 的坐标即 $bm(X)$ 的特征向量。

在线性变换的角度中
- 由于线性变换矩阵被表示为了最简单的对角矩阵 $bm(Lambda)$，此时变换的效果就可以简单地表示为拉伸向量在某个基 $bm(S)$ 下的坐标。
- 由于原像 $arrow(xi)$ 经过线性变换后的像 $lambda_i arrow(xi)$ 成比例关系即相互平行，因此 $lambda_i$ 对应的所有特征向量 $bm(A) N(bm(X) - lambda_i bm(I))$（$bm(A)$ 为线性变换矩阵 $bm(X)$ 基偶中两个相同的基）构成一个不变子空间 $bold(W)$，记为 $bold(V)_(lambda_i)$。
- 由不同特征值的特征向量间线性无关的特性还可得出，#hl(2)[各个特征值 $lambda_i$ 对应的特征值构成的不变子空间 $bold(W)_i$ 的叫空间为 $arrow(0)$，和运算属于直和 $plus.circle$]。

=== 特征值的计算与性质

首先以方阵为讨论对象探究特征值，对于矩阵 $bm(A) in bold(V)^(n times n)$，存在某些方向的向量 $arrow(x)_i eq.not arrow(0)$ 在右乘 $bm(A)$ 后，得到的结果仍然平行于 $arrow(x)_i$，将具有这种特性的向量称为特征向量 $arrow(x)_i$，而称相乘结果 $bm(A)arrow(x)_i$ 与原向量 $arrow(x)_i$ 之比 $lambda_i$ 为特征值，即

$
  bm(A)arrow(x)_i&=lambda_i arrow(x)_i\ 
  (bm(A)-lambda_i bm(I))arrow(x)_i&=arrow(0)
$

由变形 $(bm(A)-lambda_i bm(I))arrow(x)_i&=arrow(0)$ 可知
- 矩阵 $(bm(A)-lambda_i bm(I))$ 需要是不可逆的（向量组线性相关）才能保证以上方程有解，因此特征值满足 $det(bm(A)-lambda_i bm(I))=0$ 该方程可展开为一个 $n$ 次多项式，包含重根与复数根在内一定有 $n$ 个解，即矩阵 $bm(A)$ 有 $n$ 个特征值，但可能存在重复多次的特征值。
- 如果已知特征值 $lambda_i$ 后，特征向量即零空间 $N(bm(A)-lambda_i bm(I))$ 中的任意一个向量，#hl(2)[一个特征值可以对应无数个特征向量]。并且还有可能出现 $dim N(bm(A)-lambda_i bm(I))>1$ 即一个特征值对应了多个线性无关的特征向量的情况，（一般使用 $N(bm(A)-lambda_i bm(I))$ 的一组基代表用于特征向量矩阵）。
- 因此定义*代数重数* $m_a (lambda_i)$ 为 $lambda_i$ 作为特征多项式根的重数 $n_i$；定义*几何重数* $m_g (lambda_i)$ 为 $lambda_i$ 对应所有特征向量组成的子空间的维度 $dim N(bm(A)-lambda_i bm(I))=dim(bold(V)_(lambda_i))=k_i$。
- #hl(2)[对于任意特征值 $lambda_i$ 的代数重数与几何重数有大小关系：$1 lt.eq m_g (lambda_i) lt.eq m_a (lambda_i)$]。这一关系表明线性变换可能存在受别的方向牵连的剪切变换，无法简单地将线性变换分解为几个独立方向的拉伸。

由上节讨论可知，对于线性变换以上结论同样适用

=== 线性变换的对角化

此处不加证明地给出特征向量性质：#hl(2)[不同特征值对应的特征向量间线性无关]。

因此如果一个 $bold(V)^T$ 的线性变换 $T$ 存在 $n$ 个线性无关的特征向量 ${arrow(s)_i}_n$，将这些特征向量排列为方阵 $bm(S)$，根据线性变换特征值的性质有：

$
  T bm(S)=mat(T arrow(s)_1,dots,T arrow(s)_n)=mat(lambda_1 arrow(s)_1,dots,lambda_n arrow(s)_n)=mat(arrow(s)_1,dots,arrow(s)_n)mat(lambda_1;,dots.down;,,lambda_n)=bm(S)bm(Lambda)
$

可以发现等式 $T bm(S)=bm(S)bm(Lambda)$ 中的 $bm(Lambda)$ 即基偶 ${bm(S),bm(S)}$ 下的线性变换矩阵，这也是最简的线性变换矩阵，称为线性变换 $T$ 的*对角化*。

然而并不是每个线性变换都可以对角化的，仅当满足以下等价条件之一，线性变换才可以对角化
- 线性变换 $T$ 有 n 个线性无关的特征向量
- $dim bold(V)_(lambda_i)=n_i,1 lt.eq i lt.eq n$ 即所有特征值代数重数与几何重数相同（代数重数均为 1 一定成立）
- $bold(V)_(lambda_1) plus.circle dots plus.circle bold(V)_(lambda_n) = bold(V)^n$

=== 线性变换的特征值与对角化例子

此处给出一个线性变换特征值计算例子：定义在多项式线性空间 $bold(P)_(2(t))$ 下的线性变换 $T$ 满足：

$
  T[p(t)]=p(t)+(t+1)(d)/(d t)p(t)
$

首先取一组线性空间 $bold(P)_(2(t))$ 的基 ${alpha_i}={1,t,t^2}$，有相应线性变换结果 ${1,1+2t,2t+3t^2}$，取各个结果在 ${alpha_i (t)}$ 下的坐标可得线性变换矩阵 $bm(X)$ 与线性变换的特征多项式：

$
  bm(X)=mat(1, 1, 0; 0, 2, 2; 0, 0, 3),det(bm(X)-lambda bm(I))=(1-lambda)(2-lambda)(3-lambda)
$

因此线性变换 $T$ 有特征值 $lambda_i=1,2,3$，对应的特征向量分别来自如下特征空间

$
  N(mat(0,1,0;0,1,2;0,0,2)),N(mat(-1,1,0;0,0,2;0,0,1)),N(mat(-2,1,0;0,-1,2;0,0,0))
$

由于代数重数为 $1$，因此几何重数也为 $1$，只需任找出一个 $bm(A)arrow(x)=arrow(0)$ 的解即可作为对应特征向量在基 ${alpha_i (t)}$ 的坐标。可得三个特征向量的坐标所在线性空间为 $"span"{mat(1,0,0)^T},"span"{mat(1,1,0)^T},"span"{mat(1,2,1)^T}$。

将以上三个线性空间表示为多项式线性组合的形式即线性变换 $T$ 的特征向量。因此特征值 $lambda_1=1$ 有特征向量 $k_1$；特征值 $lambda_1=2$ 有特征向量 $k_2(1+t)$；特征值 $lambda_3=3$ 有特征向量 $k_3(1+2t+t^2)$。其中 $k_1,k_2,k_3$ 可取任意实数。

== 方阵的相似化简

=== 特征值性质补充

此处再不加证明的给出以下特征值的性质：
- 定义方阵 $bm(A)$ 对角线上的元素之和称为*迹* $tr(A)$，则 $bm(A)$ 的迹等于其特征值之和, 可用该性质寻找最后一个特征值。
- 方阵 $bm(A)$ 的行列式等于其特征值之积，同时矩阵的行列式也等于其特征方程中的常数项乘以 $(-1)^n$
- 方阵 $bm(A)$ 有特征值 $lambda_i$, 则矩阵数乘 $k bm(A)$ 有特征值 $k lambda_i$
- 方阵 $bm(A)$ 有特征值 $lambda_i$, 则矩阵与单位矩阵运算 $bm(A)+k bm(I)$ 有特征值 $lambda_i+k$, 且对应特征值的特征向量相同, 简单证明如下（注意对于任意两个矩阵 $bm(A),bm(B)$, 其和与积的特征值不存在特殊性质）$ (bm(A)+k bm(I))arrow(x)=lambda_i arrow(x)+k arrow(x)=(lambda_i+k)arrow(x) $
- 方阵 $bm(A)$ 以及其转置 $bm(A)^T$ 具有相同的特征值
- 方阵 $bm(A)$ 的逆 $bm(A)^(-1)$ 的特征值为方阵 $bm(A)$ 特征值 $lambda_i$ 的倒数 $1/lambda_i$


