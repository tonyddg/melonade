#import "./index.typ": *
#show: book-page.with(title: "词语与词组")

#import "/utility/widget.typ": *

= 词语与词组

== 基本词语

=== 基础形容词

#table(
  columns: (auto, auto, 1fr),
  align: horizon + center,
  table.header()[*用途*][*形容词对*][*例句*],
  [长、短], [#aruby("長")い、#aruby("短")い], [],
  [高、低], [#aruby("高")い、#aruby("低")い], [],
  [大、小], [#aruby("大き")い、#aruby("小さ")い], [],
  [胖、瘦], [#aruby("太")い、#aruby("細")い], [],
  [新、久], [#aruby("新し")い、#aruby("古")い], [],
  [远、近], [#aruby("遠")い、#aruby("近")い], [],
  [强、弱], [#aruby("強")い、#aruby("弱")い], [],
  [快、慢], [#aruby("速")い、#aruby("遅")い], [],
  [轻、重], [#aruby("重")い、#aruby("軽")い], [],
  [宽广、狭窄], [#aruby("広")い、#aruby("狭")い], [],
  [快乐、悲伤], [#aruby("楽し")い、#aruby("悲し")い], []
)

=== 常用助词

#table(
  columns: (auto, 1fr, 1fr),
  align: horizon + center,
  table.header()[*助词*][*说明*][*例句*],
  [だけ], [副助词，用于附加在基本助词后，表示仅仅], [君にだけ 話す（只对你说话）],
  table.cell(rowspan: 3)[より], 
  [用于判断句中，表示被比较的对象], [#aruby("今年")は #aruby("去年")より #aruby("暑")い（今年比去年热）],
  [与时间、地点相连等同于 から，更加书面], [#aruby("午後")#fruby[さん|じ][三|時]より #aruby("始ま")ります],
  [作为形容词前缀表示更加#sym.tilde，与前文比较], [この#aruby("本")は より#aruby("面白")いです（这本书更有趣）]
)

