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

(write (plosh 5))
(terpri)
(write (popadanie 1 0.5))