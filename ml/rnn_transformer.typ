#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "RNN 与 Transformer")

#import "/utility/include.typ": *
#set image(height: 15em, width: 80%, fit: "contain")

= RNN 与 Transformer

== 序列模型基础

参考教程 #link("https://www.bilibili.com/video/BV1L44y1m768")

=== 序列数据

对于一串数据，第 $t$ 个位置的数据仅与 $1 tilde.op t-1$ 位置的数据 (之前观察到的数据) 有关时认为这是序列数据，如: 文本，视频等

因此序列数据通常与时间有关，且交换两个位置的数据将改变整个数据的含义

=== 预测序列的未来 <future_predict>

对于一串给定的序列数据 $x_1 tilde.op x_(t-1)$，预测下一个数据 $x_(t)$ 的模型称为自回归模型 (序列数据 $x_(t)$ 为连续值)

与相比一般的回归模型，自回归模型的输入大小取决于已知序列数据的长度，因此模型的输入不是固定的

为了解决不固定输入带来的问题，通常有两种解决方案
1. 马尔可夫假设: 认为 $x_(t)$ 仅与过去的 $tau$ 个数据 $x_(t-1) tilde.op x_(t-tau)$ 有关，此时模型输入固定可作为一般的回归问题 $x_t=F(x_(t-1),  dots, x_{t- tau})$ $arrow$ 预测多个未来时刻的数据时，除非可以证明序列的马尔可夫特性，否则模型将很容易受噪音影响
1. 隐变量模型：引入一个隐变量 $h_t=H(x_(t-1), dots,x_1)$ 表示过去的信息，利用隐变量模型 $h_(i+1)=H(x_i,h_(i))$ 遍历 $x_1  tilde.op x_(t-1)$ 编码序列得到所需的隐变量，预测模型仅需基于隐变量进行 $x_t=F(h_(t))$

隐变量 (Hidden Variable) 表示存在但观察不到的变量，潜变量 (Laten Variable) 在表示隐变量的同时也可以表示实际不存在人为创造的变量 (如聚类标记的类别)

=== 词元化

处理文本前，需要对文本进行预处理，将文本通过各种方式划分为多个词元 (Token) 并为各个词元赋予一个索引 (Index) 作为序列数据，

除了实际的词元，也存在特殊词元用于标记未知词元或句子开头与结尾等

将文本划分为多个词元的方法称为 Tokenize，常用方法#link("https://developer.baidu.com/article/detail.html?id=3248756")[参见]

词元与索引的映射必须是唯一且不变的，称为词汇表 (Vocabulary)，将原始语料库中每个完整句子分词并映射为索引后即可得到多个序列

== 循环神经网络 RNN

参考教程 #link("https://www.bilibili.com/video/BV1L44y1m768")

=== 循环神经网络的隐变量

在#link(<future_predict>)[隐变量模型]中，预测的隐变量 $h_t$ 与 $x_(t-1),h_(t-1)$ 有关，而预测的下一时刻数据 $x_t$ 仅与隐变量 $h_t$ 有关 (部分文章中输入下标为 $x_(t)$，输出下标为 $x_(t+1)$)

#figure(
  image("./res/rt_1.png"), 
  caption: [循环神经网络的隐变量],
)

因此对于如 的单层的循环神经网络中，隐变量模型使用单层神经元将输入的 $x_(t-1),h_(t-1)$ 映射为 $h_t$ 有 (其中激活函数 $ phi$ 默认为 $ tanh$ 也可以是 $"Relu"$ 等)

$ h_t= phi(W_"hh"h_(t-1)+W_"hx"x_(t-1)+b_h)  $

为了得到可用输出，还需要单层隐藏层将隐变量映射为输出

$ o_t=W_"ho"h_t+b_o  $

如果没有隐变量，就相当于 MLP 的一个隐藏层与一个输出层

=== 困惑度

