;; Policy Creation Contract
;; Defines insurance terms and coverage

(define-map policies
  { policy-id: uint }
  {
    owner: principal,
    coverage-amount: uint,
    premium: uint,
    start-date: uint,
    end-date: uint,
    terms: (string-ascii 1000),
    status: (string-ascii 20)
  }
)

(define-data-var policy-nonce uint u0)

(define-read-only (get-policy (policy-id uint))
  (map-get? policies { policy-id: policy-id })
)

(define-public (create-policy (coverage-amount uint) (premium uint) (duration uint) (terms (string-ascii 1000)))
  (let
    (
      (new-policy-id (+ (var-get policy-nonce) u1))
      (start-block block-height)
      (end-block (+ block-height duration))
    )
    (var-set policy-nonce new-policy-id)
    (ok (map-set policies
      { policy-id: new-policy-id }
      {
        owner: tx-sender,
        coverage-amount: coverage-amount,
        premium: premium,
        start-date: start-block,
        end-date: end-block,
        terms: terms,
        status: "active"
      }
    ))
  )
)

(define-public (cancel-policy (policy-id uint))
  (let
    (
      (policy (unwrap! (get-policy policy-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get owner policy)) (err u403))
    (asserts! (is-eq (get status policy) "active") (err u400))
    (ok (map-set policies
      { policy-id: policy-id }
      (merge policy { status: "cancelled" })
    ))
  )
)

(define-read-only (is-policy-active (policy-id uint))
  (match (get-policy policy-id)
    policy (and
      (is-eq (get status policy) "active")
      (<= (get start-date policy) block-height)
      (> (get end-date policy) block-height)
    )
    false
  )
)

