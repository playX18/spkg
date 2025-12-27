(define-library (spkg core manager)
  (import 
    (spkg core manifest)
    (spkg core dependency)
    (spkg core log)
    (spkg core lockfile)
    (spkg core errors)
    (spkg core util)
    (spkg core compat)
    (scheme base)
    (scheme file)
    (srfi 1)
    (scheme char)
    (srfi 130)
    (scheme write)
    (scheme process-context))
  (export 
    manifest-install-dependencies
    manifest-needs-recompile?
    manifest-update-dependencies
    run-root-build-script-if-needed!
    run-dependency-build-script-if-needed!
    ensure-locked!
    implementation->binary-name
    current-implementation
    ops->runargs
    path->scriptarg
    system-has-library?)
  (include "manager.scm"))
