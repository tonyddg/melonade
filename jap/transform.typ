#import "./index.typ": *
#show: book-page.with(title: "词语变形")

#import "/utility/include.typ": *

= 词语变形

== 名词及形容词变换

名词及形容词表示状态时，通过变形体现状态特点

=== 形容词分类 <sec:adj_type>

参考自 #link("https://res.wokanxing.info/jpgramma/adjectives.html")[形容词的属性]

根据形容词的变换规则可分为 な 形容词与 い 形容词两大类

#figure(
  table(
    columns: (0.3fr, 1fr, auto),
    align: horizon + center,
    table.header()[*动词类别*][*类别特点*][*示例*],
    [な 形容词], [本质为可通过介词 な 修饰其他名词的名词，变形规则与名词完全相同。], [#fruby[す][好]き、#fruby[きれい][綺麗]、#fruby[しず][静]か],
    [い 形容词], [直接修饰名词的一类词语，且汉字形式必定以独立的假名 い 结尾。仅有少数特例不满足，如 #fruby[きら][嫌]い 为 な 形容词。], [#fruby[たか][高]い、#fruby[かわい][可愛]い\ いい、#fruby[かっこ][格好]いい],
  )
)

=== 名词与 な 形容词变换

参考自 #link("https://res.wokanxing.info/jpgramma/stateofbeing.html")[状态表示]

#figure(
  table(
    columns: (0.2fr, 1fr, 1fr),
    align: horizon + center,
    [], [肯定], [否定（未然）],
    [现在], [#fruby[がくせい][学生] #hl(1)[(だ)#super[#link(<ref:na_adj1>)[[1]]]]、#fruby[しず][静]か#hl(1)[(だ)#super[#link(<ref:na_adj1>)[[1]]]]], [#fruby[がくせい][学生]#hl(2)[じゃない]、#fruby[しず][静]か#hl(2)[じゃない]],
    [过去], [#fruby[がくせい][学生]#hl(2)[だった]、#fruby[しず][静]か#hl(2)[だった]], [#fruby[がくせい][学生]#hl(3)[じゃなかった]、#fruby[しず][静]か#hl(3)[じゃなかった]],

  )
)

#super[[1]]<ref:na_adj1> 仅用于句子末尾表示状态时需要加上 だ，但可以省略。

=== い 形容词变换

参考自 #link("https://res.wokanxing.info/jpgramma/adjectives.html#iadj")[い形容词]

#figure(
  table(
    columns: (0.2fr, 1fr, 1fr),
    align: horizon + center,
    [], [肯定], [否定（未然）],
    [现在], [#fruby[たか][高]#hl(1)[い]], [#fruby[たか][高]#hl(2)[くない]],
    [过去], [#fruby[たか][高]#hl(2)[かった]], [#fruby[たか][高]#hl(3)[くなかった]],

  )
)

对于形容词 いい 及以其为末尾构造的形容词如 #fruby[かっこ][格好]いい 变形需要转为 いい 的原型 #fruby[よ][良]い：

#figure(
  table(
    columns: (0.2fr, 1fr, 1fr),
    align: horizon + center,
    [], [肯定], [否定（未然）],
    [现在], [い(#fruby[よ][良])#hl(1)[い]、#fruby[あたま][頭]が#hl(1)[いい]], [#fruby[よ][良]#hl(2)[くない]、#fruby[あたま][頭]が#hl(2)[よくない]],
    [过去], [#fruby[よ][良]#hl(2)[かった]、#fruby[あたま][頭]が#hl(1)[よかった]], [#fruby[よ][良]#hl(3)[くなかった]、#fruby[あたま][頭]が#hl(1)[よくなかった]],

  )
)

=== 形容词副词化

参考自 #link("https://res.wokanxing.info/jpgramma/adverbs.html#part2")[副词的属性]

日语的副词可以放在它所修饰的动词前面的任何地方，并且此处介绍的是如何将形容词转化为修饰动词的副词，除此之外也有很多词语本身即副词如 #fruby[たくさん][沢山]、#fruby[ぜんぜん][全然] 等。

#figure(
  table(
    columns: (0.3fr, 1fr, auto, auto),
    align: horizon + center,
    table.header()[*形容词类别*][*变形说明*][*形容词示例*][*副词示例*],
    [な 形容词], [在最后加上助词 に（与表示目的的 に 区分）], [#fruby[しず][静]か #hl(1)[な] #hl(0)[#fruby[としょかん][図書館]]], [#fruby[しず][静]か #hl(2)[に] #hl(0)[する]],
    [い 形容词], [将 い 替换为 く], [#fruby[おお][大]き#hl(1)[い] #hl(0)[#fruby[とし][都市]]], [#fruby[おお][大]き#hl(2)[く] #hl(0)[#fruby[か][変]わった]],
  )
)

此处副词的含义为用于修饰动词的形容词，和英语形容动作的副词存在区别，例如 俺が 強く なる

== 动词变换

=== 动词分类

参考自 #link("https://res.wokanxing.info/jpgramma/verbs.html")

日语中动词一定以 う 段假名为结尾 (且不是所有 う 段假名都可以作为动词结尾)

根据动词在未然形与过去形变形的特点，可将动词大致归类为 る 动词与 う 动词两大类

#figure(
  table(
    columns: (0.3fr, 1fr, auto),
    align: horizon + center,
    table.header()[*动词类别*][*类别特点*][*示例*],
    [る 动词], [大部分动词以 る 结尾，倒数第二个假名来自 い、え 行], [#fruby[た][食]べる、#fruby[み][見]る、いる],
    [う 动词], [不属于 る 动词的大部分动词], [#fruby[わ][分]かる、#fruby[か][書]く、ある],
    [特例], [变形完全不遵循一般规律], [する、#fruby[く][来]る]
  )
)

动词以 る 结尾，倒数第二个假名来自 あ、う、お 行一定是 う 动词，反之则存在例外，可参考#link("https://res.wokanxing.info/jpgramma/verbs.html#part3")[る前为 /i/ 或 /e/ 的う动词]

以下为常见例外
#figure(
  table(
    columns: (1fr, 1fr, 1fr, 1fr),
    align: horizon + center,

    [#fruby[はい][入]る], [#fruby[はし][走]る], [#fruby[し][知]る], [#fruby[かえ][帰]る]
  )
)

=== 过去形变换

参考自 #link("https://res.wokanxing.info/jpgramma/past_tense.html")

过去形变换主要根据末尾假名确定，规则固定

#figure(
  table(
    columns: (0.3fr, 1fr, auto, auto),
    align: horizon + center,

    table.header()[*动词类型*][*变形说明*][*原型*][*过去形*],


    table.cell(rowspan: 9)[う 动词], 
    [原辅音牙齿闭合], 
    [#fruby[はな][話]#hl(1)[す]], [#fruby[はな][話]#hl(2)[した]],
    table.cell(rowspan: 2)[原辅音舌根发音], 
    [#fruby[か][書]#hl(1)[く]], [#fruby[か][書]#hl(2)[いた]],
    [#fruby[いそ][急]#hl(1)[ぐ]], [#fruby[いそ][急]#hl(2)[いた]],
    table.cell(rowspan: 3)[原辅音嘴唇发音],
    [#fruby[たの][頼]#hl(1)[む]], [#fruby[たの][頼]#hl(2)[んだ]],
    [#fruby[し][死]#hl(1)[ぬ]], [#fruby[し][死]#hl(2)[んだ]],
    [#fruby[あそ][遊]#hl(1)[ぶ]], [#fruby[あそ][遊]#hl(2)[んだ]],
    table.cell(rowspan: 3)[原辅音舌根发音],
    [#fruby[わ][分]か#hl(1)[る]], [#fruby[わ][分]か#hl(2)[った]],
    [#fruby[ま][待]#hl(1)[つ]], [#fruby[ま][待]#hl(2)[った]],
    [#fruby[か][買]#hl(1)[う]], [#fruby[か][買]#hl(2)[った]],
    [る 动词], 
    [去掉 る变为 た], [#fruby[た][食]べ#hl(1)[る]], [#fruby[た][食]べ#hl(2)[た]],
    table.cell(rowspan: 3)[特例], 
    [完全例外], [する], [した],
    [完全例外], [#fruby[く][来]る], [きた],
    [う 动词唯一例外], [#fruby[い][行]く], [いった],
  )
)

=== 未然形变换

参考自 #link("https://res.wokanxing.info/jpgramma/negativeverbs.html")

#figure(
  table(
    columns: (0.3fr, 1fr, auto, auto),
    align: horizon + center,

    table.header()[*动词类型*][*变形说明*][*原型*][*未然形*],
    table.cell(rowspan: 2)[う 动词], 
    [将末尾假名替换为同行下 あ 段假名再接上 ない], [#fruby[いそ][急]#hl(1)[ぐ]], [#fruby[いそ][急]#hl(1)[がない]], 
    [以う结尾时将 う 替换为 わ 再接上 ない], [#fruby[か][買]#hl(1)[う]], [#fruby[か][買]#hl(2)[わない]], 
    [る 动词], [去掉 る 变为 ない], [#fruby[た][食]べ#hl(1)[る]], [#fruby[た][食]べ#hl(2)[ない]], 
    [过去形], 
    [将结尾的 ない 替换为 なかった], [#fruby[た][食]べ#hl(1)[ない]], [#fruby[た][食]べ#hl(2)[なかった]], 
    table.cell(rowspan: 3)[特例], 
    [完全例外], [する], [しない],
    [完全例外], [#fruby[く][来]る], [こない],
    [唯一例外], [ある], [ない], 
  )
)

== 变形基础

=== て 形 <transform_teform>

参考自 #link("https://res.wokanxing.info/jpgramma/compound.html")

#figure(
  table(
    columns: (0.5fr, 1fr, auto, auto),
    align: horizon + center,
    table.header()[*词语类别*][*变形说明*][*原型*][*て 形*],

    [名词或 な 形容词], [在末尾加 で（可认为来自于 だ）], [#fruby[しず][静]か], [#fruby[しず][静]か#hl(2)[で]], 

    [い 形容词], table.cell(rowspan: 2)[把 い 替换成 くて（いい 变回原形 よい）], [#fruby[かわい][可愛]#hl(1)[い]], [#fruby[かわい][可愛]#hl(2)[くて]], 

    [词语否定形], [#fruby[かのじょ][彼女]じゃな#hl(1)[い]\ #fruby[た][食]べな#hl(1)[い]], [#fruby[かのじょ][彼女]じゃな#hl(2)[くて]\ #fruby[た][食]べな#hl(2)[くて]], 

    [动词], [基于#cross-link(p-transform)[过去形]，将末尾的 た 替换为 て（だ 替换为 で）], [し#hl(1)[た]\ #fruby[たの][頼]ん#hl(1)[だ]], [し#hl(2)[て]\ #fruby[たの][頼]ん#hl(2)[で]], 
    [丁宁体], [基于丁宁体动词变换 です（状态）、ます（动作）], [#fruby[がくせい][学生]でし#hl(1)[た]\ #fruby[か][買]いまし#hl(1)[た]], [#fruby[がくせい][学生]でし#hl(2)[て]\ #fruby[か][買]いまし#hl(2)[て]], 
  )
)

当主语同时完成多个动作（或者动作顺序），或处于多种状态（将处于状态也是为一种动作）时，可通过 て 形并列这些动作，仅最后一个动词需要变形为具体形态（字典形 / 未然形 / 过去形）

例如
- 以下句子通过 て 形表示动作顺序：\ 
 食堂に 行って、昼ご飯を 食べて、昼寝を する
- 以下句子通过 て 形表示动作的前提（原因）：\ 
 時間がありまして、映画が見ました

て 形中将某些动词作为结尾时还将具有特殊含义，如用于表示动作的时态（如 #fruby[い][行]く 等可参见参考链接）或附加其他含义

部分动词的 て 形则可用在动词前起到类似副词的效果如：

#figure(
  table(
    columns: (auto, auto, 1fr),
    align: horizon + center,
    table.header()[*动词原型（て 形）*][*含义*][*例句*],
    [#fruby[はじ][始]める（初めて）], [第一次], [テストを 始めて ください],
    [#fruby[お][落]ち#fruby[つ][着]く（#fruby[お][落]ち#fruby[つ][着]いて）], [冷静地], [私の話を #fruby[お][落]ち#fruby[つ][着]いて 聞いて ください],
    [#fruby[だま][黙]る（#fruby[だま][黙]って）], [沉默地], [彼は いつも 黙って 仕事おします]
  )
)

- 初めて 为动词 始める 的 て 形但一般用在其他动词前表示第一次

=== 动词词根（连用形） <transform_term>

参考自 #link("https://res.wokanxing.info/jpgramma/polite.html#part2")

在 Tae Kim 的语法指南中称为动词词根，但在一般语法指南中称为动词连用形

#figure(
  table(
    columns: (0.3fr, 1fr, auto, auto),
    align: horizon + center,
    table.header()[*动词类别*][*变形说明*][*原型*][*词根*],
    [る 动词], [去掉 る], [#fruby[た][食]べ#hl(1)[る]、#fruby[み][見]#hl(1)[る]], [#fruby[た][食]べ、#fruby[み][見]],
    [う 动词], [将末尾假名替换为同行下 い 段假名], [#fruby[か][書]#hl(1)[く]、あ#hl(1)[る]], [#fruby[か][書]#hl(2)[き]、あ#hl(2)[り]],
    [特例], [变形完全不遵循一般规律], [する、#fruby[く][来]る], [し、き]
  )
)

动词词根可将动词转化为名词，用于一些仅用于名词的助词连接如（表达一类事情应使用#cross-link(p-partial, reference: <partial_no>)[表示通用名词的 の]）
- 与 xxx に #fruby[く][来]る、xxx に #fruby[い][行]く 连接表示为了 xxx 而来，例如：明日、映画を見に行く
- 用于 の 代替类似关系从句的用法
- 用于复杂词语的构造，例如：#fruby[た][食]べ#fruby[もの][物]

相比于 て 形，动词词根主要用于#link(<transform_teneigo>)[丁宁语]

== 附加动作含义

=== 丁宁语 <transform_teneigo>

日语的基本语法均为普通体，为了转换为表示尊敬的丁宁语，还需要在普通体的基础上进一步变形

通过#link(<transform_term>)[动词词根]加动词 ます 得到动词丁宁语，不同时态的表示基于动词 ます

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: horizon + center,
    table.header()[][*ます 变形*][*丁宁语示例*],
    [字典形], [ます], [#fruby[た][食]べ#hl(1)[ます]],
    [未然形], [ません], [#fruby[た][食]べ#hl(1)[ません]],
    [过去形], [ました], [#fruby[た][食]べ#hl(1)[ました]],
    [过去未然形], [ませんでした], [#fruby[た][食]べ#hl(1)[ませんでした]],
  )
)

名词与形容词丁宁语则基于动词 です 得到


#figure(
  table(
    columns: (0.8fr, 0.75fr, 1fr, 1.1fr, 1.1fr),
    align: horizon + center,
    table.header()[][*词语类型*][*变形说明*][*原型*][*丁宁语*],
    [字典形\ 未然形（口语）\ 过去未然形（口语）], [规则相同], [在变形的基础后加上 です], [#fruby[しず][静]か\ #fruby[かわい][可愛]くない\ #fruby[しず][静]かじゃなかった], [#fruby[しず][静]か#hl(2)[です]\ #fruby[かわい][可愛]くない#hl(2)[です]\ #fruby[しず][静]かじゃなかった#hl(2)[です]],

    table.cell(rowspan: 2)[过去形], 
    [名词或 な 形容词], [字典形基础后加上 でした], [#fruby[しず][静]か#hl(1)[だった]], [#fruby[しず][静]か#hl(2)[でした]], 
    [い 形容词], [过去形基础后加上 です], [#fruby[かわい][可愛]かった], [#fruby[かわい][可愛]かった#hl(2)[です]],

    table.cell(rowspan: 2)[未然形（书面）], 
    [规则相同], [去掉未然形的 ない 换为 ありません], [#fruby[しず][静]かじゃ#hl(1)[ない]\ #fruby[かわい][可愛]く#hl(1)[ない]], [#fruby[しず][静]かじゃ#hl(2)[ありません]\ #fruby[かわい][可愛]く#hl(2)[ありません]], 
    [名词或 な 形容词\ 更加正式], [使用 では 代替原来的 じゃ，其中 は 发音为 wa], [#fruby[しず][静]かじゃ#hl(1)[ない]\ #fruby[かわい][可愛]く#hl(1)[ない]\ #fruby[うそ][噓]#hl(1)[じゃ]ありません], [#fruby[しず][静]かじゃ#hl(2)[ありません]\ #fruby[かわい][可愛]く#hl(2)[ありません]\  #fruby[うそ][噓]#hl(2)[では]ありません], 
    [过去未然形（书面）], [规则相同], [在书面未然形的基础加上 でした], [#fruby[しず][静]かじゃ#hl(2)[ありません]\ #fruby[かわい][可愛]く#hl(2)[ありません]], [#fruby[しず][静]かじゃ#hl(2)[ありません]#hl(3)[でした]\ #fruby[かわい][可愛]く#hl(2)[ありません]#hl(3)[でした]], 
  )
)

=== 表示持续或完成 <transform_state>

参考自 
- #link("https://res.wokanxing.info/jpgramma/teform.html")
- #link("https://hkotakujapanese.com/%e6%97%a5%e6%96%87%e6%96%87%e6%b3%95%e5%9f%ba%e7%a4%8e15-%e3%80%8c%e8%a3%9c%e5%8a%a9%e5%8b%95%e8%a9%9e%e3%80%8d/")[補助動詞]
- #link("https://www.sigure.tw/learn-japanese/grammar/n4/18")[補助動詞 てみる]

基于 て 形与特定动词（称为补助动词）相连可用于附加含义，通过对最后动词变形表示过去与未然以及丁宁体。

#figure(
  table(
    columns: (0.5fr, 1fr, 1fr),
    align: horizon + center,
    table.header()[*时态*][*变形说明*][*例句*],
    [动作进行中\ 状态持续中], [与动词 いる 连用，具体含义需要结合上下文], [教科書を読んで#hl(1)[います] #sym.arrow 正在读书\ ドアが開いて#hl(1)[いる] #sym.arrow 门处于打开状态],
    [动作意外发生\ 动作完全完成], [与动词 しまう 连用（一般为过去形）\ 口语中有如下替换（变形基于替换）\ #sym.tilde て(で)しまう #sym.arrow #sym.tilde ち(じ)ゃう], [そのケーキを全部食べて#hl(1)[しまった]\ #fruby[きんぎょ][金魚]がもう死ん#hl(1)[じゃった]],
    [动作完成], [与动词 ある 连用，通常用于回答提问], [準備はどうですか?\ 準備は、もうして#hl(1)[ある]],
    [步骤准备好], [与动词 #fruby[お][置]く 连用], [晩ご飯を作って#hl(1)[おく] \ #sym.arrow 包含做完饭准备吃的含义],
  )
)

注意，ている 用于动作动词时，将还原为 て 形的基本含义，即变为作为 xxx 然后出现了如：
- 家に 帰って いる #sym.arrow 回了家然后待在家里
- 来て いる #sym.arrow 过来并出现在目的地

关于更多补助动词的使用参见第二、三个参考文献

=== 表示能力

参考自 
- #link("https://res.wokanxing.info/jpgramma/potential.html")[可能形]
- https://zhuanlan.zhihu.com/p/366176836

可能形用于表示具有能力完成某事，动词的可能形一定为 る 动词（对应变形即不能完成某事或过去能完成某事）

注意此处的可能指具有能力完成某事，对于表示确定性的可能参见 #link("https://res.wokanxing.info/jpgramma/certainty.html")

#figure(
  table(
    columns: (0.3fr, 1fr, auto, auto),
    align: horizon + center,

    table.header()[*动词类型*][*变形说明*][*原型*][*过去形*],
    [う 动词], 
    [将末尾假名替换为同行下 え 段假名再接上 る（变为 る 动词）], [#fruby[か][買]#hl(1)[う]], [#fruby[か][買]#hl(2)[える]], 
    [る 动词], [去掉 る 变为 られる], [#fruby[た][食]べ#hl(1)[る]], [#fruby[た][食]べ#hl(2)[られる]], 
    table.cell(rowspan: 3)[特例], 
    [完全例外], [する], [#fruby[でき][出来]る\ （以新单词代替）],
    [完全例外], [#fruby[く][来]る], [こられる],
    [表示物体 / 事情可能存在（不属于可能形）], [ある], [あり#fruby[え][得]る], 
  )
)

使用可能形时注意
- 通常只有人能做的动作具有可能形（参见参考连接 2）
- 由于可能形作为动作时没事实际执行，因此不能使用 を 表示动作对象，只能使用 が、は、も 代替（通常为 が）
- 有的动词本身带有可能形含义如 見える，但强调物体能被看到，相应可能形强调人有看的能力 / 机会如
  - 今日は 晴れて、富士山が #hl(1)[見える] #sym.arrow 表示能看到富士山
  - 友達のおかげで、映画は ただで #hl(2)[見られた] #sym.arrow 表示有机会免费看电影

=== 表示条件 <trasform_condition>

参考自 #link("https://res.wokanxing.info/jpgramma/conditionals.html")[条件语]

通过改变句子中最后的动词 / 表示状态的名词或形容词，使句子转换为条件语，表示 如果xxx 的含义，并后接下个句子表示结果

#figure(
  table(
    columns: (0.5fr, 1fr, auto, auto),
    align: horizon + center,
    table.header()[词语类别][变形说明][*原型*][*一般条件语*],

    [名词或 な 形容词], [在末尾加 であれば], [#fruby[しず][静]か], [#fruby[しず][静]か#hl(2)[であれば]], 

    [い 形容词与否定形\ （以 ない 结尾）], [将末尾的 い 换成 ければ], [#fruby[かのじょ][彼女]じゃな#hl(1)[い]\ い#hl(1)[い]], [#fruby[かのじょ][彼女]じゃな#hl(2)[ければ]\ よ#hl(2)[ければ]], 

    [动词], [将末尾假名替换为同行下 え 段假名再接上 ば], [#fruby[ま][待]#hl(1)[つ]\ #fruby[た][食]べ#hl(1)[る]], [#fruby[ま][待]#hl(2)[てば]\ #fruby[た][食]べ#hl(2)[れば]], 

    [过去形\ （侧重结果）], [在过去形基础上加上 ら(ば#super[#link(<ref:ba_1>)[[1]]])], [#fruby[がくせい][学生]だった\ #fruby[たか][高]かった], [#fruby[がくせい][学生]だった#hl(2)[ら]\ #fruby[たか][高]かった#hl(2)[ら]], 
  )
)
#super[[1]]<ref:ba_1> 额外的 ば 可以显得更加正式

上述介绍的为一般条件语（也成为 ば 形），对于特殊的条件可直接用连接词连接，详见上述参考链接

#figure(
  table(
    columns: (1fr, 1fr, 1.5fr),
    align: horizon + center,
    table.header()[*条件语类型*][*连接词*][*示例*],
    [一般条件语], [一般的 ば 形], [お金が #hl(1)[あれば] いいね\ 情况会很好，如果我有钱，对吧？], 
    [过去条件语\ 不关心条件强调结果], [过去形的 ば 形], [お金が#hl(1)[あったら]いいね\ 如果我有钱的话，那情况会很好，对吧？], 
    [前提条件\ 通常条件已经发生或作为句子的前提条件], [在末尾添加 なら(ば#super[#link(<ref:ba_2>)[[1]]])\ （名词的 だ 必须省略）], [みんなが行く#hl(1)[なら] 私も行く\ 如果大家都去的话我也去], 
    [自然条件\ 表明结果发生为必然的], [在末尾添加 と\ （名词的 だ 不能省略）], [電気を消す#hl(1)[と] 暗くなる\ 如果关了灯，会变暗], 
  )
)
#super[[1]]<ref:ba_2> 额外的 ば 可以显得更加正式

=== 表示希望 <transform_desire>

参考自 
- #link("https://res.wokanxing.info/jpgramma/desire.html")[希望和建议]
- #link("https://zhuanlan.zhihu.com/p/502406095")

#figure(
  table(
    columns: (0.4fr, 0.5fr, 1fr, 1fr),
    align: horizon + center,

    table.header()[*词语*][*使用场景*][*变形说明*][*示例*],

    table.cell(rowspan: 2)[动词\ 想做某事], 
    [第一人称陈述\ 第二人称提问\ 第三人称推测], [在动词词根后加上 たい 变为 い 形容词\ 第三人称只能用于表示#link("https://res.wokanxing.info/jpgramma/similarity.html")[推测]的句子], [温泉に 行き#hl(1)[たい]\ 何を し#hl(1)[たい] ですか?\ 王さんは 飲み#hl(1)[たい] そうです],
    [第三人称陈述], [在动词词根后加上 たがる 变为动词，通常还需要进一步转化为#link(<transform_state>)[持续状态]], [王さんは 飲み#hl(1)[たがって]いる\ あの人は 新しいことを やり#hl(1)[たがる]],

    table.cell(rowspan: 2)[名词\ 想要某物], 
    [第一人称陈述\ 第二人称提问\ 第三人称推测], [使用助词 が 与 い 形容词 #bl(1)[#fruby[ほ][欲]しい] 表示\ 第三人称只能用于表示#link("https://res.wokanxing.info/jpgramma/similarity.html")[推测]的句子], [私は 急に それが #hl(1)[ほしい] です\ 王さんは それが #hl(1)[ほしい] そうです],
    [第三人称陈述], [使用助词 を 与动词 #bl(1)[ほしがる] 表示，通常还需要进一步转化为#link(<transform_state>)[持续状态]], [王さんは それを #hl(1)[ほしがって] います],
  )
)

// 对于希望做的动作，可通过动词的 #bl(1)[たい] 形表示，即在动词词根后加上 たい，且新的词变为 い 形容词形式的动词，变形规则与 い 形容词相同

// #figure(
//   table(
//     columns: (0.2fr, 1fr, 1fr),
//     align: horizon + center,
//     [], [肯定], [否定（未然）],
//     [现在], [#fruby[い][行]き#hl(1)[たい]、#fruby[た][食]べ#hl(1)[たい]], [#fruby[い][行]き#hl(1)[たくない]、#fruby[た][食]べ#hl(1)[たくない]],
//     [过去], [#fruby[い][行]き#hl(1)[たかった]、#fruby[た][食]べ#hl(1)[たかった]], [#fruby[い][行]き#hl(2)[たくなかった]、#fruby[た][食]べ#hl(2)[たくなかった]],

//   )
// )

// たい 形作为 い 形容词
// - 可以变形为副词修饰动作，常用与修饰 なる，例如：食べたく なった
// - 可以使用 を、に、へ、で 等动词助词，例如：何を したいですか？

// 对于希望的东西，可通过 い 形容词 #bl(1)[#fruby[ほ][欲]しい] 表示（使用方法类似 #bl(1)[#fruby[す][好]き]），与动词的 て 形结合则用于表示希望某事被完成（使用较少，多用#link(<transform_require>)[请求]代替）

// #figure(
//   table(
//     columns: (auto, auto, 1fr),
//     align: horizon + center,

//     table.header()[*表示含义*][*使用方法*][*示例*],
//     [想要某物], [名词 + が + #fruby[ほ][欲]しい], [私は パソコンが ほしいです],
//     [请求某事被完成], [动词 て 形 + ほしい], [],
//   )
// )

=== 表示建议 <transform_suggest>

参考自 #link("https://res.wokanxing.info/jpgramma/desire.html")[希望和建议]

意向形代表某人准备着手做某事，可用于表示建议，英语通常翻译为 Let's xxx 或 We shall xxx

#figure(
  table(
    columns: (0.5fr, 1.8fr, 1fr, 1fr),
    align: horizon + center,
    table.header()[*动词类型*][*变形规则*][*字典形*][*意向形*],
    [る 动词], [去掉 る 再加上 よう], [#fruby[た][食]べ#hl(1)[る]], [#fruby[た][食]べ#hl(2)[よう]],
    [う 动词], [将末尾 う 段假名改为 お 段再加上 う], [#fruby[か][買]#hl(1)[う]], [#fruby[か][買]#hl(2)[おう]],
    [丁宁语], [将 ます 改为 ましょう], [#fruby[た][食]べ#hl(1)[ます]\ #fruby[か][買]い#hl(1)[ます]], [#fruby[た][食]べ#hl(1)[ましょう]\ #fruby[か][買]い#hl(1)[ましょう]],
    [例外], [完全例外], [する、#fruby[く][来]る], [しよう、こよう],
  )
)

日语中还可基于#link(<trasform_condition>)[条件形]与疑问代词 どう，通过问句 xxx 的话怎么样？ 表示建议如：
- #fruby[ぎんこう][銀行]に 行ったら どう ですか

=== 表示尝试

参考自 #link("https://res.wokanxing.info/jpgramma/try.html")[试和尝试]

可通过以下两种方式表示尝试

#figure(
  table(
    columns: (0.5fr, 0.5fr, auto, 1fr),
    align: horizon + center,
    table.header()[*变形规则*][*使用场景*][*变形示例*][*例句*],
    [基于#link(<transform_teform>)[ て 形]及补助动词 みる], [表示尝试做某事], [#fruby[た][食]べ#hl(1)[て]#hl(2)[みる]], [お#fruby[この][好]み#fruby[や][焼]きを #fruby[はじ][初]めて #fruby[た][食]べて #hl(2)[みた] けど、とても おいしかった\ #sym.arrow 尽管我第一次尝试广岛烧，但我觉得很好吃],
    [基于#link(<transform_suggest>)[意向形]与 とする], [表示努力做到某事], [#fruby[た][食]べ#hl(1)[よう]#hl(2)[とする]], [#fruby[まいにち][毎日]、#fruby[べんきょう][勉強]を#fruby[さ][避]けよう#hl(2)[と する]\ #sym.arrow 他每天都试图逃避学习],
  )
)

关于表示尝试
- 后续变形需要基于变形后附加的动词，例如以下例句中将尝试与#link(<transform_desire>)[表示希望]结合，体现为希望尝试：#fruby[ひろしま][広島]の お#fruby[この][好]み#fruby[や][焼]きを #fruby[た][食]べて#hl(1)[みたい]
- 意向形 + と + 动词中，还可使用其他动词为尝试附加其他意思例如：#fruby[まいにち][毎日]ジムに#fruby[い][行]こうと#fruby[き][決]めた #sym.arrow 我决定尝试每天去健身房

=== 表示请求与命令 <transform_require>

参考自 #link("https://res.wokanxing.info/jpgramma/requests.html")[做出请求]

一般的请求通过动词 #bl(1)[くださる]（给） 的尊敬语 #bl(1)[ください] 表示

以上请求表示中
- 在口语中则使用 #bl(1)[#fruby[ちょうだい][頂戴]] 代替
- 口语中表示请求他人做某事可以省略 ください 仅留下 #link(<transform_teform>)[て 形]

#figure(
  table(
    columns: (auto, auto, 1fr),
    align: horizon + center,
    table.header()[*使用场景*][*句型*][*例句*],
    [请求给自己某物], [N を ください], [それを ください],
    [请求他人做某事], [V(#link(<transform_teform>)[て 形]) ください], [書いて ください]
  )
)

通过动词的命令形表示命令，一般极少使用

=== 表示必须

参考自 #link("https://res.wokanxing.info/jpgramma/must.html")[表达「必须」或「不得不」]

通过动词的 #link(<transform_teform>)[て 形] + は 后接以下三个词语特定地用于表示#bl(0)[禁止做某事]。用于丁宁语 / 过去形时需要做出对应变形

#figure(
  table(
    columns: (1fr, 0.6fr, auto),
    align: horizon + center,
    table.header()[*词语*][*使用场景*][*例句*],
    [名词 #bl(1)[だめ]], [用于口语], [それを 食べ#hl(2)[ては] #hl(1)[だめ]],
    [动词 いける 的否定形 #bl(1)[いけない]], [用于一般情况], [ここに #fruby[はい][入]っ#hl(2)[ては] #hl(1)[いけません]],
    [动词 なる 的否定形 #bl(1)[ならない]], [用于表示规定，可翻译为（不）允许], [早く 寝#hl(2)[ては] #hl(1)[なりませんでした]],
  )
)

在口语中有时会使用 ちゃ 代替 ては（使用 じゃ 代替 では），且多使用 だめ 并加上语气助词 よ，例如
- ここに #fruby[はい][入]っ#hl(2)[ちゃ] だめだよ
- #fruby[し][死]ん#hl(2)[じゃ] だめだよ

表示必须时同样基于上述三个词语，使用动词的否定形式以双重否定的形式表示。除了 #link(<transform_teform>)[否定 て 形] + は 外共有以下三种构造方式

#figure(
  table(
    columns: (auto, 1fr),
    align: horizon + center,
    table.header()[*构造方式*][*例句*],
    [基于不能做：#link(<transform_teform>)[否定 て 形] + は], [毎日学校に#hl(1)[行かなくては]なりません],
    [#link(<trasform_condition>)[基于自然条件]：否定形 + と], [宿題を#hl(1)[しないと]いけない],
    [#link(<trasform_condition>)[基于否定一般条件]], [宿題を#hl(1)[しなければ]だめだった],
  )
)

由于表示必须的句子过长，因此口语中更多使用如下的简略表示，同时省略后续表示不能做的词语

#figure(
  table(
    columns: (0.8fr, 1fr),
    align: horizon + center,
    table.header()[*构造方式*][*例句*],
    [将 #link(<transform_teform>)[否定 て 形] 的 なくて 换成 なくちゃ], [毎日学校に#hl(1)[行か]#hl(2)[なくちゃ]],
    [将 #link(<trasform_condition>)[否定一般条件] 的 なければ 换成 なきゃ], [宿題を#hl(1)[し]#hl(2)[なきゃ]],
    [仅使用否定形 + と], [宿題を#hl(1)[しないと]],
  )
)

=== 表示可以做某事

参考自 #link("https://res.wokanxing.info/jpgramma/must.html#part5")[表达可以做或可以不做什么]

通过动词的 #link(<transform_teform>)[て 形] + も 后接以下三个词语特定地用于表示#bl(0)[可以做某事]

#figure(
  table(
    columns: (1fr, 0.6fr, auto),
    align: horizon + center,
    table.header()[*词语*][*使用场景*][*例句*],
    [い 形容词 #bl(1)[いい]], [表示可以这样做\ 口语中可省略 も], [それを 食べ#hl(2)[ても] #hl(1)[いい] よ\ もう 帰っ#hl(2)[て] #hl(1)[いい]？],
    [名词 #bl(1)[#fruby[だいじょうぶ][大丈夫]]], [表示这样做没问题], [全部 飲ん#hl(2)[でも] #hl(1)[#fruby[だいじょうぶ][大丈夫]] だよ],
    [动词 #fruby[かま][構]う 的否定形 #bl(1)[#fruby[かま][構]わない]], [表示不介意这样做], [全部 飲ん#hl(2)[でも] #hl(1)[#fruby[かま][構]わない] だよ],
  )
)

=== 表示被动

参考自 #link("https://res.wokanxing.info/jpgramma/causepass.html#part3")[被动词]


=== 表示使役

参考自 #link("https://res.wokanxing.info/jpgramma/causepass.html#part1")[使役动词]

== 其他

=== 自动词与他动词

参考自 #link("https://enuncia.online/zh/2024/05/07/blog24-zh/")

- 自动词：
  - 表示动作由主语本身自动地做出或描述主语做出动作的状态
  - 主语为（强调）发生改变的人或物
  - 使用自动词的句子一般不存在宾语，或不使用助词 を 表示宾语，一般使用 が 强调主语
  - 例如：#hl(1)[ドアが] 閉まります
- 他动词：
  - 强调动作受到主语有意动作的影响而产生
  - 主语为（强调）使其他物体发生改变的人或物
  - 使用他动词的句子需要助词 を 表示宾语，一般使用 は 表示主语
  - 例如：#hl(2)[わたしは] #hl(1)[ドアを] 閉めます

关于区分：
- 同一个动作（汉字相同）可能存在自动词与他动词版本或既是自动词也是他动词
- 区分自动词与他动词没有简单规律，一般自动词版本为 る 动词或以 -aru 为结尾
- 具体规律可参见参考链接

=== 变形总览


