#import "/book.typ": book-page, cross-link
#show: book-page.with(title: "日语笔记")

///////////

#import "@preview/rubby:0.10.2": get-ruby
#let ruby = get-ruby(
  size: 0.5em,         // Ruby font size
  dy: 0pt,             // Vertical offset of the ruby
  pos: top,            // Ruby position (top or bottom)
  alignment: "center", // Ruby alignment ("center", "start", "between", "around")
  delimiter: "|",      // The delimiter between words
  auto-spacing: true,  // Automatically add necessary space around words
)

#let p-index = "/jap/index.typ"
#let p-verb = "/jap/verb.typ"

///////////

= 日语笔记

== 参考文章与工具

- 实用参考文章
  - 发音教程 #link("https://www.bilibili.com/video/BV1T2kuYQEx4")
  - 基础语法 #link("https://res.wokanxing.info/jpgramma/")
  - 实用解读 #link("https://www.sigure.tw/")
- 实用工具
  - 分词翻译 #link("https://www.edrdg.org/cgi-bin/wwwjdic/wwwjdic?9T")
  - 日语词典 #link("https://jisho.org/")
  - 动词变形 #link("http://www.japaneseverbconjugator.com/")
  - 词汇学习 #link("https://www.youtube.com/watch?v=_MWtbI4IwfU")

== 笔记主要内容

- #cross-link(p-verb)[动词变形]
