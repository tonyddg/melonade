#import "/book.typ": book-page, cross-link
#show: book-page.with(title: "数理统计")

#import "/utility/include.typ": *
#set math.mat(delim: "[")
#set math.vec(delim: "[")

= 数理统计

== 预备知识

=== 离散型随机变量典型分布

离散型随机变量通常使用*分布列* $P(X=k)$ 描述

#table(
  columns: (auto,) + (1fr,) * 3,
  align: center + horizon,
  [], [二项分布], [泊松分布], [几何分布],
  [记号], [$ X tilde B(n,p) $], [$ X tilde pi(lambda) $], [$X tilde G(p)$],
  [概率\ 分布\ 列], [$ P(X=k)=C^k_n p^k (1-p)^(n-k) \ k=0,1,dots,n $], [$ P(X=k)=(e^(-lambda)lambda^k)/(k!)\ k=0,1,dots,infinity $], [$P(X=k)=p(1-p)^(k-1)$],
  [期望], [$ E(X) = n p $], [$ E(X) = lambda $], [$ E(X)=1/p $],
  [方差], [$ D(X) = n p (1-p) $], [$ D(X) = lambda $], [$ D(X)=(1-p)/p^2 $],
  [说明], [重复 n 次单次为正面概率为 p 的实验，正面出现 k 次的概率。], [一段时间内，小概率事件发生 $k$ 次的概率。\ （记忆：提出 $e^(-lambda)$，分布列即 $e^(lambda)$ 在 $x=0$ 处的泰勒展开）], [重复做实验 $A$, 第 $k$ 次成功的概率]
)

=== 连续性随机变量典型分布

连续性随机变量通常使用*概率密度函数* $f(x)$ 或其积分得到的*概率分布函数* $F(x)$ 描述，满足关系 

$
F(x)=P(X lt.eq x)=integral_(-infinity)^x f(x) d x
$ 

#table(
  columns: (auto,) + (1fr,) * 3,
  align: center + horizon,
  [], [均匀分布], [正态分布], [指数分布],
  [记号], [$ X tilde U(a,b) $], [$ X tilde N(mu, sigma^2) $], [$ X tilde E(lambda) $],
  [概率\ 密度\ 函数], [$ f(x)=cases(1/(b-a)\,a lt.eq x lt.eq b, 0\, "其余") $], [$ f(x)=\ 1/(sqrt(2 pi sigma^2))exp[-((x-mu)^2)/(2 sigma^2)] $], [$ f(x)=cases(lambda e^(-lambda x)\, x gt.eq 0,0\, "其余") $],
  [期望], [$ E(X) = (a+b)/2 $], [$ E(X) = mu $], [$ E(X)=1/lambda $],
  [方差], [$ D(X) = ((b-a)^2)/12 $], [$ D(X) = sigma^2 $], [$ E(X)=1/lambda^2 $],
  [说明], [密度为常数的连续分布], [有标准化方法\ $Y=(X-E(X))/(sqrt(D(X))) tilde N(0,1)$], [刻画物体一段时间后损坏的概率]
)

=== 期望与方程

期望 $E(X)$ 具有以下性质
- *线性性质*，即对于任意两个随机变量 $X_1,X_2$，其期望满足 #h(1fr) $ E(a X_1 + b X_2 + c) = a E(X_1)+b E(X_2)+c $

- 独立随机变量 $X_1,X_2$ 之积可以分解 $ E(X_1 X_2)=E(X_1) E(X_2) $

方差 $D(X)$ 有以下性质
- 不受常数项改变 #h(1fr) $ D(X+c)=D(X) $

- 随机变量线性系数提出后变为平方 $ D(a X)=a^2 D(X) $

- 独立随机变量 $X_1,X_2$ 之和可以分解 $ D(X_1+X_2)=D(X_1)+D(X_2) $

- 与均值间的转化关系 $ D(X)=E(X^2)-[E(X)]^2 $

协方差 $"Cov"(X,Y)$ 用于衡量两个随机变量的相关性，当两个随机变量相关时显然 $"Cov"(X,Y)=0$

$
  "Cov"(X,Y)=E(X Y)-E(X) E(Y)
$

== 基本概念

=== 总体与样本

研究对象全体称为*总体*，组成总体的每个元素称为*个体*，认为每个个体相互独立且有相同性质。人们通常关注其中某几项指标的分布，因此可用随机变量 $X$（或多维的随机向量）表示总体性质。

从总体抽取 $n$ 个个体称为*样本*，$n$ 为样本容量。被抽取第 $i$ 个样本也可以用随机变量 $X_i$ 表示。抽取样本后只能得到样本的观察值 $(x_1,x_2,dots,x_n)$，称为*样本值*。

抽样的一般方法称为*简单随机抽样*，此时：*认为样本间相互独立且与总体同分布*。此时样本的联合分布具有以下特点：

$
  cases(p(x_1,x_2,dots,x_n)=product_(i=1)^(n) p(x_i)\, "离散", f(x_1,x_2,dots,x_n)=product_(i=1)^(n) f(x_i)\, "连续" )
$

统计的目的为，假定总体服从特定分布，依据抽样得到一系列样本值 $(x_1,x_2,dots,x_n)$，估计总体的分布参数。首先依据概率论分析确定总体参数与样本随机变量 $(X_1,X_2,dots,X_n)$ 之间的关系，最后将样本值带入得到总体的估计。

最简单的总体估计方法为经验分布函数，其中 $v_n (alpha)$ 为样本值 $x lt.eq alpha$ 出现的次数，当样本容量足够大将接近真实总体分布，概率分布函数可表示为

