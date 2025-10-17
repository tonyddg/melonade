#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Flow base 生成模型")

#import "/utility/widget.typ": *
#set math.mat(delim: "[")

= Flow base 生成模型

#link("https://www.bilibili.com/video/BV1TD4y137mP?p=38")[参考教程]

== Flow base 生成模型的理论基础

=== 生成模型的目标

#figure(
  image("res/fbgm_1.png", height: 15em), 
  caption: [生成模型的目标],
)

对于一个理想的生成模型，对于输入的，满足标准正态分布的随机变量 $z$，其输出 $x=G(z)$ 的分布 $p_G(x)$ 应当与真实数据分布 $p_"data"(x)$ 越接近越好

由此可以得到理想的生成模型中，真实数据样本
应当使其输出的分布 $p_G(x)$

=== 雅可比矩阵

定义一个向量函数 $arrow(f)(arrow(z))=mat(f_1 (arrow(z)),dots,f_m (arrow(z)))^T=arrow(x) in RR^m,z in RR^n$，将这个向量函数各个元素关于变量 $arrow(z)$ 求偏导数，并按一定规则排列可得到雅可比矩阵：

$
  bm(J)_(f)(arrow(z))=(partial arrow(x))/(partial arrow(z))=mat(
    (partial x_1)/(partial z_1),(partial x_1)/(partial z_2), dots, (partial x_1)/(partial z_n);
    (partial x_2)/(partial z_1),(partial x_2)/(partial z_2), dots, (partial x_2)/(partial z_n);
    dots.v,dots.v,dots.down,dots.v;
    (partial x_m)/(partial z_1), (partial x_m)/(partial z_2), dots, (partial x_m)/(partial z_n)) in RR^(m times n)
$

雅可比矩阵根据如下规则排列偏导数
- 沿行增大方向上，输入元素不变，输出元素序号增大，因此矩阵行数由输出 $arrow(x)$ 的长度 $m$ 决定
- 沿列增大方向上，输入元素序号增大，输出元素序号不变，因此矩阵列数由输入 $arrow(z)$ 的长度 $n$ 决定
- 矩阵的第 $i$ 行第 $j$ 列为多元函数 $f_i (arrow(z))$ 关于变量 $z_j$ 的偏导数 $(partial x_i)/(partial z_j)(arrow(z))$

当 $m=n$ 时雅可比矩阵为方阵 $bm(J)_(f)(arrow(z))in RR^(n times n)$ 时，函数输入与输出的元素数量相同，此时可以构造逆函数 $arrow(f)^(-1)(arrow(x))$ 满足 $arrow(f)^(-1)(arrow(x))=arrow(f)^(-1)(arrow(f)(arrow(z)))=arrow(z)$。此处不加证明地给出结论，逆函数 $arrow(f)^(-1)(arrow(x))$ 的雅可比矩阵即函数 $arrow(f)(arrow(z))$ 雅可比矩阵的逆：

$
  bm(J)_(f)^(-1)(arrow(z))=bm(J)_(f^(-1))(arrow(x)),arrow(f)(arrow(z))=arrow(x)
$

=== 随机变量替换定理

现有随机变量 $Z$ 的分布满足概率密度函数 $pi(z)$，随机变量 $X$ 与 $Z$ 之间存在函数关系 $X=f(Z)$，此时 $X$ 的概率密度函数为 $p(x)$。现希望确定这三者间的关系。

#figure(
  image("res/fbgm_2.png", height: 15em), 
  caption: [一维的随机变量替换],
)

虽然 $pi(z),p(x)$ 可能是任意分布，但是取一小块 $z tilde z+d z$ 及其对应的 $x tilde x + d x$（即 $f(z) tilde f(z)+d f(z)$）可以认为是均匀分布。又由于概率密度函数与坐标轴围成面积总满足 $integral pi(z) d z=1$，可以认为两块面积相同，因此有（绝对值保证概率密度函数值总为正）

$
  p(x)d x&=pi(z)d z\ 
  p(x)&=pi(z)abs((d z)/(d x))
$

#figure(
  image("res/fbgm_3.png", height: 15em), 
  caption: [多维的随机变量替换],
)

对于多维随机变量同理，可以以在点 $arrow(z)$ 处取长度为 $partial arrow(z)$ 的矩形（二元）。平面的一边将对应 $arrow(x)$ 值域内的一条向量 

$
mat(partial x_(1,i),dots,partial x_(n,i))^T = d arrow(f)(z_i) = arrow(f)(z_i + d z_i) - arrow(f)(z_i)
$ 

这 $n$ 条矢量将会在 $arrow(x)$ 值域内构成一个平行四边形（二元），这两个形状加上各自的高度 $pi(arrow(z)),p(arrow(x))$ 后的体积必然相同。

对于点 $arrow(z)$ 处取长度为 $partial arrow(z)$ 的矩形（二元）其面积（二元）即 $product partial z_i$。对于 $i$ 个向量 $d arrow(f)(z_i)$ 构成的平行四边形（二元）/ 平行六面体（三元）可以使用行列式计算。由向量 $d arrow(f)(z_i)$ 的等式也可得到 

$  
  partial x_(j,i) = f_j (z_i + d z_i) - f_j (z_i) arrow (partial x_(j,i))/(partial z_i)=(partial x_(j))/(partial z_i)
$

根据两块区域体积（二元）相等的条件有

$
  p(arrow(x))abs(det mat(partial x_(1,1), dots, partial x_(1,n); dots.v,,dots.v;partial x_(n,1), dots, partial x_(n,n)))&=pi(arrow(z)) product^n_i partial z_i\ 
  p(arrow(x))1/(product^n_i partial z_i) abs(det mat(partial x_(1,1), dots, partial x_(1,n); dots.v,,dots.v;partial x_(n,1), dots, partial x_(n,n)))=p(arrow(x))abs(det mat((partial x_(1,1))/(partial z_1), dots, (partial x_(1,n))/(partial z_n); dots.v,,dots.v;(partial x_(n,1))/(partial z_1), dots, (partial x_(n,n))/(partial z_n)))&=pi(arrow(z))\ 
  p(arrow(x))abs(det bm(J)_f (arrow(z)))&=pi(arrow(z))\ 
$

当 $bm(J)_f (arrow(z))$ 可逆时还有

$
  p(arrow(x))abs(det bm(J)_f (arrow(z)))&=pi(arrow(z))\ 
  p(arrow(x))&=pi(arrow(z))abs(det bm(J)_(f^(-1)) (arrow(x)))\ 
$

因此只要知道 $pi(arrow(z)),p(arrow(x)),f(arrow(z))$ 中的两者就可以得到第三者的表达式，对于生成模型该理论也给出了固定参数分布 $pi(arrow(z))$且已知生成样本数据分布 $p(arrow(x))$ 下理想生成模型 $g(arrow(z))$ 的表达式。

