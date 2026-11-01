#import "/book.typ": book-page, cross-link, templates
#show: book-page.with(title: "ROS2 笔记")

#import "/utility/include.typ": *

= ROS2 笔记

== ROS2 Python 功能包开发

=== Python 功能包基础

*创建功能包*

工作空间下的 `src` 目录中通过以下命令创建功能包

```sh
ros2 pkg create [功能包名称] \
# 功能包类型, 说明是 python 功能包
--build-type ament_python \
# 依赖功能包, 可以是其他 Python 功能包
--dependencies rclpy std_msgs
```

ROS2 通常将 Python 功能作为一个 Python 模块，构建时将模块安装到 `install` 目录，模块注册的入口命令即作为 ROS2 节点

创建的功能包具有以下结构

```txt
ros2_ws/
└── src/
    └── [功能包名称]/
        ├── package.xml           # 功能包信息
        ├── setup.py              # 配置功能包中的 Python 模块，如注册入口命令
        ├── setup.cfg             # 配置如何将模块作为功能包安装到 install, 一般不修改
        ├── resource/[功能包名称]   # 功能包标记文件
        └── my_robot/             # 作为功能包的 Python 文件
            ├── __init__.py
            └── ...
```

*Python 虚拟环境管理*

推荐使用 uv 管理功能包的虚拟环境，习惯上整个工作空间共用一个虚拟环境，因此在工作空间根目录下创建 `pyproject.toml` 管理虚拟环境，通常具有以下配置

```toml
[project]
name = "my_module" # 工作空间名称
# 必要的元信息，按需要填写
version = "0.1.0"
description = "A module"
requires-python = ">=3.10" # Python 版本要求，与 ROS2 使用的 Python 保持一致
# 依赖模块
dependencies = [
    ...
]
# 显式声明该虚拟环境不包含功能包
[tool.uv]
package = false
# 使用 uv 提供的 colcon build 完成功能包的构建
[dependency-groups]
dev = {
  "colcon-common-extensions"
}

# 虚拟环境不需要构建器
```

对于如 `rclpy`、`std_msgs` 等功能包相关的依赖应该通过增加 `package.xml` 中的 `<exec_depend>` 项实现，虚拟环境仅负责 Python 相关的依赖

通过 `uv venv --python /usr/bin/python3` 基于 ROS2 所用的 Python 创建虚拟环境 (ROS2 默认使用系统中的 Python3)，保证 ROS2 相关的功能能被正确使用

通过 `uv run colcon build ...` 从虚拟环境中构建 Python 功能包，保证 Python 模块安装到 `install` 后依然使用正确的虚拟环境

使用该方法时，虚拟环境安装的同名模块会覆盖原 Python 中安装的模块，因此可能出现模块版本不正确导致的问题，可在虚拟环境中固定为相同版本解决，并在安装 `numpy`、`opencv` 前先使用 `pip3 show` 查询原 Python 中安装的模块版本信息再在虚拟环境中固定

*Python 模块安装设置*

编写 Python 模块后，还需要通过 `setup.py` 中的函数 `step` 传递设置参数，才能正确告诉 ROS2 的构建工具如何将这个模块作为 ROS2 功能包安装到 install 中，常用的设置包括
- 功能包元信息：包括 `name`，`version` 等元信息，注意与 `package.xml` 对齐即可
- 安装 Python 模块：通过 `packages=find_packages(...)` 说明同一文件夹下的 Python 模块（即带有 `__init__.py` 的文件夹）哪些要安装到 `install`
- *注册 Python 命令作为节点入口名称*：通过 `entry_points={'console_scripts': [...]}` 注册，列表内为 `<节点入口>=<模块>:<函数名>` 的字符串，通过 `ros2 run [功能包] [节点入口]` 即可运行对应的函数
- 安装资源文件：通过 `data_files=[...]` 说明如配置文件等资源要如何安装到 `install` 中，列表内为元组 `("目标文件夹", "资源路径")`，通常
  - `目标文件夹` 基于 `install/[功能报名]` 的相对路径，资源文件一般使用 `share/[功能包名]/文件夹` 以便作为 ROS2 节点时能被其他功能包找到
  - `资源路径` 基于 `setup.py` 所在目录的相对路径，可以使用 `*` 等通配符
  - 可通过模块 `ament_index_python.packages` 中的函数 `get_package_share_path(功能包名)`<ref:get_package_share_path> 读取本功能包或其他功能包资源文件夹 `share/[功能包名]` 下安装的资源文件路径，函数将返回 Python 的 `Path` 对象
  - *ROS2 Python 功能包的 Launch 文件通过同样的方式安装资源文件夹* <ref:launch_install_python>，通常放在 `launch` 文件夹下，具体的编写参见#link(<sec:launch_python>)[笔记]。

