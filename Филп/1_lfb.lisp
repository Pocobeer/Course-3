'((father(Sergey :age 52))
(mother(Helen))
(son(Alex))
(son(Vladimir))
(cat(murz)))

(defun start ()
    (f_head)
    (f_tail)
    (add_f)
    (predicat_atom)
    (predicat_list)
)

(defun f_head ()   (write(car '((father(Sergey))(mother(Helen))(son(Alex))(son(Vladimir))(cat(murz))))))

(defun f_tail () (write(cdr '((father(Sergey))(mother(Helen))(son(Alex))(son(Vladimir))(cat(murz))))))

(defun add_f () (write(cons '(babushka(Zoya)) '((father(Sergey))(mother(Helen))(son(Alex))(son(Vladimir))(cat(murz))))))

(defun predicat_atom () (write(atom '((father(Sergey))(mother(Helen))(son(Alex))(son(Vladimir))(cat(murz))))))

(defun predicat_list () (write(list '((father(Sergey))(mother(Helen))(son(Alex))(son(Vladimir))(cat(murz))))))

