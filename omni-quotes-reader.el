;;; omni-quotes-reader.el --- Utilities to read "quotes" files
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

;; This file is used to read quotes from differents kind of files formats
;; some custom and some not.

;;; Code:

;; §later: see existing format.
;; §todo: use F
;; §todo: build tests!!!!

;;; ¤> Entry points.
(defun omni-quotes-load-simple-quote-file (file-name)
  ;; ¤doc!
  (interactive "f")
  (omni-quotes-process-quote-file file-name 'omni-quotes-parser-a-quote-aline))

;;; ¤> processing function

;; ¤parser function should send back
(defun omni-quotes-process-quote-file (file parser)
  ;; ¤doc!
  ;; §todo: type checking
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (funcall parser))

  ;; §see: what do send back: result. or stored already?
  ;; §post processing. see what to do with this. create a specific ring, by example.

;; §todo: see where should store this. what data structure? ¤HERE!!
  )


;;; ¤> parsers

;;; ¤>> simple file reader:
;; format is a line a quote.
;; ignore file w


(defun omni-quotes-parser-a-quote-aline ()
  ;; see comment traiter ligne par ligne?
  ;; ou tuiliser regexp
  (let ((quotes '()) )
    (while (not (eobp))
      ;; (buffer-substring)
      (push (thing-at-point 'line) quotes)
      (forward-line))
      ;; §later: filter lines: trims and so on. (use dash+s lib?)
    quotes))


;; ¤>> other

(provide 'omni-quotes-reader)
;;; omni-quotes-reader.el ends here
