#import "@preview/codly:1.3.0": *
#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "基础知识拾遗")

#import "/utility/include.typ": *
#set image(height: 15em, width: 80%, fit: "contain")

= 基础知识拾遗

== 神经网络的数据表示

对于任意神经网络，其#hl(2)[输出可以简化为 N 批次数据，每批次数据中有 L 条数据，每条数据为一个 C 维向量，将向量每个元素称为特征，总计有 $N times C times L$ 个随机变量]。归一化层的实质即#hl(2)[先通过某种方式对这 $N times C times L$ 个随机变量分为 $n$ 组总体]，神经网络输出中对应部分内的元素即总体的样本。

以上描述中，$N$ 即批次大小，$C$ 即特征维度，$L$ 则会由于数据的不同表示方法而存在差异
- 对于单个特征向量或标量特征问题：
  - 通常仅有一条数据或特征仅使用标量表示
  - 此时 $L=1$ 或 $C=1$ 张量一般表示为 $(N, C)$
  - 一般用于 `nn.Linear()` 等专门处理单个特征的层
- 对于图像处理等涉及到卷积运算的问题：
  - 认为数据仅使用简单的一维向量表示，而数据则有意义地排列为多为一维或多维结构
  - 此时 $L=(W, H, ...)$ 张量一般表示为 $(N, C, L = [W, H, ...])$
  - 相关层会关注数据维度而存在 `xd` 的后缀，而通过 `num_features: int` 的参数获取特征维度，如 `nn.Conv1d, nn.BatchNorm2d` 等
- 对于文字或点云序列等序列
  - 不关注数据排列，且数据可能是一维向量，也可能是多维张量的复杂表示
  - 此时 $C=(X, Y, ...)$ 张量一般表示为 $(N, L, C = [X, Y, ...])$
  - 相关层不会关注数据维度，但需要通过 `tuple[int]` 的参数获取特征的形状，并匹配到输入张量的最后几个维度

=== 归一化层的数据运算

神经网络每次输出就相当于一次采样，基于这些采样得到的样本值可以分别估计这 $n$ 组总体 $X_i$ 的均值 $mu_i$ 与方差 $sigma_i^2$ 以将其标准化为 $N(0,1)$ 的标准正态分布，最后再用可学习参数对总体进行仿射变换，转化为适合学习的正态分布 $X'_i tilde N(beta, gamma^2)$。

对于神经网络输出中，来自总体 $X_i$ 的单个样本 $x_i$ 有（其中 $epsilon$ 用于保证数值稳定性）

$ 
x'_i= gamma ((x_i-mu_i)/(sqrt(sigma_i^2+epsilon)))+beta
$

=== 用于图像的归一化层

一般用于图像数据，认为输入张量各维度含义为 $(N, C, L = [W, H, ...])$

*BatchNorm*
- #hl(2)[将所有批次、所有数据的单一特征视为整体]进行归一化。
- 由于 BatchNorm 总体是跨批次，因此估计的是模型全体可能输入的分布，需要用移动平均值估计真实均值与方差用于测试的归一化。这一特性也要求#hl(2)[使用 BatchNorm 时输入分布必须固定]。
- 当训练的 Batch 足够大（至少为 2），且训练与测试分布接近时，BatchNorm 作为归一化层效果最好

*InstanceNorm*
- #hl(2)[将单一批次、所有数据的单一特征视为整体]进行归一化。
- 由于 InstanceNorm 总体限制在单个批次内，因此仅需每次输入数据单独估计均值与方差用于归一化即可。InstanceNorm 相当于限制在单批次内的 BatchNorm，归一化强度降低。
- InstanceNorm 类似对图片各个通道分别均衡化，不能用于深度图等像素值有特定意义的情况，在图像任务中较少使用。

*GroupNorm*
- #hl(2)[将单一批次、所有数据的同组特征视为整体]进行归一化。
- GroupNorm 同样没有跨批次特性，其中分组数为 C 时即具有仿射参数的 InstanceNorm；分组数为 1 时即对所有数据和所有特征进行归一化，仅发挥限制特征数量级防止梯度爆炸的作用，通常作为 #link(<sec:norm_for_seq>)[LayerNorm] 用于图像数据的版本。
- GroupNorm 一般用于边缘设备训练中模型参数量较大而 Batch 只能取较小值的情况，且同样不能用于深度图等像素值有特定意义的情况。

=== 用于序列的归一化层 <sec:norm_for_seq>

一般用于序列数据，认为输入张量各维度含义为 $(N, L, C = [X, Y, ...])$，#hl(2)[如果用于图片等非序列的处理前需要先调换维度]

*LayerNorm*
- #hl(2)[将单一批次、单一数据的所有特征视为整体]进行归一化。
- 由于 LayerNorm 总体限制在单个批次内，因此仅需每次输入数据单独估计均值与方差用于归一化即可。归一化抹平了所有元素间的差异，为了体现各个位置数据的重要性，#hl(2)[LayerNorm 还需要各个被归一化的样本做仿射变换，即每个总体有独立地可学习仿射变换参数]。
- LayerNorm 通常用于数据长度不固定、且批次数较小的序列模型，分别归一化每条词向量，从而将词向量各个特征约束在较小范围内。
- 由于图片各个维度通常记录完全独立的信息，而 LayerNorm 会破坏这些信息因此效果通常不好

