;; Invoice Tokenization Contract

(define-fungible-token invoice-token)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-invalid-invoice (err u102))

(define-map invoices
  { invoice-id: uint }
  {
    supplier: principal,
    buyer: principal,
    amount: uint,
    due-date: uint,
    status: (string-ascii 20)
  }
)

(define-data-var last-invoice-id uint u0)

(define-public (create-invoice (buyer principal) (amount uint) (due-date uint))
  (let
    ((invoice-id (+ (var-get last-invoice-id) u1)))
    (try! (ft-mint? invoice-token amount tx-sender))
    (map-set invoices
      { invoice-id: invoice-id }
      {
        supplier: tx-sender,
        buyer: buyer,
        amount: amount,
        due-date: due-date,
        status: "active"
      })
    (var-set last-invoice-id invoice-id)
    (ok invoice-id)))

(define-public (transfer-invoice (invoice-id uint) (recipient principal))
  (let
    ((invoice (unwrap! (map-get? invoices { invoice-id: invoice-id }) err-invalid-invoice)))
    (asserts! (is-eq tx-sender (get supplier invoice)) err-not-authorized)
    (try! (ft-transfer? invoice-token (get amount invoice) tx-sender recipient))
    (ok (map-set invoices
      { invoice-id: invoice-id }
      (merge invoice { supplier: recipient })))))

(define-public (settle-invoice (invoice-id uint))
  (let
    ((invoice (unwrap! (map-get? invoices { invoice-id: invoice-id }) err-invalid-invoice)))
    (asserts! (is-eq tx-sender (get buyer invoice)) err-not-authorized)
    (try! (ft-burn? invoice-token (get amount invoice) (get supplier invoice)))
    (ok (map-set invoices
      { invoice-id: invoice-id }
      (merge invoice { status: "settled" })))))

(define-read-only (get-invoice (invoice-id uint))
  (ok (unwrap! (map-get? invoices { invoice-id: invoice-id }) err-invalid-invoice)))

(define-read-only (get-balance (account principal))
  (ok (ft-get-balance invoice-token account)))

