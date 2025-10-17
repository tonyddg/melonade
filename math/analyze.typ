#import "/book.typ": book-page, cross-link
#show: book-page.with(title: "数值分析")

#import "/utility/widget.typ": *

= 数值分析

考虑近似求解中存在的*截断误差*（现在计算机中，舍入误差通常远小于截断误差）

算法中如果能保证误差逐步缩小 $abs(e_(n-1))>abs(e_(n))$，称为*稳定的算法*

== 函数插值

已知函数 $f(x)$ 的 $n$ 个点 ${f(x_i)}$（称为插值节点），现希望找到一个过这些点的简单函数 $p(x)$ 近似 $f(x)$。一般 $p(x)$ 为多项式或分段多项式，称为插值多项式。

插值问题存在两个问题
- 找到插值多项式 $p(x)$
- 估计插值误差 $abs(f(x)-p(x))$

=== Lagrange <sec:lagrange>

当 $p(x)$ 为 $p(x)=a_0+a_1 x^1 dots a_n x^n$ 的简单多项式时，只要有 $n+1$ 个不重复的插值节点就能得到唯一的 $p(x)$，但直接计算 $p(x)$ 复杂度过大，可用 Lagrange 多项式简化计算过程。

对于插值节点 $f(x_i)$，定义 Lagrange 基函数 $l_i$ 为一个多项式满足 

$
  l_i (x)=cases(1\,x=x_i,0\,x=x_k\,k eq.not i)  
$

可以得出 Lagrange 基函数满足（条件一确定分母，二确定分子）

$
  l_i (x)=product_(k=0\ k eq.not i)^(n)( (x-x_k))/( (x_i-x_k))
$

插值多项式即可通过 Lagrange 基函数的组合表示为：

$
  L(x)=sum_(i=0)^n f(x_i) l_i (x)
$

由于插值多项式唯一，因此 $L(x)=p(x)$

然而 Lagrange 插值中，如果某个插值节点改变或增加新的插值节点时，需要重新计算每个基函数

当 $f(x)$ 足够光滑时可以估计点 $x$ 上的插值余项 $f(x)=p(x)+R(x)$ 满足

$
  R(x)=(f^((n+1))(xi_x))/(n+1)! product_(i=0)^n (x-x_i)
$

其中 $xi_x in (x_0,x_n)$，可根据 $f^((n+1))(xi_x)$ 在 $(x_0,x_n)$ 上的最大与最小值确定 $R(x)$（需要给出判断点 $x$）的范围，即插值误差范围

=== Newton

针对 Lagrange 中添加新节点需要重新计算的问题，Newton 插值通过构造另一种与仅与 $x_0 tilde x_i$ 有关的基函数以解决，每次增加节点仅需添加一个基函数，基函数与插值多项式表达式如下（注意 $n$ 个插值节点，仅需要 $n-1$ 个基函数）：

$
  n_i (x)=product_(k=0)^(i)(x-x_k),space N(x)=sum_(i=0)^(#hl(2)[$n-1$]) c_i n_i (x) 
$

然而 Newton 插值中基函数的系数 $c_i$ 计算较为复杂。由基函数形式可知，根据 $f(x_i)=N(x)$ 计算 $n_i (x)$ 的系数时，基函数 $n_j (x)=0,j>i$，仅与前面基函数的系数有关。

首先定义零阶差商 $f(x_i)$、一阶差商 $f[x_i,x_j]$、二阶差商 $f[x_i,x_j,x_k]$ 有

$
  f[x_i,x_j]=(f(x_i)-f(x_j))/(x_i-x_j),f[x_i,x_j,x_k]=(f[x_i,x_j]-f[x_j,x_k])/(x_i-x_k)
$

因此各阶差商计算具有递推关系

$
  mat(
    delim: #none,
    f(x_0);
    ,arrow.br;
    f(x_1),arrow,f[x_0,x_1];
    ,arrow.br,,arrow.br;
    f(x_2),arrow,f[x_1,x_2],arrow,f[x_0,x_1,x_2];
    ,arrow.br,,arrow.br,,arrow.br;
    f(x_3),arrow,f[x_2,x_3],arrow,f[x_1,x_2,x_3],arrow,f[x_0,x_1,x_2,x_3];
  )
$

以上推导表格中
- 左上差商第一个元素与左侧差商已有元素合并得到下一阶差商
- 箭头表示分子中相减的两个差商（左上减去左侧），分母即差商中最小与最大元素相减

牛顿多项式的系数 $c_i$ 即差商 $f[x_0,dots,x_i]$，也即以上推导表格的对角线（包括零阶差商 $f(x_0)$）

=== Hermite

Hermite 插值是一种特殊的插值问题，除了要求插值多项式的函数值相同，还要求部分节点的导数值也相同。

由差商定义可知，导数即差商在同一个点的极限，简便记为对同一点的差商 $f[x_i,x_i]$

$
  f'(x_i)=lim_(x arrow x_i)f[x_i,x]:=f[x_i,x_i]
$

因此可继续使用 Newton 插值方法计算 Hermite 插值，其中提供了导数条件的插值节点 $f(x_i)$ 即相当于在推导表格中重复加入该节点，其中差商 $f[x_i,x_i]$ 通过额外的导数条件确定。最终 Hermite 插值多项式依然由 Newton 多项式基函数组成，系数依然为推导表格的对角线元素。

对于 Newton 或 Hermite 插值多项式的余项 $R(x)$ 表达式与 #link(<sec:lagrange>)[Lagrange 的形式]相同，导数条件即视为重复节点包含在连乘部分中。

// == 函数逼近

// === 最佳二次逼近

// === 最小二乘逼近

// == 迭代法

// === 线性方程迭代求解

// === 单变量非线性方程

// == 数值积分

// === 插值求积分

// === Gauss 求积分

// == 微分方程数值解

// === Eular 法

// === Runge-Kutta 法