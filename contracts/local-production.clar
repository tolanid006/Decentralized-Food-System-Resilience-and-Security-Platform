(define-constant ERR-INVALID-INPUT (err u1000))
(define-constant ERR-NOT-AUTHORIZED (err u1001))
(define-constant ERR-INSUFFICIENT-BALANCE (err u1002))
(define-constant ERR-ALREADY-EXISTS (err u1003))
(define-constant ERR-NOT-FOUND (err u1004))
(define-constant ERR-PRODUCTION-HALTED (err u1005))

(define-data-var production-active bool true)
(define-data-var price uint u10)
(define-data-var supply uint u100)
(define-data-var owner principal tx-sender)

(define-read-only (get-price)
  (var-get price)
)

(define-read-only (get-supply)
  (var-get supply)
)

(define-read-only (is-production-active)
  (var-get production-active)
)

(define-read-only (get-owner)
  (var-get owner)
)

(define-public (set-price (new-price uint))
  (begin
    (asserts! (is-eq tx-sender (var-get owner)) ERR-NOT-AUTHORIZED)
    (var-set price new-price)
    (ok true)
  )
)

(define-public (set-supply (new-supply uint))
  (begin
    (asserts! (is-eq tx-sender (var-get owner)) ERR-NOT-AUTHORIZED)
    (var-set supply new-supply)
    (ok true)
  )
)

(define-public (toggle-production (active bool))
  (begin
    (asserts! (is-eq tx-sender (var-get owner)) ERR-NOT-AUTHORIZED)
    (var-set production-active active)
    (ok true)
  )
)

(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-eq tx-sender (var-get owner)) ERR-NOT-AUTHORIZED)
    (var-set owner new-owner)
    (ok true)
  )
)

(define-public (produce (quantity uint) (quality-rating uint))
  (begin
    (asserts! (var-get production-active) ERR-PRODUCTION-HALTED)
    (asserts! (>= quality-rating u1) ERR-INVALID-INPUT)
    (asserts! (<= quality-rating u10) ERR-INVALID-INPUT)
    (asserts! (>= (var-get supply) quantity) ERR-INSUFFICIENT-BALANCE)

    (var-set supply (- (var-get supply) quantity))

    (ok {quantity: quantity, quality: quality-rating})
  )
)
