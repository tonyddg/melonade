
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

    - #chapter(none)[编程]
      - #chapter("./code/pybullet.typ")[Pybullet 笔记]
      - #chapter("./code/mujoco.typ")[mujoco 笔记]
      - #chapter("./code/maniskill.typ")[ManiSkill 笔记]
      - #chapter("./code/camera.typ")[相机成像原理]
      - #chapter("./code/cmake.typ")[CMake 笔记]
      - #chapter("./code/cpp.typ")[C++ 面向对象编程]
      - #chapter("./code/vscode.typ")[Vscode 笔记]
      - #chapter("./code/software.typ")[实用软件笔记]
      - #chapter("./code/fastapi.typ")[FastAPI 笔记]
      - #chapter("./code/python.typ")[Python 笔记]
      - #chapter("./code/docker.typ")[Docker 笔记]

    - #chapter(none)[神经网络]
      - #chapter("./ml/ae.typ")[自编码器]
      - #chapter("./ml/rnn_transformer.typ")[RNN 与 Transformer]
      - #chapter("./ml/diffusion.typ")[Diffusion 笔记]

    - #chapter(none)[杂项]
      - #chapter("./random/shiroa.typ")[Shiroa 笔记]
      - #chapter("./random/word.typ")[Word 使用]
  ]
)



// re-export page template
#import "/templates/page.typ": project
#let book-page = project
