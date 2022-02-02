// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;
// pragma abicoder v2;

import "./IEsterToken.sol";
import "hardhat/console.sol";


contract ReceiverExchangeOld {

    address esterToken;
    IEsterToken public EstrContract;
    event BoughtESTR(address indexed sender, uint256 amount);
    BuyOrder[] buy_orders;


    struct BuyOrder {
        uint256 amount;
        uint256 bidPrice;
        address userId;
    }


    constructor(address _esterToken) {
        esterToken = _esterToken;
        EstrContract = IEsterToken(esterToken);
    }


    function testBatchOrders() public {
        BuyOrder memory buy_order1 = BuyOrder(10, 5, 0xAFFfbFd63bE181D9B80d78De09Bb3DaEF1e478D7);
        BuyOrder memory buy_order2 = BuyOrder(10, 10, 0xe815c78c28652D9a03e187183E74A3E462057788);
        console.log("test batch orders");
        buy_orders.push(buy_order1);
        buy_orders.push(buy_order2);
        console.log("orders push to array");
        _handleBatchOrders(buy_orders);
    }


    function _handleBatchOrders(BuyOrder[] memory batchBuyOrders) internal {
        for (uint256 i = 0; i < batchBuyOrders.length; i++) {
            BuyOrder memory buy_order = batchBuyOrders[i];  
            console.log("handling order in batch order");
            _handleBuyOrderTransaction(buy_order);
            console.log("All orders handled!");
        }
    }

    function _handleBuyOrderTransaction(BuyOrder memory buy_order) internal returns(bool) {
        console.log("handling order");
        if (buy_order.bidPrice < 10) {
            return false;
        } else {
            console.log("Order passed require for bidPrice");
            _transferToBuyer(buy_order.userId, buy_order.amount);
            return true;
        }
    }
   

    //  this function works! change this to a internal function later
    function _transferToBuyer(address buyer, uint256 amount) public returns(bool) {
        emit BoughtESTR(buyer, amount);
        return EstrContract.transfer(buyer, amount);
    }

    // testing contracts using remix is faster
    // Using EsterToken function transfer(address recipient, uint256 amount) public returns bool
    // This function doesn't work
    // function contractBuyESTR(uint256 _amount) public payable {
    //     payable(address(EstrContract)).transfer(_amount);
    // }

    receive() external payable {

    }


}


/**

function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
        bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "Comp::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "Comp::delegateBySig: invalid nonce");
        require(now <= expiry, "Comp::delegateBySig: signature expired");
        return _delegate(signatory, delegatee);
    }


    function getChainId() internal pure returns (uint) {
        uint256 chainId;
        assembly { chainId := chainid() }
        return chainId;
    }

 */

