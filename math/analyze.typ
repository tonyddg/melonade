#import "/book.typ": book-page, cross-link
#show: book-page.with(title: "数值分析")

#import "/utility/include.typ": *

#set math.mat(delim: "[")
#set math.vec(delim: "[")

#let ppdm(body, p:[]) = $norm(#body)_#p$

= 数值分析

考虑近似求解中存在的*截断误差*（现在计算机中，舍入误差通常远小于截断误差）

算法中如果能保证误差逐步缩小 $abs(e_(n-1))>abs(e_(n))$，称为*稳定的算法*

== 函数插值 <sec:interpolatory>

已知函数 $f(x)$ 的 $n+1$ 个点 ${f(x_i)}$（称为插值节点），现希望找到一个过这些点的简单函数 $p(x)$ 近似 $f(x)$。一般 $p(x)$ 为多项式或分段多项式，称为插值多项式。

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

// #problem_box(
//   title: [基于 Lagrange 插值的证明题],
//   problem: [
//     证明以下两个等式

//     $
//       (1)& sum_(i=0)^n x_i^(k) l_i (x)=x^k,k=0,1,dots,n\ 
//       (2)& sum_(i=0)^n (x_i-x)^(k) l_i (x)=0,k=0,1,dots,n
//     $
//   ]
// )[
//   (1) 等式左侧即原函数 $f(x)=x^k$ 的拉格朗日插值多项式，又因为 $n+1$ 个节点的拉格朗日多项式能精确反应次数小于等于 $n$ 的多项式，因此等式两边相等。

//   (2) 令
// ]

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

$ product_(i=1)^(n)(x-x_i) $

=== Hermite

Hermite 插值是一种特殊的插值问题，除了要求插值多项式的函数值相同，还要求部分节点的导数值也相同。

由差商定义可知，导数即差商在同一个点的极限，简便记为对同一点的差商 $f[x_i,x_i]$

$
  f'(x_i)=lim_(x arrow x_i)f[x_i,x]:=f[x_i,x_i]
$

因此可继续使用 Newton 插值方法计算 Hermite 插值，其中提供了导数条件的插值节点 $f(x_i)$ 即相当于在推导表格中重复加入该节点，其中差商 $f[x_i,x_i]$ 通过额外的导数条件确定。最终 Hermite 插值多项式依然由 Newton 多项式基函数组成，系数依然为推导表格的对角线元素。

对于 Newton 或 Hermite 插值多项式的余项 $R(x)$ 表达式与 #link(<sec:lagrange>)[Lagrange 的形式]相同，导数条件即视为重复节点包含在连乘部分中。

#problem_box(
  title: [Hermite 插值例题],
  problem: [
    给定 $f(0)=0,f(1)=1,f(0.5)=1,f'(0.5) $ 求三次 Hermite 插值多项式。
  ]
)[
  有差商递推表
  $
    mat(
    delim: #none,
    f(0)&=0;
    ,arrow.br;
    f(0.5)&=1,arrow,2;
    ,arrow.br,,arrow.br;
    f(0.5)&=1,arrow,f'(0.5)=2,arrow,0;
    ,arrow.br,,arrow.br,,arrow.br;
    f(1)&=1,arrow,0,arrow,-4,arrow,-4;
    )
  $

  有插值结果 

  $
    H(x)&=0+2(x-0)+0(x-0)(x-0.5)-4(x-0)(x-0.5)(x-0.5)\
    &=2x-4x(x-0.5)^2
  $

  可使用递推表中最后一个点检查插值是否正确  
]

== 函数逼近

函数逼近中不要求逼近函数 $y(x)$ 完全过所有原函数 $f(x)$ 的已知点，仅要求逼近误差越小越好。

=== 内积空间

为了讨论误差大小，还需要用到内积空间相关理论。内积空间将函数视为一个无限维的向量，并将每个值乘以带权重的微元 $rho(x) d x$，从而将向量相关理论推广到了函数。

对于权函数 $rho(x)$ 与给定区间 $[a,b]$，函数 $f(x),g(x)$ 之间的*内积*定义为（一般取权函数 $rho(x)=1$）

$
  (f,g)=integral_a^b rho(x) f(x) g(x) d x
$

类似向量正交有*函数正交*，定义函数 $f(x),g(x)$ 正交时有 $(f,g)= 0$。

类似正交基有正交函数族，若函数族 ${phi_i (x)}$ 满足以下条件称为*正交函数族*，特别地当 $A_i=1$ 称为标准正交函数族：

$
  (phi_i, phi_j)=cases(0\,&i eq.not j, A_i\, &i=j)
$

例如 $phi_1(x)=1,phi_2(x)=sin(x),phi_3(x)=cos(x),phi_4(x)=sin(2x),dots$ 就是一个正交函数族。

类似线性无关性，若函数族 ${phi_i (x)}$ 在 $[a,b]$ 上得到 $0$ 的线性组合当且仅当全部组合系数为 $0$ 时成立，称函数族 ${phi_i (x)}$ 是*线性无关的函数族*。函数族 ${phi_i (x)}_(n+1)$ 内的函数线性组合可得到新的函数

$
  s(x)=sum^(n)_(k=0) a_k phi_k (x)
$

系数 $a_k$ 可以是任意实数，线性组合函数 $s(x)$ 的全体构成集合 $Phi="span"{phi_i (x)}$

=== 逼近误差 <sec:approach_error>

内积空间也可将向量范数的概念推广到函数上，此时通过原函数与逼近函数间的 p 范数衡量逼近误差，给定权函数 $rho(x)$，函数在区间 $[a,b]$ 的范数定义为

$
  ppdm(p: p, f(x))=[integral_a^b rho(x) f^p (x) d x]^(1/p)
$

对于无穷范数 $p=infinity$，称为一致逼近，误差表示为（由于数学性质较差，理论上少用）：

$
  mat(delim: bar.v.double, f(x)-y(x))_infinity=max_(x in [a,b]) abs(f(x)-y(x)) < epsilon
$

对于 2 范数 $p=2$，称为最小二乘逼近误差（平方逼近误差），误差表示为（等式两侧取平方）：

$
  mat(delim: bar.v.double, f(x)-y(x))_2^2=integral_a^b [f (x)-y(x)]^2 d x < epsilon
$

引入权函数 $rho(x)$，最小二乘逼近误差可以表示为函数内积的形式并展开：

$
  mat(delim: bar.v.double, f(x)-y(x))_2^2&=integral_a^b rho(x) [f (x)-y(x)]^2 d x\
  &=(f-y,f-y)=(f,f)-2(f,y)+(y,y)
$

=== 最佳平方逼近的基本方法

当逼近函数为一个 $n+1$ 个线性无关函数组成的函数族 $phi_k (x)$，需要求出系数 $a_k$ 组合得到逼近函数 $s^*(x)$，使得对于给定的权函数 $rho(x)$ 与原函数 $f(x)$ 在 $[a,b]$ 下的平方误差最小：

$
  s^*(x)=min_(s in Phi) mat(delim: bar.v.double, f(x)-s^*(x))_2^2
$

以上问题等价于求以下多元函数的最小值，将二范数表示为内积并利用线性性展开有：

$
  I(a_0,dots,a_n)&=integral_a^b rho(x)[f(x)-sum_(k=0)^(n) a_k phi_k (x)]^2 d x\ 
  &=(f-sum_(k=0)^(n) a_k phi_k,f-sum_(k=0)^(n) a_k phi_k )\ 
  &=(f,f)-2sum_(k=0)^(n)(f, a_k phi_k)+sum_(k=0)^(n)( a_k phi_k, a_k phi_k)

$

为了求最小值，对以上多元函数各个元素求偏导，待求系数将使偏导数为 $0$ 有

$
  I/(partial a_i)&=2 sum_(k=0)^(n) a_k (phi_k,phi_i) - (f,phi_i)=0
$

由此可以将以上方程展开为一组关于 $a_k$ 的线性方程组，方程系数为 $(phi_k,phi_i)$，等式右侧常量为 $(f,phi_i)$，称为法方程：

$
    sum_(k=0)^(n) a_k (phi_k,phi_i) = (f,phi_i)
