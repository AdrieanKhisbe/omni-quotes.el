;;; §TODO: Make header.

;;; §draft. idee de quote à charger.
;;; display random au fur et à mesure. ? ring/list
;;; Utiliser aussi pour commandes à renforcer trigger. affiche après un certain random.
;;; §Later: plusieurs catégories.
;;; §maybe: le binder avec un des trucs de quotes?: forturnes, and co.
;;; use dash/s/f library?

;;; ¤* customs:
;; §todo: to custom
(defcustom oq:idle-interval 3 "OmniQuote idle time, in seconds"
  :type 'number :group 'omni-quotes)
(defcustom oq:repeat-interval 20 "OmniQuote repeat time, in seconds"
  :type 'number :group 'omni-quotes)
(defcustom oq:prompt "» " "Leading prompt of messages"
  :type 'string :group 'omni-quotes)
(defcustom oq:color-prompt t "Is The Omni-Quote \"prompt\" colored"
  :type 'boolean :group 'omni-quotes) ; §later:face (also for the text)

(when oq:color-prompt
  (setq oq:prompt (propertize oq:prompt 'face 'font-lock-keyword-face)))

(defcustom oq:default-quotes
  '(
    ;; Emacs custos
    "Customization is the corner stone of Emacs"
    "Emacs is an acronym for \"Escape Meta Alt Control Shift\""

    ;; Tips
    "Harness Macro Powaaaa"
    "Use a fuckying good register level" ; paye ton franglish
    "Might be to learn to make function from macros"

    ) ; end-of default quotes
  "My stupid default (omni-)quotes"
  :type '(repeat string) :group 'omni-quotes
  )
;; §later:custom: quotes sources
;; §later:custom whitelist messages to bypass.

;; §todo: use a ring structure randomly populated at startup
;; §later: use category. (revision, stupid quote, emacs tips, emacs binding to learn...)
;;         category based on context (ex langage specific tips)
;; §later: , offer many method to get quotes (files, web), and use a var holding
;;        current function used to et quote. (call this several tim to populate the ring)

;; §todo: (defvar current) -> structure stockant les sources courrant

;;; ¤*vars
;; variable for the timer object
(defvar oq:idle-timer nil "OmniQuote timer")

(defun oq:display-random-quote ()
  "Affiche une quote au hasard préfixée du prompt."
  ;; §maybe: alias in global name space du genre `omni-quotes-random-display'
  (interactive)
  (message "%s%s" oq:prompt
	   ;; §maybe: print in specific buffer? [append with date?]
	   (oq:random-quote)))

(defun oq:random-quote ()
  "Renvoi une quote au hasard"
  (interactive)
  (nth (random (length oq:default-quotes)) oq:default-quotes))
;; see berkeley: utilities.lisp!!!
;; §later: to ring

(defun oq:idle-display-callback ()
  "OmniQuote Timer callback function"
  ;; maybe: force? optional argument?
  ;; ¤note: check if there is no prompt waiting!!
  (unless (or (active-minibuffer-window)
	      (and (current-message)
		   ;; §bonux: list of message to bypass (exit, end of buffer...)
		   ;; when s dep (s-starts-with-p oq:prompt (current-message) )
		   ;; §todo: check if prompt not empty.
		   ;;        extract logic in function
		   (not (string-prefix-p oq:prompt (current-message)))))
    ;; §todo: after to long idle time disable it (maybe use other timer, or number of iteration. (how to reset?))
    (oq:display-random-quote)))

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
  ;; ¤note: no need to inline them with `defsubst'
  "Cancel OmniQuote timer if set"
  (when (timerp oq:idle-timer)
    (cancel-timer oq:idle-timer)))

(defun oq:cancel-and-set-new-timer (timer)
  "Cancel timer and set it to new value."
  (oq:cancel-if-timer)
  (setq oq:idle-timer timer))

;;;###autoload
(define-minor-mode omni-quotes-mode ; §maybe:plural?
  "Display random quotes when idle."
  ;; :lighter " Ξ" ;§to option?󠁱
  :global t
  ;; :group §todo:find-one?
  (progn
    (if omni-quotes-mode
	(oq:idle-display-start)
      (oq:idle-display-stop))))

(provide 'omni-quotes)
