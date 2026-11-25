
#import "@preview/shiroa:0.2.3": *

#show: book

#book-meta(
  title: "shiroa",
  summary: [
    #prefix-chapter("index.typ")[Melonade]

    - #chapter("./jap/index.typ")[日语笔记]
      - #chapter("./jap/standard.typ")[标日初级笔记]
      - #chapter("./jap/transform.typ")[词语变形]
      - #chapter("./jap/partial.typ")[介词与连接词]
      - #chapter("./jap/sentence.typ")[句型]
      - #chapter("./jap/word.typ")[词语与词组]

    - #chapter(none)[数学]

      // - #chapter(none)[线性代数笔记]
      //   - #chapter("./math/linear_algebra/ch1.typ")[矩阵基础]
      //   - #chapter("./math/linear_algebra/ch2.typ")[线性方程组]
      //   - #chapter("./math/linear_algebra/ch3.typ")[向量空间]
      //   - #chapter("./math/linear_algebra/ch4.typ")[正交性]
      //   - #chapter("./math/linear_algebra/ch5.typ")[行列式]
      //   - #chapter("./math/linear_algebra/ch6.typ")[特征值]
      //   - #chapter("./math/linear_algebra/ch7.typ")[正定性]
      //   - #chapter("./math/linear_algebra/ch8.typ")[线性变换]
      //   - #chapter("./math/linear_algebra/ch9.typ")[变换矩阵]
  
      - #chapter("./math/matrix.typ")[矩阵论]
      - #chapter("./math/analyze.typ")[数值分析]
      - #chapter("./math/statistic.typ")[数理统计]

      - #chapter("./math/pose.typ")[坐标系、位姿与运动的描述]
      - #chapter("./math/camera.typ")[相机成像原理]

    - #chapter(none)[Python]

      - #chapter(none)[数学相关模块]
        - #chapter("./python/math/numpy.typ")[Numpy 笔记]
        - #chapter("./python/math/opencv.typ")[OpenCV 笔记]
        - #chapter("./python/math/pandas.typ")[Pandas 笔记]
        - #chapter("./python/math/pytorch.typ")[Pytorch 笔记]
        - #chapter("./python/math/scikit-learn.typ")[Scikit-learn 机器学习]
        - #chapter("./python/math/sympy.typ")[Sympy 笔记]

      - #chapter(none)[PyQT]
        - #chapter("./python/pyqt/base.typ")[PyQT 基础笔记]
        - #chapter("./python/pyqt/examples.typ")[PyQT 示例]

      - #chapter(none)[机器人仿真]
        - #chapter("./python/robot/pybullet.typ")[Pybullet 笔记]
        - #chapter("./python/robot/mujoco.typ")[mujoco 笔记]
        - #chapter("./python/robot/maniskill.typ")[ManiSkill 笔记]

      - #chapter("./python/python.typ")[Python 笔记]
      - #chapter("./python/fastapi.typ")[FastAPI 笔记]
      - #chapter("./python/ml.typ")[神经网络开发]

    - #chapter(none)[编程]

      - #chapter(none)[CPP]
        - #chapter("./code/cpp/cmake.typ")[CMake 笔记]
        - #chapter("./code/cpp/cpp.typ")[C++ 面向对象编程]

      - #chapter(none)[Linux]
        - #chapter("./code/linux/base.typ")[Linux 基础与常用命令笔记]
        - #chapter("./code/linux/shell.typ")[Shell 笔记]
        - #chapter("./code/linux/xpra.typ")[Xpra 仅窗口的远程连接]

      - #chapter("./code/vscode.typ")[Vscode 笔记]
      - #chapter("./code/docker.typ")[Docker 笔记]
      - #chapter("./code/claude_code.typ")[AI Agent 笔记]
      - #chapter("./code/ros2.typ")[ROS2 笔记]

    - #chapter(none)[神经网络]
      - #chapter("./ml/ae.typ")[自编码器]
      - #chapter("./ml/rnn_transformer.typ")[RNN 与 Transformer]
      - #chapter("./ml/diffusion.typ")[Diffusion 笔记]
      - #chapter("./ml/random.typ")[基础知识拾遗]

    - #chapter(none)[杂项]
      - #chapter("./random/shiroa.typ")[Shiroa 笔记]
      - #chapter("./random/word.typ")[Word 使用]
      - #chapter("./random/shotcut.typ")[ShotCut 视频剪辑]
  ]
)



// re-export page template
#import "/templates/page.typ": project
#let book-page = project
