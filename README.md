# atxu_school_blockchain
**Smart Contracts for ATXU school**

<a href="https://excalidraw.com/#json=tM2-K9HKGik1HLsTr3vga,r7DUVZxz84J01mJj6jyhvw">Excalidraw diagram</a>

## Key features
- Smart Contracts are upgradable through the Diamond Proxy pattern.

## Smart Contracts

### School
This Smart Contract should be used as the entry point (public interface) for all interactions with a particular school.

### Students
This Smart Contract contains the functionality about students.

### Semesters
This Smart Contract contains the functionality about semesters.

### Donations
This Smart Contract contains the functionality about donations. Donations can be made from any address. These donor addresses are stored in the mapping in a pseudonymous way (the address is public, but it is not known who owns it).

### Sponsors
This Smart Contract contains the functionality about school sponsors. Sponsors donate in the same way as regular donors, but they are registered in this smart contract. In this way, a donation can be de-anonymized in the Donations Smart Contract and the sponsor can enjoy public recognition.
