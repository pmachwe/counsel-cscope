;; counsel-cscope

(require 'counsel)
(require 'async)

(defgroup counsel-cscope nil
  "Navigate cscope using Ivy.")

(defcustom counsel-cscope-database nil
  "Location of cscope.out."
  :type 'string
  :group 'counsel-cscope)

(defconst counsel-cscope--prompts
  '((symbol      . "Find this C symbol: ")
    (definition  . "Find this definition: ")
    (func-called . "Find functions called by this function: ")
    (reference   . "Find functions calling this function: ")
    (text-str    . "Find this text string: ")
    (egrep-pat   . "Find this egrep pattern: ")
    (file        . "Find this file: ")
    (includes    . "Find files #including this file: ")
    (assigns     . "Find places where this symbol is assigned a value: ")))

(defconst counsel-cscope--complete-options
  '((symbol      . "-L0")
    (definition  . "-L1")
    (func-called . "-L2")
    (reference   . "-L3")
    (text-str    . "-L4")
    (egrep-pat   . "-L6")
    (file        . "-L7")
    (includes    . "-L8")
    (assigns     . "-L9")))

(defvar counsel-cscope-mode-name " CounselCscope")
(defvar counsel-cscope-mode-map (make-sparse-keymap))

;;;###autoload
(define-minor-mode counsel-cscope-mode ()
  "Minor mode of counsel-cscope.
  If `counsel-cscope-update-tags' is non-nil, the tag files are updated
  after saving buffer."
  :init-value nil
  :global     nil
  :keymap     counsel-cscope-mode-map
  :lighter    counsel-cscope-mode-name
  (if counsel-cscope-mode
      (when counsel-cscope-auto-update
        (add-hook 'after-save-hook 'counsel-cscope-update-tags nil t))
    (when counsel-cscope-auto-update
      (remove-hook 'after-save-hook 'counsel-cscope-update-tags t))))

(defun counsel-cscope--construct-cmd (prompt)
  "Construt the shell command string for the given PROMPT."
  (let ((option (cdr (assoc prompt counsel-cscope--complete-options))))
      (concat "cscope -d -f" counsel-cscope-database " " option)))

