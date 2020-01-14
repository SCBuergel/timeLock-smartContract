pragma solidity ^0.5.16;

contract timeLock
{
    struct accountData
    {
        uint balance;
        uint releaseTime;
    }

    mapping (address => accountData) accounts;

    function payIn(uint lockTimeS) public payable
    {
        uint amount = msg.value;
        payOut();
        if (accounts[msg.sender].balance > 0)
            msg.sender.transfer(msg.value);
        else
        {
            accounts[msg.sender].balance = amount;
            accounts[msg.sender].releaseTime = now + lockTimeS;
        }
    }

    function payOut() public
    {
        if (accounts[msg.sender].balance != 0 && accounts[msg.sender].releaseTime < now)
        {
            msg.sender.transfer(accounts[msg.sender].balance);
            accounts[msg.sender].balance = 0;
            accounts[msg.sender].releaseTime = 0;
        }
    }

    function getMyLockedFunds() public view returns (uint x)
    {
        return accounts[msg.sender].balance;
    }

    function getMyLockedFundsReleaseTime() public view returns (uint x)
    {
        return accounts[msg.sender].releaseTime;
    }

    function getNow() public view returns (uint x)
    {
        return now;
    }
}
