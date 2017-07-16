# Carouselm
Pages' simple carousel based on `iframes` and written in the [Elm](http://elm-lang.org/) language.


----
## Goal & design

Prepare small application, which could presents a carousel (like a: [Bootstrap Carousel](https://www.w3schools.com/bootstrap/bootstrap_carousel.asp)) of few pages loaded in to `iframes`.
Show should be done in given order with a few seconds of display.
Users can prepare those carousels of pages and share with others.

"Kanban" board at: [Carouselm@Trello](https://trello.com/b/w6EtWSC6/carouselm).

**Requirements**:
  1. Should be _stateless_.
       * All information should be stored in the `URL`, so "show" could be shared by users.
       * There is no requirement for any back-end, just the web server which serves static `HTML`, `JS` or `CSS` for this application.
  1. Should have _two_ sides: **edit** and **show**.
       * **edit** - Allows to edit list of pages or time interval. Also enables way to copy _show_'s `URL` and just go to **show** page.
       * **show** - Just displays _Carousel of pages_ based on data from `URL`. Also enables way to just go to **edit** page.
  1. Initial page should move to the empty **edit**.
       * Also on both sides (**edit**, **show**) should be available button to create _new_ show.
  1. State should be stored in the `URL`.
       * Data will be compressed and represent as _Base64_.
  1. Mostly written in the Elm.
       * Elm is Haskell for web - could I say that?
       * Because this is a Elm's experiment.
       * I would like to try Elm language.
