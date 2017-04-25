(ert-deftest  can-retrieve-quote ()
  (should (s-presence (omni-quotes-random-quote))))

(ert-deftest can-set-custom ()
  (customize-set-variable 'omni-quotes-fading t)
  (should (equal t omni-quotes-fading)))

;;; ¤> parsers

(ert-deftest load-simple-quote-file ()
  (mocklet (((omni-quotes-set-populate '("a" "b" "c" "alpha" "beta") "quote-file")))
           (omni-quotes-load-simple-quote-file (f-expand "quote-file.txt" omni-quotes-test-path) "quote-file")))

(ert-deftest can-parse-simple-file-ok ()
  (should (equal (omni-quotes-simple-parser (f-expand "quote-file.txt" omni-quotes-test-path))
                 '("a" "b" "c" "alpha" "beta"))))

(ert-deftest can-parse-simple-file-ko ()
  (should-not (shut-up (omni-quotes-simple-parser (f-expand "NOT-A-quote-file.txt" omni-quotes-test-path)))))


;;; ¤> quotes display

(ert-deftest omni-quotes-cant-redisplay-no-message ()
  (with-mock
   (stub current-message => nil)
   (should-not (omni-quotes-cant-redisplay))))

(ert-deftest omni-quotes-cant-redisplay-boring-message ()
  (with-mock
   (stub current-message => "Mark set")
   (should-not (omni-quotes-cant-redisplay))))

(ert-deftest omni-quotes-cant-redisplay-important-message ()
  (with-mock
   (stub current-message => "Important Message")
   (should (omni-quotes-cant-redisplay))))

(ert-deftest omni-quote-idle-redisplay-active-minibuffer()
  (mocklet ((active-minibuffer-window => t)
            (omni-quotes-display-random-quote not-called))
           (omni-quotes-idle-display-callback)))

(ert-deftest omni-quote-idle-redisplay-cant()
  (mocklet ((active-minibuffer-window => nil)
            (omni-quotes-cant-redisplay => t)
            (omni-quotes-display-random-quote not-called))
           (omni-quotes-idle-display-callback)))

(ert-deftest omni-quote-idle-redisplay-cant()
  (mocklet ((active-minibuffer-window => nil)
            (omni-quotes-cant-redisplay => nil)
            (omni-quotes-display-random-quote => "called"))
           (should (equal (omni-quotes-idle-display-callback) "called"))))

(ert-deftest calling-omni-quote-start-cancels-the-timer()
  (omni-quotes-idle-display-start)
  (should omni-quotes-idle-timer)
  (omni-quotes-idle-display-start)
  (should omni-quotes-idle-timer))

;;; ¤> Quote ring

(ert-deftest omni-quotes-next-set-ok ()
  (let ((pointer omni-quotes-sets-ring-pointer))
    (omni-quotes-next-set)
    (should (equal (1+ pointer) omni-quotes-sets-ring-pointer))))

(ert-deftest omni-quotes-prev-set-ok ()
  (let ((pointer omni-quotes-sets-ring-pointer))
    (omni-quotes-prev-set)
    (should (equal (1- pointer) omni-quotes-sets-ring-pointer))))

;; ¤>> simple test, calling function
(ert-deftest shuffle-didnt-fail ()
  (omni-quotes-shuffle-current-set)
  (should (equal (ht-get omni-quotes-current-set 'pointer) 0)))

(ert-deftest omni-quote-set-prev-test()
  (let ((pointer (ht-get omni-quotes-current-set 'pointer)))
    (should (omni-quotes-set-prev omni-quotes-current-set))
    (should (equal (1- pointer) (ht-get omni-quotes-current-set 'pointer)))))

(ert-deftest omni-quote-set-random-test()
    (should (omni-quotes-set-random omni-quotes-current-set)))
