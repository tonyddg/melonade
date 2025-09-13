#import "./index.typ": *
#show: book-page.with(title: "标日初级笔记")

#import "/utility/widget.typ": *

= 标日初级笔记

== 第一到四课

=== 表达

#table(
  columns: (1fr, 1fr, 1fr),
  align: horizon + center,
  table.header()[*模式*][*说明*][*例句*],
  [N は N(地点) です], [です 除了表示判断句，宾语为地点时，也可表示所处位置或方位], [小野さん は #aruby("事務所") です\ （小野先生在事务所）],
  [N1 は N2 ですか、N3 ですか], [询问多个可能答案时，可以并列多个 ですか，此时需要具体回答哪一个不能回答 はい 或 いえ], [今日は #aruby("水曜日") ですか、#aruby("木曜日")ですか],
  [N は どちらですか], [どちら 不一定是在问在哪里，也可以问来自哪里，具体需要结合上下文], [お#aruby("国")は どちらですか\ （你来自哪个国家）],
  [N(地点) に N が あります / います], [N(地点) 处有 N(物体)，强调物体，常用于描述地点的状况\ 动词 ある 用于无生命、无法自主移动的物体，いる 用于有生命的物体], [部屋に #aruby("机")が あります\ （房间里有桌子）],
  [N は N(地点) に あります / います], [N(物体) 在 N(地点)，强调地点，常用于询问或回答物体在哪里的问题], [#aruby("図書館") は どこに ありますか\ （图书馆在哪里）],
  [(疑问词)も V(否定)], [疑问词与主题助词 も 结合用在否定句中可表示全面否定], [#aruby("教室")に #aruby("誰")も いません],

)

=== 基本词语

==== 人称代词

#table(
  columns: (0.2fr, 1fr, 0.6fr),
  align: horizon + center,
  table.header()[*词语*][*说明*][*例句*],
  [わたし], [第一人称], table.cell(rowspan: 3)[あの#aruby("人") は 森さんですか\ (那个人是森先生吗)],
  [あなた], [第二人称，仅不知道对方名称时使用，否则不尊重],
  [あの#aruby("人")], [第三人称，较为不尊重，多使用 あの方],

  [#aruby("方")], [代指某人，通常配合表位置所属的 の 使用\ 配合#link(<demon_pron>)[こ / そ / あの]使用表示一 / 二 / 三人称\ 为用于公开场合的礼貌用语], [JC #aruby("企|画")の方 ですか。\ （是 JC 策划公司的人吗）]
)

==== 称呼他人

#table(
  columns: (0.2fr, 1fr, 0.6fr),
  align: horizon + center,
  table.header()[*词语*][*说明*][*例句*],
  [#sym.tilde さん], [加在姓或全名后，#hl(1)[不能用于自己]], table.cell(rowspan: 2)[あの#aruby("人") は 森さんですか\ (那个人是森先生吗)],
  [#sym.tilde \[职务\]（さん）], [可以再加上 さん 表示敬意，例如 先生、#aruby("店員")さん],
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
  [处于某处的特定物品 N], [#sym.tilde の N], [その#aruby("自転車")は 森さんの です],
  [#sym.tilde れ 的复数形式], [#sym.tilde れら], [],
  [表示某个位置], [#sym.tilde こ\ 特例：あそこ], [あそこは 入り口てすか],
  [表示某个方向\ 或 #sym.tilde こ 的礼貌用法], [#sym.tilde ちら（#sym.tilde っち）], [#aruby("受付")は どちらですか],
  [代指某种状态（作为副词）], [#sym.tilde う], [そうですか #sym.arrow.br（是这样啊）],
)

==== 方位词

日语中常用的方位词如下

#table(
  columns: (1fr,) * 5,
  align: horizon + center,
  [前（まえ）], [後ろ（うしろ）], [隣（となり）], [外（そと）], [中（なか）],
  [上（うえ）], [下（した）], [右（みぎ）], [左（ひだり）], [],
)

日语中，方位通常利用助词 の 与物体结合使用
- 基本的语法即 N の (方位)，如 #aruby("椅子")の上
- 日语的 #aruby("上") 即正上方，没有中文表面的意思，表示墙壁表面直接使用 #aruby("壁")に 即可
- 右 / 左 通常要结合 #aruby("側") 使用，如 #aruby("机")の右#aruby("側")

==== 数字基本表示

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

=== 省略

#figure(
  table(
    columns: (0.6fr, 1fr),
    align: horizon + center,
    table.header()[*省略场景*][*例句*],
    [对话中省略第一 / 二人称主语], [（あなたは）吉田さんですか。\ #sym.arrow いいえ、（わたしは）森です。],
    [连续问句中省略宾语与谓语部分], [これは いくらですか。 #sym.arrow それは 500 #aruby("円")です。\ あれは？#sym.arrow あれも 500 #aruby("円")です]
  )
)

== 第五到八课

=== 表达

=== 基本词语

==== 具体时间



==== 相对时间

#figure(
  table(
    columns: (1fr, ) * 7,
    align: horizon + center,
    [], [前 #sym.tilde], [昨 #sym.tilde], [今 #sym.tilde], [明 #sym.tilde], [后 #sym.tilde], [每 #sym.tilde],

    [#sym.tilde 天], [#aruby("一昨日")], [#aruby("昨日")], [#aruby("今日")], [#aruby("明日")], [#aruby("明後日")], [#aruby("毎日")],

    [#sym.tilde 早上], [#sym.tilde の#aruby("朝")], [#sym.tilde の#aruby("朝")], [#aruby("今朝")], [#sym.tilde の#aruby("朝")], [#sym.tilde の#aruby("朝")], [#sym.tilde #aruby("朝")],

    [#sym.tilde 晚上], [#sym.tilde の#aruby("晩")], [#aruby("昨夜")], [#aruby("今晩")], [#sym.tilde の#aruby("晩")], [#sym.tilde の#aruby("晩")], [#sym.tilde #aruby("晩")],

    [#sym.tilde 周], [#aruby("先々週")], [#aruby("先週")], [#aruby("今週")], [#aruby("来週")], [さ#aruby("来週")], [#sym.tilde #aruby("週")],

    [#sym.tilde 月], [#sym.tilde #aruby("月")], [#sym.tilde #aruby("月")], [#sym.tilde #aruby("月")], [#sym.tilde #aruby("月")], [#sym.tilde #aruby("月")], [#sym.tilde #aruby("月")],

    [#sym.tilde 年], [#aruby("一昨年")], [#aruby("去年")], [#aruby("今年")], [#sym.tilde #aruby("年", i: 1)], [#sym.tilde #aruby("年", i: 1)], [#sym.tilde #aruby("年")],
  )
)

相对时间与后续具体时间组合时
- #aruby("毎") #sym.tilde 直接与后面的时间相连，如：#aruby("毎日")#fruby[しち|じ][七|時]
- 其他与后续时间相连时可以加 の，也可不加，如：#aruby("来週")の#aruby("日曜日")

== 其他

=== 礼貌用语

#figure(
  table(
    columns: (0.5fr, 0.5fr, 1fr),
    align: horizon + center,
    table.header()[*词语*][*含义*][*说明*],
    [どうぞ よろしく お願いいたします。], [请多关照], [可以省略 どうぞ 或 お願いいたします 中的一个部分],
    [こちらこそ #sym.dots], [这边也是 #sym.dots], [后接相同礼貌用语，作为回答如：\ こちらこそ ありがとう],
    [どうも #sym.dots], [非常 #sym.dots], [后接礼貌用语，提高敬意\ 也可仅使用 どうも 表示问候 / 感谢], 
    [#sym.dots。どうぞ], [#sym.dots 请（收下）], [接在名词后表示请收下，动词后表示请做],
    [ご家族、ご兄弟、ご両親], [家人，兄弟姐妹，父母], [提及他人亲属时的说法（自己亲属不需要 ご）]
  )
)

=== 疑问代词

#figure(
  table(
    columns: (0.6fr, 1fr, 1fr),
    align: horizon + center,
    table.header()[*疑问代词*][*说明*][*例句*],

    [#fruby[なに][何]：询问事物], [单独使用（结合其他词含义不同）\ 与 で/す/の/と 连用发音为 なん], [それは#hl(1)[#fruby[なん][何]]です。\ それは#hl(1)[#fruby[なに][何]]だ。],
    [#aruby("誰")：询问人], [可以单独使用或配合助词 の\ 正式场合使用 どなた], [森さんは どなたですか。],

    [おいくつ：询问年龄], [用于一般正式场合\ 非正式可用 いくつ 或 #aruby("何歳")], [#aruby("祖|父")は おいくつですか],
    [いくら：询问价格], [], [その服は いくらですか]
  )
)

=== 叹词与简单表达

#figure(
  table(
    columns: (0.5fr, 0.8fr, 1fr),
    align: horizon + center,
    table.header()[*词语*][*含义*][*例句*],
    [あっ], [吃惊或有所感触], [あっ、すみません。],
    [えっ], [因意外而吃惊], [],
    [あのう], [提出请求或开启新话题], [あのう…このバスはどこへ行きますか],
    [#sym.dots ですか #sym.arrow.br], [句尾降调时，表示确认与理解对方所说的内容], [それは パソコンです \ #sym.arrow パソコンですか #sym.arrow.br],

    [#sym.dots ね #sym.arrow.tr], [用于陈述句中征求听话人的同意], [あそこに #aruby("犬")が いますね],
    [ええと], [表示回答问题前的思考], [ええと、ここです]

  )
)