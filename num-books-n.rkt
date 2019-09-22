#lang racket

(require 2htdp/batch-io)

(define filename "num-books-n.css")

(define file-intro "/** 
 *    No parameter n to access for dynamic calculation,
 *    so macro eval'd to create pre-populated template
 *    for each possible size div containing n books:
 *
 *    (+ 30.8 (* 29 n)) 
**/\n\n")

(define (css-beg-stmt num)
  (string-append ".num-books-" (number->string num) " {\n"))

(define (height-val num)
  (number->string (+ 30.8 (* 29 num))))

(define (height-calc-str num)
  (string-append "\theight: " (height-val num) "px;\n"))

(define (z-index-str num)
  (string-append "\tz-index: " (number->string num) ";\n"))


(define (gen-css-prop num)
  (let ((beg-str (css-beg-stmt num))
        (height-str (height-calc-str num))
        (end-str "}\n\n"))
    (string-append beg-str height-str end-str)))

(define (add-file-content num)
  (cond [(= num 1) (gen-css-prop num)]
        [else (string-append (gen-css-prop num)
                             (add-file-content (- num 1)))]))

(define (gen-file-content intro num)
  (string-append intro (add-file-content num)))

(write-file filename (gen-file-content file-intro 40))

;; .num-books-40 -> 1190.8px
;; .num-books-39 -> 1161.8px
