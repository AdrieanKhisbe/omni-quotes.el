;;; §draft. idee de quote à charger.
;;; display random au fur et à mesure. ? ring/list
;;; Utiliser aussi pour commandes à renforcer
;;; trigger. affiche après un certain random.
;;; §Later: plusieurs catégories.
;;; §maybe: le binder avec un des trucs de quotes?
;;; use dash library

(defvar my-quotes nil "My stupid quotes")
(setq my-quotes '(
		  ;; Emacs custos
		  "Customization is the corner stone of Emacs"
		  "Emacs is an acronym for \"Escape Meta Alt Control Shift\""

		  ;; Tips
		  "Harness Macro Powaaaa"
		  "Use a fuckying good register level" ; paye ton franglish
		  "Might be to learn to make function from macros"
		  "Aren't you a bit déRanger?...(c'est le bo'del)"

		  ))

(defun my-random-quote ()
  "Affiche une quote au hasard"
  (interactive)
  (message (nth (random (length my-quotes)) my-quotes)))
;; see berkeley: utilities.lisp!!!

;; Following timer recipe: (§todo:maybe extract a library?)

;; variable for the timer object
(defvar idle-timer-quote-timer nil "MyQuote timer")
(defvar quote-idle-time 5 "MyQuote idle time, in seconds")
(defvar quote-repeat-time 30 "MyQuote repeat time, in seconds")
;; §todo: to custim

(defun idle-timer-quote-callback ()
  "MyQuote Timer Call bac function"
  ;; §TODO! check if there is no prompt waiting!!
  (my-random-quote))

;; §keep?
(defun idle-timer-quote-run-once ()
  (interactive)
  (cancel-if-quote-timer)
  ;; maybe extract update timer function?
  (setq idle-timer-quote-timer
	(run-with-idle-timer quote-idle-time nil #'idle-timer-quote-callback)))

(defun idle-timer-quote-start ()
  (interactive)
  (cancel-if-quote-timer)
  (setq idle-timer-quote-timer
	(run-with-timer quote-idle-time quote-repeat-time #'idle-timer-quote-callback)))

;; stop function
(defun idle-timer-quote-stop ()
  (interactive)
  (cancel-if-quote-timer)
  (setq idle-timer-quote-timer nil))

;; utils
(defun cancel-if-quote-timer ()
  (when (timerp idle-timer-quote-timer)
    (cancel-timer idle-timer-quote-timer)))

;; §Todo: minor mode.

(provide 'myquote)
