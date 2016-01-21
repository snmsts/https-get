(in-package :cl-user)

(defpackage https-fetch
  (:use :cl)
  (:export :https-fetch :register-quicklisp))
(in-package :https-fetch)

(defun which (cmd)
  (or (ignore-errors
        (or (uiop:run-program (format nil "which ~A" cmd)) t))
      (ignore-errors
        (or (uiop:run-program (format nil "command -v ~A" cmd)) t))
      (ignore-errors
        (or (uiop:run-program (format nil "where ~A" cmd))) t)))

(defun https-fetch (url file &key (follow-redirects t) quietly
                               (if-exists :rename-and-delete))
  "scheme-function for https protocol."
  (declare (ignore quietly follow-redirects if-exists))
  (let ((file (namestring (ensure-directories-exist file))))
    (and
     (or
      (when (which "bitsadmin")
        (uiop:run-program (format nil "bitsadmin /TRANSFER htmlget ~A ~A" url file))
        t)
      (when (which "curl")
        (uiop:run-program (format nil "curl -Ss -L ~A -o ~A" url file))
        t)
      (when (which "wget")
        (uiop:run-program (format nil "wget -q ~A -O ~A" url file))
        t)
      (when (which "fetch")
        (uiop:run-program (format nil "fetch ~A -o ~A" url file))
        t))
     (values
      (ignore-errors
        (make-instance (find-symbol (string :header) :ql-http) :status
                       200))
      (probe-file file)))))

(defun register-quicklisp ()
  (let ((symbol (find-symbol (string :*fetch-scheme-functions*) :ql-http)))
    (when (and symbol
               (symbol-value symbol))
      (set symbol (acons "https" 'https-fetch
                         (remove "https" (symbol-value symbol) :key #'first :test 'equal)))
      (symbol-value symbol))))
