 // SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WyvernExchange {

    function approveOrder_(
        address[7] memory addrs,
        uint[9] memory uints,
        uint8 feeMethod,
        uint8 side,
        uint8 saleKind,
        uint8 howToCall,
        bytes memory callData, // changed parameter name from calldata because calldata is already a keyword
        bytes memory replacementPattern,
        bytes memory staticExtradata,
        bool orderbookInclusionDesired)
        public
    {}
    function atomicMatch_(
        address[14] memory addrs,
        uint[18] memory uints,
        uint8[8] memory feeMethodsSidesKindsHowToCalls,
        bytes memory calldataBuy,
        bytes memory calldataSell,
        bytes memory replacementPatternBuy,
        bytes memory replacementPatternSell,
        bytes memory staticExtradataBuy,
        bytes memory staticExtradataSell,
        uint8[2] memory vs,
        bytes32[5] memory rssMetadata)
        public
        payable
    {}
}

contract Buyer {
    Seller seller;
    constructor(address seller_address) {
        seller = Seller(seller_address);
    }

    function buyNFT(bytes memory call_data_buy, bytes memory call_data_sell, uint borrow_amount) public {
        // approveOrder
        // atomicMatch
    }
}

/**
 * @title Seller
 * @dev Sells the NFT
 */
contract Seller {

    address public constant owner = 0x864041552CbA25B24A1398550e3AbeEb8868425f;
    address public constant exchange_address = 0x5206e78b21Ce315ce284FB24cf05e0585A93B1d9;
    address public constant fee_recipient = address(0);
    address public constant nft_address = 0x88B48F654c30e99bc2e4A1559b4Dcf1aD93FA656;
    address public constant static_call_target = address(0);
    address public constant weth_address = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
    // Taker address is 0 when selling, and seller's address when buying.
    
    Buyer buyer;
    WyvernExchange exchange;

    uint public constant maker_relayer_fee = 0;
    uint public constant taker_relayer_fee = 0;
    uint public constant maker_protocol_fee = 0;
    uint public constant taker_protocol_fee = 0;
    uint public constant auction_extra = 0;
    uint public constant expiration = 0;
    uint public constant salt = 48498403098498545;
    uint8 public constant fee_method = 1;
    uint8 public constant sale_kind = 0;
    uint8 public constant how_to_call = 0;
    bytes public constant static_extra_data = "";
    uint public constant original_salt = salt;



    bytes public constant replacement_pattern_buy = "0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    bytes public constant replacement_pattern_sell = "0x000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    bytes32 public constant empty_bytes = "";
    
    
    
    // modifier to check if caller is owner
    modifier isOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    constructor() {
        buyer = new Buyer(address(this));
        exchange = WyvernExchange(address(exchange_address));
    }
    
    
    function prepareNFT(uint price, bytes memory call_data_buy, bytes memory new_call_data_buy, bytes memory original_call_data_sell,
        bytes memory new_call_data_sell, uint original_time, uint time,
        address original_owner, uint borrow_amount) public isOwner {
        // Buy NFT
        exchange.approveOrder_([exchange_address,
            address(this), // Maker address
            original_owner, // Taker address
            fee_recipient,
            nft_address,
            static_call_target,
            weth_address],
            [maker_relayer_fee,
            taker_relayer_fee,
            maker_protocol_fee,
            taker_protocol_fee,
            price,
            auction_extra,
            time,
            expiration,
            salt],
            fee_method,
            0,  // Side
            sale_kind,
            how_to_call,
            call_data_buy,
            replacement_pattern_buy,
            static_extra_data,
            true);
        // call atomicmatch
        exchange.atomicMatch_([exchange_address,
            address(this), // Maker address
            original_owner, // Taker address
            fee_recipient,
            nft_address,
            static_call_target,
            weth_address,
            exchange_address,
            original_owner,
            address(0), // Taker address
            fee_recipient,
            nft_address,
            static_call_target,
            weth_address],
            [maker_relayer_fee,
            taker_relayer_fee,
            maker_protocol_fee,
            taker_protocol_fee,
            price,
            auction_extra,
            time,
            expiration,
            salt,
            maker_relayer_fee,
            taker_relayer_fee,
            maker_protocol_fee,
            taker_protocol_fee,
            price,
            auction_extra,
            original_time,
            expiration,
            original_salt],
            [fee_method,
            0,
            sale_kind,
            how_to_call,
            fee_method,
            1,
            sale_kind,
            how_to_call],
            call_data_buy,
            original_call_data_sell,
            replacement_pattern_buy,
            replacement_pattern_sell,
            static_extra_data,
            static_extra_data,
            [0, 0],
            [empty_bytes, empty_bytes, empty_bytes, empty_bytes, empty_bytes]);
        // Place the NFT on sale
        // call approveorder
        exchange.approveOrder_([exchange_address,
            address(this), // Maker address
            address(0), // Taker address
            fee_recipient,
            nft_address,
            static_call_target,
            weth_address],
            [maker_relayer_fee,
            taker_relayer_fee,
            maker_protocol_fee,
            taker_protocol_fee,
            borrow_amount,
            auction_extra,
            time,
            expiration,
            salt],
            fee_method,
            1,  // Side
            sale_kind,
            how_to_call,
            new_call_data_sell,
            replacement_pattern_sell,
            static_extra_data,
            true);
            buyer.buyNFT(new_call_data_buy, new_call_data_sell, borrow_amount);
    }

    function transferBack() public {
        ERC20 weth = ERC20(weth_address);
        weth.transfer(address(buyer), weth.balanceOf(address(this)));
    }
}