contract LockTimeContract
{
    struct accountData
    {
        uint balance;
        uint releaseTime;
    }

    mapping (address => accountData) accounts;

    function payIn(uint lockTimeS) returns (bool x)
    {
        uint amount = msg.value;
        
        if (accounts[msg.sender].balance != 0 && !payOut())
        {
            msg.sender.send(amount);
            
            return false;
        }
        accounts[msg.sender].balance = amount;
        accounts[msg.sender].releaseTime = now + lockTimeS;
        return true;
    }
    
    function payOut() returns (bool x)
    {
        if (accounts[msg.sender].balance != 0 && accounts[msg.sender].releaseTime < now)
        {
            msg.sender.send(accounts[msg.sender].balance);
            return true;
        }
        else
            return true;
    }
    
    function getMyLockedFunds() constant returns (uint x)
      {
          return accounts[msg.sender].balance;
      }
    
    function getMyLockedFundsReleaseTime() constant returns (uint x)
      {
          return accounts[msg.sender].releaseTime;
      }
    
 }
 