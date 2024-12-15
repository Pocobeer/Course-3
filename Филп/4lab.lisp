
;прямая рекурсия
(defun replace_elem (lst index val)
    (cond ((null lst) nil)
        ((= index 0) (cons val (cdr lst)))
        (t (cons (car lst) (replace_elem (cdr lst) (1- index) val)))
    )
)

;параллк=ельная рекурсия
(defun replace_elem_par (lst index val)
    (cond 
        ((null lst) nil)
        ((= index 0)
            (cons val (cdr lst))
        )
        (t (cons (car lst) (replace_elem_par (cdr lst) (1- index) val)))
    )
)

;взаимная рекурсия
(defun replace_elem_vz (lst index val)
    (cond
        (t
            (replace_elem_par lst index val)
        )
    )
)

(setq my_lst '(1 2 3 4 5))
(write (replace_elem my_lst 2 '11))
(terpri)
(write (replace_elem_par my_lst 1 '99))
(terpri)
(write (replace_elem_vz my_lst 0 '22))