语言模型从 $t$ 开始预测一段话下一个词元，并预测了 n 次相当于是做了 n 次分类，因此可用这 n 次分类的交叉熵表示语言模型预测的准确性，称为平均交叉熵

$  pi =  (1)/(n)  sum_(k=1)^(n) - log p(x_(t+k)|x_(t+k-1), dots)  $

其中 $p$ 表示给定序列 $x_(t+k-1), dots$，模型预测词元为真实值 $x_(t+k)$ 的概率，当模型预测分布中真实值出现概率为 $100%$ 则 $- log$ 结果为 $0$，否则平均交叉熵将增大

语言模型衡量标准则在平均交叉熵基础上取指数满足 $ exp( pi)$，称为困惑度

=== 梯度裁剪

由于循环神经网络要得到输出前需要经过大量矩阵运算才能得到所需的隐变量 $h_t$ 并输出为 $x_t$，因此反向传播过程极容易由于梯度模长过长导致梯度爆炸使训练失败

为了防止梯度爆炸导致训练失败，常用的技巧为梯度裁剪，当梯度 $ bm(g)$ 的模长超过给定 $ theta$ 时线性缩放到 $ theta$

$  bm(g)'= min(1,  theta/abs(bm(g))) bm(g)  $

=== 循环神经网络应用

#figure(
  image("./res/rt_2.png"), 
  caption: [循环神经网络应用],
)

在上文中提到了自回归模型用于给定一串任意长度的序列预测下一个值，但 RNN 的应用并不仅局限于预测序列未来数据

如图所示RNN 可以将序列编码为隐变量最后
- 输出类别用于语句分类
- 将隐变量展开为输出序列用于问答或翻译
- 将输入序列每个隐变量映射为对应位置词元打标签

=== 循环神经网络的实现

- 词元的索引为离散的标量，因此一般会使用 One-Hot 编码将其转换为连续向量作为神经网络输入或输出
- 当词元非常丰富时，One-Hot 编码将导致输入维度过大，此时将使用 Embedding 将词元编码为维度较低的特征向量
- 最初的隐变量 $h_0$ 是未知的，通常使用 0 向量

== 现代循环神经网络

RNN 无法处理过长的序列，现代循环神经网络在 RNN 基础上提出，对于 100 以内的短序列数据取得较好效果 (对于更长的序列推荐使用 Transformer 等更先进的架构)

=== 门控神经网络 GRU

序列中的各个值并不是同等重要，RNN 中没有对数据进行区分导致其无法处理过长的序列

GRU 引入了门控的概念
- 即使用一个大小与隐变量相同且元素值范围为 $0  tilde.op 1$ 的门控向量与隐变量对应元素相乘，从而调整隐变量
- 门控向量中取值为 0 的元素将抑制对应位置的隐变量值，反之则保留，起到了类似电路中门的效果
- 门控向量同样依据输入 $x_(t-1),h_(t-1)$ 以及一组可学习参数获得，通过训练学会给出正确的门控向量
- 获得门控向量的过程类似全连接层，并使用 Sigmoid 激活函数限制每个元素的取值范围，同时实现柔性的开关效果
- GRU 中包含了以下两个门，其计算规则如下
    - 重置门 $r_(t)$ 用于抑制隐变量 $h_(t-1)$ 中对于当前时刻预测无用的状态
    - 更新门 $z_(t)$ 用于延续隐变量 $h_(t-1)$ 中后续预测关注的状态


$
r_(t)= sigma(W_"rh"h_(t-1)+W_"rx"x_(t-1)+b_r) \
z_(t)= sigma(W_"zh"h_(t-1)+W_"zx"x_(t-1)+b_z)
$

#figure(
  image("./res/rt_4.png"), 
  caption: [门控神经网络 GRU],
)

两个门使用如图所示的方式参与到下一时刻隐藏变量 $h_t$ 的计算中，其中 $ dot.circle$ 表示两个向量对应元素相乘

重置门参与下一时刻的候选隐变量 $ tilde(h)_t$ 的计算，通过重置为 0 丢弃上一时刻隐变量中不需要的状态

