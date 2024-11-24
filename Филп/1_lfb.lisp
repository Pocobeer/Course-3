'((father(Sergey 50))
(mother(Helen))
(son(Alex))
(son(Vladimir))
(cat(murz)))

(defun start ()
    (f_head)
    (terpri)
    (f_tail)
    (terpri)
    (add_f)
    (terpri)
    (predicat_atom)
    (terpri)
    (predicat_list)
)

(defun f_head ()   (write(car '((father(Sergey 50))(mother(Helen 50))(son(Alex 24))(son(Vladimir 20))(cat(murz 5))))))

(defun f_tail () (write(cdr '((father(Sergey 50))(mother(Helen 50))(son(Alex 24))(son(Vladimir 20))(cat(murz 5))))))

(defun add_f () (write(cons '(babushka(Zoya)) '((father(Sergey 50))(mother(Helen 50))(son(Alex 24))(son(Vladimir 20))(cat(murz 5))))))

(defun predicat_atom () (write(atom '((father(Sergey 50))(mother(Helen 50))(son(Alex 24))(son(Vladimir 20))(cat(murz 5))))))

(defun predicat_list () (write(list '((father(Sergey 50))(mother(Helen 50))(son(Alex 24))(son(Vladimir 20))(cat(murz 5))))))

(car '(a b c d))