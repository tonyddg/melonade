#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "Diffusion Model 笔记")

#import "/utility/include.typ": *
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