$

法方程的矩阵表示为 

$
  mat(
    (phi_0,phi_0), (phi_0,phi_1), dots, (phi_0,phi_n);
    (phi_1,phi_0), (phi_1,phi_1), dots, (phi_1,phi_n);
    dots.v,dots.v,dots.down,dots.v;
    (phi_n,phi_0), (phi_n,phi_1), dots, (phi_n,phi_n);
  ) 
  mat(a_0;a_1;dots.v;a_n)
  =mat((f,phi_0);(f,phi_1);dots.v;(f,phi_n))
$

为了计算误差，先对法方程各等式进行转化后相加可以推出

$
  sum_(k=0)^(n) a_k (phi_k,phi_i) &= (f,phi_i)\ 
  sum_(i=0)^(n)(s^*,phi_i)&=sum_(i=0)^(n)(f,phi_i)\ 
  (s^*,s^*)&=(f,s^*)
$

对于误差函数 $delta(x)=f(x)-s^*(x)$，最佳平方逼近的误差 $ppdm(p: 2, delta)^2$ 则可表示为

$
  ppdm(p: 2, delta)^2&=(f,f)-2(f,s^*)+(s^*,s^*)\ 
  &=(f,f)-(f,s^*)
$

=== 正交多项式 <sec:othopoly>

法方程求解中，如果能保证函数族为正交函数族则法方程中的系数矩阵将变为对角矩阵，此时法方程能更易于计算机求解。

对于函数族（多项式系） ${g_k (x)}_n$ 中的函数 $g_k (x)$ 为最高次项 $k$ 系数为 1 的多项式，且 ${g_k (x)}_n$ 在区间 $[a,b]$ 与权函数 $rho(x)$ 下为正交函数族，称其中 $g_k (x)$ 为*正交多项式*。

$g_n (x)$ 为正交多项式的充要条件是 $g_n (x)$ 对任意 $n-1$ 次多项式 $p(x)$ 正交，因此可以使用待定系数法通过以下方式求解系数 

$
g_n (x) = x^n + sum_(i=0)^(n-1) a_i x^i arrow cases((g_n (x), x^(n-1))=0,space dots.v,(g_n (x), 1)=0)
$

// 以上计算较为复杂，正交多项式还可通过以下递推关系计算

// $
//   g_(k+1)(x)=(x-u_(k+1))g_k (x)-v_k g_(k-1) (x)\ 
//   u_(k+1)=((x g_k, g_k))/(g_k, g_k), v_k = ((g_k, g_k)) /((g_(k-1), g_(k-1))),v_0=0
// $

当区间为 $[-1,1]$，权函数 $rho(x)=1$，此时的正交多项式称为 *Legendre 多项式* $P_n (x)$，其与首一要求的正交多项式存在系数差 $n!$：

$
  P_n (x)= 1/(2^n n!) (d^n)/(d^n x)[(x^2-1)^n]\ 
  g_n (x)=tilde(P)_n (x)=n! P_n (x)\ 
  (P_n, P_n)=2/(2n+1)
$

实际一般仅使用低次的 Legendre 多项式，常用有

$
P_0 (x) = 1,P_1 (x) = x,P_2 (x) = 1/2(3x^2-1),P_3 (x) = 1/2(5x^3-3x)
$

当区间为 $[-1,1]$，权函数 $rho(x)=1/sqrt(1-x^2)$（来自 $x=cos theta$ 的代换），此时的正交多项式称为 *Chebyshev 多项式* $T_n (x)$，最早用于将机械的旋转运动转化为直线运动的研究，其具有以下表达式

$
  T_n (x)=cos[n arccos (x)]\ 
  T_(n+1) (x)=2x T_n (x)- T_(n-1) (x),T_1 (x)=x,T_0 (x) =1\ 
  (T_n,T_n)=cases(pi/2\,n eq.not 0,pi\,n eq 0)
$

实际一般仅使用低次的 Chebyshev 多项式，常用有

$
  T_0 (x) = 1,T_1 (x) = x,T_2 (x) = 2x^2-1,P_3 (x) = 4x^3-3x
$

对于区间为 $[a,b]$ 的情况，可以使用换元法将原变量 $x in[a,b]$ 转化为 $t in [-1,1]$ 有关系 

$
  x=(a+b)/2+(b-a)/2 t\ 
  t=(2x-(a+b))/(b-a)
$

