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
(defvar omni-quotes-ring-current-quotes nil
  "Quote Ring Storing the Different quotes.")


(defun omni-quotes-ring-populate (quote-list)
  "Populate `omni-quotes-ring-current-quoteslist' with QUOTE-LIST."
  (let ((quote-ring (omni-quote-ring-maker quote-list)))
    ;; §todo: protect from nil
    (setq omni-quotes-ring-current-quotes quote-ring)))

(defun omni-quote-ring-maker (list)
  "Make a Quote-ring out of the provided list"
  (let ((ring (ht ('list list)
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

(defun omni-quotes-ring-next (quote-ring)
  "Send next quote of the QUOTE-RING and move pointer."
  (let* ((ring (ht-get quote-ring 'ring))
         (pointer (ht-get quote-ring 'pointer))
         (quote (ring-ref ring pointer)))
    (ht-set! quote-ring 'pointer (1+ pointer))
    quote))

;; §later: prev

(defun omni-quotes-ring-random (quote-ring)
  "Give a random quote from the QUOTE-RING."
  (let ((ring (ht-get quote-ring 'ring)))
    (ring-ref ring (random (ring-size ring)))))

(defun omni-quotes-ring-get (quote-ring)
  ;; §maybe: different accès method. Get method dispatch
  (omni-quotes-ring-next quote-ring)

  ;; §later: var saying method that should be call
  )
;; ¤see: berkeley: utilities.lisp!!!

(provide 'omni-quotes-ring)
;;; omni-quotes-ring.el ends here
