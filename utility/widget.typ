#let color_arr_dark = (
  rgb("#666666"),
  rgb("#718ec1"),
  rgb("#d29a00"),
  rgb("#9473a7"),
  rgb("#d3b54e"),
  rgb("#b2534e"),
  rgb("#87b362"),
)

#let color_arr_light = (
  rgb("#f5f5f5"),
  rgb("#dce8fd"),
  rgb("#fde6cb"),
  rgb("#e0d5e8"),
  rgb("#fdf2ca"),
  rgb("#f4cecc"),
  rgb("#d7e8d3"),
)


#let hl(idx, content) = {
  set text(fill: color_arr_dark.at(idx))
  
  content
}

#let bl(idx, fh: none, content) = {

  if fh != none {
    box(
    [#box(height: 1em + fh)[]#content],
    fill: color_arr_light.at(idx),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
    )
  } else {
    box(
    content,
    fill: color_arr_light.at(idx),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
    )
  }

}

#import "@preview/showybox:2.0.4": showybox
#let problem_box(
  body, 
  problem: [],
  title: [], 
  width: 95%,
  theme_dark : rgb("#23373b"), 
  theme_light: rgb("#fafafa"),
) = (
  figure(
    showybox(
        frame: (
            title-color: theme_dark, 
            body-color: theme_light, 
            border-color: theme_dark,
            thickness: 2pt,
            radius: 10pt
        ),
        title-style: (
            weight: "bold"
        ),
        title: title,
        width: width,
    )[#problem][#body]
  )
)
