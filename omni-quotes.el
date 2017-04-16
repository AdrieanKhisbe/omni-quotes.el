;;; omni-quotes.el --- Random quotes displayer
;;
;; Copyright (C) 2014-2017 Adrien Becchis
;;
;; Author: Adrien Becchis <adriean.khisbe@live.fr>
;; Created:  2014-07-17
;; Version: 0.2
;; Keywords: convenience
;; Package-Requires: ((dash "2.8") (omni-log "0.1.2") (f "0.19.0") (s "1.11.0") (ht "2.1"))
;; Url: https://github.com/AdrieanKhisbe/omni-quotes.el


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
;; Omni Quotes is there to display quotes on you /Echo Area/ when you are idle.
;; Whether it's funny stuff, inspirational quotes, or something you try to remember.


;;; Building-Notes:
;; §draft.  idee de quote à charger.
;; display random au fur et à mesure.  ? ring/list
;; Utiliser aussi pour commandes à renforcer trigger.  affiche après un certain random.
;; §Later: plusieurs catégories.
;; §maybe: le binder avec un des trucs de quotes?: fortunes, and co.

;;; Code:

(require 'dash)
(require 's)
(require 'f)
(require 'omni-log)
(require 'omni-quotes-timer)
(require 'omni-quotes-ring)
(require 'omni-quotes-reader)

;;; ¤> customs:
(defcustom omni-quotes-lighter " Ξ" "OmniQuote lighter (name in modeline) if any."
  ;; §maybe: replace Q, (or greek style)
  :type 'string :group 'omni-quotes)

(defcustom omni-quotes-idle-interval 3 "OmniQuote idle time, in seconds."
  :type 'number :group 'omni-quotes)
(defcustom omni-quotes-repeat-interval 20 "OmniQuote repeat time, in seconds."
  :type 'number :group 'omni-quotes)
(defcustom omni-quotes-prompt " » " "Leading prompt of OmniQuotes messages."
  :type 'string :group 'omni-quotes)
;; §maybe will become a separator?
(defcustom omni-quotes-color-prompt-p t "Is The Omni-Quote \"prompt\" colored."
  :type 'boolean :group 'omni-quotes) ; §later: face (also for the text)

(when omni-quotes-color-prompt-p
  (setq omni-quotes-prompt (propertize omni-quotes-prompt 'face 'font-lock-keyword-face)))
(setq omni-quotes-prompt (propertize omni-quotes-prompt 'omni-quote-p t))

(defcustom omni-quotes-default-quotes
  '(
    ;; Emacs custos
    "Customization is the corner stone of Emacs"
    "Emacs is an acronym for \"Escape Meta Alt Control Shift\""

    ;; Tips
    "Harness Macro Powaaaa"
    "Register registers as a good practice"
    "Might be to learn to make function from macros"

    "Use position register and jump everywhere in no time! :)"
    "Bookmark are a must learn feature!"
    "Repeat command with C-x zzzzzzzzzzzzzzzzzzzzzz. (and don't fall asleep)"

    "Get some projectile and don't throw them away!"
    "Ace and jump chars!"
    "Go to the Helm Gouffre!" ; ref to lord of rings
    "Don't be Evil (nor a God)"
    ) ; end-of default quotes
  "Some stupid default (omni-)quotes."
  :type '(repeat string) :group 'omni-quotes)

;; §later: custom: quotes sources
;; §later: custom whitelist messages to bypass!!

;; §later: use category. (revision, stupid quote, emacs tips, emacs binding to learn...)
;;         category based on context (ex langage specific tips)
;; §later: offer many method to get quotes (files, web), and use a var holding
;;        current function used to et quote. (call this several tim to populate the ring)

(defcustom omni-quotes-boring-message-patterns
  '(
    "^Omni-Quotes mode enabled"
    "^Mark set"
    "^Auto-saving...done"
    "^Quit"
    "End of buffer"
    "^For information about GNU Emacs"
    ;; yas
    "^\\[yas\\]"
    ;; use-package
    "^Configuring package" "^Loading package" "^use-package idle:"
    "^Here is not Git/Mercurial work tree"
    "^Saving file" "^Wrote /"
    )
  "List of message that can be overwrite by an OmniQuote."
  :type '(repeat regexp) :group 'omni-quotes
  )

(defvar omni-quotes-boring-message-regexp
  (mapconcat 'identity omni-quotes-boring-message-patterns  "\\|")
  "Regexp used to match messages that can be overwriten by a quote.
Constructed from `omni-quotes-boring-message-patterns'.")

(defconst omni-quotes-global-quote-log
  (let ((tmplog (omni-log-create-logger "omni-quotes")))
    (omni-log-create-log-function tmplog)
    tmplog)
  "Specific logger for omni-quotes.")

;;;###autoload
(defun omni-quotes-display-random-quote ()
  "Display a random quote obtained from `omni-quotes-random-quote'.
The quote will be prefixed by the current `omni-quotes-prompt'"
  ;; §maybe: alias in global name space du genre `omni-quotes-random-display'
  (interactive)
  (log-omni-quotes (format "%s%s" omni-quotes-prompt (omni-quotes-random-quote))))
;; §maybe: [append with date?]
;; §later: add fading/sliding ->>? rather omni-log level feature
;; §maybe: change format: catégorie > texte.
;; §see: refactor to have specific logger for log? (fuction sending quote and logger?)

(defun omni-quotes-random-quote ()
  "Get a random quote."
  (omni-quotes-set-get omni-quotes-current-set))
;; §maybe: should have different quote rings for the categories. how to select-active-regions
;; §maybe have current function: (round, random...)
;; §maybe: create an intensive mode. quotes plus raprochées. éventuellement un slidding effect. sans interruption
;;        jusqu'à la prochaine touche


(defun omni-quotes-idle-display-callback () ; §maybe rename of move in timer?
  "OmniQuote Timer callback function."
  ;; §maybe: force? optional argument? §maybe: extract in other function

  (unless (or (active-minibuffer-window) ; check if there is no prompt waiting
              (omni-quotes-cant-redisplay))
    ;; §todo: after to long idle time disable it (maybe use other timer, or number of iteration. (how to reset?))
    ;;        ptetre un nombre de répétitions dans le timer? (sinon mettre au point une heuristique)

    (omni-quotes-display-random-quote)))

(defun omni-quotes-cant-redisplay()
  "Tells if Quote should be display. (in order to avoid erasing of important messages)"
  (let ((cm (current-message)))
    (and cm
         (not (or (get-text-property 0 'omni-quote-p cm)
                  ;; §todo: check if prompt not empty.
                  (string-match omni-quotes-boring-message-regexp cm))))))

;;;###autoload
(define-minor-mode omni-quotes-mode
  "Display random quotes when idle."
  :lighter omni-quotes-lighter
  :global t
  (progn
    (if omni-quotes-mode
        (omni-quotes-idle-display-start)
      (omni-quotes-idle-display-stop))))

;; §maybe: tmp?
(omni-quotes-load-defaults)

(provide 'omni-quotes)
;;; omni-quotes.el ends here
