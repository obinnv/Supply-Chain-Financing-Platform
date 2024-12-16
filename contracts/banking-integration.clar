;; Banking Integration Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-insufficient-funds (err u102))

(define-map fiat-balances
  { account: principal }
  { balance: uint }
)

(define-public (deposit-fiat (amount uint))
  (let
    ((current-balance (default-to { balance: u0 } (map-get? fiat-balances { account: tx-sender }))))
    (ok (map-set fiat-balances
      { account: tx-sender }
      { balance: (+ (get balance current-balance) amount) }))))

(define-public (withdraw-fiat (amount uint))
  (let
    ((current-balance (default-to { balance: u0 } (map-get? fiat-balances { account: tx-sender }))))
    (asserts! (>= (get balance current-balance) amount) err-insufficient-funds)
    (ok (map-set fiat-balances
      { account: tx-sender }
      { balance: (- (get balance current-balance) amount) }))))

(define-read-only (get-fiat-balance (account principal))
  (ok (get balance (default-to { balance: u0 } (map-get? fiat-balances { account: account })))))

