(import (scheme base)
        (scheme file)
        (scheme write)
        (srfi 1)
        (srfi 64)
        (spkg core compat)
        (spkg core dependency)
        (spkg core manifest)
        (spkg core manager))

(define (write-temp path content)
  (call-with-output-file path
    (lambda (out)
      (display content out))))

(define (mkdir-p path)
  (system (string-append "mkdir -p " path)))

(define (rm-rf path)
  (when (file-exists? path)
    (system (string-append "rm -rf " path))))

(test-begin "build_devdeps")

;; Dev-dependencies should be available to build.scm only, not leaked into
;; runtime runops returned from manifest-install-dependencies.
(let* ((root "./tmp/.tmp-root-builddev")
       (dev "./tmp/.tmp-devlib")
       (dev-src (string-append dev "/src"))
       (root-src (string-append root "/src"))
       (root-manifest (string-append root "/spkg.scm"))
       (dev-manifest (string-append dev "/spkg.scm"))
       (out-file (string-append root "/build.out")))

  (rm-rf root)
  (rm-rf dev)

  ;; devlib package (path dependency)
  (mkdir-p dev-src)
  (write-temp (string-append dev-src "/devlib.sld")
              "(define-library (devlib)\n  (export devlib-hello)\n  (import (scheme base))\n  (begin (define (devlib-hello) \"ok\")))\n")
  (write-temp dev-manifest
              (string-append
                "(package\n"
                "  (name (devlib))\n"
                "  (rnrs r7rs))\n\n"
                "(dependencies)\n"
                "(dev-dependencies)\n"))

  ;; root package with build.scm that imports devlib
  (mkdir-p root-src)
  (write-temp (string-append root-src "/rootpkg.sld")
              "(define-library (rootpkg) (export) (import (scheme base)) (begin))\n")
  (write-temp (string-append root "/build.scm")
              (string-append
                "(import (scheme base) (scheme write) (devlib))\n"
                "(call-with-output-file \"build.out\"\n"
                "  (lambda (out)\n"
                "    (display (devlib-hello) out)))\n"))
  (write-temp root-manifest
              (string-append
                "(package\n"
                "  (name (rootpkg))\n"
                "  (rnrs r7rs))\n\n"
                "(dependencies)\n"
                "(dev-dependencies\n"
                "  (path (name (devlib)) (path \"" (canonicalize-path-string dev) "\")))\n"))

  (let* ((m (read-manifest root-manifest))
         (ops (manifest-install-dependencies m #f))
         (dev-src* (canonicalize-path-string dev-src))
         (append* (map canonicalize-path-string (runops-append-path ops)))
         (prepend* (map canonicalize-path-string (runops-prepend-path ops))))

    (test-assert "build.scm ran (created build.out)" (file-exists? out-file))

    ;; Runtime ops should not contain devlib src path.
    (test-assert "dev dependency not in runtime append-path"
                 (not (member dev-src* append*)))
    (test-assert "dev dependency not in runtime prepend-path"
                 (not (member dev-src* prepend*))))

  (rm-rf root)
  (rm-rf dev))

(test-end "build_devdeps")
