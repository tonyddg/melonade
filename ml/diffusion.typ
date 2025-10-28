#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Diffusion Model 笔记")

#import "/utility/widget.typ": *
#set image(height: 15em, width: 80%, fit: "contain")

= Diffusion Model 笔记

== Diffusion Model 简介

=== Diffusion Model 的生成过程

#figure(

  grid(
    columns: 2, column-gutter: 2em,
    image("./res/diffusion_1.png", height: 15em, width: auto), 
    image("./res/diffusion_2.png", height: 15em, width: auto), 
  ),

  caption: [Diffusion Model 的生成过程],
)

Diffusion Model 生成图像的过程类似雕刻大理石雕像，图像本来就存在只是被大量的噪声掩盖了，因此只要去除这些噪声就能得到图像。Diffusion Model 生成图像的过程本质上为去除图像中的噪音，称为 Denoise。Diffusion Model 生成图像便是从一张大小确定但像素全为噪音的图片为输入，通过反复调用同一神经网络多步的去噪得到需要的输出图片。

Diffusion Model 中的神经网络便是负责去噪的模型，但模型并不是直接生成去除噪音的图片，而是预测图片中的噪音，并将预测结果减去原始图片。因此模型不用过于关注原图像有什么，只需要找到异常噪音即可，模型更容易训练且适合多步去噪的流程。

在去噪步骤中，由于图片中噪音强度不同时，模型需要的关注点不同，因此也需要将当前步骤告诉模型。注意到此处去噪步骤是从大到小计数的，这是因为：
+ Diffusion Model 认为图片的去噪生成过程是添加图片噪音的逆向过程。
+ Diffusion Model 中调用神经网络为图片去噪的次数是固定的 $T$。

=== Diffusion Model 的训练过程

#figure(

  image("./res/diffusion_3.png", height: 15em, width: auto), 

  caption: [Diffusion Model 的训练过程],
)

Diffusion Model 的训练数据便是通过与去噪过程相反的添加噪音过程得到的。对于一张给定的样本图片，每次加上一层噪音后，生成的噪音图片与噪音层数作为样本，生成的噪音作为模型预测目标。重复 $T$ 次就得到 Diffusion Model 的一组训练样本。使用大量图片的大量样本即可训练 Diffusion Model 中预测噪音的神经网络。

=== 带有输入的 Diffusion Model

#figure(

  image("./res/diffusion_4.png", height: 15em, width: auto), 

  caption: [带有输入的 Diffusion Model],
)

Diffusion Model 同样可以有除去噪图片与去噪步骤之外的输入用于控制输出结果。在使用时，需要每次去噪都将输入传入去噪模块中的神经网络。

== Stable Diffusion 简介

=== Stable Diffusion 的结构

#figure(

  image("./res/diffusion_5.png", height: 15em, width: auto), 

  caption: [Stable Diffusion 结构],
)

Stable Diffusion 中，模型并不是仅有 Diffusion Model，而是包含了三个部分：
+ Text Encoder：文字编码器，将文字编码为特征向量
+ Generation Model：Diffusion Model，与简单的模型不同，此处的 Diffusion Model 不直接生成图像而是生成图像的隐藏表示
+ Decoder：将生成图像的隐藏表示还原为生成图像

=== Stable Diffusion 的训练

Stable Diffusion 中，三个部分的神经网络均是独立训练的，从而无需局限于特定的图片文字对数据：
+ Text Encoder：可以使用任意语言模型的 Encoder 编码语言，通常语言模型越大对生成质量帮助越大。
+ Decoder：通过无监督学习训练得到的#link("/ml/ae.typ")[自编码器]等模型，仅保留解码器部分。
+ Generation Model：同样使用 Diffusion Model，但是样本还经过自编码器中的编码器部分处理，且完全在特征图像上去噪。

=== 生成图片相似性衡量

Diffusion Model 以下衡量标准模型生成图像的准确性
- FID：使用预训练 CNN 分别提取真实图片与预测图片的特征向量，衡量两个特征分布的接近程度（越小越好）
- CLIP：使用 CLIP 模型衡量文字与图片的接近程度（越大越好）


// == Flow Match 生成模型

// 对于样本空间下服从高斯分布的随机变量 $X_0$ 与服从真实分布的随机变量 $X_1$，生成模型的本质为一个映射 $Phi(X_0)$ 用于将随机变量 $X_0$ 映射为 $X_1$。