=== Python 节点开发主要 API

通过 `rclpy` 模块开发 Python 节点，并由节点类 `rclpy.node.Node` 管理节点行为，常用的方法有
- ROS2 客户端管理方法
  - `rclpy.init()` 启动 ROS2 客户端，启动后才能读取 ROS2 相关的上下文、与其他节点通信
  - `rclpy.shutdown()` 关闭 ROS2 客户端，启动客户端后退出程序时必须执行
  - `rclpy.ok()` 检查 ROS2 客户端是否启动
- ROS2 客户端节点控制方法
  - `rclpy.create_node(node_name)` 创建 ROS2 节点，主要用于以发布指令、请求服务为主的交互程序开发
  - `rclpy.node.Node` 节点类，继承该类并构造函数中调用 `super().__init__(node_name)`，可在实例化继承类时创建节点，主要用于以订阅指令、实现服务为主的控制程序
  - `rclpy.spin(node)` 阻塞程序执行节点事件循环，此时节点的回调函数才能被正确调用，但程序将被阻塞直到收到 `SIGNAL` 等程序终止信号，多用于以订阅指令、实现服务为主的控制程序
  - `rclpy.spin_once(node, timeout_sec = None)` 阻塞程序一段时间执行节点事件循环或取 `None` 时仅执行一次事件循环运行等待被调用的回调函数，通常用于配合终止条件判断等待消息接收等 ROS2 节点功能执行完成，多用于不以发布指令、请求服务为主的交互程序开发
  - `rclpy.spin_until_future_complete(node, future, timeout_sec = None)` 阻塞程序执行节点事件循环直到异步任务完成或超时，一般用于向服务发送请求后阻塞等待结果
- 节点对象管理方法
  - `node.destroy_node()` 销毁节点，用于程序退出时执行
  - `node.destroy_xxx(handle)` 基于创建回调时的句柄，销毁节点注册的回调函数，`xxx` 与创建方法对应
  - `node.get_logger.info(...) / warm(...) / error(...)` 发送节点日志，除了传入日志内容，还有以下参数可以控制日志行为
    - `throttle_duration_sec` 即使多次调用, 仅在指定间隔后发送日志, 用于高频控制中定期汇报消息
    - `once` 取 `True` 仅在第一次调用时发送日志
  - `time_stamp = node.get_clock().now()` 获取当前 ROS 时间戳对象，主要有以下使用方式
    - `(time_stamp2 - time_stamp1).nanoseconds * 1e-9` 获取两个时间戳的差值并把单位转为秒
    - `time_stamp.to_msg()` 转换为时间戳消息，用于带有时间戳的消息
