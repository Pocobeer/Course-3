((lambda (r) (* pi r r)) 5)

(defun plosh (r) (* pi r r))

(defun popadanie (x y) 
    (cond ((and (>= y 0) (<= y (sin x))) t)
    (t nil))
)