// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./IEsterToken.sol";

contract ReceiverExchange {

    address esterToken;

    constructor(address _esterToken) {
        esterToken = _esterToken;
    }

    struct BuyOrder {
        uint256 amount;
        address userId;
    }

    mapping(address => uint256) public balanceOf;

    // function transfer(address recipient, uint256 amount) public override returns (bool) {
    //     _transfer(msg.sender, recipient, amount);
    //     return true;
    // } 

    // function handleBuyOrder(BuyOrder memory buyorder) internal {

    // }
    
    IEsterToken EstrContract = IEsterToken(esterToken);

    function _buyESTR(address buyer, uint256 amount) external returns(bool) {
        return EstrContract.transfer(buyer, amount);
    }

    function checkBalance(address wallet) external view returns(uint256) {
        return EstrContract.balanceOf(wallet);
    }

    // need a receive function to get ETH


}