- 节点间通信方法，用于建立节点通信并返回相应的管理句柄
  - `create_publisher(msg_type, topic, qos_profile)` 创建话题发布器
    - `qos_profile` 为消息缓冲区长度，一般取 `10` 即可
    - 句柄的 `publish(msg)` 方法发布具体消息对象
  - `create_subscription(msg_type, topic, callback, qos_profile)` 订阅话题并使用回调函数接收
    - 回调函数以消息对象为参数
  - `create_service(srv_type, srv_name, callback)` 创建服务并使用服务处理回调实现服务行为
    - 回调函数接收请求对象 (request) 与空的结果对象 (response)，修改并返回该结果对象完成服务
  - `create_client(srv_type, srv_name)` 创建服务客户端
    - 句柄的 `wait_for_service(timeout_s)` 方法检查服务是否可用
    - 句柄的 `future = call_async(request)` 调用服务并异步等待结果，返回异步结果对象
    - 异步结果对象通过 `rclpy.spin_until_future_complete` 阻塞等待结果，得到结果后使用方法 `done()` 检查结果是否可用、方法 `result()` 获取结果
  - `create_timer(timer_period_sec, callback)` 创建定时回调，用于被 ROS2 管理时定时执行代码
    - 回调函数没有参数

=== 消息与服务接口

通常使用 ROS2 提供的消息与服务接口功能包即可，常用的有 `std_msgs`、`geometry_msgs`、`sensor_msgs`、`std_srvs` 等，仅需将其作为依赖加入 `package.xml`

ROS2 中话题消息分别使用 `[功能包名]/msg/[话题消息类型]` 表示，在 Python 中话题消息类型则表现为数据结构。使用 `from [功能包名].msg import [话题消息名]` 的方式引入后，通过 `msg = [话题消息类型]()` 初始化，再使用 `.` 访问具体消息字段修改或读取数据

服务接口与话题消息类似但将 `msg` 改为 `srv`，同时服务由请求 `Request` 与结果 `Response` 相独立的两部分组成，且这两部分本质依然属于话题消息。服务接口类型还可用于创建与请求服务但具体的数据结构需要通过 `[服务接口类型].Request() / Response()` 创建

话题消息通常由大量其他话题消息类型组合得到，常用的预定义话题消息及其使用方法有

用于汇报状态的消息：

```py
from std_msgs.msg import String, Float32MultiArray
msg_str = String() # 字符串
msg_str.data = "hello ros2"

msg_arr = Float32MultiArray() # 不定长数组
msg_arr.data = [1.0, 2.0, 3.0]
```

用于表示空间位姿的消息：

```py
from geometry_msgs.msg import Point, Quaternion, Pose, PoseStamped
p = Point() # 三维坐标
p.x = 1.0
p.y = 0.0
p.z = 0.0

q = Quaternion() # 四元数
q.x = 0.0
q.y = 0.0
q.z = 0.0
q.w = 1.0

pose = Pose() # 空间位姿
pose.position = p
pose.orientation = q

pose_stamp = PoseStamped() # 带有时间戳与参考坐标系的空间位姿
pose_stamp.pose = pose
pose_stamp.header.frame_id = "world" # 参考坐标系名称
# 获取当前时间作为时间戳
pose_stamp.header.stamp = node.get_clock().now().to_msg() 

# 从时间消息转换为时间戳
from rclpy.time import Time
stamp_time = int(Time.from_msg(pose_stamp.header.stamp).nanoseconds)
# 基于时间戳实现防倒灌机制，并放行 stamp_time = 0 的消息
if not(stamp_time > last_stamp_time or stamp_time == 0):
    node.get_logger().warn(...)
    return
... # 其他检查代码
if stamp_time != 0:
    last_stamp_time = stamp_time
```

用于表示空间速度的消息：

```py
from geometry_msgs.msg import Twist, Vector3
v = Vector3() # 三维坐标
v.x = 1.0
v.y = 0.0
v.z = 0.0

cmd = Twist() # 空间旋量，包含速度与角速度

cmd.linear = v
cmd.angular = v
```

图像传感器消息：