$  tilde(h)_t= phi[W_"hh"(r_(t) dot.circle h_(t-1))+W_"hx"x_(t-1)+b_h]  $

更新门参与上一时刻隐变量与候选隐变量的加权求和，从上一时刻隐变量中选择有价值的状态传递到下一时刻

$ h_t=z_(t) dot.circle h_(t-1) + (1-z_(t)) dot.circle  tilde(h)_(t)  $

=== 长短期记忆网络 LSTM

GRU 在 LSTM 的基础上简化得到，二者有着相近的性能但 LSTM 更加复杂包含
- 划分为两个部分的隐变量: 隐藏状态 $h$ 与记忆单元 $c$ 分别代表短期与长期记忆，二者形状相同但记忆单元 $c$ 仅在序列预测中使用而隐藏状态 $h$ 将作为网络的输出
- 通过三个门: 遗忘门 $f$，输入门 $i$，输出门 $o$ 控制单层中的数据 (门变量计算方法不变)

#figure(
  image("./res/rt_5.png"), 
  caption: [长短期记忆网络 LSTM],
)

在 LSTM 计算中，首先依据输入数据 $x_(t-1)$ 与隐藏状态 $h_(t-1)$ 计算候选记忆单元 $ tilde(c)_t$

$  tilde(c)_t= tanh(W_"ch"h_(t-1)+W_"cx"x_(t-1)+b_c)  $

上一时刻的记忆单元包含过去的信息，候选记忆单元包含现在的信息，与 GRU 的加权求和不同，LSTM 通过遗忘门与输入门混合二者来确定哪些状态需要记录到记忆中

$ c_t=f_t dot.circle c_(t-1)+i_t dot.circle tilde(c)_t  $

最后使用 $ tanh$ 缩放记忆单元 $c_t$ 到值域 $(-1,1)$ 避免梯度爆炸，以及输出门 $o$ 筛选记忆单元中对当前预测有用的信息，得到输出的隐藏状态

$ h_t=o_t dot.circle tanh(c_t)  $

=== 双向循环神经网络

对于完整序列已知编码改序列的场景中，单向循环神经网络只能沿时间增大方向读取序列，每个时刻仅看得到过去信息而不能充分利用已知的未来的信息

双向循环神经网络被提出，通过增加一个反向处理序列的过程充分利用未来信息，从而更加准确的编码序列，但也因此双向循环神经网络无法用于预测序列未来数据，只能用于编码序列

在遍历输入序列得到隐状态序列 $ {h_t }$ 的同时，将输入序列反向后遍历 (网络相同但结构不同) 得到另一组隐状态序列 $ {h'_t }$ 并将相同输入的隐状态合并作为输出序列，因此输出序列中数据大小为隐藏状态大小两倍

由于双向循环神经网络计算量过大的问题，通常较少在实际中使用

=== Torch 的循环神经网络

#figure(
  image("./res/rt_3.drawio.png"), 
  caption: [Torch 的循环神经网络],
)

PyTorch 中 RNN 以如图所示的方式使用
- RNN 在定义时可以具有多层隐藏层且不包含输出层，使用时将自动遍历传入序列得到序列各个位置对应的隐变量
- 规定: L 序列长度，B 批次大小 (支持单样本输入，此时忽略批次大小维度)，H 隐变量长度 (RNN 大小)，X 输入序列数据向量长度，N 隐藏层数量
- RNN 层的输入中
    - `input` 输入的序列数据，形状默认为 (L, B, X)
    - `hx` 各层隐变量的初始值，形状默认为 (N, B, H)，默认使用 0 向量
- RNN 层的输出中
    - `output` 最外隐藏层遍历序列时各个时刻的隐变量，即经过 RNN 编码后的序列，形状默认为 (L, B, H)
    - `h_n` 处理序列后各层在最后时刻的隐变量，从外到里排序，形状为 (N, B, H)