$
  P(X lt.eq a) = F_n (a)=cases((v_n (a_1))/n&\, X lt.eq a_1, &dots.v, (v_n (a_n))/n&\, X lt.eq a_n)
$

=== 统计量

*统计量*即一个关于所有样本的函数，且仅包含已知的参数（可以是已知的总体分布参数、样本数量等），从而集中所有样本信息。由于样本在观察前是随机变量，因此统计量也是随机变量，也满足特定的分布。将样本观察值带入即可得到统计量的观察值。

常用的统计量有
- 样本均值（反映了总体的均值）#h(1fr) $ overline(X)=1/n sum_(i=1)^n X_i $
- 样本方差（反映了总体的方差） $ S^2=1/(n-1) sum_(i=1)^n (X_i-overline(X))^2 $
- 样本 k 阶原点矩 $ A_k=1/n sum_(i=1)^n X_i^k $
- 样本 k 阶中心矩 $ B_k=1/n sum_(i=1)^n (X_i-overline(X))^k $

构造统计量的原则即依据大数定律，当样本容量足够大时，能够收敛到有意义的参数，如样本 k 阶原点矩 $A_k$ 依概率收敛于 $E(X^k)$

特别的，对于任意分布，样本均值 $overline(X)$ 与样本方差 $S^2$ 均是对总体均值 $E(X)$ 与总体方差 $D(X)$ 的无偏估计，因此有

$
  E(overline(X))=E(X); E(S^2)=D(X)
$

=== 统计学三大分布

#table(
  columns: (auto,) + (1fr,) * 3,
  align: center + horizon,
  [], [$Chi^2$ 分布], [$t$ 分布], [$F$ 分布],
  [记号], [$ X tilde Chi^2(n) $], [$ X tilde t(n) $], [$ X tilde F(n_1,n_2) $],
  [正态\ 分布\ 关系], [$Chi^2(n)=sum_(i=1)^n X_i^2,\ X_i tilde N(0,1)$], [$t(n)=X/(sqrt(Y slash n)),\ X tilde N(0,1), Y tilde Chi^2(n)$], [$F(n_1,n_2)=(X slash n_1)/(Y slash n_2), \ X tilde Chi^2(n_1), Y tilde Chi^2(n_2)$],
  [期望], [$ E(X) = n $], [$ E(x) = 0 $], [],
  [方差], [$ D(X) = 2n $], [], [],
  [密度\ 函数\ 形状], [$n>1$ 时为 $x>0$ 上\ 以 $n$ 为峰的曲线], [关于原点对称], [总是大于 0 的单峰分布],
  [特性], [$Chi_1+Chi_2 = Chi^2(n_1+n_2)$], [当 $n$ 充分大（$n>30$）时与标准正态分布接近], [$1/X = F(n_2,n_1),\ X tilde F(n_1,n_2)$],
)

以上统计学三大分布通常用于表示当样本服从正态分布的样本构造的统计量所满足的分布。

=== 抽样分布定理 <sec:select_theory>

假设总体满足 $X tilde N(mu, sigma^2)$ 的正态分布，则统计量具有以下特性
- 均值 $overline(X)$ 与方差 $S^2$ 的统计量相互独立
- 样本均值满足分布 #h(1fr) $ overline(X) tilde N(mu,sigma^2/n) $
- 样本方差满足分布 $ ((n-1)S^2)/(sigma^2) tilde Chi^2(n-1) arrow S^2 tilde (sigma^2 Chi^2(n-1))/(n-1) $
- 当总体均值 $mu$ 已知，可以用更有效的统计量估计总体，满足 $ G=sum_(i=1)^n (X_i-mu)^2/n arrow (sum_(i=1)^n (X_i-mu)^2)/(sigma^2) tilde Chi^2(n) $
- 由样本均值与方差构造的随机变量满足分布 $ (overline(X)-mu)/(sqrt(S^2 slash n)) tilde t(n-1) $
- 比较两个样本方差的比值满足分布 $ (S_1^2 slash sigma_1^2)/(S_2^2 slash sigma_2^2) tilde F(n_1-1,n_2-1) $

对于正态总体的其他统计量，可以尝试对统计量进行变形以得到以上三大分布。由于样本一般不是标准正态分布，为了转化为以上三大分布还需要标准化，有以下常用技巧
- 正态分布标准化（注意参数为方差，但标准化除以的是方差的平方根） $ (X-mu)/sigma = N(0,1),X tilde N(mu,sigma^2) arrow sigma Y+mu = N(mu, sigma^2),Y tilde N(0,1) $
- 正态分布闭合性质，对于独立的两个正态分布线性 $X_1 tilde N(mu_1,sigma_1^2),X_2 tilde N(mu_2,sigma_2^2)$ 的线性组合（可依据一般独立随机变量线性组合后均值与方差特性记忆） $ a_1 X_1+ a_2 X_2 tilde N(a_1 mu_1+a_2 mu_2,a_1^2 sigma_1^2+a_2^2 sigma_2^2) $

