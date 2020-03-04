;;; omni-quotes-reader.el --- Utilities to read "quotes" files
;;
;; Copyright (C) 2014-2020 Adrien Becchis
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

(require 'f)
(require 'dash)

;; §later: see existing format of quotes

;;; ¤> Entry points.
(defun omni-quotes-load-simple-quote-file (file-name name)
  "Loads quotes from given FILE-NAME as current quote-ring"
  (interactive "fQuote File: \nsQuoteSet name: ")
  (let ((quotes-list (omni-quotes-simple-parser file-name)))
    (omni-quotes-set-populate quotes-list name)))

(defun omni-quotes-load-defaults ()
  "Loads the defaults quote as current quote-set."
  (interactive)
  (omni-quotes-set-populate omni-quotes-default-quotes "default"))

;;; ¤> parsers
(defun omni-quotes-simple-parser (file-name)
  "Returns a list of quote from a simple FILE-NAME."
  (if (f-exists? file-name)
      (let ((text (f-read-text file-name)))
        (s-lines (s-trim text)))
    ;; §todo: filter pattern
    (progn
      (message "Filename does not exists %s" file-name)
      nil)))

(provide 'omni-quotes-reader)
;;; omni-quotes-reader.el ends here
