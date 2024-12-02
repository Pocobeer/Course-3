((lambda (r) (* pi r r)) 5)

(defun plosh (r) ((lambda (r) (* pi r r)) r))

(defun popadanie (x y) 
    (cond ((and (>= y 0) (<= y (sin x))) t)
    (t nil))
)

(write (plosh 5))
(terpri)
(write (popadanie 1 0.5))