#problem_box(
  title: [抽样分布例题 1],
  problem: [
    假设 $X_1,X_2$ 是来自总体 $X tilde N(0,sigma^2)$ 的独立样本，求 $(X_1+X_2)^2/(X_1-X_2)^2$ 服从的分布
  ]
)[
  题目统计量出先平方与分式，可以向 $F$ 分布靠拢。首先可以考察随机变量 $X_1+X_2$ 与 $X_1+X_2$ 的相关性。以下给出一个关于以上形式随机变量的结论的证明：

  对于独立随机变量 $X,Y$，构造随机变量 $U=X+Y,V=X-Y$ 独立时，有两者协方差 $"Conv"(U,V)=0$

  $
    "Conv"(U,V)&=E(U V)-E(U)E(V)\ 
    &=E(X^2-Y^2)-E(X+Y)E(X-Y)\ 
    &=E(X^2)-E(Y^2)-[E(X)+E(Y)][E(X)-E(Y)]\ 
    &=D(X)+E^2(X)-[D(Y)+E^2(Y)]-[E^2(X)-E^2(Y)]\ 
    &=D(X)-D(Y)
  $

  因此对于 $U,V$ 当两者方差相同时，两个随机变量相互独立

  $because X_1,X_2 tilde N(0,sigma^2) therefore X_1+X_2,X_1-X_2 tilde N(0,2 sigma^2) arrow $，随机变量 $X_1+X_2, X_1-X_2$ 独立，且 $((X_1+X_2)^2)/(2 sigma^2),((X_1-X_2)^2)/(2 sigma^2) tilde Chi^2(1)$ 因此 

  $ (X_1+X_2)^2/(X_1-X_2)^2=((X_1+X_2)slash(2 sigma))^2/((X_1-X_2)slash(2 sigma))^2 tilde F(1,1) $

]


#problem_box(
  title: [抽样分布例题 2],
  problem: [
    若 $X_1,X_2,dots,X_(n+1)$ 来自总体 $X tilde N(mu, sigma^2)$ 的独立样本，设 $overline(X)_(n)=1/n sum^(n)_(i=1)X_i$ 与 $S_n^2=1/(n-1) sum^(n)_(i=1)(X_i-overline(X)_(n))^2$，求常数 $c$ 使统计量 $G=c (X_(n+1)-overline(X)_n)/(sqrt(S^2_n))$ 满足某种统计分布。
  ]
)[
  由于 $G$ 为一次正态随机变量除以根号正态随机变量平方和的平方根，因此可能是 $t$ 分布

  分子部分标准化为正态分布有
  
  $
  E(X_(n+1)-overline(X)_n)=E(X)-E(X)=0\ D(X_(n+1)-overline(X)_n)=D(X_(n+1))+D(overline(X)_n)=sigma^2+sigma^2/n=(n+1)/n sigma^2\ 
  therefore X_(n+1)-overline(X)_n tilde N(0,(n+1)/n sigma^2) arrow (X_(n+1)-overline(X)_n)/(sqrt((n+1)/n sigma^2)) tilde N(0,1)
  $

  分母部分标准化为卡方分布有

  $
     (n-1)/(sigma^2)S_n^2 tilde Chi^2(n-1)
  $

  因此 

  $
    ((X_(n+1)-overline(X)_n)slash sqrt((n+1)/n sigma^2))/(sqrt((n-1)/(sigma^2)S_n^2 slash (n-1))) tilde t(n-1) arrow c=sqrt(n/(n+1))
  $
]

== 基于点估计的参数估计

参数估计问题中，认为总体的分布类型已知，但是分布有 $theta_1,dots,theta_r$ 共 $r$ 个未知参数，需要用特定的统计量估计。其中点估计即直接估计参数数值。

=== 矩估计

矩估计为依据大数定律的点估计方法，认为当样本容量趋于无穷大时，样本的 k 阶矩总是依概率收敛于总体的 k 阶矩。因此矩估计即假定总体的 k 阶矩 $mu_k$ 等于样本的 k 阶矩 $A_k$。

$A_k$ 的统计量可以通过样本得到，$mu_k$ 可以表示为关于分布参数的函数 $mu_k (theta_1,dots,theta_r)$，由此可构造 $r$ 个关于 $1-r$ 阶矩的方程

$
  cases(a_1&=mu_1 (theta_1,dots,theta_r), &dots.v,a_r&=mu_r (theta_1,dots,theta_r))
$

使用矩估计时
- 当 $mu_i$ 为常数与参数无关时，需要寻找更大阶数的 k 阶矩，保证独立方程个数为 $r$
- 对于常见分布，可以利用方差与均值的关系寻找二阶矩 $mu_2=E(X^2)=D(X)^2+[E(X)]^2$
- 对于一般分布，需要手动求解积分 $mu_k=integral_(-infinity)^(infinity)x^k f(x) d x$（连续分布）

=== 极大似然估计 <sec:maximum_likehood>

极大似然估计为一种点估计方法，其认为以估计的参数 $theta_1,dots,theta_r=Theta$ 为条件，样本产生一系列观测值 $x_1,dots,x_n$ 的条件概率 $P(X=x_1,dots,x_n|Theta)$ 应该最大。

由于样本间独立同分布，因此以上条件概率可以进行转化

$
  L(theta_1,dots,theta_r)=P(X=x_1,dots,x_n|Theta)=product_(i=1)^n P(X=x_i|Theta) in (0,1)
$

称 $L(theta_1,dots,theta_r)$ 为似然函数，极大似然估计即找出一组参数使多元函数 $L$ 取得最大值。通常会对似然函数加上对数，在不改变函数变化趋势的同时将连乘转为求和便于偏导数求极值

$
  ln L(Theta)&=sum_(i=1)^n ln P(X=x_i|Theta)
$

由此可以推出 $r$ 个关于 $theta$ 的方程

$
    (partial )/(partial theta_i)[ln L(Theta)]&=sum_(i=1)^n (partial )/(partial theta_i)[ln P(X=x_i|Theta)]=0
