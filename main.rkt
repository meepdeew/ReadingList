#!/usr/bin/racket
#lang racket

(define (generate-html reading-list)
  (let* ([yearly-strings (map apply-year->html reading-list)]
         [content (apply string-append yearly-strings)])
    (string-append
     "<html>\n"
     "  <head>\n"
     "    <title>loosetypes</title>\n"
     "    <link rel=\"shortcut icon\" href='./res/favicon.ico' type='image/png'>\n"
     "    <link rel='stylesheet' href='./styles/styles.css' type='text/css'>\n"
     "    <link rel='stylesheet' href='./styles/book-n.css' type='text/css'>\n"
     "    <link rel='stylesheet' href='./styles/num-books-n.css' type='text/css'>\n"
     "    <link rel='stylesheet' href='./styles/offset-left-n.css' type='text/css'>\n"
     "    <link rel='stylesheet' href='./styles/color-schemes.css' type='text/css'>\n"
     "    <meta charset='utf-8'>\n"
     "  </head>\n"
     "  <body>\n\n"
     "    <div class='banner'>\n"
     "      <div class='banner-top-space'>&nbsp;</div>\n"
     "      <hr class='hr-solid' />\n"
     "      <hr class='hr-dashed' />\n"
     "      <hr class='hr-solid' />\n"
     "    </div>\n\n"
     "    <div class='site'>\n\n"
     "      <div class='vr'>&nbsp;</div>\n\n"
     "      <img class='banner-img'\n"
     "           style='height: 125px;'\n"
     "           src='./res/loose_types_logo.png' alt='Loose Types'></img>\n\n"
     "      <h1 class='title'>What I've Been Reading</h1>\n\n"
     content
     "      <!-- footer -->\n"
     "      <br/>\n"
     "      <div class='footer'>\n"
     "        <div class='contact'>\n\n"
     "          <h2 class='footer-h2'>Made by </h2>\n"
     "          <img class='icon' src='./res/hand_icon.png' alt='hands'></img>\n"
     "          <h2 class='footer-h2'> on a </h2>\n"
     "          <img class='icon' src='./res/computer_icon.png' alt='computer'></img>\n"
     "          <h2 class='footer-h2'>.</h2>\n\n"
     "        </div>\n"
     "      </div>\n"
     "      <!-- end .footer -->\n\n"
     "    </div>\n"
     "    <!-- end .site -->\n\n"
     "  </body>\n"
     "</html>\n"
     )))


;; could do inline styling instead of classnames.
;; title,author,cover- all map 1:1 to a css property.
(define (book->html book-number title author abrev width)
  (let* ([position (number->string book-number)]
         [how-long (number->string width)])
    (string-append
     "        <div class='books book-" position "'>\n"
     "          <div class='level-row-perspective'>\n"
     "            <div class='above length-left-" how-long " cover-" abrev "'></div>\n"
     "            <div class='spine length-left-" how-long " cover-" abrev "'>\n"
     "              <a class='title-" abrev "' href='#'>" title "</a>\n"
     "              <span class='author-" abrev "'>" author "</span>\n"
     "            </div>\n"
     "            <div class='pages margin-left-" how-long "'>\n"
     "              <div class='inner-pages'></div>\n"
     "            </div>\n"
     "          </div>\n"
     "        </div>\n\n")))

(define (apply-book->html book)
  (apply book->html book))

(define (year->html annual-list)
  (let* ([year (number->string (car annual-list))]
         [books (cdr annual-list)]
         [quantity (number->string (length books))]
         [list-of-content (map apply-book->html books)]
         [content (apply string-append list-of-content)])
    (string-append
     "      <!-- start " year " -->\n\n"
     "      <h1>" year " (" quantity ")</h1>\n"
     "      <div class='stack-of-books num-books-" quantity "'>\n\n"
     content
     "      </div>\n"
     "      <!-- end " year " -->\n")))

(define (apply-year->html annual-list)
  (year->html annual-list))

(define (main input-file output-file [delete-existing-p #false])
  (when delete-existing-p
      (delete-file output-file))
  (let* ([out (open-output-file output-file)]
         [reading-list (file->list input-file)]
         [static-page (generate-html reading-list)])
    ;; html formatter?
    (display static-page out)))

;; evaluate buffer from here rather than eshell
(main "./data-input-short.rkt" "index.html" true)










