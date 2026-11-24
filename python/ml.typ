#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "神经网络开发杂记")

#import "/utility/include.typ": *

= 神经网络开发杂记

主要记录神经网络相关编程时用到的 Python 模块使用技巧

== Pytorch Lightning 高层训练框架

Pytorch Lightning 提供了模型类 `LightningModule`，开发自己的神经网络时，只需要通过定义该类虚函数的形式，规定好神经网络模型在训练、测试、推理等各个环节的底层细节，就可以接入 Pytorch Lightning 封装好的高层应用模块完成训练与验证循环、日志与 CheckPoint 管理、分布式与设备管理等工作而无需重复代码开发。

习惯上通过 `pip install lightning` 安装，再使用 `import lightning.pytorch as pl` 导入

=== LightningModule 定义

如果要接入 Pytorch Lightning 封装好的其他应用模块，首先需要将自己的模型封装为 `pl.LightningModule` 的子类（后续省略模块），一个标准的 `LightningModule` 子类通常需要实现以下接口

==== \_\_init\_\_ 构造函数 <sec:module_init>

接口原型：`def __init__(self, **kwargs)`
- 类似 `nn.Module`，构造函数中必须首先调用父类构造函数 `super().__init__()`
- `LightningModule` 认为构造函数的其他参数均为模型超参数，因此还建议在函数内主动调用 `self.save_hyperparameters()` 保存构造函数的参数
  - 该字典将随 CheckPoint 保存到 YMAL 文件中，因此需要保证构造函数参数类型为 `float, int, str, dict[str, ...], list` 等易于序列化的类型，可以但官方不建议使用 `dataclass`（可以传入时使用 `dataclasses.asdict(...)` 转为字典，再在类内重新构造）
  - 如果要传入特殊类型的参数，则要使用 `save_hyperparameters` 方法的参数 `ignore: list[str]` 明确不希望被记录的参数名
  - 通过该方式可使用 `self.load_from_checkpoint(checkpoint_path, **kwargs)` 从 CheckPoint 的 #link(<sec:train_checkpoint>)[`ckpt` 文件]中还原模型。其中 `ignore` 忽视的参数还需要通过 `**kwargs` 手动传递
  - 构造函数参数还将保存到字典 `self.hparams` 中，字典键值即参数名，键值即参数值。因此除了可以定义为 `self` 属性，也可以直接从该字典读取参数
  - `save_hyperparameters` 方法保存的是该方法调用时函数参数的值，因此如果在此之前函数参数被修改了将保存修改的版本
- 类似 `nn.Module`，一个 `LightningModule` 中允许有多个 `nn.Module` 类型的子模型，但需要在 `super().__init__()` 后将所有子模型定义为类属性
- 建议在 `__init__` 中定义属性 `self.example_input_array` 给出模型的示例输入（可通过 `torch.randn()` 构造），即 `self.forward()` 输入参考，可用于后续验证与分析模型

==== forward 基础推理函数

接口原型：`def forward(self, **kwargs)`
- 类似 `nn.Module`，即模型基础推理函数，对输入与输出没有规定，且将会在 `self.__cal__()` 中调用该函数

==== configure_optimizers 优化器与学习率调度配置

接口原型：`def configure_optimizers(self)`
- 需要在该函数中定义模型训练的优化器（如 `torch.optim` 中的优化器）以及如学习率等优化器参数，还可以定义优化器的学习率调度器（如 `torch.optim.lr_scheduler`）
- 优化器访问模型参数时，除了各个模型的 `parameters()` 方法，还可以调用 `self` 的 `parameters()` 方法访问所有类内所有自模型的参数
- 通过函数返回值确定定义了哪些优化器
  - 仅有单个优化器，没有学习率调度：返回单个优化器对象 `Optimizer`
  - 有多个优化器，没有学习率调度：返回优化器对象列表 `list[Optimizer]`
  - 有学习率调度：返回元组 `tuple[list[Optimizer], list[LRScheduler]]`

==== 训练与验证循环 <sec:train_loop>

在训练与验证循环中，模型性能指标通过对象方法 `self.log(name, value, ...)` 记录，该方法具有以下参数
- `name, value` 指标名的字符串与指标值，可以是 `float, int, torch.Tensor`
- `prog_bar = False, logger = True` 两个 bool 开关，分别控制是否在进度条上显示指标与在 Logger 上记录指标
- `on_step, on_epoch` 两个 bool 开关，用于控制指标记录频率，即取 `True` 后将按 `step`（每次报告记录） 或按 `epoch`（一般为取一个 Epoch 里的均值，可修改）记录指标
  - 在训练循环 `training_step` 中默认为 `on_step = True, on_epoch = False`
  - 在验证循环 `validation_step` 中默认为 `on_step = False, on_epoch = True`
  - 当取 `on_step = True, on_epoch = True` 时，将加上 `_step, _epoch` 的后缀分化成两个不同的指标
