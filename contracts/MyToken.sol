// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract MyToken is ERC20, ERC20Burnable {

    event MinterAdded(address indexed _minter);
    event MinterRemoved(address indexed _minter);

    address payable public owner;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    mapping (address  => bool) internal _isMinter;
    address[] _minters;


    constructor() ERC20("TomanToken", "TT") {
        owner = payable(msg.sender);
        // _minters.push(msg.sender);
        // _isMinter[msg.sender] = true;
        // _mint(owner, initialSupply * (10 ** decimals()));    
    }

    function _addMinter(address newMinter) public onlyOwner{
        _isMinter[newMinter] = true;
        _minters.push(newMinter);

        emit MinterAdded(newMinter);
    }
     function _removeMinter(address removedMinter) public onlyOwner{
        _isMinter[removedMinter] = false;
        
        emit MinterRemoved(removedMinter);
    }
     function _mint(address account, uint256 amount) internal virtual override onlyMinter{
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

    }
     function _burn(address account, uint256 amount) internal virtual override onlyMinter{
        require(account != address(0), "ERC20: burn from the zero address");

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);
    }

    function _checkMinter(address addressForCheck) public view returns(bool){
        // bool isMinter = false;
        // if (_isMinter[addressForCheck] == true) {
        //     isMinter = true;
        // }
        // return isMinter;
        return _isMinter[addressForCheck];
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
        
    }
    modifier onlyMinter {
        require(_isMinter[msg.sender] == true);
        _;
        
    }
    function destroy() public onlyOwner {
        selfdestruct(owner);
    } 
}
