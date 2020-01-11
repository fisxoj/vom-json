(defpackage vom-json
  (:use :cl)
  (:local-nicknames (:json :jonathan))
  (:export #:with-tags
           #:with-json-logging
           #:json-formatter
           #:enable-json-formatter
           #:disable-json-formatter))

(in-package :vom-json)

(defvar *tags* nil
  "Tags to be printed along with the message.")

(defvar *last-formatter* nil
  "The formatter function replaced by :function:`enable-json-formatter`.")

(defun json-formatter (format-str level-str package-keyword args)
  "The formatter which produces logs in json.

Has fields:

* ``_logLevel``: The log level, eg. warn, info, &c.
* ``msg``: The formatted message.
* ``_tags``: Any tags included by :macro:`with-tags` forms.
* ``_package``: The package the log message originates from."

  (json:with-output-to-string*
      (json:with-object
          (json:write-key-value "_logLevel" (string-downcase level-str))
        (json:write-key-value "msg" (apply #'format nil format-str args))
        (json:write-key-value "_tags" (json:with-array
                                          (dolist (item *tags*)
                                            (json:write-item item))))
        (json:write-key-value "_package" (string-downcase package-keyword)))
    (princ #\Newline json::stream)))


(defmacro with-tags ((&rest tags) &body body)
  "A nestable macro to allow adding tags to log messages.  Any log messages printed inside a :macro:`with-tags` call should have those tags in the ``tags`` array."

  `(let ((*tags* (append *tags* ',tags)))
     ,@body))


(defmacro with-json-logging (&body body)
  "Sets `vom <https://github.com/orthecreedence/vom>`_'s log format to json for the body of the macro.  You could, for example wrap the whole execution context of an app with this to ensure the app uses json logging but doesn't interfere with... I dunno... another app running in the same image that you wan to use a different log format for some reason?  It just seems right to include a ``WITH-...`` macro in a lisp library."

  `(let ((vom:*log-formatter* #'json-formatter))
     ,@body))


(defun enable-json-formatter ()
  "Changes :variable:`vom:*log-formatter*` to :function:`json-formatter`, preserving the current log formatter for :function:`disable-json-formatter` to restore, later."

  (setf *last-formatter* vom:*log-formatter*
        vom:*log-formatter* #'json-formatter))


(defun disable-json-formatter ()
  "The inverse of :function:`enable-json-formatter`."

  (setf vom:*log-formatter* *last-formatter*
        *last-formatter* nil))
