;;; omni-quotes-reader.el --- Utilities to read "quotes" files
;;
;; Copyright (C) 2014 Adrien Becchis
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

;; This file is used to read quotes from differents kind of files formats
;; some custom and some not.

;;; Code:

;; §later: see existing format.


;; see how

;; ¤> simple file reader:
;; format is a line a quote.
;; ignore file w


;; ¤parser function should send back
(defun oq:process-quote-file (file parser)
  ;; ¤doc!
  ;; §todo: type checking
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (funcall parser))

  ;; §see: what do send back: result. or stored already?
  )

(defun oq:parser:a-quote-aline ()
  ;; see comment traiter ligne par ligne?
  ;; ou tuiliser regexp
  (let ((quotes '()) )
    (while (not (eobp))
      ;; (buffer-substring)
      (push (thing-at-point 'line) quotes)
      ;; §later: filter
      (forward-line))
    quotes))


(defun oq:test ()
  (oq:process-quote-file
   "~/AA"
   'oq:parser:a-quote-aline
   ))
;; §todo: create tests
;; §how?
(oq:test)
;; §pb: grab the end of line. should delete this.


(provide 'omni-quotes-reader)
;;; omni-quotes-reader.el ends here
