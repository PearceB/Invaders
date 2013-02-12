;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |assignment 5- space invaders game 1|) (read-case-sensitive #t) (teachpacks ((lib "image.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.ss" "teachpack" "2htdp") (lib "universe.ss" "teachpack" "2htdp")))))
; Space Invaders 1: Shooting

; Physical Constants

(define HEIGHT 80)
(define WIDTH 100)
(define XSHOTS (/ WIDTH 2))

; Graphical Constants

(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define SHOT (triangle 3 "solid" "red"))

; A List-of-shots is one of: 
; – empty
; – (cons Shot List-of-shots)
; interp.: the collection of shots fired and moving straight up

; A Shot is a Number. 
; interp.: the number represents the shot's y coordinate 

; A ShotWorld is List-of-numbers. 
; interp.: the collection of shots fired and moving straight up

; Number -> Boolean
; Determine if the y-value off a number is less than 0
(check-expect (off-top 7) false)
(check-expect (off-top -7) true)

(define (off-top n)
  (if (<= n 0) true false))

; ShotWorld -> ShotWorld 
; move each shot up by one pixel
(check-expect (tock empty) empty)
(check-expect (tock (list 7 5)) (list 6 4))
(check-expect (tock (list 3 3 3 3 3)) (list 2 2 2 2 2))
(check-expect (tock (list -8 -7)) empty)

(define (tock w)
  (cond
    [(empty? w) empty]
    [(off-top (first w)) (tock (rest w))]
    [else (cons (sub1 (first w)) (tock (rest w)))]))

; ShotWorld KeyEvent -> ShotWorld 
; add a shot to the world if the space bar was hit 
(check-expect (keyh (list 2 3 4) " ") (list 80 2 3 4))
(check-expect (keyh (list 1 2) "k") (list 1 2))
(check-expect (keyh empty " ") (list 80))

(define (keyh w ke)
  (cond
    [(key=? ke " ") (cons HEIGHT w)]
    [else w]))

; ShotWorld -> Image 
; add each shot y on w at (MID,y) to the background image 
(check-expect (to-image empty) BACKGROUND)
(check-expect (to-image (list 1 2 3)) (place-image SHOT XSHOTS 1
                                                  (place-image SHOT XSHOTS 2
                                                               (place-image SHOT XSHOTS 3 BACKGROUND))))

(define (to-image w)
  (cond
    [(empty? w) BACKGROUND]
    [else (place-image SHOT XSHOTS (first w) (to-image (rest w)))]))

; ShotWorld -> ShotWorld
; Create a ShotWorld that allows the user to play Space Invaders

(define (main w0)
  (big-bang w0
            (on-tick tock)
            (on-key keyh)
            (to-draw to-image)))