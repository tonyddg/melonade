#import "../book.typ": *
#show: book-page.with(title: "Shotcut 使用")

#import "/utility/include.typ": *

= Shotcut 使用

#link("https://shotcut.org/download/")[官网地址]、#link("https://www.bilibili.com/video/BV1HoyHYnExX")[参考教程] 

Shotcut 页面基本说明如下图所示

#figure(
  image("res/shotcut_0.png", width: 80%), 
  caption: [Shotcut 页面基本说明],
) <fig:par_setting>

== 时间线基本操作

图像编辑软件中通过图层管理与组合多个图像，而视频编辑软件则使用时间线。时间线中除了和图层类似的图像层次维度外还有时间维度，并且视频的剪切、组合均需要通过时间线操作来完成。

=== 导入素材

- 打开#bl(2)[播放列表]窗口（默认在左侧），将任意视频文件拖动到#bl(2)[播放列表]窗口下即可导入一条素材。
- 双击素材文件即可在#bl(2)[视频播放器]中播放选中的素材（选中子标签#bl(1)[源]）。
- 拖动素材文件到#bl(2)[时间线]窗口即可将第一条素材导入到项目中，或将素材插入到已有的时间线中。
- 关于#bl(2)[播放列表]窗口的其他常用功能见#ref(<fig:video_list>)。

#figure(
  image("res/shotcut_1_1.png", width: 60%), 
  caption: [播放列表窗口常用功能],
) <fig:video_list>

=== 单轨道编辑 <ref:single_track>

单轨道编辑通常用到以下按钮

#figure(
  image("res/shotcut_1_2.png", width: 80%), 
  caption: [单轨道编辑工具栏按钮],
) <fig:single_track>

*增加视频片段*
- #bl(1)[#ref(<fig:single_track>)中按钮 3]能够将在当前轨道的末尾添加一个新的视频片段，添加的视频片段通过在#bl(2)[播放列表]窗口中双击所需的素材视频确定。
- 除了素材视频，选择轨道中的视频片段后，点击#bl(1)[#ref(<fig:single_track>)中按钮 2]可复制该视频片段，此时添加的新视频片段即被复制的那个。

*删除视频片段*
- 除了导入素材得到视频片段，还可以修剪素材视频，点击#bl(1)[#ref(<fig:single_track>)中按钮 5]将以当前#bl(1)[时间线光标]所在位置切割视频片段，得到新的视频片段。
- 选择轨道中的视频片段后，点击#bl(1)[#ref(<fig:single_track>)中按钮 4]可以将选中的视频片段删除，同时前后的视频片段将自动贴合。（#bl(1)[#ref(<fig:single_track>)中按钮 1]效果类似，还会复制被剪切的片段）

*调整视频片段*
- #bl(1)[#ref(<fig:single_track>)中按钮 6]可以在轨道中添加轨道标记并在标记间移动。
- 按住时间性中的视频片段拖动即可调整各个视频片段顺序、选择视频片段边界拖动
- #bl(1)[#ref(<fig:single_track>)中按钮 7、8]可改变调整行为（一般建议始终开启）
  - #bl(1)[#ref(<fig:single_track>)中按钮 7]：调整视频片段时，将尝试吸附到视频片段边界、标记、#bl(1)[时间线光标]上。
  - #bl(1)[#ref(<fig:single_track>)中按钮 8]：默认视频片段行为将在被移走的位置留下空白、覆盖放置位置已有的视频；启动该功能将自动拼接移走部分的空白、在放置位置切开再插入视频片段。

=== 多轨道编辑

多轨道中，最上层的轨道画面将优先被显示、时间线长度则取决于最长轨道，其余轨道的空白位置使用透明填充。

多轨道编辑通常用到以下按钮

#figure(
  image("res/shotcut_1_3.png", width: 80%), 
  caption: [多轨道编辑工具栏按钮],
) <fig:multi_track>

- #bl(1)[#ref(<fig:multi_track>)中按钮 1]用于打开多轨道菜单，子菜单#bl(1)[轨道操作]下的#bl(1)[插入轨道]可以插入新的轨道。
- 为了移除与调整指定轨道位置，可右键目标轨道打开多轨道菜单，子菜单#bl(1)[轨道操作]下的#bl(1)[移除轨道]、#bl(1)[向上移动轨道]、#bl(1)[向下移动轨道]。
- #bl(1)[#ref(<fig:single_track>)中按钮 2]：可改变多轨道下的调整行为，移动当前轨的视频片段时将尝试切割其他轨道相同时刻的视频片段并联动修改，仅当该视频片段跨多个轨道时建议开启（#link(<ref:single_track>)[单轨道编辑]中除了删除，其他操作不受影响，仅对选中轨道有效）。
- #bl(1)[#ref(<fig:multi_track>)中按钮 3]用于调整轨道长度与时间关系；#bl(1)[#ref(<fig:multi_track>)中按钮 1]下的子菜单#bl(1)[轨道高度]用于调整轨道高度便于查看。