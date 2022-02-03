// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;
// pragma abicoder v2; by default included 
// pragma experimental ABIEncoderV2;


import "./IEsterToken.sol";
import "hardhat/console.sol";


contract ReceiverExchange {

    address esterToken;
    IEsterToken public EstrContract;
    event BoughtESTR(address indexed sender, uint256 amount);
    BuyOrder[] buy_orders;
    string public constant name = "Token Exchange";


    struct BuyOrder {
        address account;
        uint256 amount;
        uint256 bidPrice;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }
    
    // @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address exchangeAddress)");

    // @notice The EIP-712 typehash for the delegation struct used by the contract
    // bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
    bytes32 public constant ORDER_TYPEHASH = keccak256("BuyOrder(address account,uint256 amount,uint256 bidPrice)");


    constructor(address _esterToken) {
        esterToken = _esterToken;
        EstrContract = IEsterToken(esterToken);
    }



// CONTINUE TOMORROW: THURSDAY - Deploy this contract and test



    function handleBatchOrders(BuyOrder[] memory _batchOrders) public {
        for (uint i = 0; i < _batchOrders.length; i++) {
            BuyOrder memory order = _batchOrders[i];
            handleEachOrder(order.account, order.amount, order.bidPrice, order.v, order.r, order.s);
        }
    }

    function handleEachOrder(address _account, uint256 _amount, uint256 _bidPrice, uint8 v, bytes32 r, bytes32 s) public returns (bool) {
        bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
        bytes32 structHash = keccak256(abi.encode(ORDER_TYPEHASH, _account, _amount, _bidPrice));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
        // need to check this: ecrecover should return the public key of the buyer.
        address buyer_account = ecrecover(digest, v, r, s);
        require(buyer_account == _account, "Not same account!" );
        require(buyer_account != address(0), "Invalid signature: address 0x");
        return _handleBuyOrderTransaction(_account,_amount,_bidPrice);
    }

    function _handleBuyOrderTransaction(address _account, uint256 _amount, uint256 _bidPrice) internal returns(bool) {
        console.log("handling order");
        if (_bidPrice < 10) {
            return false;
        } else {
            console.log("Order passed require for bidPrice");
            return _transferToBuyer(_account, _amount);
        }
    }
   

    function _transferToBuyer(address buyer, uint256 amount) internal returns(bool) {
        emit BoughtESTR(buyer, amount);
        return EstrContract.transfer(buyer, amount);
    }


    receive() external payable {

    }


    function getChainId() internal view returns (uint) {
        uint256 chainId;
        assembly { chainId := chainid() }
        return chainId;
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




 */



/** 
https://medium.com/metamask/eip712-is-coming-what-to-expect-and-how-to-use-it-bb92fd1a7a26
    string private constant IDENTITY_TYPE = "Identity(uint256 userId,address wallet)";
    string private constant BID_TYPE = "Bid(uint256 amount,Identity bidder)Identity(uint256 userId,address wallet)";
    uint256 constant chainId = 1;
    address constant verifyingContract = 0x1C56346CD2A2Bf3202F771f50d3D14a367B48070;
    bytes32 constant salt = 0xf2d857f4a3edcb9b78b4d503bfe733db1e3f6cdc2b7971ee739626c97e86a558;
    string private constant EIP712_DOMAIN = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)";

    bytes32 private constant DOMAIN_SEPARATOR = keccak256(abi.encode(
        EIP712_DOMAIN_TYPEHASH,
        keccak256("My amazing dApp"),
        keccak256("2"),
        chainId,
        verifyingContract,
        salt
    ));


    function hashIdentity(Identity identity) private pure returns (bytes32) {
        return keccak256(abi.encode(
            IDENTITY_TYPEHASH,
            identity.userId,
            identity.wallet
        ));
    }

    function hashBid(Bid memory bid) private pure returns (bytes32){
        return keccak256(abi.encodePacked(
            "\\x19\\x01",
        DOMAIN_SEPARATOR,
        keccak256(abi.encode(
                BID_TYPEHASH,
                bid.amount,
                hashIdentity(bid.bidder)
            ))
        ));
    }

    function verify(address signer, Bid memory bid, sigR, sigS, sigV) public pure returns (bool) {
        return signer == ecrecover(hashBid(bid), sigV, sigR, sigS);
    }
*/