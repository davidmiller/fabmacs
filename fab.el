;;; fab.el --- Fabric integration for Emacs

;; Copyright (C) 2011 David Miller <david@deadpansincerity.com>

;; Author: David Miller <david@deadpansincerity.com>
;; Maintainer: David Miller <david@deadpansincerity.com>
;; Created 2011-02-20
;; Keywords: python fabric
;;
;; Version: 0.1
;;

;; This file is NOT part of GNU Emacs

;;; License

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

;;
;; Commentary:
;;
;; fab.el began when I needed to use Fabric for a non-django project and
;; so factored all the Fabric stuff out of pony-mode for generic use
;;

;;; Code:


;;;###autoload
(defun fab-p ()
  "Is this project using fabric?"
  (let ((cmdlist (fab-list-commands)))
    (if (and (equal "Fatal" (first cmdlist))
             (equal "error:" (second cmdlist)))
        nil
      t)))

;;;###autoload
(defun fab-list-commands()
  "List of all fabric commands for project as strings"
  (split-string (shell-command-to-string "fab --list | awk '{print $1}'|grep -v Available")))

;;;###autoload
(defun fab-run(cmd)
  "Run fabric command"
  (ansi-color-for-comint-mode-on)
  (apply 'make-comint "fabric" "fab" nil (list cmd))
  (pop-to-buffer "*fabric*"))

;;;###autoload
(defun fab()
  "Run a fabric command"
  (interactive)
  (if (fab-p)
      (fab-run (minibuffer-with-setup-hook 'minibuffer-complete
                         (completing-read "Fabric: "
                                          (fab-list-commands)))))
  (message "No fabfile found!"))

;;;###autoload
(defun fab-deploy()
  "Deploy project with fab deploy"
  (interactive)
  (fab-run "deploy"))


(provide 'fab)
;; fab.el ends