- `batch_size` 当前 Step 的 Batch Size，用于计算 Epoch 均值，可以手动传入 `X.size(0)` 也可以自动推断

接口原型：`def training_step(self, batch: Batch, batch_idx: int)` 单步训练
- 参数 `batch` 即一个 `DataLoader` 读出的一个 Batch 的数据，通常为 `Sequence[torch.Tensor]` 或 `dict[str, torch.Tensor]`；`batch_idx` 为 Batch 的编号
- 通常需要在该函数内计算 loss、调用 `self.log` 记录训练日志（建议至少记录训练 loss）最后返回 loss，梯度反向传播将在训练框架内自动完成
- 对于复杂场景，可以在构造函数中规定 `self.automatic_optimization = False`，此时需要手动调用优化器（通过 `self.optimizers()` 获取）完成梯度反向传播，单个优化器梯度下降流程一般为：（使用前建议参考文档）
  - `opt_a.zero_grad()` 清除优化器梯度 #sym.arrow `loss_a = compute_loss_fn(batch)` 计算损失 #sym.arrow `self.manual_backward(loss_a)` 使用内置方法梯度下降（不是张量方法）#sym.arrow `opt_a.step()`

接口原型：`def validation_step(self, batch: Batch, batch_idx: int)` 单步验证
- 参数含义与 `training_step` 相同，但不需要返回值，而是使用 `self.log` 方法记录模型指标
- 将在个训练 Epoch 结束后将模型转为 `eval` 模式，并在无自动梯度设置下调用
- 除此之外还有 `test_step` 专门用于独立的测试阶段，具体见#link(<sec:train_load_test>)[CheckPoint 测试]

=== 模型训练与管理 <sec:train_checkpoint>

定义好 `LightningModule` 后，可以由 `pl.Trainer` 类（后续省略模块）完成训练与验证循环，并完善底层细节

==== 训练行为参数

训练行为参数通过 `Trainer` 类定义时确定，常用的参数有
- 以下三个参数用于规定训练长度，如果同时给出，将在任意一个条件满足后终止训练
  - `max_epochs = 1000` 最大 Epoch 数；`max_steps` 参数最大更新次数；`max_time` 最长训练时间（规定方式见文档）
- 以下两个参数用于规定训练设备，对于单显卡场景取 `auto` 即可（默认值），具体见文档
  - `accelerator = "auto", devices = "auto"` 训练设备与编号
- 以下参数用于控制训练行为
  - `precision` 训练精度模式，通过字符串表示，常用有：`32` 默认 float32 精度训练，仅用于数值敏感场景，最慢；`16-mixed` 混合精度模式，能减少显存并提高速度，用于一般显卡；`bf16-mixed` 用于 A100 等计算卡上的混合精度模式
  - `accumulate_grad_batches = 1` 累计几个 Batch 的梯度后再更新，用于 Batch Size 较小的情况
- 以下参数用于模型日志记录方式控制
  - `enable_progress_bar = True` 是否显示训练进度条（进度条仅展示当前训练 Epoch 进度）
  - `enable_model_summary = True` 是否在训练前显示模型摘要
  - `enable_checkpointing = True` 是否自动保存 CheckPoint
  - `default_root_dir = "./"` 日志与 CheckPoint 的默认保存路径
  - `logger` 日志记录器，取 `False` 将不记录日志（用于模型调试），具体参见#link(<sec:lit_logger>)[日志记录器]
- 以下参数用于模型调试，默认都是关闭状态
  - `fast_dev_run = False` 启用时将在训练前跑一个训练与测试 Batch，快速测试模型代码是否存在问题
  - `detect_anomaly = False` 启用时将监控与定位 NaN 的非法梯度，但会导致训练变慢
  - `overfit_batches = 0` 启用时将检查模型是否有在极小 Batch 上过拟合的能力，用于进一步检查模型的 loss 与优化器等是否有问题

==== 训练控制

使用 `Trainer` 类的 `callback` 参数传入 CallBack 列表可以实现更复杂的训练控制，更多参见#link("https://lightning.ai/docs/pytorch/stable/common/trainer.html#callbacks")[文档]，这里仅介绍位于 `lightning.pytorch.callbacks` 模块下的#link("https://lightning.ai/docs/pytorch/stable/extensions/callbacks.html#built-in-callbacks")[内置 CallBack]。

