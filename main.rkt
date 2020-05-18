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
     "    <link rel='stylesheet' href='./styles.css' type='text/css'>\n"
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

(define (fmt-bg-and-width background width)
  (let ([how-long (number->string width)])
    (string-append "style='"
                   "background: " background "; "
                   "width: " how-long ";'")))

(define (fmt-top-and-z-index n)
  (let ([multiSpineOffset (number->string (* 29 (- n 1)))])
    (string-append "style='"
                   "top: calc(100% - " multiSpineOffset "px - 59.8px); "
                   "z-index: " (number->string n)  ";'")))

(define (fmt-prop prop-name prop-value)
  (if (not (string=? prop-value ""))
      (string-append " " prop-name "='" prop-value "'")
      ""))

(define (fmt-class classes)
  (fmt-prop "class" classes))

(define (fmt-style styles)
  (fmt-prop "style" styles))

(define (html-element type content classes styles)
  (string-append
   "<" type (fmt-class classes) (fmt-style styles) ">"
   (if (string=? type "div") "\n" "")
   content
   "</" type ">"
   "\n"))

(define (comment message)
  (string-append "<!-- " message " -->\n"))

(define (h1 [content ""] [classes ""] [styles ""])
  (html-element "h1" content classes styles))

(define (div [content ""] [classes ""] [styles ""])
  (html-element "div" content classes styles))

;;;(div big-content "books" (string-append ))

(define (book->html book-number title author background title-color author-color width)
  (let* ([top-z-index-styling (fmt-top-and-z-index book-number)]
         [bg-width-styling (fmt-bg-and-width background width)]
         [margin (number->string (+ 2 width))])
    (string-append
     "        <div class='books' " top-z-index-styling ">\n"
     "          <div class='level-row-perspective'>\n"
     "            <div class='above' " bg-width-styling " ></div>\n"
     "            <div class='spine' " bg-width-styling ">\n"
     "              <a style='color:" title-color ";' href='#'>" title "</a>\n"
     "              <span style='color:" author-color ";'>" author "</span>\n"
     "            </div>\n"
     "            <div class='pages' style='margin-left:" margin "px;'>\n"
     "              <div class='inner-pages'></div>\n"
     "            </div>\n"
     "          </div>\n"
     "        </div>\n\n")))



(define (apply-book->html book)
  (apply book->html book))

(define (num-books-calc n)
  (+ 30.8 (* 29 n)))

(define (year->html annual-list)
  (let* ([year (number->string (car annual-list))]
         [books (cdr annual-list)]
         [quantity (number->string (length books))]
         [h1-content (string-append year " (" quantity ")")]
         [height (number->string (num-books-calc (length books)))]
         [div-styles (string-append "height: " height "px;")]
         [list-of-content (map apply-book->html books)]
         [start-comment (string-append "start " year)]
         [end-comment (string-append "end " year)]
         [content (apply string-append list-of-content)])
    (string-append
     "      " (comment start-comment)
     "      " (h1 h1-content) "\n"
     "      " (div content "stack-of-books" div-styles) "\n"
     "      " (comment end-comment))))

(define (apply-year->html annual-list)
  (year->html annual-list))

(define (main reading-list [output-file "index.html"] [delete-existing-p #true])
  (when (and delete-existing-p (file-exists? output-file))
      (delete-file output-file))
  (let* ([out (open-output-file output-file)]
         [static-page (generate-html reading-list)])
    ;; html formatter?
    (display static-page out)))

;; evaluate buffer from here rather than eshell

(let ([reading-list (file->list "./data-input.rkt")])
  (main reading-list))








