// SPDX-License-Identifier:MIT
// interface for EsterToken

pragma solidity ^0.8.0;


interface IEsterToken {
    

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address from, address recipient, uint256 amount) external returns (bool);

    function depositEth() external payable;
    function withdrawEth(uint256 amount) external;

    event Transfer(address indexed _from, address indexed _to, uint256 amount);
    event Approval(address indexed _owner, address indexed _spender, uint256 amount);
    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);


}