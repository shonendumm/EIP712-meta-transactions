// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

import "./IEsterToken.sol";

contract ReceiverExchange {

    address esterToken;
    IEsterToken public EstrContract;
    // mapping(address => uint256) public balanceOf;
    event BoughtESTR(address indexed sender, uint256 amount);

    constructor(address _esterToken) {
        esterToken = _esterToken;
        EstrContract = IEsterToken(esterToken);
    }

    struct BuyOrder {
        uint256 amount;
        uint256 bidPrice;
        address userId;
    }



    function handleBatchOrders(BuyOrder[] memory batchBuyOrders) external {
        for (uint256 i = 0; i <= batchBuyOrders.length; i++) {
            BuyOrder memory buy_order = batchBuyOrders[i];
            _handleBuyOrderTransaction(buy_order);
        }
    }

    function _handleBuyOrderTransaction(BuyOrder memory buy_order) internal returns(bool) {
        require(buy_order.bidPrice >= 1 ether, "Bid price is too low!");
        _transferToBuyer(buy_order.userId, buy_order.amount);
        return true;
    }
   

    //  this function works! change this to a internal function later
    function _transferToBuyer(address buyer, uint256 amount) public returns(bool) {
        // balanceOf[buyer] += amount;
        emit BoughtESTR(buyer, amount);
        return EstrContract.transfer(buyer, amount);
    }

    // Using EsterToken function transfer(address recipient, uint256 amount) public returns bool
    // This doesn't work
    // function contractBuyESTR() public {
    //     EstrContract.depositEth();
    // }

    receive() external payable {

    }


}


