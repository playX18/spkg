(import (srfi 64)
        (spkg core manager))

(test-begin "manager")

(test-assert "system-has-library: should find scheme/base"
             (system-has-library? '(scheme base)))
(test-assert "system-has-library: should not find non-existent lib"
             (not (system-has-library? '(spkg non existent lib))))
(test-end "manager")