$

在极大似然估计中
- 对于连续型概率分布，有 $f(x)=P(X=x)d x$，因此可以直接使用 $f(x|Theta)$ 代替 $P(X=x|Theta)$
- 当概率函数 $P(x)$ 为连乘形式、存在指数时，还可以进一步转化 $ln P(X=x_i|Theta)$ 得到更简单的形式再关于 $theta_i$ 求偏导
- 对于极大似然估计参数 $hat(theta)$，带入通过该参数构造的的单调函数 $g(theta)$ 得到的为关于该函数的极大似然估计 $g(hat(theta))$
- 当密度函数简单但不可微时，可以考虑从似然函数 $L(Theta)$ 入手，看如何取值令似然函数尽量大

两种点估计方法没有明显优劣，一般出于便利性，连续性随机变量（密度函数连续可微）多使用极大似然估计；离散型随机变量或密度函数简单但不可微的连续随机变量（如均匀分布）多使用矩估计。

=== 估计量评价标准

// - 无偏性：估计参数的统计值与真实值之差的期望为 0，即统计值的期望与估计参数的真实值相同，满足这一性质的统计量称为无偏估计。
// - 有效性：
// - 一致性：

// *无偏估计*

估计量第一个评价标准为*无偏性*：估计参数的统计值与真实值之差的期望为 0，即统计值的期望与估计参数的真实值相同，满足这一性质的统计量称为*无偏估计*。
- 参数估计方法得到的统计量不一定满足无偏性
- 几个无偏估计的线性组合依然为无偏估计

例如使用矩估计估计总体方差时有 $G = A_2-A_1^2$ 并不满足无偏性

$
  E(A_2-A_1^2)&=E(A_2)-E(overline(X)^2)\ 
  &=E(X^2)-[D(overline(X))+E(overline(X))^2]\ 
  &=E(X^2)-D(X)/n-E(X)^2\ 
  &=(n-1)/n D(X) eq.not D(X)
$

// *无偏估计的有效性*

估计量第二个评价标准为*有效性*：对于同一参数的多个无偏估计，统计量的方差越小越有效

例如总体均值的两种无偏估计 $G_1=1/3X_1+1/3X_2+1/3X_3$，$G_2=1/2X_1+1/3X_2+1/6X_3$ 分别求方差可得，$G_1$ 方差更小因此更有效

#grid(columns: (1fr,) * 2)[
  $ 
    D(G_1) &=1/3^2D(X_1)+1/3^2D(X_2)+1/3^2D(X_3)\ 
    &=1/3D(X)
  $
][
  $
    D(G_2) &=1/2^2D(X_1)+1/3^2D(X_2)+1/6^2D(X_3)\ 
    &=14/36D(X)
  $
]

其中可依据 Rao-Cramer 不等式确定无偏估计量中方差的下界，即参数 $theta$ 最有效的估计量 $hat(theta)$ 方差的下界

$ D(hat(theta))gt.eq 1/(n E{[(partial)/(partial theta) ln p(X; theta)]^2}) $

估计量第三个评价标准为*一致性*：即当样本容量 $n$ 趋于无穷大时，统计量依概率收敛到被估计参数。直接证明较难，可利用以下结论
- 样本的 k 阶矩是总体 k 阶矩的一致估计量（矩估计得到的估计量一定是一致估计量）
- 当估计量是无偏估计量 $G$ ，当 $lim_(n arrow infinity) D(G)=0$ 则 $G$ 是一致估计量

#problem_box(
  title: [样本估计有效性例题],
  problem: [
    假设总体 $X tilde N(mu, sigma^2)$，证明 $G=1/n sum_(i=1)^n (X_i-mu)^2$ 是 $sigma^2$ 的最有效估计而 $S^2=1/(n-1) sum_(i=1)^n (X_i-overline(X))^2$ 不是。
  ]
)[
  首先证明 $G$ 是总体方差的无偏估计（样本分布与总体相同）

  $ E(G)&=1/n sum_(i=1)^n E[(X_i-mu)^2]=E[(X-mu)^2]\ &=D(X-mu)+[E(X-mu)]^2=D(X)+[E(X)-mu]^2\ &=D(X)=sigma^2 $

  然后求出 $G$ 的方差（利用方差统计量与卡方分布关系以及卡方分布的均值 / 方差）

  $ n/(sigma^2) G= G'=sum_(i=1)^n ((X_i-mu)/sqrt(sigma^2))^2 tilde X^2(n)\ n^2/sigma^4 D(G)=D(n/(sigma^2) G)=D(G')=2n arrow D(G)=(2sigma^4)/n $

  对于 $S^2$ 使用类似方式可证明 $D(S^2)=(2sigma^4)/(n-1)>D(G)$，有效性低于 $G$

  使用 Rao-Cramer 不等式求方差 $sigma^2=theta$ 参数估计的方差下界 $ ln p(X; theta)=-1/2 ln(2pi theta)-(X-mu)^2/(2 theta)\ (partial)/(partial theta) ln p(X; theta)=-1/(2theta)+(X-mu)^2/(2theta^2)=((X-mu)^2-theta)/(2theta^2) $

  利用卡方分布有 $((X-mu)/sqrt(sigma^2))^2 tilde X^2(1)$, 令 $Y=(X-mu)^2$
  
  $ E(Y) =sigma^2=theta,D(Y) =2sigma^4=2theta^2\ E(Y^2)=D(Y)+(E(Y))^2=3theta^2 $

  $ E{[(partial)/(partial theta) ln p(X; theta)]^2}=E[((Y-theta)/(2theta^2))^2]&=E[(Y^2+theta^2-2Y theta)/(4theta^4)]=1/(2 theta^2) $

  带入 Rao-Cramer 不等式有

  $ D(hat(theta))gt.eq 1/(n E{[(partial)/(partial theta) ln p(X; theta)]^2})=(2sigma^4)/n=D(G) $

]

