(defun filter-non-numeric (lst) (remove-if 'numberp lst))

(write (filter-non-numeric '(1 "aa" 2.5 symbol "aaaaa" 3)))