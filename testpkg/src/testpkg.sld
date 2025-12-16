(define-library testpkg
  (export add1)
  (import (scheme base))

  (begin
    (define (add1 x)
      (+ x 1))
  ))
