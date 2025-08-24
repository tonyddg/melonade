#import "./index.typ": *
#show: book-page.with(title: "标日初级笔记")

#import "/utility/widget.typ": *

= 标日初级笔记

== 第一到四课

=== 人称与代词

==== 人称代词

#table(
  columns: (0.2fr, 1fr, 0.6fr),
  align: horizon + center,
  table.header()[*词语*][*说明*][*例句*],
  [わたし], [第一人称], table.cell(rowspan: 3)[あの#fruby[ひと][人] は 森さんですか\ (那个人是森先生吗)],
  [あなた], [第二人称，仅不知道对方名称时使用，否则不尊重],
  [あの#fruby[ひと][人]], [第三人称，较为不尊重，多使用 あの方],

  [#fruby[かた][方]], [代指某人，通常配合表位置所属的 の 使用\ 配合#link(<demon_pron>)[こ / そ / あの]使用表示一 / 二 / 三人称\ 为用于公开场合的礼貌用语], [JC #fruby[き|かく][企|画]の方 ですか。\ （是 JC 策划公司的人吗）]
)

==== 称呼他人

#table(
  columns: (0.2fr, 1fr, 0.6fr),
  align: horizon + center,
  table.header()[*词语*][*说明*][*例句*],
  [#sym.tilde さん], [加在姓或全名后，#hl(1)[不能用于自己]], table.cell(rowspan: 2)[あの#fruby[ひと][人] は 森さんですか\ (那个人是森先生吗)],
  [#sym.tilde \[职务\]], [例如 先生、#fruby[てんいん][店員]さん],
)

==== 指物词 <demon_pron>

根据指物词的第一个假名可分为以下四种类别
- 当说话人与听话人面对面时
  - こ#sym.tilde：距离说话人较近的事物
  - そ#sym.tilde：距离听话人较近的事物
  - あ#sym.tilde：不在两人范围内的事物
- 当说话人与听话人处于同一位置时
  - こ#sym.tilde：在两人附近的事物
  - そ#sym.tilde：距离两人较远的事物
  - あ#sym.tilde：距离更加遥远的事物
- ど#sym.tilde：作为疑问词，询问事物所处位置

#table(
  columns: (1fr, 0.5fr, 1fr),
  align: horizon + center,
  table.header()[*用法*][*模式*][*例句*],
  [处于某处的某个物品], [#sym.tilde れ], [これは 本です],
  [处于某处的特定物品 N], [#sym.tilde の N], [その#fruby[じてんしゃ][自転車]は 森さんの です],
  [#sym.tilde れ 的复数形式], [#sym.tilde れら], [],
  [表示某个位置], [#sym.tilde こ], [],
  [表示某个方向], [#sym.tilde ちら（#sym.tilde っち）], [],
)

=== 省略

#figure(
  table(
    columns: (0.6fr, 1fr),
    align: horizon + center,
    table.header()[*省略场景*][*例句*],
    [对话中省略第一 / 二人称主语], [（あなたは）吉田さんですか。\ #sym.arrow いいえ、（わたしは）森です。]
  )
)

=== 叹词

#figure(
  table(
    columns: (0.5fr, 0.8fr, 1fr),
    align: horizon + center,
    table.header()[*词语*][*含义*][*例句*],
    [あっ], [吃惊或有所感触], [あっ、すみません。],
    [えっ], [因意外而吃惊], [],
  )
)

=== 礼貌用语

#figure(
  table(
    columns: (0.5fr, 0.5fr, 1fr),
    align: horizon + center,
    table.header()[*词语*][*含义*][*说明*],
    [どうぞ よろしく お願いいたします。], [请多关照], [可以省略 どうぞ 或 お願いいたします 中的一个部分],
    [こちらこそ #sym.tilde], [这边也是 #sym.tilde], [后接相同礼貌用语，作为回答如：\ こちらこそ ありがとう],
    [どうも #sym.tilde], [非常 #sym.tilde], [后接礼貌用语，提高敬意\ 也可仅使用 どうも 表示问候 / 感谢], 
    [#sym.tilde。どうぞ], [#sym.tilde 请（收下）], [接在名词后表示请收下，动词后表示请做],

  )
)

=== 疑问代词

// #figure(
//   table(
//     columns: (0.5fr, 0.8fr, 1fr),
//     align: horizon + center,
//     table.header()[*疑问代词*][*含义*][*例句*],
//     [#fruby[なん][何] + 量词], [询问数字，如几个 xxx\ 何 发音为 なん（名词发音也可能不同）\ 同样有 + も / でも 的用法], [#fruby[なんけん][何県]ですか #sym.arrow 几个县？\ #fruby[なんにん][何人]ですか #sym.arrow 几个人？\ #fruby[なんど][何度]も #sym.arrow 每一次],
//     [#fruby[なに][何] + 名词前缀], [询问对象，如哪个 xxx\ 何 发音为 なに（名词发音也可能不同）], [#fruby[なにけん][何県]ですか #sym.arrow 哪个县？\ #fruby[なにじん][何人]ですか #sym.arrow 哪里人？],
//     [#fruby[だれ][誰]の、#fruby[なん][何]の], [谁的、关于什么的\ 何 与 で/す/の/と 连用发音为 なん], [#hl(2)[何の]本ですか #sym.arrow 关于什么的书\ #hl(2)[誰の]本ですか #sym.arrow 谁的书],
//   )
// )

#figure(
  table(
    columns: (0.6fr, 1fr, 1fr),
    align: horizon + center,
    table.header()[*疑问代词*][*说明*][*例句*],

    [#fruby[なに][何]：询问事物], [单独使用（结合其他词含义不同）\ 与 で/す/の/と 连用发音为 なん], [それは#hl(1)[#fruby[なん][何]]です。\ それは#hl(1)[#fruby[なに][何]]だ。],
    [#fruby[だれ][誰]：询问人], [可以单独使用或配合助词 の\ 正式场合使用 どなた], [森さんは どなたですか。],

    [おいくつ：询问年龄], [用于一般正式场合\ 非正式可用 いくつ 或 #fruby[なんさい][何歳]], [#fruby[そ|ふ][祖|父]は おいくつですか],
  )
)