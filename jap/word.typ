#import "./index.typ": *
#show: book-page.with(title: "词语与词组")

#import "/utility/widget.typ": *

= 词语与词组

== 特殊动词

=== 做某事 する

=== 成为 なる

=== 授受动词

== 数字和量词

参考自 #link("https://res.wokanxing.info/jpgramma/numbers.html")

=== 数字基本表示

日语中 1 到 10 以及基本数字词的表示如下：

#figure(
  table(
    columns: (1.2fr,) + (1fr,) * 6 + (1.2fr,),
    align: horizon + center,
    
    [零], [一], [二], [三], [四], [五], [六], [七], 
    [ゼロ/れい#super[#link(<ref:num1>)[[1]]]], [いち], [に], [さん], [よん/し#super[#link(<ref:num1>)[[1]]]], [ご], [ろく], [なな/しち#super[#link(<ref:num1>)[[1]]]], 
    [八], [九], [十], [百], [千], [万], [億], [兆],
    [はち], [きゅう], [じゅう], [ひゃく], [せん], [まん], [おく], [ちょう]
  )
)

#super[[1]]<ref:num1> 后一种表达较少用且仅能用于表示单个数字

对于一般的数字使用类似中文的方法即可表示，但为了便于发音还存在以下特例

#figure(
  table(
    columns: (1fr,) * 6,
    align: horizon + center,
    [三百], [六百], [八百], [三千], [八千], [一兆],
    [さんびゃく], [ろっぴゃく], [はっぴゃく], [さんぜん], [はっせん], [いっちょう]
  )
)

== 固定句型

#figure(
  table(
    columns: (auto, 1fr),
    align: horizon + center,
    table.header()[*句型*][*含义*],
    [お#fruby[かえ][帰]りなさい], [欢迎回家],
    [ただいま], [我回来了],
    [お#fruby[じゃま][邪魔]します], [打扰了],
    [よろしくお#fruby[ねが][願]いします], [请多指教（初次见面）],
    [はじめまして], [初次见面],
    [どういたしまして（不常用）], [不客气（我没做什么值得感谢的事）],
  )
)