- GRU 与 RNN 相同，LSTM 由于隐变量包含两部分，因此隐变量使用一个元组管理，此时
    - 输入为 `input, (h_0, c_0)`
    - 输出为 `output, (h_n, c_n)`
- 通过参数 `bidirection = True` 可以启用双向循环神经网络，此时网络层的输入与输出发生改变
    - 对于表示隐藏状态的 `hx, h_n`，PyTorch 将反向处理序列的网络视为独立隐藏层，即隐藏层数翻倍，因此形状为 (2 x N, B, H)
    - 对于网络输出的序列 `output`，合并对应输入数据并按正向排列，即隐藏状态大小翻倍，因此形状为 (L, B, 2 x H)
    - 由于输出按序列位置排列，为了利用反向序列的输出，通常会取 `torch.cat((output[0], output[-1]), dim = 1)` 作为序列特征
- 部分应用中使用 `h_n[0]` 提取 RNN 将句子编码后的特征向量，为了适应 LSTM 与双向神经网络，建议使用 `output[-1]` 这一较为通用的方法取网络输出的末尾

一般循环神经网络都会使用两层相同大小的网络以获得一定非线性性，大小一般取 256 等

== 序列到序列学习

=== 编码器解码器架构

#figure(
  image("./res/rt_6.png", height: auto), 
  caption: [编码器解码器架构的抽象],
)

常见的机器学习神经网络结构可以简单划分为编码器解码器架构，即将模型分为两块：
- 编码器（Encoder）：将输入编码为某种利于机器学习的表达形式（特征），例如图像分类任务中的主干提取网络
- 解码器（Decoder）：将编码器得到的特征转化为所需的模型输出，例如图像分类任务中的分类头（全连接层）
- #hl(2)[编码器除了接收特征向量外，还允许其他额外的输入]

=== 序列到序列任务的编码器与解码器

#figure(
  image("./res/rt_7.png", height: auto), 
  caption: [序列到序列任务的编码器与解码器],
)

序列到序列任务中, 输入与输出均为任意长度的序列, 通常使用编码器解码器结构处理这类任务, 此时
- 编码器的 RNN 仅负责提取序列特征, 因此不需要输出层调整隐藏状态, 而是直接将最后时刻的隐藏状态输出
- 解码器在推理时与一般序列模型类似，使用上一时刻输出作为输入，从而生成任意长度的序列
- 解码器以开始标记 `<bos>` 作为初始输入, 编码器的隐藏状态作为初始状态, 之后像一般语言模型将上一时刻输出作为输入从而生成一段序列直到输出结束标记 `<eos>`

序列到序列模型的训练中
- 编码器同样仅编码输入序列, 但解码器不再使用上一时刻输出作为输入, 而是上一时刻的真实输出, 避免训练初期序列预测跑偏带来的问题（称为 Teacher Forcing）
- 为了避免使用 Teacher Forcing 时，解码器在训练时无法应对错误输出的问题，可以在真实输出内加入噪音（称为 Scheduled Sampling）
- 使用指标 BLEU 衡量序列预测的准确性
    - 有 n-gram 精度 $p_n$ 表示对于长为 $n$ 的不同词组, 生成序列有效词组占目标序列所有词组数的比值 (当词组在目标序列中为有效), n 越大, $p_n$ 越高表明匹配越精准
    - 当生成序列过短, $p_n$ 衡量将失真, 需要额外的过短惩罚

$
"BLEU" = exp( min(0,1-("len"_("label"))/("len"_("pred")))) dot product^("len"_("label"))_(n=1)p_n^(1/2^n)
$

=== 序列到序列任务的数据处理

