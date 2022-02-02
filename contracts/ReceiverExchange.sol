// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;
// pragma abicoder v2;
// pragma experimental ABIEncoderV2;


import "./IEsterToken.sol";
import "hardhat/console.sol";


contract ReceiverExchange {

    address esterToken;
    IEsterToken public EstrContract;
    event BoughtESTR(address indexed sender, uint256 amount);
    BuyOrder[] buy_orders;


    struct BuyOrder {
        uint256 amount;
        uint256 bidPrice;
    }

    struct Sig {
        uint256 amount;
        uint256 bidPrice;
        uint8 v;
        bytes32 r;
        bytes32 s;

    }

        /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");


    constructor(address _esterToken) {
        esterToken = _esterToken;
        EstrContract = IEsterToken(esterToken);
    }


    /**
    * From https://etherscan.io/address/0xc00e94Cb662C3520282E6f5717214004A7f26888#code
     * @notice Delegates votes from signatory to `delegatee`
     * @param delegatee The address to delegate votes to
     * @param nonce The contract state required to match the signature
     * @param expiry The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
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


// To write a new function that handles each signature based on the above delegateBySig

    function handleEachSignature(uint256 _amount, uint256 _bidPrice, uint8 v, bytes32 r, bytes32 s) public {




    }



    function handleBatchSignatures(Sig[] memory sigs) public {
        for (uint i = 0; i < sigs.length; i++) {
            Sig memory sig = sigs[i];
            handleEachSignature(sig.amount, sig.bidPrice, sig.v, sig.r, sig.s);
        }
        
    }


    function _handleBatchOrders(BuyOrder[] memory batchBuyOrders) internal {
        for (uint256 i = 0; i < batchBuyOrders.length; i++) {
            BuyOrder memory buy_order = batchBuyOrders[i];  
            console.log("handling order in batch order");
            _handleBuyOrderTransaction(buy_order);
            console.log("All orders handled!");
        }
    }




    function testBatchOrders() public {
        BuyOrder memory buy_order1 = BuyOrder(10, 5);
        BuyOrder memory buy_order2 = BuyOrder(10, 10);
        console.log("test batch orders");
        buy_orders.push(buy_order1);
        buy_orders.push(buy_order2);
        console.log("orders push to array");
        _handleBatchOrders(buy_orders);
    }



    function _handleBuyOrderTransaction(BuyOrder memory buy_order) internal returns(bool) {
        console.log("handling order");
        if (buy_order.bidPrice < 10) {
            return false;
        } else {
            console.log("Order passed require for bidPrice");
            // temporarily bypass this:
            // _transferToBuyer(buy_order.userId, buy_order.amount);
            return true;
        }
    }
   

    //  this function works! change this to a internal function later
    function _transferToBuyer(address buyer, uint256 amount) public returns(bool) {
        emit BoughtESTR(buyer, amount);
        return EstrContract.transfer(buyer, amount);
    }

    // sometimes writing/testing contracts using remix is faster
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

