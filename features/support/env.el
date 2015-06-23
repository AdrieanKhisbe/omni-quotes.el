(require 'f)

(defvar omni-quotes-support-path
  (f-dirname load-file-name))

(defvar omni-quotes-features-path
  (f-parent omni-quotes-support-path))

(defvar omni-quotes-root-path
  (f-parent omni-quotes-features-path))

(add-to-list 'load-path omni-quotes-root-path)

(require 'undercover)
(undercover "*.el" "omni-quotes/*.el"
            (:exclude "*-test.el")
            (:report-file "/tmp/undercover-report.json"))
(require 'omni-quotes)
(require 'espuds)
(require 'ert)

(Setup
 ;; Before anything has run
 )

(Before
 ;; Before each scenario is run
 )

(After
 ;; After each scenario is run
 )

(Teardown
 ;; After when everything has been run
 )
