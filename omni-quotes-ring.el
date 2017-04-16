;;; omni-quotes-ring.el --- Datastructure to old [Omni] Quotes
;;
;; Copyright (C) 2014-2017 Adrien Becchis
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

;;; Code:

(require 'dash)
(require 'ht)

;;; ¤>vars
(defvar omni-quotes-set-current-quotes nil
  "Quote Sets Storing the Different quotes.")

(defvar omni-quotes-sets (ht))

(defun omni-quotes-set-populate (quote-list name)
  "Populate `omni-quotes-set-current-quoteslist' with QUOTE-LIST."
  (let ((quote-ring (omni-quote-set-maker quote-list name)))
    ;; §todo: protect from nil
    (ht-set! omni-quotes-sets name quote-ring)
    (setq omni-quotes-set-current-quotes quote-ring)))

(defun omni-quote-set-maker (list name)
  "Make a Quote-Set out of the provided LIST."
  (let ((ring (ht ('list list)
                  ('name name)
                  ('pointer 0)
                  ('ring (make-ring (length list))))))
    (-each (omni-quote--shuffle-list list)
      (lambda(quote)(ring-insert (ht-get ring 'ring) quote)))
    ring))

(defun omni-quote--shuffle-list (list)
  "Returns a shuffled version of the LIST."
  (let ((next-insert 0)
        (shuffled-list nil))
    (-each list
      (lambda (el)
        (progn (setq shuffled-list (-insert-at next-insert el shuffled-list)
                     next-insert (random (length shuffled-list))))))
    shuffled-list))

(defun omni-quotes-set-next (quote-set)
  "Send next quote of the QUOTE-SET and move pointer."
  (let* ((ring (ht-get quote-set 'ring))
         (pointer (ht-get quote-set 'pointer))
         (quote (ring-ref ring pointer)))
    (ht-set! quote-set 'pointer (1+ pointer))
    quote))

;; §later: prev

(defun omni-quotes-set-random (quote-set)
  "Give a random quote from the QUOTE-SET."
  (let ((ring (ht-get quote-set 'ring)))
    (ring-ref ring (random (ring-size ring)))))

(defun omni-quotes-set-get (quote-set)
  "Get a quote from the given QUOTE-SET."
  ;; §maybe: different accès method. Get method dispatch
  (omni-quotes-set-next quote-set)

  ;; §later: var saying method that should be call
  )
;; ¤see: berkeley: utilities.lisp!!!

(provide 'omni-quotes-ring)
;;; omni-quotes-ring.el ends here
