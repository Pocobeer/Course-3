(defun dif( l x)
(cond ((atom l) (if (eq l x) 1 0))
          ((eq (first l) '+) (list '+ (dif (second l) x) (dif (third l) x)))
          ((eq (first l) '*) (list '+ 
                                       (list '* (dif (second l) x) (third l))
                                       (list '* (dif (third l) x) (second l))))
           ( t l)))
               
 