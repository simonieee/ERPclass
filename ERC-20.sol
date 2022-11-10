// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract ERC20 {
    mapping(address => uint) private _balances;
    mapping(address => mapping(address=>uint)) private _allowances;
    uint private _totalSupply;
    string private _name; //ETHEREUM
    string private _symbol; //ETH
    uint8 private _decimals;

    address public owner;

    modifier checkBalance(uint amount){
        require(_balances[msg.sender] > amount, "NOT Sufficient Balance");
        _;
    }

    modifier onlyOwner(address owner){
        require(msg.sender == owner, "Only Owner");
        _;
    }

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed from, address indexed to, uint amount); // 사용자 권한 인증
    
    constructor(string memory _name_, string memory _symbol_, uint8 _decimals_) {
        _name = _name_;
        _symbol = _symbol_;
        _decimals = _decimals_;
        _totalSupply = 10000000 * (10**18);
        owner = msg.sender;
    } 

    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256){
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public checkBalance(amount) returns (bool) {


        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public checkBalance(amount) returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function mint(address to, uint amount) public onlyOwner(owner) {
        _balances[to] = amount;
        _totalSupply += amount;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool){
        require(_balances[from]>amount, "Not Sufficient Balance");
        require(_allowances[from][to] > amount, "Not Allowed Amount");
        require(to == msg.sender, "Not Allowed User");
        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }
}