在序列到序列模型的样本训练中，为了保证数据能按批量读取与操作，需要保证样本的序列长度相同，为此在 `<bos>` 外引入了以下两个标记：
- 引入结束标记 `<eos>`，标记一段样本序列到达末尾（可以使用和 `<bos>` 相同的符号）
- 引入填充标记 `<pad>`，在短于给定长度的样本序列后填充此标记，反之则截断
- 通过标记 `<eos>` 位置模型可以判断句子有效部分，而读取不到则表明句子被截断
- 通过标记 `<pad>` 的填充保证了每个样本具有相同的长度，可在反向传播时屏蔽这一标记的影响

=== 束搜索

在一般的神经网络分类任务中，都会直接选择预测概率最大的作为分类结果。在序列预测中只能直到当前序列下选择特定词元的概率，而无法直到所有序列的概率。

#figure(
  grid(
    columns: 2, column-gutter: 5em,
    image("./res/rt_8_1.svg", height: auto, width: auto), 
    image("./res/rt_8_2.svg", height: auto, width: auto), 
  ),
  
  caption: [贪心搜索的困境],
)

如果依然选择预测概率最大的作为结果的贪心搜索，那么会出现如上图的贪心搜索困境。即在时间步 2 选择概率最大的预测结果得到整体序列概率 $0.5 times 0.4 times 0.4 times 0.6=0.048$ 并非最优序列，概率低于在时间步 2 选择次优预测结果得到整体序列概率 $0.5 times 0.3 times 0.6 times 0.6=0.054$。

#figure(

  image("./res/rt_9.svg"), 

  caption: [束搜索],
)

虽然穷举搜索遍历所有序列概率一定能得到最优序列，但是计算代价过大。束搜索则尽在最优的 $k$ 个序列上搜索，在计算量小的同时保证预测序列尽可能最好（共有 $n$ 个词元，最长预测 $T$ 步）：
- 第一次预测与一般预测相同，但选择最优的 $k$ 个词元合并为一个 batch
- 对整个 batch 进行预测，得到 $k times n$ 个序列概率（子序列概率乘预测词元概率），从中选择最优的 $k$ 个合并为 batch 预测下一词元
- 束搜索有时间复杂度 $O(k n T)$，贪心搜索与穷举搜索即 $k=1,k=n$ 的情况

对于生成确定序列的任务如语音辨识束搜索有较好作用，但对于需要发挥创造性任务搜索最优序列意义不大。

== 注意力机制

参考教程 #link("https://www.bilibili.com/video/BV1Wv411h7kN?p=38")

=== 注意力机制的引出 <attention_mech>

#figure(

  image("./res/rt_10.png"), 

  caption: [注意力机制],
)

注意力机制的原始目标即，已知一系列样本与标签（称为 key-value），现有一个新的样本（称为 query）想要知道其对应的值是多少。一种朴素的想法即当 query 与 key 越接近，那么 query 对应的 value 也就会越接近，由此引出注意力机制的计算：

对于输入的 query，计算query 与所有 key 之间的相似性，用这个相似性作为对用 value 的权重求和即可预测 query 对应的标签，即注意力机制的输出（称为查询结果），数学表示如下：

// query 的查询结果通常表示为 query $q$ 与所有 key $k_i$ 之间*注意力权重* $ alpha(q,k_i)$ 关于 $k_i$ 对应 value $v_i$ 的加权和 ($q,k_i$ 可以是不同形状的向量)

$ 
f(q)= sum_(i=1)^n alpha(q,k_i)v_i
$ 

在实际应用场景中，query、key、value 并不一定局限于其字面含义
- query 与 key 不一定是来自同一结构的样本，也可能是不同的输入（多模态融合），value 也可以是向量而不是标量
- query、key、value 也可以是完全相同的一组样本，通过查询每个样本的输出提取特征（自注意力机制）

// 理解 query、key、value 时，应跳出 Nadaraya-Watson 核回归，即 query、 key、value 并不一定局限于其字面含义，在不同场景中可能有不同含义

=== 注意力分数

为了保证查询结果（$v_i$ 的加权和）不会发生偏离，需要利用 $"softmax"$ 标准化以保证权重和为 $1$，此时注意力权重表示为