```py
import cv2
import numpy as np
from sensor_msgs.msg import CompressedImage

# Numpy 数组转为图像消息
msg = CompressedImage()
msg.header.stamp = self.get_clock().now().to_msg()
msg.header.frame_id = 'camera'
msg.format = 'jpeg'
success, encoded = cv2.imencode(
    '.jpg',
    image
)
msg.data = encoded.tobytes()

# 图像消息转为 Numpy 数组
# uint8[] → NumPy
buffer = np.frombuffer(
    msg.data,
    dtype=np.uint8
)
# JPEG / PNG → OpenCV ndarray
image = cv2.imdecode(
    buffer,
    cv2.IMREAD_COLOR
)
```

ROS2 的服务主要依靠自定义，常用标准服务有：

```py
from std_srvs.srv import SetBool # 控制器开关服务

def enable_callback(self, request, response):

    if request.data:
        self.enabled = True

        response.success = True
        response.message = 'enabled'

    else:
        self.enabled = False

        response.success = True
        response.message = 'disabled'

    return response
```

自定义话题消息与服务接口时，通常会在工作空间中定义一个独立的功能包，具体方法参见#link("https://docs.ros.org/en/humble/Tutorials/Beginner-Client-Libraries/Custom-ROS2-Interfaces.html")[官方文档]

=== 节点参数管理

与节点运行功能相关的参数通常将其作为 ROS2 参数由 ROS2 统一管理，便于通过 Launch 文件、ROS2 命令行设置或命令行工具动态修改

参数相关的功能还需要使用到功能包 `rcl_interface` 

ROS2 中没有参数服务器，而是由每个节点自身管理自己的参数，因此在节点创建后需要先使用节点方法 `node.declare_parameters(...)` 声明自身具有的参数，该方法的参数为一个元组列表，列表中的元组即对应一条参数生命，元组中各个元素分别表示
- 第一个元素：字符串，表示参数名称
- 第二个元素：参数默认值（如果其他地方提供参数将覆盖该默认值），只能是字符串、布尔值、整数、浮点数，ROS2 将自动识别参数类型且不能再修改
- 第三个元素：参数额外描述，可以省略，具体使用见下

通过 `rcl_interface.ParameterDescriptor` 类的对象作为第三个元素用于表示参数额外描述与约束，这些描述通过类构造函数的参数传入，常用的有
- `description` 参数描述，建议使用英文以在 `rqt` 中正常显示
- `read_only` 参数是否在第一次确定后无法修改，对于不在运行中动态修改的参数建议启用
- `floating_point_range` 浮点数范围约束，使用 `rcl_interface.FloatingPointRange` 类的对象表示，由该类构造函数的以下参数表示约束内容：`from_value` 参数最小值；`to_value` 参数最大值
- `integer_range` 整数范围约束，与浮点数类似，使用 `rcl_interface.IntegerRange` 类的对象表示

声明完参数后，`node.declare_parameters(...)` 将读取并返回 `rclpy.parameter.Parameter` 的参数类对象列表，或使用 `node.get_parameter(name)` 方法主动获取特定参数，对于获取到的参数类
- 对象属性 `value` 获取参数值，建议使用 `int`、`str` 等显示类型转换 
- 对象属性 `name` 获取参数名，用于从参数类对象列表匹配需要的参数名并给属性赋值等


=== 节点结构

以订阅指令、实现服务为主的控制程序通常具有如下结构

```py
import rclpy
from rclpy.node import Node

class Controller(Node):
    def __init__(self):
        # 注册节点
        super().__init__("...")
        ...

# 函数参数即启动节点命令后附带的命令行参数
def main(args = None):
    rclpy.init(args = args)

    node = Controller()
    # 阻塞 Python 程序，执行节点事件循环
    rclpy.spin(node)
    node.destroy_node()
  
    rclpy.shutdown()

if __name__ == '__main__':
    main()
```

以订阅指令、实现服务为主的控制程序通常具有如下结构

```py
import rclpy

class RobotInterface():
    def __init__(self, node_name: str):
        if not rclpy.ok():
            rclpy.init()
        self.node = rclpy.create_node(node_name)

    def close(self):
        if self.node is not None:
            rclpy.destroy_node(self.node)
            self.node = None
        # 假设一个程序仅创建一次对象
        if rclpy.ok():
            rclpy.shutdown()
```