=== 归一化层演示

使用以下代码构造 $(N=2, C=4, L=3)$ 的输入张量，测试两种归一化层输出特性

```py
input_tensor = (torch.tensor(
    range(batch_size * data_length * feat_dim), dtype = torch.float32)
).reshape((batch_size, feat_dim, data_length))
```

构造以下张量，两块代表两个批次，块中每列代表一条数据，每行代表不同数据的同一特征。#hl(2)[当来自同一总体的样本被标准化时，这些样本的和为 0]。

```txt
tensor([[[ 0.,  1.,  2.],         [[12., 13., 14.],
         [ 3.,  4.,  5.],          [15., 16., 17.],
         [ 6.,  7.,  8.],          [18., 19., 20.],
         [ 9., 10., 11.]],         [21., 22., 23.]]])  
```

*BatchNorm*：#raw("nn.BatchNorm1d(num_features = feat_dim)", lang: "py")

#codly(highlights: (
  (line: 1, start: 11, end: 35, fill: red),
  (line: 1, start: 50, end: 73, fill: red),
))
```txt
tensor([[[-1.1560, -0.9909, -0.8257],         [[ 0.8257,  0.9909,  1.1560],
         [-1.1560, -0.9909, -0.8257],          [ 0.8257,  0.9909,  1.1560],
         [-1.1560, -0.9909, -0.8257],          [ 0.8257,  0.9909,  1.1560],
         [-1.1560, -0.9909, -0.8257]],         [ 0.8257,  0.9909,  1.1560]]])
```

*InstanceNorm*：#raw("nn.InstanceNorm1d(num_features = feat_dim)", lang: "py")

#codly(highlights: (
  (line: 1, start: 11, end: 35, fill: green),
))
```txt
tensor([[[-1.2247,  0.0000,  1.2247],         [[-1.2247,  0.0000,  1.2247],
         [-1.2247,  0.0000,  1.2247],          [-1.2247,  0.0000,  1.2247],
         [-1.2247,  0.0000,  1.2247],          [-1.2247,  0.0000,  1.2247],
         [-1.2247,  0.0000,  1.2247]],         [-1.2247,  0.0000,  1.2247]]])
```

*GroupNorm*：#raw("nn.GroupNorm(num_groups = int(feat_dim / 2), num_channels = feat_dim)", lang: "py")
#codly(highlights: (
  (line: 1, start: 11, end: 35, fill: yellow),
  (line: 2, start: 11, end: 35, fill: yellow),
))
```txt
tensor([[[-1.4638, -0.8783, -0.2928],         [[-1.4638, -0.8783, -0.2928],
         [ 0.2928,  0.8783,  1.4638],          [ 0.2928,  0.8783,  1.4638],
         [-1.4638, -0.8783, -0.2928],          [-1.4638, -0.8783, -0.2928],
         [ 0.2928,  0.8783,  1.4638]],         [ 0.2928,  0.8783,  1.4638]]])
```

*LayerNorm（卷积）*：#raw("nn.GroupNorm(num_groups = 1, num_channels = feat_dim)", lang: "py")
#codly(highlights: (
  (line: 1, start: 11, end: 35, fill: orange),
  (line: 2, start: 11, end: 35, fill: orange),
  (line: 3, start: 11, end: 35, fill: orange),
  (line: 4, start: 11, end: 35, fill: orange),
))
```txt
tensor([[[-1.5933, -1.3036, -1.0139],         [[-1.5933, -1.3036, -1.0139],
         [-0.7242, -0.4345, -0.1448],          [-0.7242, -0.4345, -0.1448],
         [ 0.1448,  0.4345,  0.7242],          [ 0.1448,  0.4345,  0.7242],
         [ 1.0139,  1.3036,  1.5933]],         [ 1.0139,  1.3036,  1.5933]]])
```

*LayerNorm（时序序列）*：#raw("nn.LayerNorm(normalized_shape = feat_dim)", lang: "py") 
#codly(highlights: (
  (line: 1, start: 11, end: 17, fill: purple),
  (line: 2, start: 11, end: 17, fill: purple),
  (line: 3, start: 11, end: 17, fill: purple),
  (line: 4, start: 11, end: 17, fill: purple),
))
```txt
tensor([[[-1.3416, -1.3416, -1.3416],         [[-1.3416, -1.3416, -1.3416],
         [-0.4472, -0.4472, -0.4472],          [-0.4472, -0.4472, -0.4472],
         [ 0.4472,  0.4472,  0.4472],          [ 0.4472,  0.4472,  0.4472],
         [ 1.3416,  1.3416,  1.3416]],         [ 1.3416,  1.3416,  1.3416]]])
# 已对输入与输出数据进行转置处理 
# lnl(input_tensor.permute((0, 2, 1))).permute((0, 2, 1))
```

*LayerNorm（单一特征）*：#raw("nn.LayerNorm(normalized_shape = feat_dim)", lang: "py") 
#codly(highlights: (
  (line: 1, start: 10, end: 43, fill: blue),
))
```txt
tensor([[-1.3416, -0.4472,  0.4472,  1.3416],
        [-1.3416, -0.4472,  0.4472,  1.3416]],
# 如 MLP，每条数据即一个特征向量
# input_tensor = (torch.tensor(
#   range(batch_size * feat_dim), dtype = torch.float32)
# ).reshape((batch_size, feat_dim))
```