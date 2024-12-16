;; Payment Automation Contract

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-invalid-delivery (err u102))

(define-map deliveries
  { delivery-id: uint }
  {
    invoice-id: uint,
    confirmed: bool
  }
)

(define-data-var last-delivery-id uint u0)

(define-public (create-delivery (invoice-id uint))
  (let
    ((delivery-id (+ (var-get last-delivery-id) u1)))
    (map-set deliveries
      { delivery-id: delivery-id }
      {
        invoice-id: invoice-id,
        confirmed: false
      })
    (var-set last-delivery-id delivery-id)
    (ok delivery-id)))

(define-public (confirm-delivery (delivery-id uint))
  (let
    ((delivery (unwrap! (map-get? deliveries { delivery-id: delivery-id }) err-invalid-delivery)))
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set deliveries
      { delivery-id: delivery-id }
      (merge delivery { confirmed: true })))))

(define-read-only (get-delivery (delivery-id uint))
  (ok (unwrap! (map-get? deliveries { delivery-id: delivery-id }) err-invalid-delivery)))

