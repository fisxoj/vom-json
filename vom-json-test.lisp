(defpackage :vom-json/test
  (:local-nicknames (:log :vom))
  (:use :cl :rove))

(in-package :vom-json/test)

(defmacro with-captured-output (() &body body)
  (let ((string-output (gensym)))
    `(with-output-to-string (,string-output)
       (let ((vom:*log-stream* ,string-output))
         ,@body))))


(deftest with-json-logging
  (testing "the vom formatter"
    (ok (not (eq vom:*log-formatter* #'vom-json:json-formatter))
        "is initially not the json formatter.")
    (vom-json:with-json-logging
      (ok (eq vom:*log-formatter* #'vom-json:json-formatter)
          "is the json formatter inside the macro."))
    (ok (not (eq vom:*log-formatter* #'vom-json:json-formatter))
        "is not the json formatter after the macro body.")))

(deftest json-formatter
  (vom-json:with-json-logging
    (ok (jojo:parse (with-captured-output () (log:info "hello")) :as :alist)
        "outputs valid json.")

    (testing "fields"
      (let ((output (jojo:parse (with-captured-output () (log:info "hello"))
                                :as :alist)))
        (flet ((aget (key)
                 (cdr (assoc key output :test 'string=))))

          (ok (string= (aget "_logLevel") "info")
              "the log level is correct.")
          (ok (local-time:parse-rfc3339-timestring (aget "_timestamp"))
              "the timestamp is valid.")
          (ok (string= (aget "msg") "hello")
              "the message is correct.")
          (ok (equal (aget "_tags") nil)
              "there are no tags.")
          (ok (string= (aget "_package") "vom-json/test")
              "the package is correct."))))))

(deftest with-tags
  (vom-json:with-json-logging
    (vom-json:with-tags ("this" "that")
      (ok (equal (cdr (assoc "_tags" (jojo:parse (with-captured-output () (log:info "hello")) :as :alist)
                             :test 'string=))
                 '("this" "that"))
          "adds tags to the log output."))))
