// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
    


}


contract Faucet {
    
    event ClaimToken (address indexed _user , uint _txCount);

    IERC20 public MYToken;
    address public owner;

    constructor (address token) {
        MYToken = IERC20 (token);
        owner = msg.sender;
    }
    mapping (address => uint256) public timeForNextFaucet;
    mapping (address => uint) public txCount;

    function getToken (address who) external{
        require(msg.sender == who, 'you can not sent token for another address');
        require(msg.sender != address(0),"address zero");
        require(timeForNextFaucet[msg.sender] < block.timestamp,"address zero");
        MYToken.transfer(msg.sender, 50000000000000000000);
        timeForNextFaucet[msg.sender] = block.timestamp + 1 days;
        txCount[msg.sender] += 1;

        emit ClaimToken(msg.sender, txCount[msg.sender]);
    }

    function transferTokenForFaucet (uint amount) external {
        require(MYToken.balanceOf(msg.sender)>= amount, "amount bigger than balance");
        MYToken.transferFrom(msg.sender, address(this), amount);
    }

    function getBalance () external view returns(uint){
        return(MYToken.balanceOf(address(this)));
    }
}