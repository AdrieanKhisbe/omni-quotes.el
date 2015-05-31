;;; omni-quotes-ring.el --- Datastructure to old [Omni] Quotes
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


(require 'dash)

;; §todo: (defvar current) -> structure stockant les sources courrant
;;; ¤>vars
(defvar omni-quotes-ring-current-quotes (make-ring 42) ;§see:size
  "Ring Storing the Different quotes.")

(defvar omni-quotes-ring-current-pointer 0
  "Pointer to the current element of the quote ring.")

(defun omni-quotes-ring-populate () ;§todo: make it call current population method
  "Populate `omni-quotes-ring-current-quoteslist' with `omni-quotes-default-quotes'."
  ;; ¤warn:doc-update-with-function
  ;; §note: random population method. (maybe to instract in shuffle) [and optimize...]
  ;; that send a new list

  ;; §maybe: empty ring?
  (let ((next-insert 0)
        (shuffled-list nil))
    ;; §todo: extract shuffle list
    (-each omni-quotes-default-quotes
      (lambda (quote)
        (progn (setq shuffled-list (-insert-at next-insert quote shuffled-list)
                      next-insert (random (length shuffled-list))))))
    (-each shuffled-list (lambda(quote)(ring-insert omni-quotes-ring-current-quotes quote)))))

;; ¤note:beware random 0 give all numbers!
;; (omni-quotes-message "Update list"))
;; §maybe:see cycle (send an infinte copy?)
;;§tmp; (omni-quotes-ring-populate)
;; (setq omni-quotes-ring-current-quoteslist nil)
;; §TODO: extract a real structure in specific file. (access and modifying api)

;; §draft: force population ;§todo: extract in omni-quotes-ring. or data structure whatever
;; §ring- random or rotating. use a pointer rather than stupidly rotate the list....

(defun omni-quotes-ring-next()
  "Send next quote of the ring and move pointer."
  (let ((quote (ring-ref omni-quotes-ring-current-quotes omni-quotes-ring-current-pointer))) ;§here TOTEST
    (setq omni-quotes-ring-current-pointer (1+ omni-quotes-ring-current-pointer))
    quote))

;;§later: prev
(defun omni-quotes-ring-random ()
  "Give a random quote from the ring."
  ;;§here §TOTEST
  (ring-ref omni-quotes-ring-current-quotes (random (ring-size omni-quotes-ring-current-quotes))))

(defun omni-quotes-ring-get ()
  ;; §maybe: different accès method. Get method dispatch
  (omni-quotes-ring-next)

  ;; §later: var saying method that should be call
  )
;; ¤see berkeley: utilities.lisp!!!

;; §maybe:rename
;; §maybe: store as ring, use dash for filter, whatever?


(provide 'omni-quotes-ring)
;;; omni-quotes-ring.el ends here
