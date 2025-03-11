;; Claim Verification Contract
;; Assesses and approves insurance claims

(define-map claims
  { claim-id: uint }
  {
    policy-id: uint,
    amount: uint,
    coverage-amount: uint,
    description: (string-ascii 1000),
    status: (string-ascii 20),
    submitted-by: principal,
    submitted-at: uint,
    verified-by: (optional principal),
    verified-at: (optional uint)
  }
)

(define-data-var claim-nonce uint u0)
(define-constant contract-owner tx-sender)

(define-read-only (get-claim (claim-id uint))
  (map-get? claims { claim-id: claim-id })
)

(define-public (submit-claim (policy-id uint) (amount uint) (coverage-amount uint) (description (string-ascii 1000)))
  (let
    (
      (new-claim-id (+ (var-get claim-nonce) u1))
    )
    (asserts! (<= amount coverage-amount) (err u401))
    (var-set claim-nonce new-claim-id)
    (ok (map-set claims
      { claim-id: new-claim-id }
      {
        policy-id: policy-id,
        amount: amount,
        coverage-amount: coverage-amount,
        description: description,
        status: "pending",
        submitted-by: tx-sender,
        submitted-at: block-height,
        verified-by: none,
        verified-at: none
      }
    ))
  )
)

(define-public (verify-claim (claim-id uint) (approved bool))
  (let
    (
      (claim (unwrap! (get-claim claim-id) (err u404)))
    )
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (asserts! (is-eq (get status claim) "pending") (err u400))
    (ok (map-set claims
      { claim-id: claim-id }
      (merge claim {
        status: (if approved "approved" "rejected"),
        verified-by: (some tx-sender),
        verified-at: (some block-height)
      })
    ))
  )
)

(define-public (process-claim (claim-id uint))
  (let
    (
      (claim (unwrap! (get-claim claim-id) (err u404)))
    )
    (asserts! (is-eq (get status claim) "approved") (err u400))
    ;; Here you would typically call a function to process the payout
    ;; For simplicity, we'll just update the status
    (ok (map-set claims
      { claim-id: claim-id }
      (merge claim { status: "processed" })
    ))
  )
)