== 多节点协同与 Launch 文件

=== 话题与服务名称

对于每个节点，在创建时必须指定节点名与节点所在的名称空间 `namespace`
- ROS2 将节点视为机器人中的一个控制单元，名称空间用于表示具体的机器人，保证不同机器人的相同控制单元不会产生冲突
- 默认名称空间为空，不需要专门设置而是建议通过 Launch 文件在启动具体机器人上所有节点时统一指定名称空间

节点与名称空间具体表现为影响话题与服务的解析结果，即调用 `create_publisher` 等函数指定话题或服务名称时，提供的名称将被解析为完整名称，该名称才是节点真正发布的话题

依据希望话题或服务共享范围分为绝对名称、相对名称、私有名称三种。一般使用相对名称即可

#figure()[
    #table(
        columns: 5,
        table.header()[名称类型][含义][提供名称][解析名称 (无名称空间)][解析名称 (有名称空间)],
        [绝对名称], [所有节点间共享], [`/image`], [`/image`], [`/image`],
        [相对名称], [同名称空间下共享], [`image`], [`/image`], [`/[名称空间]/image`],
        [私有名称], [节点内共享], [`~/image`], [`/[节点名]/image`], [`/[名称空间]/[节点名]/image`],
    )
]

类似路径，名称类型由第一个字符（是否包含 `~` 或 `/`）决定，后续可以手动加入多层级的 `/` 进一步细分，如 `image/compress`，并没有严格的第一层级为名称空间、第二层级为节点名的要求。

=== ROS2 RUN 命令行参数 <sec:ros2_run_cli>

使用 `ros2 run` 运行节点程序时，可以使用以下方式动态改变节点名称与参数相关设置

```sh
ros2 run 功能包 节点入口 \ 
    基础命令行参数 \ 
    ... \ 
    --ros-args \ 
    ROS2命令行参数 \ 
    ...
```

常用的命令行参数有
- `-r [原始话题服务名]:=[新话题服务名]` 重命名节点创建或读取的话题或服务
- `-r __node/__ns:=[名称]` 重命名节点的名称 `__node` 或名称空间 `__ns`，名称空间一般为空该方法即可用于指定节点的名称空间
- `-p [参数名]:=[参数值]` 设置节点参数，将覆盖节点内的默认值
- `--params-file [YAML 文件路径]` 从 YAML 文件加载节点参数
- `--log-level [DEBUG/INFO/WARN/ERROR]` 设置节点输出的最低日志级别

如果节点程序本身也有命令行参数，可通过以下方式去除 ROS2 命令行参数，保留其他部分

```py
import sys
from rclpy.utilities import remove_ros_args

def main(args = None):
    # 让 ROS2 自己识别并提取出非 ROS2 命令行参数
    app_args = remove_ros_args(sys.argv)[1:]
    ...
    # 使用原始命令行参数初始化 ROS2 上下文
    rclpy.init(args=sys.argv)
    ...
```

=== Launch 文件 <sec:launch_python>

ROS2 RUN 命令行参数只能对单个节点进行设置，如果需要同时启动多个节点则建议使用 Launch 文件，并通过 `ros2 launch [功能包] xxx.launch.py`。

Python 功能包中通常使用 `.launch.py` 的 Python 文件表示 Launch 文件，并放在 `src/功能包/launch` 目录下，具体安装方式参见#link(<ref:launch_install_python>)[前文]。

相比基于 XML 的静态的 Launch ，基于 Python 的 Launch 以 `generate_launch_description` 为入口函数，允许在程序中以 `launch_ros.actions` 或 `launch.actions` 模块下的类实例作为组件构建动态的 Launch，将这些组件通过列表排列实例化 `launch.LaunchDescription` 对象后返回，实现更加灵活的节点启动。

