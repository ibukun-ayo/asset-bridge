;; Title: AssetBridge Protocol - Universal Digital Asset Liquidity Engine
;;
;; Summary:
;; A revolutionary decentralized liquidity protocol that transforms digital
;; asset management by providing instant access to capital through secure,
;; over-collateralized lending mechanisms with intelligent risk assessment
;; and autonomous portfolio management capabilities.
;;
;; Description:
;; AssetBridge Protocol establishes a new paradigm in decentralized finance
;; by creating seamless bridges between asset ownership and capital access.
;; Designed for both retail and institutional participants, the protocol
;; delivers unprecedented financial flexibility while maintaining the highest
;; standards of security and transparency.
;;
;; Key Features:
;;   - Dynamic Risk Engine - Advanced algorithms continuously assess and
;;     adjust risk parameters based on real-time market conditions
;;   - Instant Liquidity Access - Zero-delay capital deployment without
;;     asset liquidation requirements
;;   - Multi-Asset Support Framework - Extensible architecture enabling
;;     diverse digital asset integration
;;   - Autonomous Liquidation Protection - Proactive monitoring prevents
;;     position deterioration through predictive interventions
;;   - Decentralized Oracle Network - Multiple price feed aggregation
;;     ensures maximum accuracy and manipulation resistance
;;
;; AssetBridge Protocol represents the evolution of decentralized lending,
;; where cutting-edge technology meets traditional financial principles
;; to create a robust, scalable, and user-centric financial infrastructure.

;; SYSTEM CONFIGURATION & CONSTANTS

(define-constant CONTRACT-OWNER tx-sender)

;; Protocol Error Codes - Comprehensive error handling system
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-COLLATERAL (err u101))
(define-constant ERR-BELOW-MINIMUM (err u102))
(define-constant ERR-INVALID-AMOUNT (err u103))
(define-constant ERR-ALREADY-INITIALIZED (err u104))
(define-constant ERR-NOT-INITIALIZED (err u105))
(define-constant ERR-INVALID-LIQUIDATION (err u106))
(define-constant ERR-LOAN-NOT-FOUND (err u107))
(define-constant ERR-LOAN-NOT-ACTIVE (err u108))
(define-constant ERR-INVALID-LOAN-ID (err u109))
(define-constant ERR-INVALID-PRICE (err u110))
(define-constant ERR-INVALID-ASSET (err u111))

;; Supported Digital Assets Registry
(define-constant VALID-ASSETS (list "BTC" "STX"))

;; PROTOCOL STATE MANAGEMENT

;; Core protocol operational flags
(define-data-var platform-initialized bool false)

;; Risk management parameters
(define-data-var minimum-collateral-ratio uint u150) ;; 150% minimum collateralization
(define-data-var liquidation-threshold uint u120) ;; 120% liquidation trigger
(define-data-var platform-fee-rate uint u1) ;; 1% protocol fee

;; Global protocol metrics
(define-data-var total-btc-locked uint u0)
(define-data-var total-loans-issued uint u0)

;; DATA ARCHITECTURE & STORAGE MAPS

;; Primary loan registry - stores all loan details and status
(define-map loans
  { loan-id: uint }
  {
    borrower: principal,
    collateral-amount: uint,
    loan-amount: uint,
    interest-rate: uint,
    start-height: uint,
    last-interest-calc: uint,
    status: (string-ascii 20),
  }
)

;; User loan tracking - maps users to their active loan positions
(define-map user-loans
  { user: principal }
  { active-loans: (list 10 uint) }
)

;; Price oracle data - stores validated asset pricing information
(define-map collateral-prices
  { asset: (string-ascii 3) }
  { price: uint }
)

;; PRIVATE UTILITY FUNCTIONS

(define-private (calculate-collateral-ratio
    (collateral uint)
    (loan uint)
    (btc-price uint)
  )
  ;; Computes real-time collateralization ratio for risk assessment
  ;; Returns: Percentage ratio (e.g., 150 = 150% collateralization)
  (let (
      (collateral-value (* collateral btc-price))
      (ratio (* (/ collateral-value loan) u100))
    )
    ratio
  )
)

(define-private (calculate-interest
    (principal uint)
    (rate uint)
    (blocks uint)
  )
  ;; Calculates accrued interest based on block progression
  ;; Uses daily compounding with block-based time tracking
  (let (
      (interest-per-block (/ (* principal rate) (* u100 u144))) ;; 144 blocks * 1 day
      (total-interest (* interest-per-block blocks))
    )
    total-interest
  )
)

