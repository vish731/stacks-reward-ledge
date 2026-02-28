;; reward-ledger.clar
;; Tracks user reward points on Stacks

(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-NO-BALANCE (err u402))

(define-data-var admin principal tx-sender)
(define-map balances principal uint)

;; Add rewards (admin only)
(define-public (add-reward (user principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) ERR-NOT-AUTHORIZED)
    (let ((current (default-to u0 (map-get? balances user))))
      (map-set balances user (+ current amount))
    )
    (ok amount)
  )
)

;; Claim rewards
(define-public (claim (amount uint))
  (let ((bal (default-to u0 (map-get? balances tx-sender))))
    (asserts! (>= bal amount) ERR-NO-BALANCE)
    (map-set balances tx-sender (- bal amount))
    (ok amount)
  )
)

;; Read balance
(define-read-only (get-balance (user principal))
  (ok (default-to u0 (map-get? balances user)))
)