$  
alpha(q,k_i)="softmax"[a(q,k_i)]
$ 

其中 $a(q,k_i)$ 即衡量 $q,k_i$ 之间的相似性的*注意力分数*，通常是一个可学习的函数，称函数 $a$ 为*注意力打分函数*  
设计不同的注意力分数即可实现不同的注意力机制

=== 相加注意力分数 Additive Attention

对于 $ arrow(q) in RR^(q), arrow(k) in RR^(k)$，相加性注意力分数中，有可学习参数 $ bm(W)_k in RR^(h times k), bm(W)_q in RR^(h times q)_, arrow(w) in RR^h$，注意力打分函数为 

$ 
a( arrow(q), arrow(k))= arrow(w)^T tanh( bm(W)_k arrow(k)+ bm(W)_q arrow(q))
$ 

此时注意力分数函数 $a$ 相当于将 $ arrow(q), arrow(k)$ 沿向量方向合并后传入隐藏层大小为 $h$，输出层大小为 $1$ 的 MLP（注意此 MLP 中没有偏置，#hl(2)[注意力机制相关的模块默认情况下都是没有偏置的]）

在此类注意力分数中，query 与 key 的大小可以不同

=== 点积注意力分数 Scaled Dot-Product Attention <dot_product_attention>

#figure(

  grid(
    columns: 2, column-gutter: 5em,
    image("./res/rt_11_1.png", height: 15em, width: auto), 
    image("./res/rt_11_2.png", height: 15em, width: auto), 
  ),

  caption: [点积注意力分数],
)

对于 $ arrow(q), arrow(k) in RR^(d)$，由于 query 与 key 相同，点积注意力机制直接使用点积衡量二者的相似度。（此处还除以了 $d$ 根据向量长度调整分数，用于保证训练梯度的稳定性）

$ 
a( arrow(q), arrow(k))=( arrow(q) dot arrow(k))/( sqrt(d))
$ 

一般情况下，此类注意力分数中，query 与 key 的大小必须相同，且没有参数。也可以如右图引入一个全连接层将不同大小的 query 与 key 映射为大小相同的特征向量。

== 自注意力模块

#figure(

  grid(
    columns: 2, column-gutter: 2em,
    image("./res/rt_12_1.png", height: 15em, width: auto), 
    image("./res/rt_12_2.png", height: 15em, width: auto), 
  ),

  caption: [注意力机制处理序列数据],
)

参考教程：#link("https://www.bilibili.com/video/BV1Wv411h7kN?p=49")

自注意力模块与 RNN 类似都是用于解决序列任务，但与 RNN 不同，自注意力模块中没有隐变量，而是通过注意力机制，其能够直接输出一个新的特征向量序列，这个序列不但提取了对应位置输入的特征，更多的还结合了整个序列其他元素的上下文信息。

相比 RNN 与 CNN，自注意力模块最大的特性即可以同时且平等地考虑整个序列。

=== 自注意力模块的计算

#figure(

  grid(
    columns: 2, column-gutter: 2em,
    image("./res/rt_13_1.png", height: 15em, width: auto), 
    image("./res/rt_13_2.png", height: 15em, width: auto), 
  ),

  caption: [自注意力模块的计算],
)

自注意力模块在计算输入序列的元素 $x_i$ 时结合上下文信息的方法即：通过三个全连接层将输入元素分别映射为大小相同的 key、query、value（记为 $arrow(q)_i,arrow(k)_i,arrow(v)_i$）；根据当前计算的序列位置取出 $arrow(q)_i$，使用#link(<dot_product_attention>)[点积注意力分数]与 $"Softmax"$ 计算注意力权重；value 重经过#link(<attention_mech>)[注意力机制]的加权求和得到查询结果 $arrow(b)_i$，即输出序列位置 $i$ 的元素，表示输入元素 $arrow(x)_i$ 结合了上下文信息后的特征；对输入序列的每个元素进行一次相同的查询计算即可得到自注意力模块的输出。