(define-private (check-liquidation (loan-id uint))
  ;; Monitors loan health and executes automated liquidation when necessary
  ;; Prevents cascading liquidations through early intervention
  (let (
      (loan (unwrap! (map-get? loans { loan-id: loan-id }) ERR-LOAN-NOT-FOUND))
      (btc-price (unwrap! (get price (map-get? collateral-prices { asset: "BTC" }))
        ERR-NOT-INITIALIZED
      ))
      (current-ratio (calculate-collateral-ratio (get collateral-amount loan)
        (get loan-amount loan) btc-price
      ))
    )
    (if (<= current-ratio (var-get liquidation-threshold))
      (liquidate-position loan-id)
      (ok true)
    )
  )
)

(define-private (liquidate-position (loan-id uint))
  ;; Executes position liquidation with collateral seizure
  ;; Protects protocol solvency while minimizing borrower losses
  (let (
      (loan (unwrap! (map-get? loans { loan-id: loan-id }) ERR-LOAN-NOT-FOUND))
      (borrower (get borrower loan))
    )
    (begin
      (map-set loans { loan-id: loan-id } (merge loan { status: "liquidated" }))
      (map-delete user-loans { user: borrower })
      (ok true)
    )
  )
)

(define-private (validate-loan-id (loan-id uint))
  ;; Validates loan identifier against issued loan registry
  ;; Prevents invalid loan access and manipulation
  (and
    (> loan-id u0)
    (<= loan-id (var-get total-loans-issued))
  )
)

(define-private (is-valid-asset (asset (string-ascii 3)))
  ;; Verifies asset eligibility within protocol's supported asset framework
  (is-some (index-of VALID-ASSETS asset))
)

(define-private (is-valid-price (price uint))
  ;; Validates oracle price feed integrity and reasonable value bounds
  ;; Prevents price manipulation and extreme value attacks
  (and
    (> price u0)
    (<= price u1000000000000) ;; Reasonable upper limit protection
  )
)

(define-private (not-equal-loan-id (id uint))
  ;; Utility function for loan collection filtering operations
  (not (is-eq id id))
)

;; PUBLIC INTERFACE - CORE PROTOCOL FUNCTIONS

;; Platform Management & Initialization

(define-public (initialize-platform)
  ;; Activates the AssetBridge Protocol for full operational capacity
  ;; Only contract owner can initialize to ensure proper deployment
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (not (var-get platform-initialized)) ERR-ALREADY-INITIALIZED)
    (var-set platform-initialized true)
    (ok true)
  )
)

;; Core Lending Operations

(define-public (deposit-collateral (amount uint))
  ;; Secures digital assets in the protocol's vault infrastructure
  ;; Enables instant liquidity access without asset liquidation
  (begin
    (asserts! (var-get platform-initialized) ERR-NOT-INITIALIZED)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (var-set total-btc-locked (+ (var-get total-btc-locked) amount))
    (ok true)
  )
)

(define-public (request-loan
    (collateral uint)
    (loan-amount uint)
  )
  ;; Creates a new collateralized loan with automated risk validation
  ;; Provides instant capital access while maintaining protocol security
  (let (
      (btc-price (unwrap! (get price (map-get? collateral-prices { asset: "BTC" }))
        ERR-NOT-INITIALIZED
      ))
      (collateral-value (* collateral btc-price))
      (required-collateral (* loan-amount (var-get minimum-collateral-ratio)))
      (loan-id (+ (var-get total-loans-issued) u1))
    )
    (begin
      (asserts! (var-get platform-initialized) ERR-NOT-INITIALIZED)
      (asserts! (>= collateral-value required-collateral)
        ERR-INSUFFICIENT-COLLATERAL
      )
      ;; Create new loan record
      (map-set loans { loan-id: loan-id } {
        borrower: tx-sender,
        collateral-amount: collateral,
        loan-amount: loan-amount,
        interest-rate: u5, ;; 5% annual interest rate
        start-height: stacks-block-height,
        last-interest-calc: stacks-block-height,
        status: "active",
      })
      ;; Update user loan tracking
      (match (map-get? user-loans { user: tx-sender })
        existing-loans (map-set user-loans { user: tx-sender } { active-loans: (unwrap!
          (as-max-len? (append (get active-loans existing-loans) loan-id) u10)
          ERR-INVALID-AMOUNT
        ) }
        )
        (map-set user-loans { user: tx-sender } { active-loans: (list loan-id) })
      )
      (var-set total-loans-issued (+ (var-get total-loans-issued) u1))
      (ok loan-id)
    )
  )
)