== 基于区间估计的参数估计 <sec:range_estimate>

（仅考察单个正态总体）

参数估计中除了点估计还有区间估计，其要求估计参数所在区间以及置信度（参数在区间内的概率）

规定置信度 $1-alpha$，参数 $theta$ 的两个估计量：$underline(theta)$ 双侧置信下限；$overline(theta)$ 双侧置信上限。此时有概率表达式：

$
  P{underline(theta)(X_1,dots,X_n)<theta<overline(theta)(X_1,dots,X_n)} gt.eq 1- alpha
$

由于区间估计一般较为复杂，因此通常仅考虑正态总体的区间估计。

=== 概率分布的分位点

对于分布 $f(x)$，给定分位 $1alpha in [0,1]$ 有上分位点 $x_alpha$ 满足以下公式。

$
  P(X gt.eq x_alpha)=integral^(infinity)_(x_alpha)f(x)d x=alpha
$

因此上分位点对应随机变量取值，分位对应随机变量概率。类似有下分位点 $z_alpha$，根据概率运算与上分位点、概率分布函数间存在关系（位于 $alpha$ 分位的下分位点同时也是位于 $1-alpha$ 分位的上分位点）

$
  P(X lt.eq z_(alpha))=F(z_(alpha))=1-P(X gt.eq z_(alpha)) arrow z_(alpha)=x_(1-alpha)
$

对于正态分布与 $t$ 分布等关于 $0$ 对称的分布有以下性质

$
  P(X gt.eq x)=P(X lt.eq -x) arrow x_alpha=-z_(alpha)=z_(1-alpha)\ 
$

对于 $F$ 分布有分子分母对称性

$
  P[F(n_1,n_2) gt.eq x]=P[F(n_2,n_1) lt.eq 1/x] arrow f_(alpha)(n_1,n_2)=1/(f_(1-alpha)(n_2,n_1))
$

=== 均值的区间估计

当总体方差 $sigma^2$ 已知，求关于均值 $mu$ 的区间估计时
- 首先依据总体方差标准化样本均值有#h(1fr) $ (overline(X)-mu)/(sigma slash sqrt(n)) tilde N(0,1) $
- 由于标准正态分布关于原点对称，对于标准正态分布的上分位点 $z_(alpha slash 2)$ 可求出概率表达式 $ P{-z_(alpha slash 2)<(overline(X)-mu)/(sigma slash sqrt(n))<z_(alpha slash 2)} = 1- alpha $
- 将不等式中的间的待求 $mu$ 分离出来即可得到上下限满足 $ cases(underline(mu)=overline(X)-sigma/sqrt(n) z_(alpha slash 2), overline(mu)=overline(X)+sigma/sqrt(n) z_(alpha slash 2)) $

当总体方差未知，求关于均值 $mu$ 的区间估计时
- 方差未知时只能使用样本方差 $S^2$ 估计总体方差，以此构造的统计量服从 t 分布#h(1fr) $ (overline(X)-mu)/sqrt(S^2 slash n) tilde t(n-1) $
- 类似的 t 分布关于原点对称，对于 $t(n-1)$ 分布的上分位点 $t_(alpha slash 2)(n-1)$ 可求出概率表达式 $ P{-t_(alpha slash 2)(n-1)<(overline(X)-mu)/sqrt(S^2 slash n)<t_(alpha slash 2)(n-1)} = 1- alpha $
- 将不等式中的间的待求 $mu$ 分离出来即可得到上下限满足 $ cases(underline(mu)=overline(X)-sqrt(S^2/n) t_(alpha slash 2)(n-1), overline(mu)=overline(X)+sqrt(S^2/n) t_(alpha slash 2)(n-1)) $

=== 方差的区间估计

当总体均值未知，求关于方差 $sigma^2$ 的区间估计时
- 样本方差与总体方差之间可构造出一个关于 $Chi^2$ 分布的统计量#h(1fr) $ ((n-1)S^2)/(sigma^2) tilde Chi^2(n-1) $
- $Chi^2$ 分布虽然没有对称性，对于 $Chi^2(n-1)$ 分布的上分位点 $x^2_(alpha slash 2)(n-1)$ 与 $x^2_(1- alpha slash 2)(n-1)$（用上分位点表示的下分位点）可求出概率表达式 $ P{chi^2_(1- alpha slash 2)(n-1)<((n-1)S^2)/(sigma^2)<chi^2_(alpha slash 2)(n-1)} = 1- alpha $
- 将不等式中的间的待求 $sigma^2$ 分离出来即可得到上下限满足 $ cases(underline(sigma)^2=((n-1)S^2)/(chi^2_(alpha slash 2)(n-1)), overline(sigma)^2=((n-1)S^2)/(chi^2_(1-alpha slash 2)(n-1))) $

当均值 $mu$ 已知时，可使用#link(<sec:select_theory>)[更有效的方差统计量] $G=sum_(i=1)^n (X_i-mu)^2/n, (n G)/sigma^2 tilde Chi^2(n)$

=== 正态总体比较的区间估计

对两个相互独立的正态总体 $X tilde N(mu_1,sigma_1^2),Y tilde N(mu_2,sigma_2^2)$ 进行比较

