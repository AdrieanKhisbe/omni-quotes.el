;; test-helper - for omni-quotes

;;; Code:

(require 'f)

(defvar omni-quotes-path
  (f-parent (f-this-file)))

(defvar omni-quotes-test-path
  (f-dirname (f-this-file)))

(defvar omni-quotes-root-path
  (f-parent omni-quotes-test-path))

(require 'undercover)
(undercover "*.el" "omni-quotes/*.el"
            (:exclude "*-test.el")
            (:send-report nil)
            (:report-file "/tmp/undercover-report.json"))
(undercover "*.el" "omni-quotes/*.el"
            (:exclude "*-test.el")
            (:send-report nil)
            (:report-file "/tmp/undercover-report.json"))
(require 'ert)
(require 's)
(require 'dash)
(require 'omni-log)
(require 'omni-quotes-ring (f-expand "omni-quotes-ring" omni-quotes-root-path))
(require 'omni-quotes-timer (f-expand "omni-quotes-timer" omni-quotes-root-path))
(require 'omni-quotes-reader (f-expand "omni-quotes-reader" omni-quotes-root-path))
(require 'omni-quotes (f-expand "omni-quotes" omni-quotes-root-path))

(provide 'test-helper)
;;; test-helper.el ends here
