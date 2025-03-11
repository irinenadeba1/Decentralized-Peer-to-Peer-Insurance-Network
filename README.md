# Decentralized Peer-to-Peer Insurance Network

A blockchain-based solution for managing peer-to-peer insurance policies, risk pools, claims, and premium adjustments, built on the Stacks blockchain using Clarity smart contracts.

## Overview

This platform provides a set of smart contracts to handle various aspects of decentralized insurance:

1. Policy Creation
2. Risk Pool Management
3. Claim Verification
4. Premium Adjustment

These contracts work together to create a transparent, efficient, and decentralized insurance system.

## Contracts

### Policy Creation Contract

Manages the creation and lifecycle of insurance policies.

Key functions:
- `create-policy`: Create a new insurance policy
- `cancel-policy`: Cancel an existing policy
- `is-policy-active`: Check if a policy is currently active

### Risk Pool Contract

Handles the management of shared risk pools for claim payouts.

Key functions:
- `create-risk-pool`: Create a new risk pool
- `join-risk-pool`: Join an existing risk pool with a policy
- `leave-risk-pool`: Leave a risk pool

### Claim Verification Contract

Manages the submission, verification, and processing of insurance claims.

Key functions:
- `submit-claim`: Submit a new insurance claim
- `verify-claim`: Verify and approve/reject a claim
- `process-claim`: Process an approved claim for payout

### Premium Adjustment Contract

Handles the calculation and adjustment of policy premiums based on risk factors.

Key functions:
- `update-risk-score`: Update the risk score for a policy
- `calculate-premium`: Calculate the premium based on risk score
- `adjust-premium`: Adjust the premium for a policy

## Getting Started

1. Clone this repository
2. Install dependencies (if any)
3. Deploy the contracts to a Stacks blockchain network
4. Interact with the contracts using a Stacks wallet or custom frontend

## Testing

Each contract has a corresponding test file in the `tests` directory. To run the tests:

1. Ensure you have Vitest installed
2. Run `npm test` or `yarn test` in the project directory

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