具体使用时
- 先将给定函数 $f(x)$ 中的变量换元为 $t$ 的到 $h(t)=f[m(t)]$ 的最佳平方逼近 $p(t)$
- 然后将逼近函数 $p(t)$ 再次换元得到所需结果 $q(x)=p[m'(x)]$
- 平方逼近误差有比例 $ppdm(delta(x), p:2)^2=(a+b)/2 ppdm(delta(t), p:2)^2$，因此仅计算 $ppdm(delta(t), p:2)^2$ 即可

根据正交函数族性质可知，使用以上正交函数族的法方程与误差具有如下形式：

$
  mat(
    (phi_0,phi_0), , , ;
    , (phi_1,phi_1), , ;
    , ,dots.down, ;
    , , , (phi_n,phi_n);
  ) 
  mat(a_0;a_1;dots.v;a_n)
  =mat((f,phi_0);(f,phi_1);dots.v;(f,phi_n))
  arrow a_k=((f,phi_k))/((phi_k,phi_k))\

  ppdm(delta, p:2)^2=(f,f)-(f,s^*)=(f,f)-sum_(i=0)^(n) a_i (f,phi_i)
$


#problem_box(
  title: [基于正交多项式的最佳二次逼近问题],
  problem: [
    求 $f(x)=sqrt(x)$ 在区间 $[0,1]$ 上的一次最佳平方逼近多项式
  ]
)[
  令 $x=1/2+1/2 t$ 将 $f(x)$ 换元为 $h(t)$ 有

  $
    h(t)=f(1/2+1/2t)=sqrt((1+t)/2),t in [-1,1]
  $

  一次多项式中有 Legendre 多项式 $P_0 (x)=1,P_1 (x)=x$，求基函数自身内积和与原函数间内积有

  $
    (P_0,P_0)=2,(P_1,P_1)=2/3\ 
    (P_0,f)=1/sqrt(2) integral_(-1)^(1)sqrt(1+t) dot d t=1/sqrt(2) integral_(0)^(2)sqrt(u) dot d (u-1)=1/sqrt(2) dot 2/3 u^(3/2) lr(|, size: #2em)_(0)^2=4/3\ 
    
    (P_1,f)=1/sqrt(2) integral_(-1)^(1)t sqrt(1+t) dot d t=1/sqrt(2) integral_(0)^(2)(u-1)sqrt(u) dot d (u-1)=1/sqrt(2) dot (2/5 u^(5/2)-2/3 u^(3/2)) lr(|, size: #2em)_(0)^2=4/15
  $

  可得到以 $t$ 为变量的逼近函数满足

  $
    a_0=((P_0,f))/((P_0,P_0))=2/3,a_1=((P_1,f))/((P_1,P_1))=2/5,p(t)=2/3+2/5t
  $

  令 $t=2x-1$ 将 $p(t)$ 换元为 $q(x)$ 有

  $
    q(x)=p(2x-1)=4/5x+4/15
  $

]


// === 多项式的最佳平方逼近

// 对于函数族 $phi_k (x)=x^k, rho(x)=1, x in [0,1]$ 有

// $
//   (phi_i,phi_j)=1/(i+j+1), (f,phi_i)=d_i
// $

// 法方程有系数矩阵 $bm(H)$，可以发现元素分母即所谓坐标之和加一：

// $
//   bm(H)=mat(1,1/(2),dots,1/(n+1);1/2,1/3,dots,1/(n+2); dots.v,dots.v,dots.down,dots.v;1/(n+1),1/(n+2),dots,1/(2n+1))
// $

// ==== 离散点逼近

// 当原函数 $f(x)$ 的表达式未知，仅知道其中几个点 ${f(x_i)}_n$，依然可以使用上述方法进行逼近。此时内积所在的区间由连续的 $[a,b]$ 变为 $n$ 个点 ${x_i}_n$，此时函数 $f(x)$ 可表示为向量 $f=mat(f(x_1),dots,f(x_m))^T$，因此函数内积 $(f,g)$ 即向量内积，表示为：

// $
//   (f,g)=sum_(i=1)^(n)f(x_i)g(x_i)
// $

// 由于区间变化，因此之前讨论的连续区间上的正交函数族在离散点上一般不成立，但最佳平方逼近方法依然不变，依然可用法方程方法求解。

=== 最小二乘逼近的基本方法

当原函数 $f(x)$ 的表达式未知，仅知道其中几个点 ${f(x_i)}_m$，依然可以使用上述方法进行逼近。此时内积所在的区间由连续的 $[a,b]$ 变为 $m$ 个点 ${x_i}_m=arrow(x)$，此时函数 $f(x)$ 可表示为向量 $arrow(y)=mat(f(x_1),dots,f(x_m))^T$，因此函数内积 $(f,g)$ 即向量内积，表示为：

$
  (f,g)=sum_(i=1)^(m)f(x_i)g(x_i)=arrow(y) dot g(arrow(x))
$

离散情况下，将平方误差称为*最小二乘误差*

$
  ppdm(f-s, p: 2)^2=sum^(n)_(i=1)[y_i-s(x_i)]^2
$

因此最小二乘逼近与最佳平方逼近问题本质相同：当逼近函数为一个 $n+1$ 个线性无关函数组成的函数族 $phi_k (x)$，需要求出系数 $a_k$ 组合得到逼近函数 $s^*(x)$ ，使得与原函数 $f(x)$ 在离散点 $arrow(x)$ 下的最小二乘误差最小：

$
  s^*(x)=min_(s in Phi) mat(delim: bar.v.double, f-s^*)_2^2
$

因此与最佳平法逼近类似的法方程，通过求偏导可以得到函数系数所满足的方程，此时称为*正规方程*：

$
  mat(
    (phi_0,phi_0), (phi_0,phi_1), dots, (phi_0,phi_n);
    (phi_1,phi_0), (phi_1,phi_1), dots, (phi_1,phi_n);
    dots.v,dots.v,dots.down,dots.v;
    (phi_n,phi_0), (phi_n,phi_1), dots, (phi_n,phi_n);
  ) 
  mat(a_0;a_1;dots.v;a_n)
  =mat((f,phi_0);(f,phi_1);dots.v;(f,phi_n))
$

由于离散情况下函数内积与向量相乘一致，因此可进一步转化正规方程如下，其中 $bm(A)in RR^(m times n)$，基函数线性无关，且离散点大于等于函数族内函数个数（$m gt.eq n$），时矩阵 $bm(A)^T bm(A)$ 一定可逆，方程一定有解。

$
  bm(A)=mat(phi_0(arrow(x)),dots,phi_n (arrow(x))) arrow bm(A)^T bm(A)arrow(a)=bm(A)^T arrow(y)
$

最小二乘误差满足

$
  ppdm(p: 2, delta)^2&=(f,f)-(f,s^*)
  =arrow(y)^T arrow(y)-(arrow(y)^T bm(A))arrow(a)\ 
  &=arrow(y)^T (arrow(y)-bm(A)arrow(a))
$

=== 离散点的正交多项式

正规方程求解中，同样面临计算机不易求解的问题。同样可以用正交多项式的方法保证矩阵为对角矩阵。注意，由于区间变化，因此之前讨论的连续区间上的正交函数族在离散点上一般不成立。

对于给定离散点 $arrow(x)$ 下的正交多项式 $g_k (x)$（$g_k (x)$ 为最高次项 $k$ 系数为 1 的多项式）可以通过以下递推公式求出

$
  g_(k+1)(x)=(x-u_(k+1))g_k (x)-v_k g_(k-1) (x)\ 
  u_(k+1)=((x g_k, g_k))/((g_k, g_k)), v_k = ((g_k, g_k)) /((g_(k-1), g_(k-1))),v_0=0
$

同样的，此时的系数 $a_k$ 可以直接得到，有

$
  a_k=((f,g_k))/((g_k,g_k))
$

最小二乘误差具有如下形式（其中 $bm(A)^T bm(A)$ 为以 $(g_k,g_k)$ 为元素的对角矩阵）：

$
  ppdm(delta, p:2)^2=arrow(y)^T (arrow(y)-bm(A)arrow(a))=arrow(y)^2-arrow(a)^T (bm(A)^T bm(A))arrow(a)
$

#problem_box(
  title: [基于正交多项式的最小二乘逼近问题],
  problem: [
    已知数据

    #table(
      columns: (1fr, ) * 6,
      [$x_i$], [-2], [-1], [0], [1], [2],
      [$y_i$], [0], [1], [2], [1], [0]
    )

    求这些数据的二次最小二乘逼近多项式
  ]
)[
  通过正交多项式作为基函数，可通过一下表格统筹递推基函数所需的计算

  #table(
    columns: (2fr,) + (1fr, ) * 9,
    [], [$f(x_1)$], [$f(x_2)$], [$f(x_3)$], [$f(x_4)$], [$f(x_5)$], [$(,g_i)$], [$(f,g_i)$], [$u_(i+1)$], [$v_(i)$],
    [$g_0=1$], [1], [1], [1], [1], [1], [5], [4], [], [],
    [$x g_0=x$], [-2], [-1], [0], [1], [2], [2], [], [0], [0],

    table.cell(colspan: 10, inset: 1pt)[],

    [$g_1=x$], [-2], [-1], [0], [1], [2], [10], [0], [], [],
    [$x g_1=x^2$], [4], [1], [0], [1], [4], [0], [], [0], [2],

    table.cell(colspan: 10, inset: 1pt)[],

    [$g_2=x^2-2$], [2], [-1], [-2], [-1], [2], [14], [-6], [], [],

  )

  通过表格可得出 $a_0=4/5,a_1=0,a_2=-6/14=-3/7$

  有插值多项式 $p(x)=4/5-3/7(x^2-2)=58/35-3/7 x^2$
]


=== 非线性逼近函数的线性化

以上讨论中均认为逼近函数为简单函数的线性组合，但当逼近函数为复杂的待定系数函数时，需要将其线性化，常见的线性化方案如下：

- 当 $y=p(x)=x/(a x+b)$，可以令 $x'=1/x;y'=1/y$，此时有 $y'=a+b x'$
- 当 $y=p(x)a e^(-b/x)$，可以令 $x'=1/x;y'=ln y;a'=ln a$，此时有 $y'=a'+b x'$

=== 线性方程的最小二乘解

从投影角度下的线性方程最小二乘解可#link("https://tonyddg.github.io/noteverse/course/math/Linear_Algebra/ch4.html#%E6%9C%80%E5%B0%8F%E4%BA%8C%E4%B9%98%E6%B3%95%E4%B8%8E%E6%AD%A3%E8%A7%84%E6%96%B9%E7%A8%8B")[参见]。

对于任意线性方程组 $bm(A)arrow(x)=arrow(y)$，方程可能无解，但又希望找到一组解 $arrow(hat(x))$ 使得方程两侧 $bm(A)arrow(hat(x)),arrow(y)$ 的二次误差尽可能小，称其为*最小二乘解*。

易得 $arrow(hat(x))$ 即正规方程 $bm(A)^T bm(A) arrow(hat(x))=bm(A)^T arrow(y)$ 的解。由于方程两侧的向量都来自矩阵 $bm(A)^T$ 列向量的线性组合，因此方程一定有解。

当 $bm(A)$ 列不满秩时，可能有多个最小二乘解，可以取 $bm(A)$ 的主元列构成 $tilde(bm(A))$ 代替 $bm(A)$，$arrow(x)$ 中非主元列的元素置零，求其中一个最小二乘解。