这些 CallBack 通常为为类的实例，将这些实例用列表排列传入 `Trainer` 类的 `callback` 参数后就能生效

`ModelCheckpoint(...)` CheckPoint 保存类（默认启用该 Callback，但仅保存最后一个 CheckPoint）
- `dirpath` CheckPoint 保存文件夹，默认为 `{日志文件夹}/checkpoints`
- `filename` CheckPoint 文件名，支持模板字符串，模板参数有 `epoch` 与 #link(<sec:train_loop>)[self.log] 中的指标等，如 `best-{epoch:02d}-{val_loss:.3f}`
- `monitor, mode = "min"` 监控#link(<sec:train_loop>)[self.log] 中的指标名，以及最佳模型指标取最小（`min`）还是最大（`max`）
- `save_top_k = 1, save_last = True` 保存前 `save_top_k` 个最佳模型与是否保存最后一个模型
- `every_n_epochs = None, every_n_train_steps = None` 每隔几个 Epoch 与 Step 保存一次 CheckPoint

`EarlyStopping(...)` 模型训练早停控制，当监控指标长时间没有改善终止训练
- `monitor, mode = "min"` 监控 #link(<sec:train_loop>)[self.log] 中的指标名，以及最佳模型指标取最小（`min`）还是最大（`max`）
- `patience = 3` 等待指标改善的检查次数，默认在每个验证循环结束后检查（不是完整 Epoch 结束，但默认设置下类似），因此指标建议选择模型验证步骤中的
- `verbose = False` 是否打印早停相关信息

`LearningRateMonitor(...)` 学习率监控，将学习率作为指标记录到 #link(<sec:train_loop>)[self.log] 中
- `logging_interval` 记录学习率频率，可以是 `step` 或 `epoch`

`RichProgressBar(...)` 训练进度条
- `leave` 一个 Epoch 结束后是否保留旧的进度条
- 需要安装 `rich`

==== 模型训练与测试 <sec:train_load_test>

使用 `Trainer` 类的以下方法可以对模型进行训练与验证

`Trainer.fit(model, ...)` 训练模型
- `model` 训练模型的 `LightningModule` 对象
- `train_dataloaders, val_dataloaders` 训练与验证集的 `DataLoader` 对象，仅提供训练集时验证步骤将被跳过
- `datamodule` 通过 #link(<sec:data_module>)[LightningDataModule] 对象给出数据集
- `ckpt_path` 从给定的 CheckPoint 文件路径（`.ckpt` 文件）恢复训练，所有训练进度都会恢复

`Trainer.validate(...) / Trainer.test(...)` 验证与测试模型（区别仅在于调用的是验证还是测试步骤以及采用的数据集是验证集还是测试集）
- `model, ckpt_path` 模型对象与 CheckPoint 文件路径
- `dataloaders / datamodule` 验证集 / 测试集的 `DataLoader` 对象
- 函数将通过返回对应步骤中 #link(<sec:train_loop>)[self.log] 指标字典反应验证 / 测试结果

==== 日志记录器 <sec:lit_logger>

日志记录器为模块 `lightning.pytorch.loggers` 下的一系列对象，这些对象可传入 `Trainer` 用于管理日志，此处仅介绍常用的日志记录器，更多日志记录器参见#link("https://lightning.ai/docs/pytorch/stable/extensions/logging.html")[文档]

`TensorBoardLogger(...)` 基于 TensorBoard 的日志记录器
- `save_dir = "."` 日志根目录
- `name = "lightning_logs"` 实验名称，通常即模型的名称
- `version` 模型版本数，一般即模型不同超参数下的版本，默认将自动推断
- 日志将记录到文件夹 `{save_dir}/{name}/version_{version}`
- 安装了 `TensorBoard` 后将作为默认日志记录器

=== 数据集管理 <sec:data_module>

除了使用 Pytorch 提供的 `DataLoader` 对象管理单个数据集，Pytorch Lightning 还提供了数据集管理类 `pl.LightningDataModule`，只需通过定义该类虚函数规定数据集底层操作，后续由 Lightning 封装好的高层应用模块统一管理三类数据集的各个环节

首先需要将数据集处理流程封装为 `pl.LightningDataModule` 的子类（后续省略模块），并使用类成员管理 `DataLoader` 对象，一个标准的 `LightningDataModule` 子类通常需要实现以下接口

