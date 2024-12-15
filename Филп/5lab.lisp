(write (apply '* '(0.5 2 3)))
(terpri)
(write (apply '* '(0.5 5 10)))
(terpri)
(write (funcall '* 0.5 2 3))
(terpri)
(write (funcall '* 0.5 5 10))
(terpri)
;2
(write (funcall (lambda (a b) (* 0.5 a b)) 2 3))
;3
(terpri)
(write ((lambda (a b fn)(* 0.5 (funcall fn a b))) 2 3 '*))
(terpri)
;4
(write (mapcar 'cons '(1 2 3) '(a b c)))
(terpri)
(write (maplist 'cons '(1 2 3) '(a b c)))
(terpri)
(write (mapcon 'reverse '(1 2 3)))
(terpri)
;5
(write (mapcar (lambda (lst1 lst2) (cons lst1 lst2)) '(1 2 3) '(a b c)))
(terpri)
;6
(write ((lambda (lst1 lst2)
    (maplist #'cons lst1 lst2)) '(1 2 3) '(a b c))
)
(terpri)
;7
(write (some 'equal '(a b c) '(a b d)))