比较均值时通常会研究两者均值之差 $mu_1-mu_2$，可构造如下符合正态分布的统计量

$
  overline(X)-overline(Y) tilde N(mu_1-mu_2,sigma_1^2/n_1+sigma_2^2/n_2) arrow (overline(X)-overline(Y) - (mu_1-mu_2))/(sqrt(sigma_1^2/n_1+sigma_2^2/n_2))
$

- $sigma_1^2,sigma_2^2$ 已知时，两个分布的均值差 $mu_1-mu_2$ 的区间估计满足 $ cases(underline(mu_1-mu_2)=overline(X)-overline(Y)-sqrt(sigma_1^2/n_1+sigma_2^2/n_2) z_(alpha slash 2), overline(mu_1-mu_2)=overline(X)-overline(Y)+sqrt(sigma_1^2/n_1+sigma_2^2/n_2) z_(alpha slash 2)) $
- 由于 $overline(X)-overline(Y)$ 无法构造出 $t$ 分布，因此 $sigma_1^2,sigma_2^2$ 未知时只能用 $S_1^2,S_2^2$ 近似（假设 $sigma_1^2=sigma_2^2$ 可构造，此处略）
- 如果 $mu_1-mu_2$ 的置信区间包含 $0$ 时，可以认为两个分布在给定置信度下均值没有差异


比较方差时通常会研究两者方差之比 $sigma_1^2 slash sigma_2^2$，可构造如下符合 $F$ 分布的统计量

$
  (S_1^2 slash sigma_1^2)/(S_2^2 slash sigma_2^2)=(S_1^2 slash S_2^2)/(sigma_1^2 slash sigma_2^2) tilde F(n_1-1,n_2-1)
$

- 两个分布的方差比 $sigma_1^2 slash sigma_2^2$ 的区间估计满足#h(1fr) $ cases(underline(sigma_1^2 slash sigma_2^2)=(S_1^2 slash S_2^2)/(F_(alpha/2)(n_1-1,n_2-1)), overline(sigma_1^2 slash sigma_2^2)=(S_1^2 slash S_2^2)/(F_(1-alpha/2)(n_1-1,n_2-1))=(S_1^2 slash S_2^2)F_(alpha/2)(n_2-1,n_1-1)) $

== 假设检验

（仅考察单个正态总体）

当总体分布未知或某些参数未知时，提出关于总体分布或未知参数的假设，称为*原假设*记为 $H_0$，而与假设相矛盾的假设称为*备择假设* $H_1$。然后根据样本所提供的信息，推断原假设是否合理，并作出接受或拒绝所提出原假设的决定。

=== 假设检验的原理

假设检验可划分为总体已知但参数未知假设参数值的*参数假设检验*、总体未知假设总体分布的*非参数假设检验*两种。

假设检验认为小概率时间在实验中不可能发生，因此在实验时，通常会设计一个仅当原假设 $H_0$ 成立时会发生的概率小于 $alpha$ 的小概率事件（称为*拒绝域* 记为 $W$，拒绝域中的统计量称为*检验统计量*），当实验时小概率事件发生则拒绝原假设 $H_0$ 选择备择假设 $H_1$。其中 $alpha$ 称为*显著性水平*，一般取 $0.05,0.01$ 等（显著性水平越高越容易拒绝原假设，一般倾向于保护原假设而取较小的显著性水平）。使用概率表示假设被拒绝有（设检验统计量 $X$）

$
  P{"拒绝" H_0 | H_0 "为真"} = alpha arrow P(x in W)=alpha
$

不通过假设检验不能绝对说明原假设一定错误，只能说明原假设成立的显著性低于给定的显著性水平 $alpha$。


// 发生以下假设检验结论

假设检验存在两种错误及错误发生概率表达式
- 弃真错误（False Negtive），拒绝了应为真的原假设 $P{"拒绝" H_0 | H_0 "为真"} = alpha$
- 取伪错误（False Positive），接受了应为假的原假设 $P{"接受" H_0 | H_0 "为假"} = beta$

弃真错误通过显著性水平控制，取伪错误则一般通过增加样本容量控制，从而允许发生少数小概率事件也不会影响判断。

对于同一问题，原假设与备择假设选择没有严格标准，取相反的原假设可能得到相反的结论（表明结论可能不可靠，可能存在取伪错误）。

=== 正态总体的参数假设检验

参数假设检验中，的一般方法为取置信度为 $1-alpha$ 的 #link(<sec:range_estimate>)[区间估计]的补集作为拒绝域。然后计算样本统计量的观察值根据观察值超出估计区间（即进入拒绝域）判断假设检验是否成立。

方差未知时，关于正态总体均值的假设检验称为 *$T$ 检验*（方差已知称为 $U$ 检验，公式类似，此处略）
- 利用假设均值 $mu_0$ 可以构造如下检验统计量，假设成立时统计量将符合 $t(n-1)$ 分布 #h(1fr) $ T =(overline(X)-mu_0)/(sqrt(S^2 slash n)) tilde t(n-1) $
- 对于 $mu=mu_0$ 的假设（均值无显著差异），统计量 $T$ 的观测值在两端概率极低，可构造双边拒绝域 $ W ={abs(T)gt.eq t_(alpha slash 2)(n-1)} $
- 对于 $mu lt.eq mu_0$ 的假设，当总体均值越大则样本均值 $overline(X)$ 越大统计量 $T$ 也越大，因此取分布的右端构造单边拒绝域（注意单边拒绝域中，不要再对显著性水平 $alpha$ 除以 2） $ W={T gt.eq t_(alpha)(n-1)} $

