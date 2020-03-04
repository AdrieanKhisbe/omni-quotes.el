;;; omni-quotes.el --- Random quotes displayer   -*- lexical-binding: t -*-
;;
;; Copyright (C) 2014-2020 Adrien Becchis
;;
;; Author: Adrien Becchis <adriean.khisbe@live.fr>
;; Created: 2014-07-17
;; Last-Release: 2020-03-04
;; Version: 0.5.1
;; Keywords: convenience
;; Package-Requires: ((dash "2.8") (omni-log "0.4.0") (f "0.19.0") (s "1.11.0") (ht "2.1"))
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

;;; Building-Notes:
;; §Later: plusieurs catégories.
;; §maybe: le binder avec un des trucs de quotes?: fortunes, and co.

;;; Commentary:
;; Omni Quotes is there to display quotes on your Echo Area when emacs is idle,
;; whether it's funny stuff, inspirational quotes, or something you try to remember.

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
  ;; §maybe: replace by Q, (or greek style ϙ)
  :type 'string :group 'omni-quotes)

(defcustom omni-quotes-idle-interval 4 "OmniQuote idle time, in seconds."
  :type 'number :group 'omni-quotes)

(defcustom omni-quotes-repeat-interval 20 "OmniQuote repeat time, in seconds."
  :type 'number :group 'omni-quotes)

(defun omni-quotes--log-setter (property)
  "Return function handling forwarding PROPERTY update to logger."
  (lambda (symb value)
    (if (boundp 'omni-quotes-global-quote-log)
        (omni-log-logger-set-property omni-quotes-global-quote-log property value))
    (set-default symb value)))

(defcustom omni-quotes-prompt " » " "Leading prompt of OmniQuotes messages."
  :type 'string :group 'omni-quotes
  :set (lambda (symb value)
         (let ((value (propertize value 'omni-quote-p t)))
           (if (boundp 'omni-quotes-global-quote-log)
               (omni-log-logger-set-property omni-quotes-global-quote-log 'prompt value))
           (set-default symb value))))

(defcustom omni-quotes-max-repeat 6
  "Number of omni-quotes will repeat without any activity. If zero there wont be any limit"
  :type 'number :group 'omni-quotes)

(defcustom omni-quotes-fading nil
  "Does omni-quote fade after some duration."
  :type 'boolean :group 'omni-quotes
  :set (omni-quotes--log-setter 'fading))

(defcustom omni-quotes-fading-delay 14
  "Delay after which quote will fade away."
  :type 'number :group 'omni-quotes
  :set (omni-quotes--log-setter 'fading-delay))

(defcustom omni-quotes-fading-duration 4
  "Duration of the fade away effect."
  :type 'number :group 'omni-quotes
  :set (omni-quotes--log-setter 'fading-duration))

(defcustom omni-quotes-centered nil
  "Does omni-quote fade after some duration."
  :type 'boolean :group 'omni-quotes
  :set (omni-quotes--log-setter 'centered))

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
  (omni-log-create "omni-quotes"
                   `((prompt . ,omni-quotes-prompt)
                     (fading . ,omni-quotes-fading)
                     (fading-delay . ,omni-quotes-fading-delay)
                     (fading-duration . ,omni-quotes-fading-duration)
                     (centered . ,omni-quotes-centered)))
      "Specific logger for omni-quotes.")

;;;###autoload
(defun omni-quotes-display-random-quote ()
  "Display a random quote obtained from `omni-quotes-random-quote'.
The quote will be prefixed by the current `omni-quotes-prompt'"
  (interactive)
  (log-omni-quotes (omni-quotes-random-quote)))
;; §maybe: [append with date?]
;; §maybe: change format: catégorie > texte.

(defun omni-quotes-random-quote ()
  "Get a random quote."
  (omni-quotes-set-get omni-quotes-current-set))
;; §maybe: should have different quote rings for the categories. how to select-active-regions
;; §maybe have current function: (round, random...)
;; §maybe: create an intensive mode. quotes plus raprochées. éventuellement un slidding effect. sans interruption
;;        jusqu'à la prochaine touche

(defvar omni-quotes--nb-current-repeat 0)

(defun omni-quotes-idle-display-callback () ; §maybe rename of move in timer?
  "OmniQuote Timer callback function."
  ;; §maybe: force? optional argument? §maybe: extract in other function

  (if (or (active-minibuffer-window) ; check if there is no prompt waiting
              (omni-quotes-cant-redisplay))
      (setq omni-quotes--nb-current-repeat 0)
    (let ((cm (current-message)))
      (setq omni-quotes--nb-current-repeat
            (if (and cm (get-text-property 0 'omni-quote-p cm)) (1+ omni-quotes--nb-current-repeat) 1))
      (if (or (eq 0 omni-quotes-max-repeat)
              (>= omni-quotes-max-repeat omni-quotes--nb-current-repeat))
          (omni-quotes-display-random-quote)))))

(defun omni-quotes-cant-redisplay()
  "Tells if Quote should be display. (in order to avoid erasing of important messages)"
  (let ((cm (current-message)))
    (and cm
         (not (or (get-text-property 0 'omni-quote-p cm)
                  (string-match omni-quotes-boring-message-regexp cm))))))


;;;###autoload
(define-minor-mode omni-quotes-mode
  "Display random quotes when idle."
  :lighter omni-quotes-lighter
  :global t
  (if omni-quotes-mode
      (progn
        (add-hook 'post-command-hook 'omni-quotes-idle-display-start)
        (omni-quotes-idle-display-start))
    (progn
      (remove-hook 'post-command-hook 'omni-quotes-idle-display-start)
      (omni-quotes-idle-display-stop))))

;; §maybe: tmp?
(omni-quotes-load-defaults)

(provide 'omni-quotes)
;;; omni-quotes.el ends here
