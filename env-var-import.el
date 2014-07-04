;;; env-var-import.el --- Import shell environment variables in GUI Emacs

;; Copyright (c) 2014 Andrew Johnson <andrew@andrewjamesjohnson.com>

;; Version: 1.0
;; Keywords: shell, environment, env-var
;; Author: Andrew Johnson <andrew@andrewjamesjohnson.com>
;; Maintainer: Andrew Johnson <andrew@andrewjamesjohnson.com>
;; URL: https://github.com/ajsquared/color-theme-x

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login.  This library works around that by copying environment
;; variables from the shell.

;; This library will first set exec-path to the value of a
;; customizable environment variable (defualting to $PATH) You can
;; optionally pass in a list of additional variables to import

;;; Example usage:

;; (env-var-import)
;; This usage will only import env-var-import-exec-path-var and set
;; exec path to the value of that variable.
;; (env-var-import '("VAR1", "VAR2"))
;; This usage will import env-var-import-exec-path-var and set exec
;; path to the value of that variable as well as import the values of
;; VAR1 and VAR2.

;;; Code:

(defgroup env-var-import nil
  "Import shell environment variables"
  :version 1.0
  :group 'external)

(defcustom env-var-import-exec-path-var "PATH"
  "The environment variable to use to set `exec-path'."
  :type 'string
  :group 'env-var-import)

(defvar env-var-import-shell-command "$SHELL -i -c 'printenv'")

(defun env-var-import-chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (replace-regexp-in-string (rx (or (: bos (* (any " \t\n")))
				    (: (* (any " \t\n")) eos)))
			    ""
			    str))

(defun shell-command-to-string-trimmed (command)
  "Run COMMAND and return its output as a string trimmed of whitespace."
  (env-var-import-chomp (shell-command-to-string command)))

(defun read-shell-env ()
  "Read all shell environment variables using `printenv` and return their values as a hash table."
  (let ((printenv (split-string (shell-command-to-string-trimmed env-var-import-shell-command) "\n"))
	(shell-env (make-hash-table :test 'equal)))
    (while printenv
      (let* ((split (split-string (car printenv) "="))
	     (var (car split))
	     (value (car (last split))))
	(puthash var value shell-env))
      (setq printenv (cdr printenv)))
    shell-env))

(defun env-var-import (&optional other-vars)
  "Import environment variables from the shell.
`env-var-import-exec-path-var` is imported and used to set `exec-path`.
Any variables specified in OTHER-VARS are imported as well."
  (let* ((shell-env (read-shell-env))
	 (exec-val (gethash env-var-import-exec-path-var shell-env)))
    (setenv env-var-import-exec-path-var exec-val)
    (setq exec-path (split-string exec-val path-separator))
    (if other-vars
	(dolist (var other-vars)
	  (let ((value (gethash var shell-env)))
	    (if value
		(setenv var value)))))))

(provide 'env-var-import)

;;; env-var-import.el ends here
