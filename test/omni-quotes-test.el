(ert-deftest  can-retrieve-quote ()
  (should (s-presence (omni-quotes-random-quote))))

;;; ¤> parsers

(ert-deftest can-parse-simple-file-ok ()
  (should (equal (omni-quote-simple-parser (f-expand "quote-file.txt" omni-quotes-test-path))
                 '("a" "b" "c" "alpha" "beta"))))

(ert-deftest can-parse-simple-file-ko ()
  (should-not (shut-up (omni-quote-simple-parser (f-expand "NOT-A-quote-file.txt" omni-quotes-test-path)))))


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

;;; ¤> Quote ring

(ert-deftest omni-quotes-next-set-ok ()
  (let ((pointer omni-quotes-sets-ring-pointer))
    (omni-quotes-next-set)
    (should (equal (1+ pointer) omni-quotes-sets-ring-pointer))))

(ert-deftest omni-quotes-prev-set-ok ()
  (let ((pointer omni-quotes-sets-ring-pointer))
    (omni-quotes-prev-set)
    (should (equal (1- pointer) omni-quotes-sets-ring-pointer))))
