;;; §draft. idee de quote à charger.
;;; display random au fur et à mesure. ? ring/list
;;; Utiliser aussi pour commandes à renforcer
;;; trigger. affiche après un certain random.
;;; §Later: plusieurs catégories.
;;; §maybe: le binder avec un des trucs de quotes?
;;; use dash library


;;; ¤* customs:
;; §todo: to custom
(defvar oq:idle-interval 5 "OmniQuote idle time, in seconds")
(defvar oq:repeat-interval 30 "OmniQuote repeat time, in seconds")
(defvar oq:prompt "»" "Leading prompt of messages")
(defvar oq:color-prompt t "Is The prompt colored") ; §later:face (also for the text)

(when oq:color-prompt
  (setq oq:prompt (propertize oq:prompt 'face 'font-lock-keyword-face)))

(defvar oq:quotes nil "My stupid quotes")
;; §todo: use a ring structure randomly populated at startup
;; §later: use category. (revision, stupid quote, emacs tips, emacs binding to learn...)
;; §later: , offer many method to get quotes (files, web), and use a var holding
;;        current function used to et quote. (call this several tim to populate the ring)
(setq oq:quotes '(
		  ;; Emacs custos
		  "Customization is the corner stone of Emacs"
		  "Emacs is an acronym for \"Escape Meta Alt Control Shift\""

		  ;; Tips
		  "Harness Macro Powaaaa"
		  "Use a fuckying good register level" ; paye ton franglish
		  "Might be to learn to make function from macros"
		  "Aren't you a bit déRanger?...(c'est le bo'del)"

		  ))

;;; ¤*vars
;; variable for the timer object
(defvar oq:idle-timer nil "OmniQuote timer")

(defun oq:random-quote ()
  "Affiche une quote au hasard"
  (interactive)
  (message "%s %s" oq:prompt
	   (nth (random (length oq:quotes)) oq:quotes)))
;; see berkeley: utilities.lisp!!!

;; Following timer recipe: (§todo:maybe extract a library?)


(defun oq:idle-display-callback ()
  "OmniQuote Timer Call bac function"
  ;; ¤note: check if there is no prompt waiting!!
  (unless (or (active-minibuffer-window)
	      (and (current-message)
		   ;; §bonux: list of message to bypass (exit, end of buffer...)
		   ;; when s dep (s-starts-with-p oq:prompt (current-message) )
		   (not (string-prefix-p oq:prompt (current-message)))))
    ;; §todo: after to long idle time disable it (maybe use other timer, or number of iteration. (how to reset?))
    (oq:random-quote)))

(defun oq:idle-display-start (&optional no-repeat)
  "Add OmniQuote idle timer with repeat (by default)"
  (interactive)
  (oq:cancel-and-set-new-timer (run-with-timer oq:idle-interval
					       (if no-repeat nil oq:repeat-interval)
					       #'oq:idle-display-callback)))

(defun oq:idle-display-stop ()
  "Stop OmniQuote Idle timer"
  (interactive)
  (oq:cancel-and-set-new-timer nil))


;; Helper Methods:
(defun oq:cancel-if-timer ()
  "Cancel OmniQuote timer if set"
  (when (timerp oq:idle-timer)
    (cancel-timer oq:idle-timer)))

(defun oq:cancel-and-set-new-timer (timer)
  "Cancel timer and set it to new value."
  (oq:cancel-if-timer)
  (setq oq:idle-timer timer))

;; §Todo: minor mode.

(provide 'omni-quotes)
