.. image:: https://travis-ci.org/fisxoj/vom-json.svg?branch=master
   :target: https://travis-ci.org/fisxoj/vom-json
   :alt: Travis CI status badge
.. image:: https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg
   :alt: Contributor Covenant
   :target: CODE_OF_CONDUCT.md


:Source: `https://github.com/fisxoj/vom-json <https://github.com/fisxoj/vom-json>`_
:Docs:  `https://fisxoj.github.io/vom-json/ <https://fisxoj.github.io/vom-json/>`_

vom-json is a complementary library to `vom <https://github.com/orthecreedence/vom>`_, which changes the logger syntax to something like `lambda-log <https://github.com/KyleRoss/node-lambda-log/>`_ making it arguably a more useful format in cloud environments like AWS.

You can use it two ways:

1. Wrap the body of your program in it using :macro:`vom-json:with-json-logging`::
  (vom-json:with-json-logging
    (vom:error "Oh noes!"))
  ;; => {"_logLevel":"error","msg":"Oh noes!","_tags":[],"_package":"common-lisp-user"}

2. Enable the logger globally::
  (vom-json:enable-json-logging)

This project is extremely inspired by `log4cl-json <https://github.com/40ants/log4cl-json/>`_.
