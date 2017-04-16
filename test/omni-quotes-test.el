(ert-deftest  can-retrieve-quote ()
  (should (s-presence (omni-quotes-random-quote))))

;;; ¤> parsers

(ert-deftest can-parse-simple-file-ok ()
  (should (equal (omni-quote-simple-parser (f-expand "quote-file.txt" omni-quotes-test-path))
                 '("a" "b" "c" "alpha" "beta"))))

(ert-deftest can-parse-simple-file-ko ()
  (should-not (shut-up (omni-quote-simple-parser (f-expand "NOT-A-quote-file.txt" omni-quotes-test-path)))))
