// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/smartMarketplace.sol";
import "../src/smartNFT.sol";

contract MarketTest is Test {
    NFTMarket public market;
    NFT public nft;


    address Bob = vm.addr(0x1);
    address Alice = vm.addr(0x2);
    address Idogwu = vm.addr(0x3);
    address Faith = vm.addr(0x4);
    address Femi = vm.addr(0x5);
    address Nonso = vm.addr(0x6);

    function setUp() public {
        market = new NFTMarket();
        nft = new NFT(address(market));

        
    }

    function testMarketplace() public {
        vm.deal(Bob, 100 ether);
        vm.startPrank(Bob);
        nft.createToken("https://www.mytokenlocation.com");
        nft.createToken("https://www.mytokenlocation2.com");
        uint256 auctionPrice = 0.1 ether;
        uint256 listingPrice = market.getListingPrice();
        market.createMarketItem{value: listingPrice }(address(nft), 1, auctionPrice);
    }

    function testSaleExecution() public {
        testMarketplace();
        vm.stopPrank();
        vm.deal(Alice, 500 ether);
        vm.startPrank(Alice);
        market.createMarketSale{value: 0.1 ether }(address(nft), 1);

    }

    // function testIncrement() public {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }

    // function testSetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
