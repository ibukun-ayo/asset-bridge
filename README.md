# AssetBridge Protocol

> Universal Digital Asset Liquidity Engine

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Clarity](https://img.shields.io/badge/clarity-v2-orange.svg)](https://clarity-lang.org/)
[![Stacks](https://img.shields.io/badge/stacks-blockchain-purple.svg)](https://www.stacks.co/)

## Overview

AssetBridge Protocol is a revolutionary decentralized liquidity protocol that transforms digital asset management by providing instant access to capital through secure, over-collateralized lending mechanisms with intelligent risk assessment and autonomous portfolio management capabilities.

The protocol establishes a new paradigm in decentralized finance by creating seamless bridges between asset ownership and capital access, designed for both retail and institutional participants while maintaining the highest standards of security and transparency.

## 🚀 Key Features

### 🔧 Dynamic Risk Engine

- Advanced algorithms continuously assess and adjust risk parameters based on real-time market conditions
- Intelligent collateralization ratio management (150% minimum, 120% liquidation threshold)
- Automated liquidation protection to prevent position deterioration

### ⚡ Instant Liquidity Access

- Zero-delay capital deployment without asset liquidation requirements
- Over-collateralized lending with competitive interest rates (5% annual)
- Seamless borrowing experience with automated loan management

### 🏗️ Multi-Asset Support Framework

- Extensible architecture enabling diverse digital asset integration
- Currently supports BTC and STX with easy expansion capability
- Comprehensive asset validation and price oracle integration

### 🛡️ Autonomous Liquidation Protection

- Proactive monitoring prevents position deterioration through predictive interventions
- Transparent liquidation process with borrower protection mechanisms
- Real-time collateral ratio monitoring and alerts

### 📊 Decentralized Oracle Network

- Multiple price feed aggregation ensures maximum accuracy
- Manipulation resistance through validated price bounds
- Real-time asset valuation for accurate risk calculations

## 🏛️ Architecture

### Contract Structure

```text
AssetBridge Protocol
├── System Configuration & Constants
├── Protocol State Management
├── Data Architecture & Storage Maps
├── Private Utility Functions
├── Public Interface - Core Protocol Functions
├── Governance & Protocol Administration
└── Read-Only Data Access Interface
```

### Core Components

#### State Variables

- `platform-initialized`: Protocol operational status
- `minimum-collateral-ratio`: Risk management parameter (150%)
- `liquidation-threshold`: Liquidation trigger point (120%)
- `total-btc-locked`: Global collateral metrics
- `total-loans-issued`: Loan tracking counter

#### Data Maps

- `loans`: Primary loan registry with comprehensive loan details
- `user-loans`: User loan tracking for portfolio management
- `collateral-prices`: Oracle price feed data storage

## 🔧 Installation & Setup

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) CLI tool
- [Node.js](https://nodejs.org/) (v16 or higher)
- [Stacks CLI](https://docs.stacks.co/understand-stacks/command-line-interface)

### Quick Start

1. **Clone the repository**

   ```bash
   git clone https://github.com/ibukun-ayo/asset-bridge.git
   cd asset-bridge
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

3. **Check contract validity**

   ```bash
   clarinet check
   ```

4. **Run tests**

   ```bash
   npm test
   ```

5. **Deploy to testnet**

   ```bash
   clarinet deploy --testnet
   ```

## 📝 Usage Examples

### Initialize Platform

```clarity
;; Initialize the AssetBridge Protocol (Owner only)
(contract-call? .asset-bridge initialize-platform)
```

### Deposit Collateral

```clarity
;; Deposit BTC as collateral
(contract-call? .asset-bridge deposit-collateral u100000000) ;; 1 BTC in satoshis
```

### Request Loan

```clarity
;; Request loan with 1.5 BTC collateral for 0.5 BTC loan
(contract-call? .asset-bridge request-loan u150000000 u50000000)
```

### Repay Loan

```clarity
;; Repay loan with interest
(contract-call? .asset-bridge repay-loan u1 u52500000) ;; loan-id + amount with interest
```

### Update Price Feed (Owner)

```clarity
;; Update BTC price oracle
(contract-call? .asset-bridge update-price-feed "BTC" u4500000000000) ;; $45,000 per BTC
```

## 🔍 API Reference

### Public Functions

#### Platform Management

- `initialize-platform()` - Activates the protocol for operation
- `update-collateral-ratio(new-ratio)` - Adjusts minimum collateralization requirements
- `update-liquidation-threshold(new-threshold)` - Modifies liquidation trigger points
- `update-price-feed(asset, new-price)` - Updates oracle price feeds

#### Core Lending Operations

- `deposit-collateral(amount)` - Secures digital assets in protocol vault
- `request-loan(collateral, loan-amount)` - Creates new collateralized loan
- `repay-loan(loan-id, amount)` - Processes loan repayment with interest

#### Read-Only Functions

- `get-loan-details(loan-id)` - Retrieves comprehensive loan information
- `get-user-loans(user)` - Returns all active loan positions for user
- `get-platform-stats()` - Provides real-time protocol metrics
- `get-valid-assets()` - Lists supported collateral assets

### Error Codes

| Code | Error | Description |
|------|-------|-------------|
| u100 | ERR-NOT-AUTHORIZED | Unauthorized access attempt |
| u101 | ERR-INSUFFICIENT-COLLATERAL | Inadequate collateral for loan |
| u102 | ERR-BELOW-MINIMUM | Amount below minimum threshold |
| u103 | ERR-INVALID-AMOUNT | Invalid amount specified |
| u104 | ERR-ALREADY-INITIALIZED | Platform already initialized |
| u105 | ERR-NOT-INITIALIZED | Platform not yet initialized |
| u106 | ERR-INVALID-LIQUIDATION | Invalid liquidation attempt |
| u107 | ERR-LOAN-NOT-FOUND | Loan identifier not found |
| u108 | ERR-LOAN-NOT-ACTIVE | Loan not in active state |
| u109 | ERR-INVALID-LOAN-ID | Invalid loan identifier |
| u110 | ERR-INVALID-PRICE | Invalid price feed data |
| u111 | ERR-INVALID-ASSET | Unsupported asset type |

## 🧪 Testing

The protocol includes comprehensive test coverage using Vitest and Clarinet testing framework.

```bash
# Run all tests
npm test

# Run specific test file
npx vitest run tests/asset-bridge.test.ts

# Run tests with coverage
npm run test:coverage
```

### Test Structure

```text
tests/
├── asset-bridge.test.ts      # Core protocol functionality tests
├── fixtures/                 # Test data and mock scenarios
└── utils/                   # Testing utilities and helpers
```

## 🚀 Deployment

### Development Environment

```bash
# Start local blockchain
clarinet integrate

# Deploy to local environment
clarinet deploy --devnet
```

### Testnet Deployment

```bash
# Configure testnet settings
clarinet deployment generate --testnet

# Deploy to Stacks testnet
clarinet deployment apply --testnet
```

### Mainnet Deployment

```bash
# Configure mainnet settings
clarinet deployment generate --mainnet

# Deploy to Stacks mainnet
clarinet deployment apply --mainnet
```

## 🔐 Security Considerations

### Risk Management

- **Collateralization**: 150% minimum collateral ratio ensures protocol solvency
- **Liquidation**: 120% threshold provides borrower protection while maintaining security
- **Price Oracle**: Validated price feeds with manipulation resistance
- **Access Control**: Owner-only administrative functions with proper authorization checks

### Best Practices

- Always verify loan details before repayment
- Monitor collateral ratios to avoid liquidation
- Use appropriate gas limits for complex transactions
- Validate all user inputs and error handling

### Audit Status

- [ ] Internal security review completed
- [ ] External security audit pending
- [ ] Bug bounty program active

## 🤝 Contributing

We welcome contributions to the AssetBridge Protocol! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Standards

- Follow Clarity best practices and conventions
- Include comprehensive test coverage
- Document all public functions and complex logic
- Use meaningful variable and function names
- Maintain consistent code formatting

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support & Community

- **Documentation**: [AssetBridge Docs](https://docs.assetbridge.io)
- **Discord**: [Join our community](https://discord.gg/assetbridge)
- **Twitter**: [@AssetBridge](https://twitter.com/assetbridge)
- **Email**: [support@assetbridge.io](mailto:support@assetbridge.io)

## 🗺️ Roadmap

### Phase 1 - Core Protocol (Current)

- [x] Basic lending and borrowing functionality
- [x] Collateral management system
- [x] Oracle price feed integration
- [x] Liquidation mechanism

### Phase 2 - Advanced Features

- [ ] Multi-asset collateral pools
- [ ] Dynamic interest rate models
- [ ] Governance token integration
- [ ] Flash loan capabilities

### Phase 3 - Ecosystem Expansion

- [ ] Cross-chain bridge integration
- [ ] Institutional lending features
- [ ] Advanced portfolio management
- [ ] Mobile application interface

## 📊 Protocol Statistics

*Real-time statistics available through the `get-platform-stats()` function*

- **Total Value Locked**: Dynamic based on collateral deposits
- **Active Loans**: Real-time loan tracking
- **Collateralization Ratio**: Current 150% minimum
- **Supported Assets**: BTC, STX (expanding)
