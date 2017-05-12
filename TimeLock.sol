contract TimeLock {
    // custom data structure to hold locked funds and time
    struct accountData {
        uint balance;
        uint releaseTime;
    }

    // only one locked account per address
    mapping (address => accountData) accounts;

    function payIn(uint lockTimeS) payable {
        // send some amount (in Wei) when calling this function.
        // the amount will then be placed in a locked account
        // the funds will be released once the indicated lock time in seconds
        // passed and can only be retrieved by the same account which was
        // depositing them - highlighting the intrinsic security model
        // offered by a blockchain system like Ethereum

        uint amount = msg.value;
        payOut();
        if (accounts[msg.sender].balance > 0)
            msg.sender.send(msg.value);
        else {
            accounts[msg.sender].balance = amount;
            accounts[msg.sender].releaseTime = now + lockTimeS;
        }
    }
    
    function payOut() {
        // check if user has funds due for pay out because lock time is over
        if (accounts[msg.sender].balance != 0 && accounts[msg.sender].releaseTime < now) {
            msg.sender.send(accounts[msg.sender].balance);
            accounts[msg.sender].balance = 0;
            accounts[msg.sender].releaseTime = 0;
        }
    }

    // some helper functions for demo purposes (not required)
    function getMyLockedFunds() constant returns (uint x) {
        return accounts[msg.sender].balance;
    }
    
    function getMyLockedFundsReleaseTime() constant returns (uint x) {
	    return accounts[msg.sender].releaseTime;
    }

    function getNow() constant returns (uint x) {
        return now;
    }
}
