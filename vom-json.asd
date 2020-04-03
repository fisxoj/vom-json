(defsystem vom-json
  :author "Matt Novenstern <fisxoj@gmail.com>"
  :license "MIT"
  :version "1"
  :depends-on ("jonathan"
               "vom")
  :components ((:file "vom-json"))
  :description "A json-formatted logger for vom"
  :source-control (:git "https://github.com/fisxoj/vom-json.git")
  :long-description #.(uiop:read-file-string #P"README.rst"))