```py
from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    controller_node = Node(
        package = "...",
        executable = "...",
    )
    # ...

    return LaunchDescription([controller_node, ])
```

`launch_ros.actions` 与 `launch.actions` 模块中的类可以作为构造 Launch 的组件，常用的组件有：

启动节点组件 `launch_ros.actions.Node`：与 #link(<sec:ros2_run_cli>)[ROS2 RUN 命令行参数]类似，该组件也从重命名与参数加载两个方面覆盖节点程序中原有的设置、规定如何启动节点，这些设置通过创建 `Node` 对象时的参数给定，常用的有：
- `package, executable` 必须给定的参数，说明节点来自哪个功能包下的哪个入口
- `name` 节点名称，影响节点内话题或服务的私有名称
- `namespace` 节点名称空间，影响节点内话题或服务的相对名称
- `remappings` 重命名节点创建或读取的话题或服务，通过列表表示多个重命名关系，每个元素为元组 `(节点内名称, 实际名称)` 表示
- `parameters` 设置节点参数，通过列表表示
    - 列表元素为字典：将其中的键值对作为节点参数名与参数值加载
    - 列表元素为字符串：读取字符串路径所指的 yaml 文件作为参数加载，建议将 yaml 文件也作为#link(<ref:launch_install_python>)[功能包资源安装]，此时可通过函数 #link(<ref:get_package_share_path>)[`get_package_share_path`] 给定功能包名称获取功能包资源目录，在传递前需要*用 `str` 将 `Path` 对象转为字符串*
- `arguments` 字符串列表形式的节点自定义命令行参数
- `ros_arguments` 字符串列表形式的 `ros2 run` 命令行参数
- `output` 节点输出位置，默认为 `log` 输出到日志文件，取 `screen` 可以输出到终端

使用示例如下

```py
# ...
def generate_launch_description():

    config_file = (
        get_package_share_path('my_robot') / 'config' / 'controller.yaml'
    )

    controller_node = Node(
        package = 'my_robot', executable = 'controller',
        name = 'controller',
        remappings = [('cmd_vel', 'base/cmd_vel'),],
        parameters = [
            str(config_file),
            {'speed': 1.0}
        ],
        arguments = [
            '--model',
            'model.pt',
        ],
    )

    return LaunchDescription([controller_node,])
```

// Launch 命令行参数组件 `launch.actions.DeclareLaunchArgument`：该组件仅用于声明 Launch 文件命令行参数，这些参数可通过 `ros2 launch ... 参数名:=参数值` 传入从而改变 Launch 文件的行为，或通过 `--show-args` 查看有哪些参数

// 定义该组件所需的参数有 `name, default_value` 参数名与参数默认值。与节点不同，*`generate_launch_description` 动态构建 Launch 的过程中并没有得到真实值*，因此无法获取真实参数值，只能用特殊占位对象代表这些值.通过模块 `launch.substitutions` 下的类 `LaunchConfiguration(参数名)` 获取参数值占位符对象，使用方法有
// - 占位符对象虽然不能当作普通的 Python 值使用，但占位符对象一般可以直接用于组件对象定义时的参数
// - Launch 参数没有约束类型，在传递给 `Node` 组件的 `parameters` 时可能会出错，为此可通过模块 `launch_ros.parameter_descriptions` 下的类 `ParameterValue` 包裹并约束占位符对象的类型，构造类的参数为：
//     - `value` 为对应的 `LaunchConfiguration` 对象，也可以是任意 Python 值用于后续变量转换
//     - `value_type` Python 类型如 `str, bool, float` 等，列表使用 `List[...]`
//     - 类似的还有 `ParameterFile(value)` 规定参数文件路径 <ref:parameter_file>
// - 对于布尔型的 Launch 参数，虽然不能用于 `if` 语句，但可以通过模块 `launch.conditions` 下的类 `IfCondition(占位符对象)` 包裹，传入 Luncha 组件对象的 `condition` 参数，仅当参数为 `True` 时才会启动组件

