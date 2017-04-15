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

;; §DOING: extract a real structure in specific file. (access and modifying api)!!

;;; Code:


(require 'dash)
(require 'ht)

;;; ¤>vars
(defvar omni-quotes-ring-current-quotes nil
  "Ring Storing the Different quotes.")

(defvar omni-quotes-ring-current-pointer 0
  "Pointer to the current element of the quote ring.")

(defun omni-quotes-ring-populate (quote-list) ;§todo: make it call current population method
  "Populate `omni-quotes-ring-current-quoteslist' with QUOTE-LIST."
  ;; ¤warn:doc-update-with-function
  ;; §note: random population method. (maybe to instract in shuffle) [and optimize...]
  ;; that send a new list

  (setq omni-quotes-ring-current-quotes (make-ring 42)) ;§see:size
  (-each (omni-quote--shuffle-list quote-list)
    (lambda(quote)(ring-insert omni-quotes-ring-current-quotes quote))))

(defun omni-quote-ring-maker (list)
  (let ((ring (ht ("list" list)
                  ("pointer" 0)
                  ("ring" (make-ring (length list))))))



    ))

(defun omni-quote--shuffle-list (list)
  "Returns a shuffled version of the LIST."
  (let ((next-insert 0)
        (shuffled-list nil))
    ;; §todo: extract shuffle list
    (-each list
      (lambda (el)
        (progn (setq shuffled-list (-insert-at next-insert el shuffled-list)
                     next-insert (random (length shuffled-list))))))
    shuffled-list))



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
;; ¤see: berkeley: utilities.lisp!!!

;; §maybe:rename
;; §maybe: store as ring, use dash for filter, whatever?


(provide 'omni-quotes-ring)
;;; omni-quotes-ring.el ends here