数学表示中，将序列各个元素（列向量）沿列方向合并即可得到矩阵，因此可将序列表示为矩阵 $bm(I),bm(O),bm(Q),bm(K),bm(V)$，此时自注意力可使用如下的数学表示：

首先将输入映射为 key、query、value：

$
  bm(K)=[arrow(k)_1 dots arrow(k)_n]=[bm(W)^k  arrow(x)_1 dots bm(W)^k  arrow(x)_n]=bm(W)^k [arrow(x)_1 dots arrow(x)_n]==bm(W)^k bm(I)
$

然后计算查询 $i$ 对应的点乘注意力分数再使用如 $"Softmax"$ 等函数标准化为注意力权重，也可将计算各个元素的注意力权重转化为矩阵形式（其中 $Phi_"col"$ 表示按列标准化函数，例如按列的 Softmax）：

$
  vec(delim: "[", alpha_(1,i), dots, alpha_(n,i))=vec(delim: "[", arrow(k)_1^T, dots, arrow(k)_n^T)arrow(q)_i=bm(K)^T arrow(q)_i arrow bm(A)=mat(delim: "[", alpha_(1,1), dots, alpha_(1,n); dots.v, dots.down, dots.v; alpha_(n,1), dots, alpha_(n,n))=vec(delim: "[", arrow(k)_1^T, dots, arrow(k)_n^T)[arrow(q)_1 dots arrow(q)_n]=bm(K)^T bm(Q) \ bm(A)'=Phi_"col" (bm(A))=Phi_"col" (bm(K)^T bm(Q))
$

最后使用注意力权重计算对应 value 的加权和作为输出：

$
  arrow(b)_i=[arrow(v)_1 dots arrow(v)_n]vec(delim: "[", alpha'_(1,i), dots, alpha'_(n,i)) arrow bm(O)=bm(V)bm(A)'=bm(V)Phi_"col" (bm(K)^T bm(Q))
$

因此注意力机制中仅三个映射矩阵需要学习

=== 多头自注意力模块

#figure(

  grid(
    columns: 2, column-gutter: 2em,
    image("./res/rt_14_1.png", height: 15em, width: auto), 
    image("./res/rt_14_2.png", height: 15em, width: auto), 
  ),

  caption: [多头自注意力模块],
)

结合上下文时，特征可能存在多个方面单个自注意力模块无法区分这些方面，因此就有了多头自注意力模块：使用多组投影矩阵处理输入，从而得到多组的 key、query、value，单独计算各组的输出向量，最后合并这些输出并使用一个投影矩阵转为最终输出向量。

=== 位置编码

在自注意力模块中，输入序列没有包含相对位置信息，但对于大部分情况下，如图片与文字，序列的相对位置都是非常重要的。为了编码位置信息，同样需要将位置信息编码为一维向量，即位置嵌入 (Position Embedding)，并且习惯上#hl(2)[通过相加]而不是合并将位置编码信息附加到序列中。

位置编码可以是多种形式
- 固定位置编码: 根据向量在序列中的位置，生成对应的位置编码 (基本 Transformer)
- 可学习位置编码: 将位置编码作为一个大小为 (1, L, X) 的可学习参数直接加在序列上（多用于序列固定长度的图片）
- 如果序列之间没有位置关系，则可以不使用位置编码

=== Masked Self-Attention <masked-sa>

#figure(

  image("./res/rt_16.png", height: 15em, width: auto), 

  caption: [Masked Self-Attention],
)

将自注意力模块用于序列输出时，预测序列下一时刻的元素 $arrow(a)_i$ 时，完整的序列还是未知的，因此只有过去的序列 $arrow(a)_(1) dots arrow(a)_(i-1)$ 能用于预测，相当于后续的序列不参与自注意力的计算，因此称为 Masked Self-Attention。

=== 交叉注意力模块 <cross-attention>

#figure(

  image("./res/rt_17.png", height: 15em, width: auto), 

  caption: [交叉注意力模块],
)

