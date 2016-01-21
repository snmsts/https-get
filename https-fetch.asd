(in-package :cl-user)

#-asdf
(require :asdf)

(defpackage https-fetch-asd
  (:use :cl :asdf))
(in-package :https-fetch-asd)

(defsystem https-fetch
  :version "0.1"
  :author "SANO Masatoshi"
  :mailto "snmsts@gmail.com"
  :license "MIT"
  :depends-on (:uiop)
  :components ((:module "src"
                :components
                ((:file "fetch"))))
  :description "simplest https-client")
