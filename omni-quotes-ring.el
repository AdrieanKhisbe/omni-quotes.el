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
(defvar omni-quotes-current-set nil
  "Quote Sets Storing the Different quotes.")

(defvar omni-quotes-sets (ht)
  "Hashtable of the quote sets.")

(defvar omni-quotes-sets-ring (make-ring 42)
  "Ring of the used quote sets.")

(defvar omni-quotes-sets-ring-pointer 0
  "Pointer on the `omni-quote-sets-ring'")

(defun omni-quotes-set-populate (quote-list name)
  "Populate `omni-quotes-current-set' with a quote set made out of
the provided QUOTE-LIST and NAME."
  (let ((quote-set (omni-quote-set-maker quote-list name)))
    ;; §todo: protect from nil
    (ht-set! omni-quotes-sets name quote-set)
    (ring-insert omni-quotes-sets-ring quote-set)
    (setq omni-quotes-current-set quote-set)))

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

(defun omni-quotes-shuffle-set (quote-set)
  "Reshuffle given QUOTE-SET."
  (let* ((new-list (omni-quote--shuffle-list (ht-get quote-set 'list)))
         (new-ring (make-ring (length new-list))))
    (-each new-list (lambda (quote) (ring-insert new-ring quote)))
    (ht-set! quote-set 'ring new-ring)))

(defun omni-quotes-shuffle-current-set ()
  "Reshuffle current `omni-quotes-current-set'"
  (interactive)
  (omni-quotes-shuffle-set omni-quotes-current-set))

(defun omni-quotes-next-set ()
  "Shift the `omni-quotes-current-set' forward."
  (interactive) ; §todo: universal arg.
  (let ((new-pointer (1+ omni-quotes-sets-ring-pointer)))
    (setq omni-quotes-sets-ring-pointer new-pointer
          omni-quotes-current-set (ring-ref omni-quotes-sets-ring new-pointer))))

(defun omni-quotes-prev-set ()
  "Shift the `omni-quotes-current-set' backward."
  (interactive)
  (let ((new-pointer (1- omni-quotes-sets-ring-pointer)))
    (setq omni-quotes-sets-ring-pointer new-pointer
          omni-quotes-current-set (ring-ref omni-quotes-sets-ring new-pointer))))

(provide 'omni-quotes-ring)
;;; omni-quotes-ring.el ends here
