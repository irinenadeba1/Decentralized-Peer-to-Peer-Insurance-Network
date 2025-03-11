;; Risk Pool Contract
;; Manages shared funds for claim payouts

(define-map risk-pools
  { pool-id: uint }
  {
    total-funds: uint,
    total-coverage: uint,
    member-count: uint
  }
)

(define-map pool-members
  { pool-id: uint, member: principal }
  {
    policy-id: uint,
    coverage-amount: uint,
    premium: uint
  }
)

(define-data-var pool-nonce uint u0)

(define-read-only (get-risk-pool (pool-id uint))
  (map-get? risk-pools { pool-id: pool-id })
)

(define-read-only (get-pool-member (pool-id uint) (member principal))
  (map-get? pool-members { pool-id: pool-id, member: member })
)

(define-public (create-risk-pool)
  (let
    (
      (new-pool-id (+ (var-get pool-nonce) u1))
    )
    (var-set pool-nonce new-pool-id)
    (ok (map-set risk-pools
      { pool-id: new-pool-id }
      {
        total-funds: u0,
        total-coverage: u0,
        member-count: u0
      }
    ))
  )
)

(define-public (join-risk-pool (pool-id uint) (policy-id uint) (coverage-amount uint) (premium uint))
  (let
    (
      (pool (unwrap! (get-risk-pool pool-id) (err u404)))
    )
    (map-set pool-members
      { pool-id: pool-id, member: tx-sender }
      {
        policy-id: policy-id,
        coverage-amount: coverage-amount,
        premium: premium
      }
    )
    (ok (map-set risk-pools
      { pool-id: pool-id }
      {
        total-funds: (+ (get total-funds pool) premium),
        total-coverage: (+ (get total-coverage pool) coverage-amount),
        member-count: (+ (get member-count pool) u1)
      }
    ))
  )
)

(define-public (leave-risk-pool (pool-id uint))
  (let
    (
      (pool (unwrap! (get-risk-pool pool-id) (err u404)))
      (member-info (unwrap! (get-pool-member pool-id tx-sender) (err u404)))
    )
    (map-delete pool-members { pool-id: pool-id, member: tx-sender })
    (ok (map-set risk-pools
      { pool-id: pool-id }
      {
        total-funds: (- (get total-funds pool) (get premium member-info)),
        total-coverage: (- (get total-coverage pool) (get coverage-amount member-info)),
        member-count: (- (get member-count pool) u1)
      }
    ))
  )
)

(define-public (process-payout (pool-id uint) (amount uint))
  (let
    (
      (pool (unwrap! (get-risk-pool pool-id) (err u404)))
    )
    (asserts! (<= amount (get total-funds pool)) (err u401))
    (ok (map-set risk-pools
      { pool-id: pool-id }
      (merge pool { total-funds: (- (get total-funds pool) amount) })
    ))
  )
)

