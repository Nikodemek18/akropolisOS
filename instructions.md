# How to work with the Akropolis Pool

## Developer tools
* [Openzeppelin SDK](https://openzeppelin.com/sdk/)
* [Openzepplin Contracts](https://openzeppelin.com/contracts/)
* [Truffle](https://www.trufflesuite.com/)

## Deployment

### Required data:
* Address of liquidity token (`LToken.address`)

### Deployment sequence:
1. PToken
   1. Deploy proxy and contract instance
   1. Call `initialize()`
1. Pool
   1. Deploy proxy and contract instance
   1. Call `initialize`
1. CurveModule
   1. Deploy proxy and contract instance
   1. Call `initialize(Pool.address)`
   1. Register in pool: `Pool.set("curve", CurveModule.address)`
1. FundsModule
   1. Deploy proxy and contract instance
   1. Call `initialize(Pool.address, LToken.address, PToken.address)`
   1. Register in pool: `Pool.set("funds", FundsModule.address)`

## Liquidity

### Deposit
#### Required data:
* `lAmount`: Deposit amount, DAI
#### Required conditions:
* All contracts are deployed
#### Workflow:
1. Call `FundsModule.calculatePoolEnter(lAmount)` to determine expexted PTK amount (`pAmount`)
1. Determine minimum acceptable amount `pAmountMin <= pAmount`, which user expect to get when deposit `lAmount` DAI. Zero value is allowed.
1. Call `LToken.approve(FundsModule.address, lAmount)` to allow exchange
1. Call `FundsModule.deposit(lAmount, pAmountMin)` to execute exchange

### Withdraw
#### Required data:
* `pAmount`: Withdraw amount, PTK
#### Required conditions:
* Available liquidity `LToken.balanceOf(FundsModule.address)` is greater whan expected amount DAI
* User has enough PTK: `PToken.balanceOf(userAddress) >= pAmount`
#### Workflow:
1. Call `FundsModule.calculatePoolExitInverse(pAmount)` to determine expected amount of DAI (`lAmount`). The responce has 3 values, use second one.
1. Determine minimum acceptable amount `lAmountMin <= lAmount` DAI , which user expects to get when deposit `pAmount` PTK. Zero value is allowed.
1. Call `PToken.approve(FundsModule.address, pAmount)` to allow exchange
1. Call `FundsModule.withdraw(pAmount, lAmountMin)` to execute exchange


## Credits
### Create Loan Request
#### Required data:
* `debtLAmount`: Loan amount, DAI
* `interest`: Interest rate, percents
* `pAmount`: Borrower's own pledge, PTK. Should be not less than 50% оf `debtLAmount` when converted to DAI.
#### Required conditions:
* User has enough PTK: `PToken.balanceOf(userAddress) >= pAmount`
#### Workflow:
1. Call `FundsModule.calculatePoolExitInverse(pAmount)` to determine expected pledge in DAI (`lAmount`). The responce has 3 values, use first one.
1. Determine minimum acceptable amount `lAmountMin <= lAmount` DAI, which user expects to lock as a pledge, sending `pAmount` PTK. Zero value is allowed.
1. Call `PToken.approve(FundsModule.address, pAmount)` to allow operation.
1. Call `FundsModule.createDebtProposal(debtLAmount, interest, pAmount, lAmountMin)` to create loan proposal.
#### Data required for future calls:
* Proposal index: `proposalIndex` from event `DebtProposalCreated`.

### Add Pledge
#### Required data:
* Loan proposal identifiers:
  * `borrower` Address of borrower
  * `proposal` Proposal index
* `pAmount`  Pledge amount, PTK
#### Required conditions:
* Loan proposal created
* Loan proposal not yet executed
* Loan proposal is not yet fully filled: `FundsModule.getRequiredPledge(borrower, proposal) > 0`
* User has enough PTK: `PToken.balanceOf(userAddress) >= pAmount`
#### Workflow:
1. Call `FundsModule.calculatePoolExitInverse(pAmount)` to determine expected pledge in DAI (`lAmount`). The responce has 3 values, use first one.
1. Determine minimum acceptable amount `lAmountMin <= lAmount` DAI, which user expects to lock as a pledge, sending `pAmount` PTK. Zero value is allowed.
1. Call `PToken.approve(FundsModule.address, pAmount)` to allow operation.
1. Call `FundsModule.addPledge(borrower, proposal, pAmount, lAmountMin)` to execute operation.

### Withdraw Pledge
#### Required data:
* Loan proposal identifiers:
  * `borrower` Address of borrower
  * `proposal` Proposal index
* `pAmount`  Amount to withdraw, PTK
#### Required conditions:
* Loan proposal created
* Loan proposal not yet executed
* User pledge amount >= `pAmount`
#### Workflow:
1. Call FundsModule.withdrawPledge(borrower, proposal, pAmount) to execute operation.

### Loan issuance
#### Required data:
`proposal` Proposal index
#### Required conditions:
* Loan proposal created, user (transaction sender) is the `borrower`
* Loan proposal not yet executed
* Loan proposal is fully funded: `FundsModule.getRequiredPledge(borrower, proposal) == 0`
* Pool has enough liquidity
#### Workflow:
1. Call `FundsModule.executeDebtProposal(proposal)` to execute operation.
#### Data required for future calls:
* Loan index: `debtIdx` from event `DebtProposalExecuted`.

### Loan repayment (partial or full) 
#### Required data:
* `debt` Loan index
* `lAmount` Repayable amount, DAI
#### Required conditions:
* User (transaction sender) is the borrower
* Loan is not yet fully repaid
#### Workflow:
1. Call `LToken.approve(FundsModule.address, lAmount)` to allow operation.
1. Call `FundsModule.repay(debt, lAmount)` to execute operation.

