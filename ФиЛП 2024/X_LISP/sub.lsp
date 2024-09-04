(defun sub(new old lst)
(cond((null lst) nil)
          ((eql old (car lst)) (cons new (sub new old (cdr lst))))
          (t (cons (car lst)(sub new old (cdr lst))))))

  