#problem_box(
  title: [线性方程的最小二乘解问题],
  problem: [
    求以下线性方程组的一个最小二乘解

    $
      mat(0,2,0;1,0,2;0,1,0)arrow(x)=mat(1;1;1)
    $
  ]
)[
  $because$ 线性方程中的矩阵 $bm(A)$ 第三列与前两列线性相关

  $therefore$ 令 $x_3=0$，取 $bm(A)$ 的第一、二列构造如下正规方程

  $
    mat(0,1,0;2,0,1)mat(0,2;1,0;0,1) hat(x)=mat(0,1,0;2,0,1)mat(1;1;1) arrow hat(x)=mat(1;3/5) 
  $

  $therefore$ 线性方程有一个最小二乘解 $hat(x)=mat(1,3/5,0)^T`$
]

== 数值积分

当原函数 $f(x)$ 的表达式未知，仅知道其中几个点 ${f(x_i)}_(n+1)$，无法使用莱布尼兹公式进行积分，只能用数值积分方法近似求解。

数值积分中，除了构造求积公式，还需要
- 考虑其精度等级以比较不同方法的好坏
- 确定余项估计方法以确定方法在具体问题中的误差大小

当求积公式对次数不超过 $m$ 的多项式准确成立，但对 $m+1$ 次多项式不一定准确，称公式具有 $m$ 次*代数精度*。可以令原函数 $f(x)=x^(m+1)$，检查求积公式与实际结果是否相等判断求积公式的代数精度。

// === 基于中值定理的求积公式

// 根据积分中值定理

// $
//   integral^(b)_(a) f(x)d x=(b-a)f(xi),xi in (a,b)
// $

// 可以用不同方法估计 $f(xi)$，本质即将原函数曲线与坐标轴围成的面积近似为矩形、梯形、抛物线梯形的面积

// $
//   integral^(b)_(a) f(x)d x &approx (b-a) f((a+b)/2),"中矩公式",m=1\ 
//   integral^(b)_(a) f(x)d x &approx (b-a) (f(a)+f(b))/2,"梯形公式",m=1\ 
//   integral^(b)_(a) f(x)d x &approx (b-a) (f(a)+4f((a+b)/2)+f(b))/6,"Simpson 公式", m=3
// $

=== 插值型求积公式 <sec:poly_intergral>

对于区间 $[a,b]$ 上的 $n+1$ 个点 $arrow(x)={x_i}_(n+1)$，假设求积公式为各个点上函数值 $arrow(y)=f(arrow(x))$ 的线性组合 $arrow(a)$，有

$
  I=integral_a^b f(x) d x=sum_(i=0)^n a_i f(x_i)=arrow(a) dot arrow(y)
$

可以假设原函数为 $f(x)=1,x,dots,x^n$，此时积分准确结果满足 $I=(b^(n+1)-a^(n+1))/(n+1)$，从而利用代数精度定义构造求积公式

$
  mat(
    1,1,dots,1;
    x_0,x_1,dots,x_n;
    dots.v, dots.v,dots.down,dots.v;
    x_0^n,x_1^n,dots,x_n^n
  )
  mat(a_0;a_1;dots.v;a_n)=
  mat(b-a;(b^(2)-a^(2))/(2);dots.v;(b^(n+1)-a^(n+1))/(n+1))
$

由此得到的求积公式将具有至少 $n$ 次的代数精度，因此如果要构造 $n$ 次代数精度的求积公式，取 $n+1$ 个节点最保守（对于一些特殊的中间点，可通过令 $f(x)=x^(n+1)$ 检查 $arrow(a)dot arrow(x)^(n+1)=(b^(n+2)-a^(n+2))/(n+2)$ 判断其是否有更高的精度）

然而以上求系数方法还需要解方程，可借助#link(<sec:interpolatory>)[函数插值]，先求出原函数 $f(x)$ 的插值多项式 $p(x)$，再用插值多项式的积分近似原函数的积分，称为*插值型求积公式*有

$
  I=integral_a^b f(x) d x approx   sum_(i=0)^n c_i integral_a^b  l_i (x) d x
$

对于 Lagrange 插值有 $c_i=f(x_i)$，此时求积公式中的系数 $a_i$ 满足
 $a_i=integral_a^b  l_i (x) d x$（使用 Largrange 基函数代替 $f(x)=1,x,dots,x^(n)$ 可得到相同结果）。

利用 $f(x)=1,integral_(a)^(b) f(x)=b-a=sum_(i=0)^n a_i$ 可知插值系数之和一定等于积分区间大小 $b-a$

=== Newton-Cotes 积分公式

当求积公式节点等距分布时，利用变量代换可将 $[0,1]$ 区间的求积公式推广到任意区间

$
  integral^(1)_(0) f(x)d x &approx sum_(i=0)^(n) c_i^((n)) f((i)/n) arrow integral^(b)_(a) f(x)d x &approx (b-a)sum_(i=0)^(n) c_i^((n)) f[(i)/n (b-a)+a]
$

Newton-Cotes 积分公式有特性：
- 对于 $n+1$ 个节点，使用奇数个节点（$n$ 为偶数）时有 $n+1$ 的代数精度，偶数个节点仅有 $n$ 的代数精度 
- 节点数大于等于 $9$ 时公式稳定性将得不到保证

由此有常用的插值型求积公式及其余项（其中，$xi in [a,b]$）：
- 梯形公式，节点数 $n+1=2$，代数精度 $m=1$, #h(1fr)$
integral^(b)_(a) f(x)d x approx (b-a) (f(a)+f(b))/2,R[f]=-1/12 (b-a)^3 f^((2))(xi)
$
- Simpson 公式，节点数 $n+1=3$，代数精度 $m=3$, $
integral^(b)_(a) f(x)d x approx (b-a) (f(a)+4f((a+b)/2)+f(b))/6,R[f]=-1/90 ((b-a)/2)^5 f^((4))(xi)
$

=== 复化求积公式

根据余项公式可知，当求积区间越大，积分误差越大，且有 Runge 现象。因此可以通过将求积区间 $[a,b]$ 分割为多个小区间再分别使用求积公式，从而用更小的计算量得到更精确的积分结果。

如果基于梯形公式，将区间 $[a,b]$ 按 $n+1$ 个节点划分，分别求积有（当节点间距固定为 $h=(b-a)/n$ 可进一步化简）

$
  integral^(b)_(a) f(x)d x approx sum_(i=0)^(n-1) (x_(i)-x_(i+1)) (f(x_i)+f(x_(i+1)))/2=h/2[f(a)+2 sum^(n-1)_(i=1) f(x_k)+f(b)]
$

如果基于 Simpson 公式，将区间 $[a,b]$ 等距 $h=(b-a)/n$ 划分为 $n+1$ 个节点，再取出子区间中间节点 $x_(i+1/2)$，分别求积有（实际的节点间距为 $(b-a)/(2n)$）

$
  integral^(b)_(a) f(x)d x approx h/6 [f(a)+4 sum^(n-1)_(i=0) f(x_(i+1/2)) + 2 sum^(n-2)_(i=0) f(x_(i+1)) + f(b)]
$

以上复化求积公式的余项计算方法相同，仅需要将 $b-a$ 替换为子区间 $h$，且 $xi in [a,b]$

=== Gauss 积分公式

Gauss 积分公式同样基于插值型积分公式，但选取特定的节点以求仅用更少的节点得到更高的代数精度，可用于原函数 $f(x)$ 已知的情况。

Gauss 积分公式首先考虑 $[-1,1]$ 的积分区间，选择 $n+1$ 次 #link(<sec:othopoly>)[Legendre 多项式]的 $n+1$ 个根作为插值型积分公式的节点，此时的积分公式将有 $2n+1$ 的代数精度（可证明的给出节点数下能达到的最高精度），这些节点也称为 *Gauss 点*。

由于 Gauss 积分公式依然属于插值型求积公式，因此依然可 #link(<sec:poly_intergral>)[基于 Lagrange 插值求系数]。

例如
- 二次 Legendre 多项式 $P_2(x)=(3x^2-1)/2$ 有根 $x_(0,1)=plus.minus 1/sqrt(3)$，$n=1$，可求出有 3 次代数精度的求积公式 $
integral_(-1)^(1) f(x) d x=f(-1/sqrt(3))+f(1/sqrt(3))
$ 
- 三次 Legendre 多项式 $P_3(x)=(5x^3-3x)/2$ 有根 $x_(0,2)=plus.minus sqrt(3/5),x_(1)=0$，$n=2$，可求出有 5 次代数精度的求积公式 $
integral_(-1)^(1) f(x) d x=5/9 f(-sqrt(3/5))+8/9 f(0)+5/9 f(sqrt(3/5))
$ 

// 当权函数不为 $rho(x)=1$，无法使用 Legendre 多项式寻找节点（即对于 $integral_(-1)^(1)rho(x)f(x)$ 积分的求积公式），需要寻找与使用对应正交多项式的根作为节点。如 $n=1$ 时使用待定系数法令 $p_2(x)=x^2+a x+b$ 依据线性方程 $(p_2,1)=0,(p_2,x)=0$ 求解待定系数。例如取权函数 $rho(x)=1/sqrt(1-x^2)$ 时，需要使用 #link(<sec:othopoly>)[Chebyshev 多项式]作为正交多项式，此时有求积公式（积分公式系数均为 $pi/(n+1)$）：

// $
//   integral_(-1)^(1)f(x)/sqrt(1-x^2) d x=pi/(n+1)sum_(k=0)^n f[cos((2k+1)/(2(n+1))pi)]
// $

Gauss 积分中，通过选择特定的权函数 $rho(x) eq.not 1$ 下的正交多项式的根作为 Gauss 点，也可以构建 Gauss 积分公式。由于权函数的加入积分公式变为以下形式，需要将权函数的倒数整合在系数部分以消除权函数对积分计算的影响：

$
integral_(-1)^(1)rho(x) [f(x)/rho(x)] d x=sum_(i=0)^(n)a_i/rho(x_i) f(x_i)
$

以 #link(<sec:othopoly>)[Chebyshev 多项式]作为正交多项式为例，此时有求积公式（积分公式系数均为 $pi/(n+1)$）：

$
  integral_(-1)^(1)1/sqrt(1-x^2)[f(x)sqrt(1-x^2)] d x=pi/(n+1)sum_(k=0)^n  sqrt(1-cos^2((2k+1)/(2(n+1))pi)) dot f[cos((2k+1)/(2(n+1))pi)] dot 
$

由于实际被积函数是 $f(x)/rho(x)$，因此在讨论这类积分公式的代数精度时，需要考察多项式 $f(x)/rho(x)$，而不是 $f(x)$，例如以上基于 Chebyshev 多项式的求积公式求 $f(x)=1$ 存在误差，但能准确反映 $f(x)=1/sqrt(1-x^2)$ 的积分结果。

不同权函数下得到的求积公式习惯上称为 Gauss-\<正交多项式类型\> 积分公式。这些公式间无法直接比较精度，但根据权函数的特性，如 Chebyshev 的 $rho(x)=1/sqrt(1-x^2)$ 在区间两端权重更大，因此对于两端剧烈变化的被积函数如 $f(x)=1/(1-x^2)$ 使用基于 Gauss-Chebyshev 积分公式得到的结果误差更小。

对于任意区间 $x in [a,b]$ 下使用 Gauss 积分公式前需要进行换元有

$
  x=((a+b)+(b-a)t)/2,integral_(a)^(b) f(x)d x=(b-a)/2 integral_(-1)^(1) f[((a+b)+(b-a)t)/2]d t\ 
  arrow integral_(a)^(b) f(x)d x=(b-a)/2 sum_(i=0)^n a_i f[((a+b)+(b-a)t_i)/2]
$

当权函数不为 $rho(x)=1$ 时，任意区间 $x in [a,b]$ 下积分时依然仅使用 $t in [-1,1]$ 区间的权函数，即直接使用 $rho(t)$，不需要对权函数做额外变量代换，有

$
  integral_(a)^(b)rho(t) [f(x)/rho(t)] d x=(b-a)/2 sum_(i=0)^n a_i/(rho(t_i)) f[((a+b)+(b-a)t_i)/2]
$

#problem_box(
  title: [不同权函数的 Gauss 积分公式问题],
  problem: [
    分别使用 3 节点的 Gauss-Legendre 求积公式和 3 节点的 Gauss-Chebyshev 求积公式计算以下积分

    $
      integral_(0)^(1/3)(6x)/sqrt(x(1-3x)) d x
    $
  ]
)[
  根据积分区间有 $x=(1+t)/6$，使用 Legendre 正交多项式时有

  $
  integral_(0)^(1/3)(6x)/sqrt(x(1-3x)) d x=1/6[5/9f((1-sqrt(3/5))/6)+8/9f(1/6)+5/9f((1+sqrt(3/5))/6)] approx 1.5275
  $

  使用 Chebyshev 正交多项式时有

  $
  &space integral_(0)^(1/3)(6x)/sqrt(x(1-3x)) d x\ &=1/6 dot pi/3 [ f((1-sqrt(3/4))/6)sqrt(1-(-sqrt(3/4))^2)+f(1/6)sqrt(1-(0)^2) +f((1+sqrt(3/5))/6)sqrt(1-(sqrt(3/4))^2) ]\  &approx 1.8138 ("误差更小")
  $
]

== 微分方程数值解

考虑一阶常微分方程的初值问题

$
  cases((d y)/(d x)=f(x, y),y(a)=y_0\,x in [a,b])
$

数值方程中首先会离散化有效区间 $[a,b]$ 为小区间，然后使用以下两种思路求解小区间下的解
- 使用适当的差商近似导数 $(d y)/(d x) approx (y(x_(k+1))-y(x_k))/(x_(k+1)-x_k)$
- 将常微分方程转为积分 $y(x_(k+1))-y(x_k)=integral_(x_k)^(x_(k+1)) f[x,y(x)] d x$

=== Eular 法

Eular 法中将区间 $[a,b]$ 按间隔 $h$ 离散为 $x_k=a+h k$，并用差商近似导数 $(d y)/(d x)=f(x, y)$，从而得到数值解 $y_k$ 的迭代公式

使用前向差商法时，将差分近似为点 $x_k$ 的导数有，称为显式欧拉法，具有一阶精度

$
  (d y)/(d x) lr(bar.v, size: #2em)_(x_(k)) approx  (y(x_(k+1))-y(x_k))/(h) arrow y(x_(k+1)) approx y_(k+1) = h f(x_k, y_k)+y_k
$

使用后向差商法时，将差分近似为点 $x_(k+1)$ 的导数有，该方法 $y_(k+1)$ 出现在迭代式右侧，虽然更稳定但迭代完还要逆向求解，称为隐式欧拉法，具有二阶精度

$
  (d y)/(d x) lr(bar.v, size: #2em)_(x_(k+1)) approx (y(x_(k+1))-y(x_k))/(h) arrow y(x_(k+1)) approx y_(k+1) =  h f(x_(k+1), y_(k+1))+y_k
$

使用梯形公式时，将差分近似为点 $x_k,x_(k+1)$ 导数的平均值，同时用显示欧拉得到的 $tilde(y)_(k+1)$ 近似实际值避免逆向求解，称为改进欧拉法（不近似时称为梯形欧拉公式）

$

  (d y)/(d x) lr(bar.v, size: #2em)_(x_(k))+(d y)/(d x) lr(bar.v, size: #2em)_(x_(k+1)) approx 2/h [y(x_(k+1))-y(x_k)] arrow \ y(x_(k+1)) approx y_(k+1) =  h/2 [f(x_(k+1), tilde(y)_(k+1))+ f(x_(k), y_(k))]+y_k, space tilde(y)_(k+1) = h f(x_k, y_k)+y_k space 
$

=== 微分方程数值解的误差

由于差商近似导数一定存在误差，因此以上迭代公式的误差将不断积累

为了估计数值解的误差大小，通过将精确解与数值解的误差 $T_(n+1) (h) = y(x_n+h)-y_(n+1)$ 在点 $x_n$ 泰勒展开，其扰动项即间隔 $h$，有

$
  T_(n+1) (h) = y(x_n+h)-y_(n+1) =y(x_n)+y'(x_n)h + (y''(x_n))/2 h^2 + O(h^3) - y_(n+1)
$

确定展开多项式中第一个系数非 $0$ 的项 $h^k$，表明公示与间隔 $h$ 的 $k$ 次方有关，记为 $O(h^k)$，称为 $k-1$ 阶*整体精度*。由于 $h<1$ 因此次数越高精度越高。

认为 $y_(n+1)$ 的迭代公式中使用真实值，因此求解误差时有以下技巧
- 原始迭代公式中 $f(x_(k+1),y_(k+1))$ 可直接视为 $y'(x_k+h)$，再对其泰勒展开 $y'(x_k+h)=y'(x_k)+y''(x_k)h+O(h^2)$
- 真实值泰勒展开中 $y'(x_k)$ 满足 $ y'(x)=f(x,y) $
- 真实值泰勒展开中 $y''(x_k)$ 满足 $ y''(x) = f(x,y)/(d x)=(f_x (x,y)d x+f_y (x, y) d y)/(d x)=f_x (x,y)+f_y (x,y)f(x,y) $
- 真实值泰勒展开中 $y'''(x_k)$ 满足 $ y'''(x) = f_(x x)+2f_(x y) + f_(y y)f^2 + f_x f_y + f_y^2 f $
- 记号 $O(h)$ 即 $h arrow 0$ 的等价无穷小，认为 $h O(h^k)=O(h^(k+1))$

原始迭代公式不直接取 $x_(n+1)=x_n+h$ 而是中间某一点如 $f(x_n+a h,y_n+ b h)$ 需要二维泰勒展开

$
  f(x_n+a h,y_n+ b h)=f(x_n,y_n)+f_x (x_n,y_n) a h+ f_y (x_n,y_n) b h + O(h^2)
$

微分方程数值解方法精度越高，对方程解高阶导数连续性要求也越高，当高阶导数不存在或不光滑也不能保证解的准确性。

#problem_box(
  title: [微分方程数值解公式的精度分析],
  problem: [
    求以下微分方程数值解公式的整体精度

    $
      y_(n+1)=y_n + h f[x_n + h/2, y_n + h/2 f(x_n, y_n)]
    $
  ]
)[
  对迭代公式 $y_(n+1)$ 做泰勒展开有

  $
    y_(n+1)&=y_n + h [f(x_n, y_n)+h/2 f_x (x_n, y_n) + (h )/2 f(x_n, y_n) f_y (x_n, y_n)+O(h^2)]\
    &=y_n+ h y' + h^2/2 y'' + O(h^3)
  $

  原函数泰勒展开有

  $
    y(x_n + h)=y_n+ h y' + h/2 y''+h^3/6 y''' + O(h^4)
  $
  
  因此误差 $T_(n+1) (h) = y(x_n+h)-y_(n+1)=O(h^3)$，公式具有 2 阶整体精度
]

=== Runge-Kutta 法

单步递推的显示欧拉法与改进欧拉法本质为寻找一个斜率恰好链接 $y_(k+1),y_k$ 两点有 $y_(k+1)=h K_m+y_k$。而这个斜率 $K_m$ 可通过常微分方程的导数 $f(x,y)$ 估计：
- 与改进欧拉法类似，可先预测精度较低的斜率，再线性组合得到精度高的斜率
- 取点时不一定仅取 $x_(k),x_(k+1)$，还可以取中间点 $x_(k)+p h$，此时有 $y$ 的估计 $y_(k)+p h K$

由此可构造二阶 Runge-Kutta 法数值求积公式，其中系数 $lambda_1,lambda_2,p$ 可依据使公式误差尽量小求出

$
  cases(
    y_(n+1)=y_n + h [lambda_1 K_1 + lambda_2 K_2],
    K_1=f(x_n,y_n),
    K_2=f(x_n + p h, y_n + p h K_1) 
  )
$

对于形如 $K_2=f(x_n + p h, y_n + p h K_1)$ 在 $(x_n,y_n)$ 关于 $h$ 的二维泰勒展开

$
  K_2&=f(x_n + p h, y_n + p h K_1)\ 
  &=f(x_n,y_n)+f_x (x_n,y_n) p h+ f_y (x_n,y_n) p h K_1 + O(h^2)\ 
$

然后代入 $y_(n+1)$ 可得到（将 $f(x_n,y_n)$ 简记为 $f$）

$
  y_(n+1)&=y_n+h[(lambda_1+lambda_2) f+lambda_2 p h (f_x+ f_y f)]\ 
  &=y_n+(lambda_1+lambda_2)h y'+lambda_2 p h^2 y''+O(h^3)
$

对比 $y(x_(n+1))$，可得到系数满足的方程

$
  y(x_(n+1))=y_n+h y' + h^2/2 y''+O(h^3) arrow cases(lambda_1+lambda_2=1,lambda_2 p=1/2)
$

因此
- 二阶的 Runge-Kutta 方法具有二阶精度 
- 二阶的 Runge-Kutta 方法存在无数种系数选择均能成立（高阶 Runge-Kutta 方法同）

仅二、三、四阶 Runge-Kutta 方法阶数与精度恰好相等，实际中较多使用二与四阶 Runge-Kutta 方法

=== 微分方程数值解的收敛性与稳定性

只要截断误差可以写为 $O(h^n)$ 的形式，那么数值解方法一定收敛，且上述方法均收敛。

收敛性仅表明当 $h$ 足够小就能得到精确解，但需要多小的 $h$ 才能让解的误差可接受而不会发散，即稳定性所考虑的。定义算法产生的误差在计算过程中每一步都逐步衰减称为*绝对稳定*。

为了验证微分方程数值解方法的稳定性，通常会构造如下的微分方程，称为*实验方程*（系数 $lambda$ 可以是任意复数，要求实部 $Re(lambda)<0$，方程的解 $y(x)$ 一定趋于 $0$）

$
  cases(y'=lambda y\, Re(lambda)<0 ,y(0)=1) arrow y=exp(lambda x) 
$

由于导数 $y'=lambda y$ 仅和 $y$ 有关，因此可将微分方程数值解方法的递推公式写为关于 $y_n$ 的等比数列 $y_(n+1)=g(h lambda) y_(n)$。因此当等比数列随 $n$ 增大趋于 $0$（即比例的绝对值满足 $abs(g(h lambda))<1$）则认为方法#hl(2)[关于给定的 $lambda,h$ 绝对稳定]。

#problem_box(
  title: [微分方程数值解公式的稳定性分析],
  problem: [
    求以下微分方程数值解公式求解时 $f(x,y)=lambda y$，使求解绝对稳定的 $h$ 的区间，其中 $lambda<0$

    $
      y_(n+1)=y_n + h f[x_n + h/4, y_n + h/4 f(x_n, y_n)]
    $
  ]
)[
  将 $f(x,y)=lambda y$ 带入迭代公式有

  $
    y_(n+1)&=y_n + h f[x_n + h/4, y_n + h/4 f(x_n, y_n)]\
    y_(n+1)&=y_n + h lambda[y_n + h/4 lambda y_n]\ 
    y_(n+1)&=y_n (1+h lambda+(h^2 lambda^2)/4)
  $

  严格收敛时有

  $
    abs(1+h lambda+(h^2 lambda^2)/4)&lt 1\ 
    ((h lambda)/2+1)^2 &lt 1\
    0 lt h &lt -4/lambda 
  $

  因此严格收敛时间隔满足 $h in (0, -4/lambda)$

]

== 线性方程组数值求解

迭代求解即从对解的一个不准确的解 $x^((0))$ 开始，通过构造的数值方法求出相对较准确的解 $x^((1))$，重复 $k$ 次即可得到误差较小的解。

=== 线性方程迭代求解

对于线性方程 $bm(A)arrow(x)=arrow(b)$ 可以改写为等价形式 $arrow(x)=bm(B)arrow(x)+arrow(y)$，即可得到线性方程一般迭代公式。对于 $m times m$ 的方阵，相比计算复杂度为 $m^3$ 的矩阵求逆，以下迭代公式的计算复杂度为 $k m^2$。

$
  arrow(x)^((k+1))=bm(B)arrow(x)^((k))+arrow(y)
$

在 Jacobi 迭代法中，将线性方程组写为 $x_i$ 关于 $x_0,dots,x_(i-1),dots,x_(k)$ 的方程组，如

$
  cases(x_0^((n+1))=b_(01) x_1^((n))+b_(02) x_2^((n))+f_0,x_1^((n+1))=b_(10) x_0^((n))+b_(12) x_2^((n))+f_1,x_2^((n+1))=b_(20) x_0^((n))+b_(21) x_1^((n))+f_2)
$

上述迭代公式用矩阵表示时，可以将矩阵 $bm(A)$ 分为对角、上三角、下三角三个部分有 $bm(A)=bm(D)+bm(L)+bm(U)$，可得到 Jacobi 迭代法的矩阵表示：

$
  bm(A)arrow(x)&=arrow(b)\ 
  (bm(D)+bm(L)+bm(U))arrow(x)&=arrow(b) &arrow bm(B)_J=-bm(D)^(-1)(bm(L)+bm(U)),arrow(f)_J=bm(D)^(-1)arrow(b)\ 
  bm(D)arrow(x)&=-(bm(L)+bm(U))arrow(x)+arrow(b)\ 
  arrow(x)&=-bm(D)^(-1)(bm(L)+bm(U))arrow(x)+bm(D)^(-1)arrow(b)
$

Gauss-Seidel 迭代法在 Jacobi 迭代法基础上改进，即每当计算出 $x_i^((n+1))$ 后立刻用于 $x_(i+1)^((n+1))$ 的计算，在迭代速度更快的同时仅需要一个向量记录信息（但收敛性和 Jacobi 方法没有明显优势）。

$
  cases(x_0^((n+1))=b_(01) x_1^((n))+b_(02) x_2^((n))+f_0,x_1^((n+1))=b_(10) x_0^((n+1))+b_(12) x_2^((n))+f_1,x_2^((n+1))=b_(20) x_0^((n+1))+b_(21) x_1^((n+1))+f_2)
$

该迭代法具有如下的矩阵表示（仅用于分析，实际编程中无需具体计算 $bm(B)_G,arrow(f)_G$）

$
  bm(B)_G=-(bm(D)+bm(L))^(-1)bm(U), arrow(f)_G=(bm(D)+bm(L))^(-1)arrow(b)
$

=== 矩阵范数

从向量的 $p$ 范数延申（可#link(<sec:approach_error>)[参见]）可定义矩阵的 $p$ 范数满足

$
  norm(bm(A))_(p)=max_(norm(arrow(x))_p eq.not 0) norm(bm(A)arrow(x))_(p)/norm(arrow(x))_(p) =max_(norm(arrow(x))=1)norm(bm(A)arrow(x))_(p)
$

从几何的角度下，矩阵范数即从对应向量范数在半径为 $1$ 的球面经过线性变换 $bm(A)$ 后在向量范数下最远点的距离。

#figure(
  grid(
    columns: 4,
    column-gutter: 8%,
    row-gutter: 0.5em,
    image("res/p1_norm.png"),
    image("res/p2_norm.png"),
    image("res/p4_norm.png"),
    image("res/pinf_norm.png"),

    [$p-1$ 单位圆], [$p-2$ 单位圆], [$p-4$ 单位圆], [$p-infinity$ 单位圆]
  )
)

其中 $p=1,p=infinity$ 范数的计算较为简单，因此最常使用
- $p=1$ 即#hl(2)[矩阵元素取绝对值]后，各列元素之和中最大的
- $p=infinity$ 即#hl(2)[矩阵元素取绝对值]后，各行元素之和中最大的

=== 线性方程迭代法的收敛性

规定迭代误差为精确值与迭代值的误差同样满足以下迭代公式

$
  arrow(e)^((n+1))&=arrow(x)^(*) -arrow(x)^((n+1))\ 
  arrow(e)^((n+1))&=(bm(B)arrow(x)^(*)+bm(f)) -(bm(B)arrow(x)^((n))+bm(f))\ 
  arrow(e)^((n+1))&=bm(B)arrow(e)^((n))=bm(B)^(n)arrow(e)^((0))
$

由于初始误差 $arrow(e)^((0))$ 为任意向量，因此只要保证 $bm(B)^(n) arrow bm(0)$ 即可保证迭代收敛。

由矩阵多项式相关定理可知，矩阵的幂次下特征向量不变，对应的特征值变为对应幂次，由此得到误差的近似公式

$
  norm(arrow(e)^((n))) approx [rho(bm(B))]^(n) norm(arrow(e)^((0)))
$

其中 $rho(bm(A))$ 称为*谱半径*，等于矩阵 $bm(B)$ 最大特征值 $lambda_(max)$。当矩阵谱半径 $rho(bm(A))<1$ 时，误差将趋于 $0$，迭代收敛。根据以上近似公式可知，如果希望迭代求解 $k$ 次后误差 $norm(arrow(e)^((k)))$ 为初始的 $10^(-t)$，迭代次数需要满足

$
  k gt.eq (t ln 10)/(-ln rho(bm(B)))
$

谱半径 $rho(bm(A))$ 属于一种特殊的矩阵范数，对于任意 $p$ 范数一定有 $rho(bm(A))lt.eq norm(bm(A))_p$，在实际分析矩阵收敛性时通常有以下两种充分条件（如果条件不成立还需要具体计算谱半径）
- 用易于计算的 $p=1$ 或 $p=infinity$ 范数较小的一个代替谱半径。
- 原始线性方程 $bm(A)$ 中，主对角元素的绝对值在所在行是最大值（仅用于 Gauss-Seidel 迭代法）

实际问题求矩阵元素如何取值能让矩阵收敛时，取任意范数计算结果作为合理答案即可

=== 线性方程的误差分析

此处误差考虑的是给定系数 $bm(A)$ 而线性方程组的常数项存在误差 $delta arrow(b)$，有 $arrow(b)'=arrow(b)+delta arrow(b)$。无论用什么方法求解，其对解 $arrow(x)$ 的误差 $delta arrow(x)$ 满足（不考虑 $bm(A)$ 的扰动）

$
  norm(delta arrow(x))_p/norm(arrow(x))_p lt.eq norm(bm(A))_p norm(bm(A)^(-1))_p norm(delta arrow(b))_p/norm(arrow(b))_p
$

称其中误差放大系数 $norm(bm(A))_p norm(bm(A)^(-1))_p$ 为线性方程的*条件数* $"cond"_p (bm(A))gt.eq 1$，当 $"cond"_p (bm(A))$ 越大，系数 $bm(A)$ 越病态，过大的条件数将导致即使精确求解线性方程，结果也没有意义。

实际使用中一般使用 $p=2$ 条件数，也是一般数值分析方法的默认算法，因为有简便公式（$sigma(bm(A))$ 为奇异值，即矩阵 $bm(A)^T bm(A)$ 或 $bm(A) bm(A)^T$ 特征值的平方根）

$
  "cond"_2 (bm(A))=(sigma_(max)(bm(A)))/(sigma_(min)(bm(A)))
$

条件数有以下特性
- 矩阵 $A$ 可逆时一定有 $"cond"_p (bm(A)) gt.eq 1$
- 矩阵 $A$ 可逆时，常数项不影响条件数，$"cond"_p (a bm(A)) = "cond"_p (bm(A))$
- 矩阵 $A$ 正交时，条件数最小有 $"cond"_p (bm(A))=1$

条件数很大的矩阵有如下特点
- 行列式很大或很小，通常是不可逆矩阵加上小扰动得到的可逆矩阵
- 元素间相差极大数量级且无规律
- 特征值相差较大数量级（一般数值分析方法判断算法）

#problem_box(
  title: [线性方程组分析],
  problem: [
    有方程组

    $
      cases(x_1+2x_2-2x_3=1,x_1+x_2+x_3=1,2x_1+2x_2+x_3=1)
    $

    求 (1) 系数矩阵的 $"cond"_1(bm(A))$ 条件数。(2) 求 $(delta arrow(b)+arrow(b))=mat(1.001,0.998,1)^T$ 时解的相对误差 $norm(delta arrow(x))_1/norm(arrow(x))_1$。(3) 写出 Jacobi 与 Gauss-Seidel 迭代的矩阵表示。(4) 证明 Jacobi 迭代收敛。
  ]
)[
  (1) 

  $
    bm(A)=mat(1,2,-2;1,1,1;2,2,1); bm(A)^(-1)=mat(-1,-6,4;1,5,-3;0,2,-1); "cond"_1(bm(A))=norm(bm(A))_1 norm(bm(A)^(-1))_1=5 dot 13=65
  $

  (2)

  $
    norm(delta arrow(b))_1/norm(arrow(b))_1=0.001, norm(delta arrow(x))_1/norm(arrow(x))_1 lt.eq "cond"_1(bm(A)) norm(delta arrow(b))_1/norm(arrow(b))_1=0.065 arrow norm(delta arrow(x))_1/norm(arrow(x))_1 approx 0.065
  $

  (3) 可解出 $arrow(x)$，带入迭代公式 $arrow(x)=bm(B)arrow(x)+arrow(f)$ 验证准确性

  $
    bm(B)_J=-bm(D)^(-1)(bm(L)+bm(U))=mat(0,-2,2;-1,0,-1;-2,-2,0), arrow(f)_J=bm(D)^(-1)arrow(b)=mat(1;1;1)\ 
    bm(B)_G=-(bm(D)+bm(L))^(-1)bm(U)=mat(0,-2,2;0,2,-3;0,0,2), arrow(f)_G=bm(bm(D)+bm(L))^(-1)arrow(b)=mat(1;0;-1)\ 
  $

  (4) 可以发现 $bm(B)_J$ 的 $p=1,p=infinity$ 均大于 $1$，要具体求谱半径

  $
    det(bm(I)-lambda bm(B)_J)=0 arrow lambda_1=lambda_2=lambda_3=0,rho(bm(B)_J)=0<1
  $

  因此迭代收敛
]

== 单变量非线性方程数值求解

考虑对于形如 $f(x)=0$ 的一元非线性方程

在求解这类方程前首先需要判断方程在给定区间 $[a,b]$ 的可解性，根据微分中值定理可知，当 $f(a) dot f(b)<0$，即 $0$ 位于两个点函数值中间，方程有解。

=== 不动点迭代法

将方程 $f(x)=0$ 改写为 $x=phi(x)$ 的形式，可得方程解的迭代公式，称为*不动点迭代法*（Jocabi 迭代法），其中初始值可任取，习惯上取 $(a+b)/2$

$
  cases(x_0=x_"初始值" in (a,b),x_(n+1)=phi(x_n))
$

函数 $phi(x)$ 有无穷多种构造方法，但不能保证每种构造下迭代能够收敛，且有的收敛快有的收敛慢。

收敛的 $phi(x)$ 满足 $x in [a,b] $ 有 $ phi(x) in [a,b]$，当迭代时 $x$ 超出 $[a,b]$ 即可认为发散。进一步考虑收敛速度，当 $x in [a,b]$ 有 $abs(phi'(x)) lt.eq L lt.eq 1$ 时，任取 $x_0 in (a,b)$ 迭代都能收敛，且有如下的误差估计，可得当 $L$ 越小收敛越快。

$
  abs(x^*-x^k)lt.eq (L^k)/(1-L)abs(x_1-x_0)
$

更具体地，为了比较不同迭代法的收敛速度，对于第 $k$ 次迭代误差 $e_(k)$。当非线性方程数值求解迭代法具有 $p$ 阶收敛速度时，满足如下极限，其中当 $p=1$ 称为*线性收敛*，每次迭代有效数字增加一倍，$p=2$ 称为*平方收敛*，每次迭代有效数字变为原来的平方。

$
  lim_(k arrow infinity) abs(e_(k+1))/abs(e_(k))^(p-1)=0, lim_(k arrow infinity) abs(e_(k+1))/abs(e_(k))^p = C > 0
$

不动点迭代法收敛时将满足如下极限，因此一般情况下不动点迭代法收敛速度为 $p=1$ 的线性收敛，当 $phi(x^*)=0$ 时有 $p=2$ 的平方收敛

$
  lim_(k arrow infinity) abs(e_(k+1))/abs(e_(k))=phi'(x^*)
$

=== Newton 迭代法

#figure(
  image("res/newton_raphson.png"),
  caption: [Newton 迭代法],
  supplement: none
)

Newton 迭代法来自于曲线在 $x_k$ 的切线 $y=f(x_k)-f'(x_k)x$ 与 $y=0$ 的交点构造 $x_(k+1)$，其不动点迭代法格式为

$
  phi(x)=x-f(x)/(f'(x)),phi'(x^*)=(f(x^*)f''(x^*))/(f'^2(x^*))=0
$

因此 Newton 迭代法在收敛时一定具有 $p=2$ 的平方收敛速度。但 Newton 迭代法不一定收敛，依然需要依据 $abs(phi(x))lt.eq 1$ 确定收敛性。

例如 $x^*=a^(1/b)$ 的开方运算就可以通过 Newton 迭代法求解，构造方程 $x^b-a=0$ 有 $phi(x)=(x(b-1))/(b)+a/(b x^(b-1))$

Newton 法需要使用到函数的导数，但一般情况下导数 $f'(x)$ 的表达式可能不存在，而会使用 $x_k,x_(k+1)$ 的差分估计导数 $f'(x)$，称为*弦截法*，有

$
  x_(k+1)=x_k-(f(x_k)(x_k-x_(k-1)))/(f(x_k)-f(x_(k-1)))  
$

弦截法收敛速度介于线性收敛与平方收敛之间。

牛顿迭代法还可以扩展到非线性方程组 $F(arrow(x))=arrow(0)$，有迭代格式

$
  arrow(x)_(k+1)=arrow(x)_k-bm(J)_(F(arrow(x)_k))^(-1) F(arrow(x)_k) 
$

#problem_box(
  title: [非线性方程数值求解分析],
  problem: [
    设方程 $x=e^(-x)$，分析(1)$x_0=0.5,x_(k+1)=e^(-x_(k))$ 的收敛性(2)分析 $x_0=0.5$ 时牛顿迭代的收敛性。
  ]
)[
  (1) 首先确定迭代范围 $because e^(-0)-0>0,e^(-1)-1<0; therefore "取" x in (0,1)$

  根据迭代格式可知 $phi(x)=e^(-x),phi'(x)=-e^(-x)$ 其中 $phi'(x)$ 单调递增

  $because phi'(0)=-1,phi'(1)=-e^(-1); therefore abs(phi(x))lt.eq 1,x in (0,1)$ 迭代收敛。

  (2) $because f(x)=e^(-x)-x,f'(x)=-e^(-x)-1; therefore phi(x)=x-(e^(-x)-x)/(-e^(-x)-1)=(1+x)/(1+e^x)$ 
  
  有 Newton 迭代格式 $ x_(k+1)=(1+x)/(1+e^x) $

  求导得到 $phi'(x)=(1-x e^x)/(1+e^x)^2$，迭代收敛时应有 $abs(phi'(x))<1$，分别证明

  #grid(
    columns: (1fr,) * 2, align: center
  )[
    $ 
      (1-x e^x)/(1+e^x)^2 &< 1\ 
      1-x e^x &< 1+e^(2x)+2e^x\ 
      0&<e^(x)+2+x
    $
    显然当 $x in (0,1)$ 不等式成立
  ][
    $ 
      -1&<(1-x e^x)/(1+e^x)^2\ 
      -1-e^(2x)-e^x&<1-x e^(x)\
      x-1&<2/e^(x)+e^x  
    $
    显然当 $x in (0,1)$ 方程左侧小于 0，右侧大于 0，不等式成立
  ]

  因此迭代收敛
]

=== 二分法

不动点迭代法存在收敛性无法保证，需要确定 $f(x)$ 的解析表达式等问题，实际更多使用的是二分法。即依据区间两端点函数值异号的特性，比较 $f((a+b)/2)$ 与 $f(a),f(b)$ 的符号不断缩小区间，收敛到精确解。（选择特殊的中间的可以实现更快的收敛速度，即黄金分割法）
