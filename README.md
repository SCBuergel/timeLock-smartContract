# time lock smart contract
This smart contract contract is meant for demonstration and testing purposes only. It runs on Ethereum and serves to lock funds for a user-defined period of time before they can be retrieved.

The contract can be used with [geth](https://github.com/ethereum/go-ethereum/wiki/geth) as follows:

Start geth via

```
geth console
```

Since this will keep synchronyzing the blockchain and produce a lot of output open a second geth session for working and testing without lots of background information:

```
geth attach
```

Compile the sourcode of the smart contract via [Remix](https://remix.ethereum.org) and copy-paste the `Web3 deploy` output into a textfile that we call `w3script.sh`. You find that output in the `Contract` tab (top right) in Remix after clicking `Create` you can open the additional information `Contract details (bytecode, interface etc.)` and from there copy the output listed as `Web3 deploy` into the textfile. This output is by default assuming you are deploying from account `web3.eth.accounts[0]`, if you want to choose a different account, change the account number accordingly. Before deploying the contract (which is broadcasted as a transaction), we need to unlock the account via `web3.personal.unlockAccount(web3.eth.accounts[0])`. Now we are ready to deploy the running the following command inside the geth web3 console:
```
loadScript('w3script.sh')
```

```
var contract = web3.eth.contract(compiled.timeLock.info.abiDefinition)
```

Deploy an instance of this contract to the blockchain. First the corresponding account needs to be unlocked (in our case account number 0):

```
web3.personal.unlockAccount(web3.eth.accounts[0])
var contractInstance = contract.new({from:web3.eth.accounts[0], data: compiled.timeLock.code, gas: 1000000})
```

Should you already have this contract on the blockchain (and kept a copy of the ABI definition) you can create an instance of that already deployed contract. In that case you also save gas for deploying the contract and do not spam the blockchain with endless contract re-creations. Replace `ABI` and `address` in the code snipped below with values which you obtained during the initial contract deployment: 

```
var contract = web3.eth.contract(ABI);
var contractInstance = contract.at(address);
```

This contract has to get mined which might take up to a minute (you can watch your primary geth session to watch for incoming blocks), it has been mined once we see an address:

```
contractInstance.address
```

The contract is ready and we check its existence on some [Ethereum blockchain explorer](https://etherchain.org/). Before we lock some funds from it within the contract, check the balance of account number 0:

```
web3.eth.getBalance(web3.eth.accounts[0])
```

Interaction with the contract happens via transactions, here we are locking 123 Wei ([0.000000000000000123 Ether or 0.00000000000000002583 USD](http://ether.fund/tool/converter) as of the time of this writing) from account 0 for 100 seconds:

```
contractInstance.payIn.sendTransaction(100, {from: web3.eth.accounts[0], value:123})
```

Checking the balance again should show a difference in value, note that not only the 123 Wei but also the gas to run this contract were subtracted from the balance of this account:

```
web3.eth.getBalance(web3.eth.accounts[0])
```

Also, the amount locked in the contract can be checked:

```
contractInstance.getMyLockedFunds()
```

After waiting the initially specified lock time (here 100 seconds), the funds can be unlocked and transferred back to the requesters account:

```
contractInstance.payOut.sendTransaction({from: web3.eth.accounts[0], gas: 1000000})
```

You could also simply use the existing account which I deployed at the address [0x807aa96410f7cff5614fd8db6cbfa82d86b7029d](https://etherchain.org/account/0x807aa96410f7cff5614fd8db6cbfa82d86b7029d). 