// 早期的生成模型范式如 GAN 的思路是直接让神经网络拟合这个变换 $Phi(X_0)$，神经网络训练困难。

// $
//   X_1=Phi(X_0)
// $

// 现在的生成模型范式转向增量生成，即多次映射样本，每个时刻都使样本分布向真实分布靠近。称这个采样过程为时间连续的马尔可夫过程（Continuous-time Markov Process），过程中的一系列随机变量 $X_t$ 由 $[0,1]$ 的连续时间 $t$ 索引。

// 此时，神经网络学习的是从时间 $t$ 变换到 $t+h$ 的映射 $Phi_(t+h|t)(X_t)$。

// $
//   X_(t+h)=Phi_(t+h|t)(X_t)
// $

// 其中典型代表即基于 Flow 与 Diffusion 两种模型

// #figure(

//   image("./res/diffusion_flow_match.png", height: 15em, width: auto), 

//   caption: [Flow 与 Diffusion 模型对比],
// )

// 不同于 Diffusion 模型直接预测噪音，将得到样本的过程建模为去噪的过程，Flow 模型预测一个

// 生成过程中，首先采样得到的随机样本，让这个样本沿速度（Velocity）移动一段时间多次以得到生成样本。模型即通过回归方式训练，使其能获取正确的速度。

== Flow Match 生成模型

参考文献
- #link("https://www.bilibili.com/video/BV1cRwJeREgk")[数学角度理论]
- #link("https://zhuanlan.zhihu.com/p/28731517852")[偏直观角度与简单实现代码]

现在的生成模型范式转向增量生成，即多次映射样本，每个时刻都使样本分布向真实分布靠近。称这个采样过程为时间连续的马尔可夫过程（Continuous-time Markov Process），过程中的一系列随机变量 $X_t$ 由 $[0,1]$ 的连续时间 $t$ 索引。其中的代表即 Diffusion 与 Flow Matching。

不同于 Diffusion 模型直接预测噪音，Flow Match 模型预测如何当前样本移动到理想样本的方向矢量，也称为速度（Velocity）。

#figure(

  image("./res/diffusion_flow_match.png", height: 15em, width: auto), 

  caption: [Flow 与 Diffusion 模型对比],
)

在数学角度上 Diffusion 模型与 Flow Match 有很大不同。但在训练角度上 Flow Match 与 Diffusion 模型都是以时间 $t$ 与当前样本 $x_t$ 作为输入，主要区别在于
+ 随机采样样本与数据集样本得到样本对 $x_0,x_1$，而不是从 $x_1$ 生成样本。
+ Flow Match 认为随机样本 $x_0$ 经过时间 $T=1$ 沿由网络预测的速度场运动到 $x_1$。
+ 假设样本以匀速运动，因此其在各个时刻的移动速度均为 $v(x_1,x_0)=x_1 - x_0$，且移动路径上的所有中间点即 $x_t=(x_1-x_0)t+x_0$ 的速度均相同。
+ 因此采样样本对 $x_0,x_1$ 后，从 $t in (0,1)$ 随机采样出一系列中间点 $x_t$ 并将样本差 $x_0,x_1$ 作为这些点的速度 $v(x_1,x_0)$ 即得到模型回归拟合所需的样本 $u^(theta)_t (x_t)=v(x_1,x_0)$。

#figure(

  image("./res/diffusion_flow_match_2.png", height: 15em, width: auto), 

  caption: [数学角度的 Flow Match 模型],
)

在数学角度下 Flow Match 模型初始的随机样本 $x_0$ 沿速度场的运动可表示为微分方程（即样本在当前位置的速度为样本向量 $x_t$ 关于时间的微分）

$
  d/(d t)x_t=u^(theta)_t (x_t)
$

因此预测时也与 Diffusion 模型类似逐步完成，但 Flow Match 以欧拉积分的角度实现推理
+ 设定欧拉积分中的微分步长 $d t$，在微分步长内认为速度场的速度为匀速，有 $x_(t+d t)=x_t + u^(theta)_t (x_t) d t$
+ 随机采样样本 $x_0$ 从 $t=0 arrow 1$ 进行欧拉积分，得到生成样本 $x_1$

实际使用中
+ 模型 $u^(theta)_t (x_t)$ 回归拟合速度时不一定适用简单的 L2 损失函数，而是其他损失函数
+ 样本对 $x_0,x_1$ 的选取不一定是完全随机的，可能有一定规律