均值未知时，关于正态总体方差的假设检验称为 *$Chi^2$ 检验*
- 利用假设方差 $sigma_0^2$ 可以构造如下检验统计量，假设成立时统计量将符合 $Chi^2(n-1)$ 分布 #h(1fr) $ cases(Chi^2 =((n-1)S^2)/(sigma_0^2) tilde Chi^2(n-1)\,&"总体均值未知" ,Chi^2 =((n-1)sum_(i=1)^n (X_i-mu)^2)/(sigma_0^2) tilde Chi^2(n)\,&"总体均值已知") $
- 对于 $sigma^2=sigma^2_0$ 的假设（方差无显著差异），可构造双边拒绝域 $ W ={Chi^2 gt.eq chi^2_(alpha slash 2)(n-1)} union {Chi^2 lt.eq chi^2_(1-alpha slash 2)(n-1)} $
- 对于 $sigma^2 lt.eq sigma^2_0$ 的假设，当总体方差越大则样本方差 $S^2$ 越大统计量 $Chi^2$ 也越大，因此取分布的右端构造单边拒绝域（注意单边拒绝域中，不要再对显著性水平 $alpha$ 除以 2） $ W={Chi^2 gt.eq Chi^2_(alpha)(n-1)} $

比较两个正态总体均值 $mu_1,mu_2$ 时，总体方差未知且 $sigma_1 eq.not sigma_2$，使用样本方差近似总体方差
- 利用两个样本均值之差可构造如下检验统计量，假设（$mu_1-mu_2=Delta mu$）成立时统计量将符合标准正态分布 #h(1fr) $ U=(overline(X)_1-overline(X)_2-Delta mu)/(sqrt(sigma_1^2/n_1+sigma_2^2/n_2)) tilde N(0,1) $
- 对于 $mu_1=mu_2,Delta mu=0$ 的假设（两个总体均值无显著差异），可构造双边拒绝域 $ W={abs(U) gt.eq z_(alpha slash 2)} $

比较两个正态总体均值 $mu_1,mu_2$ 时，总体方差未知且总体方差无显著差异 $sigma_1 approx sigma_2$（可使用 $F$ 检验验证）
- 利用两个样本均值之差可构造如下检验统计量，假设（$mu_1-mu_2=Delta mu$）成立时统计量将符合 $t$ 分布 #h(1fr) $ T=(overline(X)_1-overline(X)_2-Delta mu)/(sqrt(S^2_w (1/n_1+1/n_2))) tilde T(n_1+n_2-2) $
- 其中统计量混合样本方差 $S_w^2$ 满足 $ S_w^2=((n_1-1)S_1^2+(n_2-1)S_2^2)/(n_1+n_2-2) $
- 对于 $mu_1=mu_2,Delta mu=0$ 的假设（两个总体均值无显著差异），可构造双边拒绝域 $ W={abs(T) gt.eq t_(alpha slash 2)(n_1+n_2-2)} $

比较两个正态总体方差 $sigma_1^2,sigma_2$ 时，假设（$sigma_1^2/sigma_2^2=r_(sigma^2)$），关于两个方差之比的假设检验称为 *$F$ 检验*
- 利用两个样本方差之比可以构造如下的统计检验量（均值未知），符合 F 分布#h(1fr) $ F=(S_1^2 slash S_2^2)/(r_(sigma^2)) tilde F(n_1-1,n_2-1) $
- 对于 $sigma_1^2=sigma_2^2,r_(sigma^2)=1$ 的假设（两个总体方差无显著差异），可构造双边拒绝域 $ W={F gt.eq f_(alpha slash 2)(n_1-1,n_2-1)} union {F lt.eq 1/(f_(alpha slash 2)(n_2-1,n_1-1))} $

=== 总体参数的大样本检验

根据*中心极限定律*，对于任意满足总体 $E(X)=mu,D(X)=sigma^2$，当样本容量 $n$ 足够大时（$n>30$），其均值 $overline(X)$ 将服从分布

$ overline(X) tilde N(mu,sigma^2/n) $

因此如果总体分布已知且能确定总体均值、方差与参数间的关系 $E(X)=mu(theta_1,dots,theta_n),D(X)=sigma^2(theta_1,dots,theta_n)$ 后，就可以将对总体参数 $theta_1,dots,theta_n$ 的假设检验转化为对正态总体的假设检验，有检验统计量 $ U=(overline(X)-mu(theta_1,dots,theta_n))/(sqrt(sigma^2(theta_1,dots,theta_n) slash n)) tilde N(0,1) $

由此可构造使原假设不成立的造拒绝域 $ W={abs(U) gt.eq z_(alpha slash 2)} $

=== 分布函数拟合优度检验

在假设检验中，可以将总体满足特定分布作为一种原假设。可通过比较样本的经验分布与假设分布间的相似性检验假设是否成立。

由于检验仅约束了分布类型而没有约束参数，无法得到具体分布函数，因此通常会先使用#link(<sec:maximum_likehood>)[极大似然估计]确定分布参数以得到概率分布函数 $F(x)=P(X<x)$

