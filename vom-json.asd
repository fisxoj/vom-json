(defsystem vom-json
  :author "Matt Novenstern <fisxoj@gmail.com>"
  :license "MIT"
  :depends-on ("jonathan"
               "vom")
  :components ((:file "vom-json"))
  :long-description #.(uiop:read-file-string #P"README.rst"))
