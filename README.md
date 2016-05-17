# time lock smart contract
This smart contract contract is meant for demonstration and testing purposes only. It runs on Ethereum and serves to lock funds for a user-defined period of time before they can be retrieved.

The contract can be used with [geth](https://github.com/ethereum/go-ethereum/wiki/geth) as follows:

Start geth via

`geth console`

Since this will keep synchronyzing the blockchain and produce a lot of output open a second geth session for working and testing without lots of background information:

`geth attach`

All following commands should be entered into this javascript shell provided by geth. Remove the linebreaks from the Solidity source code, you can do so with some [online tool](http://www.textfixer.com/tools/remove-line-breaks.php) and store the source in a variable. Alternatively, copy-paste the content of the corresponding file from this repository into the parentheses below:

`var source = 'contract LockTimeContract { struct accountData { uint balance; uint releaseTime; } mapping (address => accountData) accounts; function payIn(uint lockTimeS) { uint amount = msg.value; payOut(); if (accounts[msg.sender].balance > 0) msg.sender.send(msg.value); else { accounts[msg.sender].balance = amount; accounts[msg.sender].releaseTime = now + lockTimeS; } } function payOut() { if (accounts[msg.sender].balance != 0 && accounts[msg.sender].releaseTime < now) { msg.sender.send(accounts[msg.sender].balance); accounts[msg.sender].balance = 0; accounts[msg.sender].releaseTime = 0; } } function getMyLockedFunds() constant returns (uint x) { return accounts[msg.sender].balance; } function getMyLockedFundsReleaseTime() constant returns (uint x) { return accounts[msg.sender].releaseTime; } function getNow() constant returns (uint x) { return now; } }'`

Compile the solidity source via the integrated solidity compiler:

`var compiled = web3.eth.compile.solidity(source)`

Take the compiled object and make a new contract from it:

`var contract = web3.eth.contract(compiled.LockTimeContract.info.abiDefinition)`

Deploy an instance of this contract to the blockchain, this will prompt for the password of the corresponding account (in our case account number 0):

`var contractInstance = contract.new({from:web3.eth.accounts[0], data: compiled.LockTimeContract.code, gas: 1000000})`

Should you already have this contract on the blockchain (and kept a copy of the ABI definition) you can create an instance of that already deployed contract. In that case you also save gas for deploying the contract and do not spam the blockchain with endless contract re-creations. Replace `ABI` and `address` in the code snipped below with values which you obtained during the initial contract deployment: 

```
var contract = web3.eth.contract(ABI);
var contractInstance = MyContract.at(address);
```

This contract has to get mined which might take up to a minute (you can watch your primary geth session to watch for incoming blocks), it has been mined once we see an address:

`contractInstance.address`

The contract is ready and we check its existence on some [Ethereum blockchain explorer](https://etherchain.org/). Before we lock some funds from it within the contract, check the balance of account number 0:

`web3.eth.getBalance(web3.eth.accounts[0])`

Interaction with the contract happens via transactions, here we are locking 123 Wei ([0.000000000000000123 Ether or 0.00000000000000002583 USD](http://ether.fund/tool/converter) as of the time of this writing) from account 0 for 100 seconds:

`contractInstance.payIn.sendTransaction(100, {from: web3.eth.accounts[0], value:123})`

Checking the balance again should show a difference in value, note that not only the 123 Wei but also the gas to run this contract were subtracted from the balance of this account:

`web3.eth.getBalance(web3.eth.accounts[0])`

Also, the amount locked in the contract can be checked:

`contractInstance.getMyLockedFunds()`

After waiting the initially specified lock time (here 100 seconds), the funds can be unlocked and transferred back to the requesters account:

`contractInstance.payOut.sendTransaction({from: web3.eth.accounts[0], gas: 1000000})`

You could also simply use the existing account which I deployed at the address [0x807aa96410f7cff5614fd8db6cbfa82d86b7029d](https://etherchain.org/account/0x807aa96410f7cff5614fd8db6cbfa82d86b7029d). 
