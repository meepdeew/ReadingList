#lang racket

(require 2htdp/batch-io)

(define filename "book-n.css")

(define file-intro "/** 
 *    No parameter n to access for dynamic calculation,
 *    so macro eval'd to create pre-populated template
 *    for each individual book's relative offset and z-index:
 *    
 *    height - multiSpineOffset - singleBookFullHeight,
 *    where multiSpineOffset is equal to (* 29 (- n 1)) for the nth book.
**/\n\n")

(define (css-beg-stmt num)
  (string-append ".book-" (number->string num) " {\n"))

(define (spine-offset num)
  (number->string (* 29 (- num 1))))

(define (top-calc-str num)
  (string-append "\ttop: calc(100% - " (spine-offset num) "px - 59.8px);\n"))

(define (z-index-str num)
  (string-append "\tz-index: " (number->string num) ";\n"))

(define (gen-css-prop num)
  (let ((beg-str (css-beg-stmt num))
        (top-str (top-calc-str num))
        (idx-str (z-index-str num))
        (end-str "}\n\n"))
    (string-append beg-str top-str idx-str end-str)))

(define (add-file-content num)
  (cond [(= num 1) (gen-css-prop num)]
        [else (string-append (gen-css-prop num)
                             (add-file-content (- num 1)))]))

(define (gen-file-content intro num)
  (string-append intro (add-file-content num)))

(write-file filename (gen-file-content file-intro 40))
