;;; §draft. idee de quote à charger.
;;; display random au fur et à mesure. ? ring/list
;;; Utiliser aussi pour commandes à renforcer
;;; trigger. affiche après un certain random.
;;; §Later: plusieurs catégories.
;;; §maybe: le binder avec un des trucs de quotes?
;;; use dash library

(defvar oq:quotes nil "My stupid quotes")
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

(defun oq:random-quote ()
  "Affiche une quote au hasard"
  (interactive)
  (message (nth (random (length oq:quotes)) oq:quotes)))
;; see berkeley: utilities.lisp!!!

;; Following timer recipe: (§todo:maybe extract a library?)

;; variable for the timer object
(defvar oq:idle-timer nil "OmniQuote timer")
(defvar oq:idle-interval 5 "OmniQuote idle time, in seconds")
(defvar oq:repeat-interval 30 "OmniQuote repeat time, in seconds")
;; §todo: to custom

(defun oq:idle-display-callback ()
  "OmniQuote Timer Call bac function"
  ;; §TODO! check if there is no prompt waiting!!
  (oq:random-quote))

  ;; maybe extract update timer function?: `cancel-and-set-new-timer'...
(defun oq:idle-display-start (&optional no-repeat)
  "Add OmniQuote idle timer with repeat (by default)"
  (interactive)
  (oq:cancel-if-timer)
  (setq oq:idle-timer
	(run-with-timer oq:idle-interval
			(if no-repeat nil oq:repeat-interval)
			#'oq:idle-display-callback)))

;; stop function
(defun oq:idle-display-stop ()
  "Stop OmniQuote Idle timer"
  (interactive)
  (oq:cancel-if-timer)
  (setq oq:idle-timer nil))


;; Helper Methods:
(defun oq:cancel-if-timer ()
  "Cancel OmniQuote timer if set"
  (when (timerp oq:idle-timer)
    (cancel-timer oq:idle-timer)))

;; §Todo: minor mode.

(provide 'omni-quotes)
