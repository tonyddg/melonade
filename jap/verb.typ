#import "./index.typ": *
#show: book-page.with(title: "动词变换")

#import "/utility/widget.typ": *

= 动词变换

== 动词分类

参考自 #link("https://res.wokanxing.info/jpgramma/verbs.html")

日语中动词一定以 う 段假名为结尾 (且不是所有 う 段假名都可以作为动词结尾)

根据动词在未然形与过去形变形的特点，可将动词大致归类为 る 动词与 う 动词两大类

#figure(
  table(
    columns: (auto, 1fr, auto),
    align: horizon + center,
    table.header()[*动词类别*][*类别特点*][*示例*],
    [る 动词], [大部分动词以 る 结尾，倒数第二个假名来自 い、え 行], [#fruby[た][食]べる、#fruby[み][見]る、いる],
    [う 动词], [不属于 る 动词的大部分动词], [#fruby[わ][分]かる、#fruby[か][書]く、ある],
    [特例], [变形完全不遵循一般规律], [する、#fruby[く][来]る]
  )
)

动词以 る 结尾，倒数第二个假名来自 あ、う、お 行一定是 う 动词，反之则存在例外，可参考#link("https://res.wokanxing.info/jpgramma/verbs.html#part3")[る前为 /i/ 或 /e/ 的う动词]

== 过去形变换

参考自 #link("https://res.wokanxing.info/jpgramma/past_tense.html")

过去形变换主要根据末尾假名确定，规则固定

#figure(
  table(
    columns: (auto, auto, 1fr, 1fr),
    align: horizon + center,

    table.header()[*变形类别*][*变形说明*][*原型*][*过去形*],


    table.cell(rowspan: 9)[う 动词], 
    [原辅音\ 牙齿闭合], 
    [#fruby[はな][話]#hl(1)[す]], [#fruby[はな][話]#hl(2)[した]],
    table.cell(rowspan: 2)[原辅音\ 舌根发音], 
    [#fruby[か][書]#hl(1)[く]], [#fruby[か][書]#hl(2)[いた]],
    [#fruby[いそ][急]#hl(1)[ぐ]], [#fruby[いそ][急]#hl(2)[いた]],
    table.cell(rowspan: 3)[原辅音\ 嘴唇发音],
    [#fruby[たの][頼]#hl(1)[む]], [#fruby[たの][頼]#hl(2)[んだ]],
    [#fruby[し][死]#hl(1)[ぬ]], [#fruby[し][死]#hl(2)[んだ]],
    [#fruby[あそ][遊]#hl(1)[ぶ]], [#fruby[あそ][遊]#hl(2)[んだ]],
    table.cell(rowspan: 3)[原辅音\ 舌根发音],
    [#fruby[わ][分]か#hl(1)[る]], [#fruby[わ][分]か#hl(2)[った]],
    [#fruby[ま][待]#hl(1)[つ]], [#fruby[ま][待]#hl(2)[った]],
    [#fruby[か][買]#hl(1)[う]], [#fruby[か][買]#hl(2)[った]],
    [る 动词], 
    [去掉 る\ 变为 た], [#fruby[た][食]べ#hl(1)[る]], [#fruby[た][食]べ#hl(2)[た]],
    table.cell(rowspan: 3)[特例], 
    [完全例外], [する], [した],
    [完全例外], [#fruby[く][来]る], [きた],
    [う 动词\ 唯一例外], [#fruby[い][行]く], [いった],
  )
)

== 未然形变换

参考自 #link("https://res.wokanxing.info/jpgramma/negativeverbs.html")

#figure(
  table(
    columns: (auto, auto, 1fr, 1fr),
    align: horizon + center,

    table.header()[*变形类别*][*变形说明*][*原型*][*未然形*],
    table.cell(rowspan: 2)[う 动词], 
    [将末尾假名替换为\ 同行下 あ 段假名再接上 ない], [#fruby[いそ][急]#hl(1)[ぐ]], [#fruby[いそ][急]#hl(1)[がない]], 
    [以う结尾时\ 将 う 替换为 わ 再接上 ない], [#fruby[か][買]#hl(1)[う]], [#fruby[か][買]#hl(2)[わない]], 
    [る 动词], [去掉 る 变为 ない], [#fruby[た][食]べ#hl(1)[る]], [#fruby[た][食]べ#hl(2)[ない]], 
    [未然形], 
    [将结尾的 ない \ 替换为 なかった], [#fruby[た][食]べ#hl(1)[ない]], [#fruby[た][食]べ#hl(2)[なかった]], 
    table.cell(rowspan: 3)[特例], 
    [完全例外], [する], [しない],
    [完全例外], [#fruby[く][来]る], [こない],
    [唯一例外], [ある], [ない], 
  )
)

== 其他变形


