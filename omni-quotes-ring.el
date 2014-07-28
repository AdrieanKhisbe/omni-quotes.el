;;; omni-quotes-ring.el --- Datastructure to old [Omni] Quotes
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

;;

;;; Code:

;; §todo: (defvar current) -> structure stockant les sources courrant

;;; ¤>vars
(defvar oq:ring:current-quotes (make-ring 42) ;§see:size
  "Ring Storing the Different quotes")

(defvar oq:ring:current-pointer 0
  "Pointer to the current element of the quote ring.")

(defun oq:ring:populate () ;§todo: make it call current population method
  "Populate `oq:ring:current-quoteslist' with `oq:default-quotes'" ; ¤warn:doc-update-with-function
  ;; §note: random population method. (maybe to instract in shuffle) [and optimize...]
  ;; that send a new list

  ;; §maybe: empty ring?
  (let ((next-insert 0)
	(shuffled-list nil))
    ;; §todo: extract shuffle list
    (-each oq:default-quotes (lambda (quote)
			       (progn  (setq shuffled-list (-insert-at next-insert
								       quote shuffled-list)
				       next-insert (random (length shuffled-list))))))
    (-each shuffled-list (lambda(quote)(ring-insert oq:ring:current-quotes quote )))))

  ;; ¤note:beware random 0 give all numbers!
  ;; (oq:message "Update list"))
;; §maybe:see cycle (send an infinte copy?)
;;§tmp; (oq:ring:populate)
;; (setq oq:ring:current-quoteslist nil)
;; §TODO: extract a real structure in specific file. (access and modifying api)

;; §draft: force population ;§todo: extract in omni-quotes-ring. or data structure whatever
;; §ring: random or rotating. use a pointer rather than stupidly rotate the list....

(defun oq:ring:next()
  "Send next quote of the ring and move pointer"
  (let ((quote (ring-ref oq:ring:current-quotes oq:ring:current-pointer))) ;§here TOTEST
    (setq oq:ring:current-pointer (1+ oq:ring:current-pointer))
    quote))
;; §later: prev
(defun oq:ring:random ()
  "Give a random quote from the ring"
  ;;§here §TOTEST
  (ring-ref oq:ring:current-quotes (random (ring-size oq:ring:current-quotes))))

(defun oq:ring:get ()
  ;; §maybe: different accès method. Get method dispatch
  (oq:ring:next)

  ;; §later: var saying method that should be call
  )
;; ¤see berkeley: utilities.lisp!!!

;; §maybe:rename
;; §maybe: store as ring, use dash for filter, whatever?


(provide 'omni-quotes-ring)
;;; omni-quotes-ring.el ends here