自注意力模块中 key、query、value 均来自同一个输入，但是也可以来自不同的输入，仅需分别使用全连接层调整为相同大小的特征向量，此时称为交叉注意力模块。模块的输出仅与 query 序列长度有关，key 与 value 需要有一一对应关系。

如图，在原始 Transformer 解码器中便是通过交叉注意力模块，其中 key 与 value 来自编码器输出的特征向量序列，query 来自解码器的输入，从而充分利用编码器输出的高层特征。

=== 自注意力模块的变形

参考教程 #link("https://www.bilibili.com/video/BV1Wv411h7kN?p=51")

当序列非常长时，自注意力模块的运算量将以平方级上升，可以用不同技巧提高自注意力模块运算速度，此处略。

== Transformer

=== Transformer 编码器

#figure(

  grid(
    columns: 2, column-gutter: 2em,
    image("./res/rt_15_1.png", height: 15em, width: auto), 
    image("./res/rt_15_2.png", height: 15em, width: auto), 
  ),

  caption: [Transformer Block],
)

Transformer 架构中的编码器由多个 Transformer Block 叠加得到，而每个 Transformer Block 中又包含了一个多头注意力模块与全连接层，其具体计算方式如下
- 输入序列的元素 $arrow(b)_i$ 首先经过多头自注意力模块输出特征 $arrow(a)_i$
- 通过残差链接将输出与输入相加，再经过 Layer Norm。与不同特征同一属性间标准化不同，Layer Norm 为同一特征不同属性间标准化，即分别标准化序列的各个特征向量内的元素。
- 输出特征再经过类似的过程，只是使用全连接层提取特征后残差连接与标准化。

=== Transformer 解码器

#figure(

  grid(
    columns: 2, column-gutter: 2em,
    image("./res/rt_19_1.png", height: 15em, width: auto), 
    image("./res/rt_19_2.png", height: 15em, width: auto), 
  ),

  caption: [Transformer 解码器],
)

RNN 的 seq2seq 中可以直接使用编码器输出的各层隐状态传入解码器。Transformer 编码器输出则是各层的特征向量序列，通过在解码器的自注意力模块与全连接层中间插入#link(<cross-attention>)[交叉注意力模块]，将编码器输出的序列作为 key、value 传入解码器，自注意力模块输出作为 query，实现对编码器输出特征的利用。

传入解码器的 key、value 不一定要来自对应层的编码器，也可以是编码器最终输出的特征向量，可以参考论文 #link("https://arxiv.org/pdf/2005.08081")。

由于 Transformer 解码器负责输出向量，因此无法知道完整的输出序列作为输入而是之前输出的序列，将这种自注意力模块称为#link(<masked-sa>)[Masked Self-Attention]

=== 非渐进式解码器

#figure(

  image("./res/rt_18.png", height: 15em, width: auto), 

  caption: [Masked Self-Attention],
)

编码器除了像 RNN 的解码器一样，每次仅预测下一个时间步的向量，每次将旧序列输入经过一次计算效率将非常低，无法发挥注意力机制相比 RNN 并行化运算的优势，因此非渐进式解码器（NAT Non-AutoAggressive）被提出：通过某种方法预测序列输出长度 $n$（如额外神经网络根据编码器输出预测长度），直接输入一个由 $n$ 个占位符如 `<bos>` 组成的伪序列，得到长度为 $n$ 的序列。

// == BERT

// #bl(2)[以下为草稿]

// - BERT 在序列的第一个元素传入无意义的标记 `<cls>`，再将对应位置的输出特征向量作为整个序列的特征，因为 `<cls>` 一定在第一个位置且本身无意义


// - BERT 只有 Transformer 的编码器部分，输入序列第一个元素为标记 `<cls>`，表明该标记对应的输出为整个序列的特征向量。由于 `<cls>` 一定在第一个位置且本身无意义，保证对应位置作为 query 时，能公平地反映整个序列的特征。


