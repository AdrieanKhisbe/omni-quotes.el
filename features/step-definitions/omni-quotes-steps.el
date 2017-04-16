;; This file contains your project specific step definitions. All
;; files in this directory whose names end with "-steps.el" will be
;; loaded automatically by Ecukes.


(Then "^I should see a quote"
      (lambda ()
        (switch-to-buffer "*omni-quotes*")
        (s-contains? (buffer-string)  " » ")
        (switch-to-buffer (last-buffer))))
