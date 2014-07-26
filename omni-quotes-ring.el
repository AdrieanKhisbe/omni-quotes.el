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
(defvar oq:current-quotes-ringlist '()
  "Ring Storing the Different quotes")

(defun oq:populate-ring () ;§todo: make it call current population method
  "Populate `oq:current-quotes-ringlist' with `oq:default-quotes'" ; ¤warn:doc-update-with-function
  ;; §note: random population method. (maybe to instract in shuffle) [and optimize...]
  ;; that send a new list
  (let ((next-insert 0))
    (-each oq:default-quotes (lambda (quote)
			       (progn
				 (setq oq:current-quotes-ringlist (-insert-at next-insert
									      quote oq:current-quotes-ringlist)
				       next-insert (random (length oq:current-quotes-ringlist))))))))

  ;; ¤note:beware random 0 give all numbers!
  ;; (oq:message "Update list"))
;; §maybe:see cycle (send an infinte copy?)
;;§tmp; (oq:populate-ring)
;; (setq oq:current-quotes-ringlist nil)
;; §TODO: extract a real structure in specific file. (access and modifying api)

;; §draft: force population ;§todo: extract in omni-quotes-ring. or data structure whatever
;; §ring: random or rotating. use a pointer rather than stupidly rotate the list....

(defun oq:ring:get ()
  ;; §maybe: different accès method
  (let ((quote (car oq:current-quotes-ringlist))) ;;§make this a get to the data strucure [ encapsulation powa]
	(setq oq:current-quotes-ringlist (-rotate 1 oq:current-quotes-ringlist))
	quote))
;; see berkeley: utilities.lisp!!!
;; §later: to ring


(provide 'omni-quotes-ring)
;;; omni-quotes-ring.el ends here
