((lambda (r) (* pi r r)) 5)

(defun plosh (r) ((lambda (r) (* pi r r)) r))

(defun popadanie (x y) 
    (cond ((and (>= y 0) (<= y (sin x))) t)
    (t nil))
)

(defun popadanie_if (x y) 
    (if (and (>= y 0) (<= y (sin x))) 
    t
    nil)
)

(defun popadanie_when (x y) 
    (unless (or (< y 0) (> y (sin x))) 
    t)
)

(defun popadanie_unless (x y) 
    (if (and (>= y 0) (<= y (sin x))) 
    t
    nil)
)

; (write (plosh 5))
; (terpri)
; (write (popadanie 1 0.5))
; (terpri)

(setq list1 '(a b c))
(setq list2 '(d e f))
(write ((lambda (z) 
    (cons z ((lambda (x y) (cons x(cons y nil))) 'a 'b))) 
    'c))
; (write ((lambda (x) 
;     (* x ((lambda (y z) (+ y z)) 2 3))) 
;     2))