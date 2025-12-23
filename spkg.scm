(package 
  (name (spkg))
  (rnrs r7rs)
  (version "0.1.0")
  (libraries
    (spkg)))

(dependencies
  (system 
    (scheme base)
    (scheme write)
    (scheme file)
    (scheme read)
    (scheme process-context))

  (git
    (name (args))
    (url "https://github.com/playx18/scm-args")))
