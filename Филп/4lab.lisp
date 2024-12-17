
;прямая рекурсия
(defun replace_elem (lst old_val new_val)
  (cond ((null lst) nil) 
        ((eql old_val (car lst)) 
         (cons new_val (replace_elem (cdr lst) old_val new_val)))  
        (t  
            (cons (car lst) (replace_elem (cdr lst) old_val new_val))
        )
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
;(write (replace_elem my_lst 2 11))
(terpri)
;(write (replace_elem_vz my_lst 0 22))

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


(defun lst_set (lst)
    (cond
        ((null lst) nil) 
        ((member (car lst) (lst_set (cdr lst))) 
        (lst_set (cdr lst)))  
        (t (cons (car lst) (lst_set (cdr lst))))
    )
)

(terpri)
(write (lst_set '(1 2 1 3 1 4 5 2 6)))