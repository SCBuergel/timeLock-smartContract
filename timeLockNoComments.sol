contract timeLock
{
    struct accountData
    {
        uint balance;
        uint releaseTime;
    }

    mapping (address => accountData) accounts;

    function payIn(uint lockTimeS)
    {
        uint amount = msg.value;
        payOut();
        if (accounts[msg.sender].balance > 0)
            msg.sender.send(msg.value);
        else
        {
            accounts[msg.sender].balance = amount;
            accounts[msg.sender].releaseTime = now + lockTimeS;
        }
    }
    
    function payOut()
    {
        if (accounts[msg.sender].balance != 0 && accounts[msg.sender].releaseTime < now)
        {
            msg.sender.send(accounts[msg.sender].balance);
            accounts[msg.sender].balance = 0;
            accounts[msg.sender].releaseTime = 0;
        }
    }

    function getMyLockedFunds() constant returns (uint x)
    {
        return accounts[msg.sender].balance;
    }
    
    function getMyLockedFundsReleaseTime() constant returns (uint x)
    {
        return accounts[msg.sender].releaseTime;
    }
    
    function getNow() constant returns (uint x)
    {
        return now;
    }
}