// 使用示例如下

// ```py
// # ...
// def generate_launch_description():

//     use_camera_arg = DeclareLaunchArgument(
//         'use_camera',
//         default_value='true',
//     )
//     fps_arg = DeclareLaunchArgument(
//         'fps',
//         default_value='30',
//     )

//     camera_node = Node(
//         package = 'my_camera', executable = 'camera',
//         parameters = [{'fps': ParameterValue(fps_arg, value_type = float)}],
//         condition = IfCondition(
//             LaunchConfiguration('use_camera')
//         ),
//     )

//     return LaunchDescription([camera_node,])
// ```

启动 Launch 组件 `launch.actions.IncludeLaunchDescription`：该组件用于启动其他 Launch 文件，常用的参数有：
- `launch_description_source` 其他 Launch 文件对象，在 `launch.launch_description_sources` 中的类定义，这些类依据 Launch 文件类型选择，以 Launch 文件路径为参数，由于 Launch 文件属于功能包资源，同样使用 #link(<ref:get_package_share_path>)[`get_package_share_path`] 函数获取
- `launch_arguments` 引用该 Launch 文件时传入的 Launch 参数，通过字典表示，并使用字典的 `item()` 方法传入迭代对象

使用示例如下

```py
from ament_index_python.packages import get_package_share_path
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
# ...
def generate_launch_description():
    camera_launch = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(str(
            get_package_share_path('my_camera') / 'launch' / 'camera.launch.py'
        ))
    )
    return LaunchDescription([camera_launch,])
```

Launch 命令行参数组件 `launch.actions.DeclareLaunchArgument`：该组件仅用于声明 Launch 文件命令行参数，这些参数可通过 `ros2 launch ... 参数名:=参数值` 传入从而改变 Launch 文件的行为，或通过 `--show-args` 查看有哪些参数。

定义该组件所需的参数有 `name, default_value` 参数名与参数默认值。与节点不同，*`generate_launch_description` 动态构建 Launch 的过程中并没有得到真实值*，因此无法获取真实参数值，只能用特殊占位对象代表这些值.通过模块 `launch.substitutions` 下的类 `LaunchConfiguration(参数名)` 获取参数值占位符对象。

命令行参数组件通常配合延迟启动组件 `launch.actions.OpaqueFunction` 使用：通改组件在获取到实际参数的上下文后再延迟构建 Launch，解决命令行参数在构建时没有真实值的问题。

定义该组件所需的参数有 `function`，参数为一个 `launch_setup(context, *args, **kwargs)` 的函数，该函数与 `LaunchDescription` 参数类似的组件列表，即延迟构建的 Launch 组件。Launch 命令行参数通过 `arg = LaunchConfiguration(参数名)` 的参数值占位符对象方法 `arg.perform(context)` 获取*参数的实际字符串值*

使用示例如下

```py
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, OpaqueFunction
from launch.substitutions import LaunchConfiguration

from launch_ros.actions import Node

PARAM_PROFILES = {
    "robot_a": {
        "speed": 1.0, "radius": 0.3, "enable_lidar": True,
    },
    "robot_b": {"speed": 2.0, "radius": 0.5, "enable_lidar": False,
    },
}

def launch_setup(context, *args, **kwargs):

    config_name = LaunchConfiguration("config_name").perform(context)
    if config_name not in PARAM_PROFILES:
        raise RuntimeError(f"Unknown config '{config_name}', ")
    params = PARAM_PROFILES[config_name]

    node = Node(
        package = "my_pkg", executable = "my_node", name = "my_node",
        parameters=[params]
    )

    return [node]

def generate_launch_description():

    return LaunchDescription([
        DeclareLaunchArgument(
            "config_name", default_value = "robot_a",
        ),

        OpaqueFunction(
            function=launch_setup
        )
    ])
```

