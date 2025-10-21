

# 🌐 **Ethereum Security Masterclass**

## 🛡️ The 2 Contracts a Day Challenge & Web3 Compass S3

This repository is a live, high-intensity training environment dedicated to accelerated mastery of **Solidity smart contract security and auditing**. It documents a rigorous personal commitment to building and analyzing **two functional Ethereum contracts every single day.**

This challenge merges high-volume development with the structured curriculum of the **Web3 Compass 30 Days of Solidity - Season 3**, ensuring both breadth and depth of technical exposure essential for professional bug bounty hunting.

-----

## 🎯 **Core Objective: Mastery Through Volume**

The entire repository is built with a singular focus: to train the "auditor's eye" through constant, deliberate practice.

| Goal | Description | Expected Outcome |
| :--- | :--- | :--- |
| **Security First** | Active implementation and demonstration of all major vulnerabilities (e.g., Reentrancy, Call Injection, Logic Flaws, MEV opportunities). | Muscle memory for identifying complex, high-severity bugs in production code. |
| **Protocol Fluency** | Hands-on development of core DeFi primitives, token standards (ERC-20, ERC-721), and upgradeability patterns. | Deep understanding of how common exploits impact real-world financial protocols. |
| **High Velocity** | Building and documenting **two fully tested contracts daily** (Challenge + Personal Deep Dive). | Rapidly expanding technical vocabulary and problem-solving speed under pressure. |

-----

## 📂 **Repository Structure**

The projects are organized sequentially by the challenge day, making it easy to track progress and specific security research.

```
/src
├── Day_04_Auction              # Web3 Compass Day 4 Challenge: Basic Auction
│   ├── BasicAuction.sol         
│   ├── VulnerableProxy.sol       # Second, security-focused contract of the day
│   └── README.md                 # Detailed Security Report & Learnings
├── Day_05_Vault                # Web3 Compass Day 5 Challenge: Secure Vault
│   └── ...
├── Day_X_Custom                 # Future days following the track...
└── ...
```

### **Daily Security Report (Example)**

Each folder contains a `README.md` that serves as a **Daily Security Report**. This report is the critical documentation, outlining the **vulnerability addressed** or **design pattern mastered**.

| Contract | Theme | Key Security Takeaway |
| :--- | :--- | :--- |
| **Challenge Contract** | **DeFi Primitive** | **CEI pattern** enforced to secure against Reentrancy; analyzed risks of **time dependency** for bidding deadlines. |
| **Personal Contract** | **Advanced Vulnerability** | Identified and exploited a **storage slot collision** in an uninitialized proxy, documenting the path from bug to fix. |

-----

## 🛠️ **Development Stack**

  * **Language:** **Solidity** (Targeting latest stable version).
  * **Framework:** **Foundry** (Prioritized for speed, powerful fuzz testing, and robust scripting).
  * **Methodology:** **Security-First, Test-Driven Development (TDD)** is strictly applied, ensuring the tests prove both functionality and the absence of known vulnerabilities.

This repository is my commitment to mastering the Ethereum security landscape. I welcome code reviews and discussions from the auditing community.
