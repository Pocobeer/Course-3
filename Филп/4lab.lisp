
;прямая рекурсия
(defun replace_elem (lst index val)
    (cond ((null lst) nil)
        ((= index 0) (cons val (cdr lst)))
        (t (cons (car lst) (replace_elem (cdr lst) (1- index) val)))
    )
)

;взаимная рекурсия
(defun replace_elem_vz (lst index val)
    (cond
        (t
            (replace_elem lst index val)
        )
    )
)

(setq my_lst '(1 2 3 4 5))
(write (replace_elem my_lst 2 '11))
(terpri)
(write (replace_elem_vz my_lst 0 '22))

(defun sum (lst)
    (cond 
        ((null lst) 0)
        (t (+ (car lst) (sum (cdr lst))))
    )
)

(defun check_atom (lst)
    (cond
        ((null lst) nil)
        ((atom (car lst)) T)
        (t (check_atom lst))
    )
)
;(write(check_atom my_lst))

(defun ackerman (m n)
	   (cond ((= m 0) (+ n 1))
		        ((= n 0) (ackerman (- m 1) 1))
	  	        (t (ackerman (- m 1)
				(ackerman m (- n 1)))
))) 
