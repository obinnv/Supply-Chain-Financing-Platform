;; Credit Scoring Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))

(define-map credit-scores
  { participant: principal }
  {
    score: uint,
    last-updated: uint
  }
)

(define-public (update-credit-score (participant principal) (new-score uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set credit-scores
      { participant: participant }
      {
        score: new-score,
        last-updated: block-height
      }))))

(define-read-only (get-credit-score (participant principal))
  (ok (unwrap! (map-get? credit-scores { participant: participant }) err-not-authorized)))

