// SPDX-License-Identifier: MIT
 
/**  
@author Benji223
*/
 
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleToken is ERC20 {
    
    string _name;       
    string _symbol;

    address[] public adminList;

    address private owner;
    address private admin1;

    mapping ( address => bool) public teamMember;
    mapping(address => uint256) public _balances;    
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 constant _totalSupply = 1000000000000000000000000;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    constructor(string memory name_, string memory symbol_, address admin1_) ERC20(name_, symbol_) {
        _name = name_;
        _symbol = symbol_;

        uint256 supplyOfAdmin1 = 100000000000000000000000;

        // set owner abilities 
        owner = msg.sender;
        teamMember[owner] = true;
        adminList.push(owner);
        _mint(msg.sender, _totalSupply);
  
        // set admin
        admin1 = admin1_;
        teamMember[admin1] = true;
        adminList.push(admin1);
        _mint(admin1, supplyOfAdmin1 );

    }

    modifier onlyOwner()   {
        require(msg.sender == owner, "This address is not the Owner");
        _;
    }

    modifier onlyAuthorized() {
        require(teamMember[msg.sender], "This address is not a member");
        _;
    } 

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = allowance(sender, _msgSender());
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);
        return true;
    }

    function mint( uint256 amount) public onlyAuthorized {
        require(msg.sender != address(0), "ERC20: mint to the zero address");
        require(balanceOf(msg.sender) <= 10000000000000000000000, "Max mint amount exceeded for this account" );
        require(amount <= 10000000000000000000000, "Max mint amount exceeded");
        _mint(msg.sender, amount);
    }
 
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    ///////////SETTER FUNCTION ///////////
 
    function setAdmin(address newAdmin) public onlyOwner {
        require(adminList.length < 10, "too many admins");
        require(!teamMember[newAdmin], "This address is already a member");
        teamMember[newAdmin] = true;
        adminList.push(newAdmin);
    }

    function removeAdmin(address _adminToRemove) public onlyOwner{require(adminList.length > 0, "no admin");
        require(teamMember[_adminToRemove], "This address is already a member");
        uint256 memberIndex = 0;

        // Find the index of the member to remove
        for (uint256 i = 0; i < adminList.length; i++) {
            if (adminList[i] == _adminToRemove) {
                memberIndex = i;
                break;
            }
        }

        // Remove the member from the array
        for (uint256 i = memberIndex; i < adminList.length - 1; i++) {
            adminList[i] = adminList[i + 1];
        }
        adminList.pop();
        teamMember[_adminToRemove] = false;
        
    }

    ///////////GETTER FUNCTION ///////////

    function getBalance(address _address) external view returns(uint256){
        return balanceOf(_address);
    }

    function getOwner() external view returns(address){
        return owner;
    }
 
}
