;;; omni-quotes-timer.el --- Timer functions for OmniQuotes
;;
;; Copyright (C) 2014-2015 Adrien Becchis
;;
;; Author: Adrien Becchis <adriean.khisbe@live.fr>
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:


(defvar oq:idle-timer nil "OmniQuote timer.")

(defun oq:idle-display-start (&optional no-repeat)
  "Add OmniQuote idle timer with repeat (by default).

With NO-REPEAT idle display will happen once."
  (interactive)
  (oq:cancel-and-set-new-timer (run-with-timer oq:idle-interval
                                               (if no-repeat nil oq:repeat-interval)
                                               #'oq:idle-display-callback)))

(defun oq:idle-display-stop ()
  "Stop OmniQuote Idle timer."
  (interactive)
  (oq:cancel-and-set-new-timer nil))


;; Helper Methods: [§maybe kill?]
(defun oq:cancel-if-timer ()
  ;; ¤note: no need to inline them with `defsubst'
  "Cancel OmniQuote timer (`oq:idle-timer') if set."
  (when (timerp oq:idle-timer)
    (cancel-timer oq:idle-timer)))

(defun oq:cancel-and-set-new-timer (new-timer)
  "Cancel timer (`oq:idle-timer') and set it to new value.
Argument NEW-TIMER is the new timer to set (nil to disable)."
  (oq:cancel-if-timer)
  (setq oq:idle-timer new-timer))

(provide 'omni-quotes-timer)
;;; omni-quotes-timer.el ends here