==== \_\_init\_\_ 构造函数 <sec:data_module_init>

接口原型：`def __init__(self, **kwargs)`
- `LightningDataModule` 与 #link(<sec:module_init>)[LightningDataModule] 一样，认为构造函数的其他参数均为模型超参数（如 batch size 等与数据集相关的超参数），因此还建议在函数内主动调用 `self.save_hyperparameters()` 保存构造函数的参数
- 构造函数中不负责数据集的加载具体数据，但习惯上会在这里注册管理 `Dataset` 对象的属性，并赋为 `None`

==== prepare_data 一次性数据准备

接口原型：`def prepare_data(self)`
- 用于一次性准备数据，如下载、解压文件等（如加载具体数据集对象，取 `download = True` 仅下载数据集但不保存），但不会具体加载数据集对象

==== setup 加载数据集

接口原型：`setup(self, stage: Union[str, None] = None)`
- 用于加载 `DataLoader` 对象，并给管理 `DataLoader` 对象的属性赋值
- 通过 `stage` 参数区分#link(<sec:train_load_test>)[训练还是测试模型]，确定具体加载哪个数据集，取 `None` 表示所有数据集
- 通常在此加载具体数据集对象 `Dataset` 并赋值

函数通常具有如下结构（实际也可以无视 `stage` 直接加载所有 `Dataset`）

```py
def setup(self, stage: str | None = None) -> None:
    # 固定种子切分数据集

    if stage == "fit" or stage is None :
        ... # 加载训练集

    if stage == "validate" or stage == "fit" or stage is None :
        ... # 加载验证集

    if stage == "test" or stage is None:
        ... # 加载测试集
```

==== 获取数据集

通过以下接口的返回值获取具体的数据集，通常在此通过 `Dataset` 对象创建 `DataLoader` 对象并返回
- `train_dataloader(self)` 获取训练集
- `val_dataloader(self)` 获取验证集
- `test_dataloader(self)` 获取测试集

== TorchVision V2 图像增强

此处主要介绍基于 `torchvision.transforms.v2` 的图片增强, 使用时模块导入方式为

```python
# v2 图片增强 API
from torchvision.transforms import v2
# 旧版图片增强 API
from torchvision.transforms import T
```

在 TorchVision，通过模块 `v2` 下的类 `Transform` 的子类定义图片增强模块（本质依然为 `nn.Module`，可以用此方式自定义变换模块），将图片 (PIL 图片对象或张量 `[B, C, H, W]`) 作为参数传入对象，可以返回经过增强的图片

除了变换单个图片，还可以作为 TorchVision 内置数据集 `VisionDataset` 的 `transform` 参数, 实现对数据集中所有样本的图片增强，或者对图片进行预处理, 将其从原始的 PIL 图片对象转换为传入网络进行训练的张量

相比旧版 API，v2 在将数据转换为张量之余，使用了模块 #link("https://pytorch.org/vision/stable/tv_tensors.html")[torchvision.TVTensors] 下的对象隐性标记了数据为图片还是边缘框、掩膜、视频、可针对这些不同的数据类型进行处理（此处不介绍）

对于更多的图片增强与预处理方法，参见#link("https://pytorch.org/vision/stable/transforms.html")[官方文档]

=== 基本图像变换

单个图像变换模块只能完成简单的工作，需要以下辅助模块排列多个图像变换模块形成完整变换流程
- `v2.Compose(transforms)` 类似 `nn.Sequential` 将一系列图像变换按顺序排列，传入图片将逐个执行列表整的变换，参数 `transforms` 为以 `Transform` 类为元素的列表

`Transform` 对于输入的图像没有强制要求，也没有规定模块输出，在一般流程中会先将任意格式图像转为 TorchVision 内置的#link("https://docs.pytorch.org/vision/master/generated/torchvision.tv_tensors.Image.html#torchvision.tv_tensors.Image")[图片张量]（基础使用与张量一致）后进行#link(<sec:image_aug>)[图像增强]变换，在最后输出时转为可用于训练的张量，以下为相关的辅助变换模块
- `v2.ToImage()` 将 PIL 图片、张量、Numpy 数组等转换为 TorchVision 内的#link("https://docs.pytorch.org/vision/master/generated/torchvision.tv_tensors.Image.html#torchvision.tv_tensors.Image")[图片张量]
- `v2.ToDtype(dtype, scale = False)` 改变图片张量的数据类型，如果 `scale = True` 还会依据数据类型缩放 `uint8: [0, 255]` / `float32: [0, 1.0]`

=== 图像增强变换 <sec:image_aug>


