
#import "@preview/shiroa:0.2.3": *

#show: book

#book-meta(
  title: "shiroa",
  summary: [
    #prefix-chapter("index.typ")[Melonade]

    - #chapter("./jap/index.typ")[日语笔记]
      - #chapter("./jap/verb.typ")[动词变形]
  ]
)



// re-export page template
#import "/templates/page.typ": project
#let book-page = project
