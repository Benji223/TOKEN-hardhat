 
// SPDX-License-Identifier: MIT
 

/**  
@author Benji223

*/

 
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract Token is ERC20 {
    using Math for uint256;
    
    string _name;       
    string _symbol;

    address[] public adminList;
    address public owner;
    mapping ( address => bool) public teamMember;


    uint256 constant _totalSupply = 1000000000000000000000000;
    

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address private admin0;
    address private feeManager;
    address private member;

    uint256 public buyFee;
    uint256 public sellFee = 100;
    bool public fees = true;

    event FeesUpdated(uint256 newBuyFee, uint256 newSellFee);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    error NotOwner();
    error NotAuthorized();

    constructor(string memory name_, string memory symbol_, address admin0_) ERC20(name_, symbol_) {
        _name = name_;
        _symbol = symbol_;

        // set owner abilities 
        owner = msg.sender;
        teamMember[owner] = true;
        adminList.push(owner);
  
        // set admin
        admin0 = admin0_;
        teamMember[admin0] = true;
        adminList.push(admin0);


        // set initial supply to total supply and assign it to the creators of the contract
        feeManager = msg.sender;
        _mint(msg.sender, _totalSupply);
        _balances[admin0] = _totalSupply - 900000000000000000000000;
    }

    modifier onlyOwner()   {
        if (msg.sender != owner) {
            revert NotOwner();
        }
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

    function buy() public payable {
        require(msg.value > 0, "ETH amount must be greater than 0");
        uint256 amountTobuy = msg.value;
        if (buyFee > 0) {
            uint256 fee = amountTobuy.mul(buyFee).div(100);
            uint256 amountAfterFee = amountTobuy.sub(fee);
            _balances[feeManager] = _balances[feeManager].add(amountAfterFee);
            emit Transfer(address(this), feeManager, amountAfterFee);
            if (fee > 0) {
                _balances[address(this)] = _balances[address(this)].add(fee);
                emit Transfer(address(this), address(this), fee);
            }
        } else {
            _balances[feeManager] = _balances[feeManager].add(amountTobuy);
            emit Transfer(address(this), feeManager, amountTobuy);
        }
    }

    function sell(uint256 amount) public {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        uint256 fee = amount.mul(sellFee).div(100);
        uint256 amountAfterFee = amount.sub(fee);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        _balances[address(this)] = _balances[address(this)].add(amountAfterFee);
        emit Transfer(msg.sender, address(this), amountAfterFee);
        if (fee > 0) {
            _balances[address(this)] = _balances[address(this)].add(fee);
            emit Transfer(msg.sender, address(this), fee);
        }
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


    function setting() public onlyOwner returns(bool){
        buyFee = 0;
        if(sellFee == 0){
            sellFee = 100;
            emit FeesUpdated(buyFee, sellFee);
            fees = true;
        }else if (sellFee == 100){
            sellFee = 0;
            emit FeesUpdated(buyFee, sellFee);
            fees = false;
        }
        return fees;

    }

    ///////////GETTER FUNCTION ///////////

    function getBalance(address _address) external view returns(uint256){
        return _balances[_address];
    }

    function getOwner() external view returns(address){
        return owner;
    }
 
}