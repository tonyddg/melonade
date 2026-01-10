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
#let fruby(head, bottom, size: 0.2em) = {
  box(height: 1em + size)
  ruby(head, bottom)
}

#let voc = yaml("/jap/vocabulary.yaml")
#let aruby(kanji, i: 0) = {
  let tup = voc.at(kanji).at(i)
  fruby(tup.at(0), tup.at(1))
}
#let lruby(kanjis, i: 0) = {
  let kanji_list = kanjis.split("|")
  let cnt = 0
  for k in kanji_list {
    if type(i) == array {
      aruby(k, i: i.at(cnt))
    } else {
      aruby(k, i: i)
    }
    cnt = cnt + 1
  }
}

#let p-index = "/jap/index.typ"
#let p-transform = "/jap/transform.typ"
#let p-partial = "/jap/partial.typ"
#let p-sentence = "/jap/sentence.typ"
#let p-word = "/jap/word.typ"
#let p-standard = "/jap/standard.typ"

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

- #cross-link(p-standard)[标准日本语笔记]
- #cross-link(p-transform)[动词变形]
- #cross-link(p-partial)[介词与连接词]
- #cross-link(p-sentence)[句型]
- #cross-link(p-word)[词语与词组]