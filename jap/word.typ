#import "./index.typ": *
#show: book-page.with(title: "词语与词组")

#import "/utility/include.typ": *

= 词语与词组

== 基本词语

=== 基础形容词

常见 い 形容词（部分 な 形容词）

#table(
  columns: (auto, auto, 1fr),
  align: horizon + center,
  table.header()[*用途*][*形容词*][*例句*],
  [长、短], [#aruby("長")い、#aruby("短")い], [],
  [高、低], [#aruby("高")い、#aruby("低")い], [],
  [大、小], [#aruby("大き")い、#aruby("小さ")い], [],
  [胖、瘦], [#aruby("太")い、#aruby("細")い], [],
  [新、久], [#aruby("新し")い、#aruby("古")い], [],
  [远、近], [#aruby("遠")い、#aruby("近")い], [],
  [强、弱], [#aruby("強")い、#aruby("弱")い], [],
  [早、快、慢], [#aruby("早")い、#aruby("速")い、#aruby("遅")い], [],
  [轻、重], [#aruby("重")い、#aruby("軽")い], [],
  [好、坏], [#aruby("良")い / いい、#aruby("悪")い], [],
  [多、少], [#aruby("多")い、#aruby("少な")い（不修饰名词）], [], 
  [宽、窄], [#aruby("広")い、#aruby("狭")い], [],
  [快乐、悲伤], [#aruby("楽し")い（持续的）、#aruby("悲し")い], [],
  [愉快、无聊], [#aruby("嬉し")い（一时的愉快）、\ つまらない（无聊的）], [],
  [整洁、脏乱], [#aruby("綺麗")、#aruby("汚")い], [],
  [好吃、难吃], [#aruby("美味し")い、#aruby("不味")い], [],
  [轻松、幸苦], [#aruby("甘")い、#aruby("辛")い], [],
  [便宜、昂贵], [#aruby("高")い、#aruby("安")い], [],
  [简单、困难], [#aruby("難し")い、#aruby("易し")い], [],
  [温度], [#aruby("熱")い、#aruby("温か")い、\ #aruby("涼し")い、#aruby("冷た")い], [],
  [天气], [#aruby("蒸し暑")い（闷热）、#aruby("暑")い、\ #aruby("暖か")い、#aruby("寒")い], [],
  [味道], [#aruby("酸っぱ")い、#aruby("甘")い、\ #aruby("苦")い、#aruby("辛", i:1)い、#aruby("塩辛")い], [],
)

常见 な 形容词

#table(
  columns: (auto, auto, 1fr),
  align: horizon + center,
  table.header()[*用途*][*形容词*][*例句*],

  [喜欢、讨厌], [#aruby("好き")、#aruby("嫌い")], [],
  [方便、不便], [#aruby("便利")、#aruby("不便")], [],
  [放心、担心、不安], [#aruby("安心")、#aruby("心配")、#aruby("不安")], [],
  [形容风景], [#aruby("賑やか")（热闹的）、\ #aruby("静か")、#aruby("有名")、#aruby("綺麗")], [],
)

其他形容词

#table(
  columns: (1fr,) * 5,
  align: horizon + center,
  [#aruby("元気") 健康的], [#aruby("簡単") 简单的], [#aruby("親切") 亲切的], [#aruby("暇") 空闲的], [],
)

=== 词语后缀

默认作为后缀与名词相连构成额外含义的名词

#table(
  columns: (0.5fr, 0.8fr, 0.8fr, 2pt, 0.5fr, 0.8fr, 0.8fr),
  align: horizon + center,
  table.header()[*词语*][*含义*][*示例*][][*词语*][*含义*][*示例*],
  [（汉字词）], [构成名词，与中文有相同含义], table.cell(colspan: 5)[#aruby("人", i: 2)（#aruby("日本")#aruby("人", i: 2)）、#aruby("家")（#aruby("専門")#aruby("家")）、#aruby("学")（#aruby("科")#aruby("学")）、#aruby("後", i:2)（#aruby("放課")#aruby("後", i:2)）、#aruby("手")（#aruby("選")#aruby("手")）、#aruby("口")（#aruby("入", i:1)り#aruby("口")）、#aruby("心")（#aruby("決")#aruby("心")）、#aruby("力")（#aruby("電")#aruby("力")）、#aruby("会", i:1)（#aruby("勉強")#aruby("会", i:1)）、#aruby("部")（#lruby("文学")#aruby("部")）], 
  [#aruby("中", i:2)], [与时间地点相连，表示整个#sym.dots], [#aruby("一")#aruby("日")#aruby("中", i:2)], [], [#aruby("中", i:1)], [与し动词相连，表示正在做#sym.dots], [#aruby("勉強")#aruby("中", i:1)], 
  [#aruby("過ぎ")], [超过某个时间或做某事过头了], [#aruby("食べ")#aruby("過ぎ")\ #aruby("一")#aruby("時")#aruby("過ぎ")], [], [#aruby("的")], [构成 な 形容词，表示像#sym.dots 的，#sym.dots 上的，关于#sym.dots 的], [#aruby("家庭")#aruby("的")（家庭般的）#aruby("現実")#aruby("的")（实际上的）], 
  [#aruby("方")], [接动词词根，表示某事的方法], [#aruby("使")い#aruby("方")\ （使用方法）], [], [#aruby("先")], [接动词词根，代指动作的对象], [#aruby("届け")#aruby("先")（收件人）], 
  [#aruby("屋")], [从事特定买卖的店或人], [#aruby("殺")し#aruby("屋")（杀手）], [], [#aruby("用")], [表示用于特定人或事的事物], [#aruby("子供")#aruby("屋")],
  [やすい], [作为形容词，容易做到某事的], [#aruby("分か")りやすい（容易理解的）], [], [にくい], [作为形容词，难以做到某事的], [#aruby("分か")りにくい（难以理解的）], 
  [出す], [#sym.dots 出来 / 开始 #sym.dots], [探し出す（找出）\ 歩き出す（开始走起来）]

)

=== 量词

#table(
  columns: (auto, 0.8fr, 1fr, auto, 0.8fr, 1fr),
  align: horizon + center,
  table.header()[*词语*][*含义*][*示例*][*词语*][*含义*][*示例*],
  [本], [], [], [], [], [],
)

=== 副词

表示数量多少

// #table(
//   columns: (auto, 0.8fr, 1fr, 2pt, auto, 0.8fr, 1fr),
//   align: horizon + center,
//   table.header()[*词语*][*含义*][*示例*][][*词语*][*含义*][*示例*],
//   [#aruby("少し")], [], [], [], [#aruby("沢山")], [], [],
// )
// 
#table(
  columns: (1fr,) * 5,
  align: center + horizon,
  [少], [一点点、稍微], [若干], [多], [大量],
  [少し], [ちょっと], [いくらか], [多く], [沢山]
)

表示程度多少

#table(
  columns: (1fr,) * 6,
  align: center + horizon,
  table.cell(colspan: 2)[非常], table.cell(colspan: 2)[一点儿], [不太], [完全不],
  [大変], [とても], [少し], [ちょっと], [余り #sym.dots ない], [#aruby("全然")#sym.dots ない]
)

表示时间频率

#table(
  columns: (1fr,) * 4 + (1.5fr,) * 2,
  align: center + horizon,
  [总是], [经常], [有时], [偶尔], [几乎不], [从不], 
  [いつも], [よく], [#aruby("時々")], [#aruby("偶に")], [ほとんど #sym.dots ない], [#aruby("全然")#sym.dots ない]
)

附加含义

#table(
  columns: (auto, 0.4fr, 1fr),
  align: horizon + center,
  [まだまだ], [仍然], [まだまだ勉強する必要がある（仍然需要多学习）],
  [まだ], [还], [まだ はっきりと 覚えている（还清楚地记得）],
  [また], [再次], [また会いましょう（下次再见面吧）],
  [もし], [如果（不构成条件句）], [もし雨が降ったら#sym.dots（如果下雨了，#sym.dots）], 
  [だって], [即使（でも 的口语）], [一年生にだって読めるよ（即使是一年级小学生也能读）],
  [もちろん], [当然], [もちろん行きます（我当然会去）],
  [やはり], [果然], [彼は やはり 遅刻しました（他果然迟到了）],
  [すぐ], [马上], [すぐ行きます（马上过去）],
  [もう], [已经，即将], [彼は もう 帰りました（他已经回去了）],
  [ただ], [只是], [ただ一人で来る（只有一个人来）], 
  [きっと], [必定], [明日は 雨がきっと降ります（明天一定会下雨）],
)

=== 连词

#table(
  columns: (auto, 0.5fr, 1fr, 2pt, auto, 0.5fr, 1fr),
  align: horizon + center,
  table.header()[*词语*][*含义*][*示例*][][*词语*][*含义*][*示例*],
  [しかし], [然而], [], [], [そして], [于是], [],
  [それから], [还有], [], [], [], [], [],
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