首先通过以下方式规定样本的经验分布
- 将区间 $(-infinity,infinity)$ 划分为 $(-infinity,b_1],(b_1,b_2],dots,(b_(k-1),infinity]$ 共 $k$ 个不重叠子区间，观察值位于各个区间内的频数记为 $f_i$ 有 $sum_(i=1)^k f_i=n$
- 当假设分布成立时，可通过概率分布函数得到每个区间内的理论概率 $P_i=F(b_i)-F(b_(i-1))$ 与理论频数 $n P_i$
- 由此可以定义*分布函数拟合优度*比较样本分布与理论分布，其中 $r$ 为极大似然估计的参数数 $ Chi^2=sum_(i=1)^k (f_i-n P_i)^2/(n P_i) tilde Chi^2(K-r-1) $
- 将分布函数拟合优度作为检验统计量，当两个分布差异越大，拟合优度应该越大，因此使用单边检验构造拒绝域 $ W={Chi^2>chi^2_(alpha)(K-r-1)} $
- 分布函数拟合优度仅在 $n P_i>4,n>50$ 时能较好近似 $Chi^2$ 分布，因此需要适当合并划分区间以保证以上条件成立

== 回归分析

（不考察）

=== 相关分析

通过*相关系数*比较两个随机变量，当两个随机变量呈线性关系时绝对值为 $1$ $ rho (X,Y)= ("Conv"(X,Y))/(sqrt(D(X) D(Y)))=(E(X Y)-E(X)E(Y))/(sqrt(D(X) D(Y))), abs(rho(X,Y))lt.eq 1 $

数学上通常用以下假设刻画两个相关随机变量，其中随机变量 $Epsilon tilde N(0,sigma^2)$ 为噪音

$ Y=cases(a + b X + Epsilon&\, "线性相关", f(X)+Epsilon&\, "非线性相关") $

将 $X,Y$ 作为总体，通过两者样本可以构造统计量，称为*样本的相关系数*（注意其中的方差使用矩估计而不是无偏估计）

$ r(X,Y)=(sum_(i=1)^(n)(x_i-overline(X))(y_i-overline(Y)))/(sqrt(sum_(i=1)^(n)(x_i-overline(X))^2sum_(i=1)^(n)(y_i-overline(Y))^2))=(L_(X Y))/sqrt(L_(X X) L_(Y Y)) $

当 $r>0$ 称为正相关，反之为负相关；当 $abs(r)>0.5$ 称为显著线性相关，当 $abs(r)>0.8$ 称为高度线性相关。

通过以下方法可以构造一个服从正态分布且与样本相关系数有关的统计量 $ Z_f=1/2 ln((1+r)/(1-r)) tilde N(1/2 ln((1+rho(X,Y))/(1-rho(X,Y))), 1/(n-3)) $

因此如果假设 $rho(X,Y)=rho_0$ 可以构造如下检验统计量，当相关系数满足假设时将服从正态分布 $ Z=(Z_f-1/2 ln((1+rho_0)/(1-rho_0)))/(sqrt(1 slash (n-3))) tilde N(0,1) $
- 对于 $rho(X,Y)=rho_0$ 的假设，有双边拒绝域#h(1fr) $ W={abs(Z)gt.eq Z_(alpha slash 2)} $
- 对于 $rho(X,Y)>rho_0$ 的假设，由于 $Z_f$ 随 $rho(X, Y)$ 增大，因此有单边拒绝域#h(1fr) $ W={Z lt.eq -Z_(alpha)} $

=== 一元线性回归

当随机变量 $X,Y$ 有足够显著的线性相关性后，可以对其线性关系中的三个参数 $a,b,sigma^2$ 进行估计，估计前通常会假设 $X,Y,Epsilon$ 服从正态分布（注意*笔记中参数 $a$ 为截距，$b$ 为斜率*） $ Y=a + b X + Epsilon, Epsilon tilde N(0,sigma^2) $

一般会希望误差项方差越小越好，即拟合时参数 $a,b$ 应使两个参数的最小二乘误差最小 $ e=E([Y-(a X+b)]^2) $

易得参数 $a,b$ 有最有效的无偏估计以及拟合量 $hat(y)_i$（以下公式即通过最小二乘逼近中的正规方程）  $ mat(arrow(x),1)mat(hat(b);hat(a))=arrow(y)arrow hat(b)=(sum_(i=1)^(n)(x_i-overline(X))(y_i-overline(Y)))/(sum_(i=1)^(n)(x_i-overline(X))^2), hat(a)= overline(Y)-hat(b) overline(X), hat(y)_i=hat(a) x_i+hat(b) $

通过以下统计量衡量拟合效果，其中 $Q$ 即*残差平方和*，$"MSE"$ 即*平均平方误差* $ Q=sum_(i=1)^n (y_i-hat(y)_i)^2=L_(Y Y)-hat(b) L_(X Y), "MSE"=Q/n $

可以证明参数误差方差 $sigma^2$ 满足 $ E(Q/(sigma^2))=n-2, hat(sigma)^2=Q/(n-2) $

=== 线性回归的拟合优度分析

线性回归中统计量 $Q/sigma^2,hat(b)$ 相互独立且分布满足 $ hat(b) tilde N(b, sigma^2/L_(X X)), Q/sigma^2 tilde Chi^2(n-2) $

然而统计量中存在未知参数 $sigma^2$，可以通过组合两个统计量得到以下检验统计量用于 $b$ 的假设检验 $ T=((hat(b)-b)sqrt(L_(X X)))/(sqrt(Q slash (n-2))) tilde t(n-2) $

实际中更常见的是使用统计量*决定系数* $R^2$ 检验拟合优度，越接近 $1$ 拟合优度越好，当大于 $0.9$ 则拟合效果较好，小于 $0$ 则拟合效果极差

$ R^2=1-(sum_(i-1)(y_i-hat(y_i))^2)/(sum_(i-1)(y_i-overline(Y))^2)=1-Q/D(Y) $
