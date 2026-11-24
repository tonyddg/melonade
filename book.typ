
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
      - #chapter("./math/matrix.typ")[矩阵论]
      - #chapter("./math/analyze.typ")[数值分析]
      - #chapter("./math/statistic.typ")[数理统计]
      - #chapter("./math/camera.typ")[相机成像原理]

    - #chapter(none)[编程]
      - #chapter(none)[Python]
        - #chapter("./code/python/python.typ")[Python 笔记]
        - #chapter("./code/python/pybullet.typ")[Pybullet 笔记]
        - #chapter("./code/python/mujoco.typ")[mujoco 笔记]
        - #chapter("./code/python/maniskill.typ")[ManiSkill 笔记]
        - #chapter("./code/python/fastapi.typ")[FastAPI 笔记]
        - #chapter("./code/python/ml.typ")[神经网络开发]

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
