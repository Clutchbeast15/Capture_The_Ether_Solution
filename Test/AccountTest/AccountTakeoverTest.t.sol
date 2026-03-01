// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {AccountTakeoverChallenge} from "src/Account/AccountTakeover.sol";

contract AccountTakeoverChallengeTest is Test {
    AccountTakeoverChallenge public accountTakeoverChallenge;

    function setUp() public {
        accountTakeoverChallenge = new AccountTakeoverChallenge();
    }

    function testAccountTakeover() public {
        console.log(
            "before hack, isComplete:",
            accountTakeoverChallenge.isComplete()
        );

        uint256 privateKey =
            uint256(0x32e890da68f49d9be6d3642b2a1163fd8233cf995e9766a459d4cb5545913faa);

        vm.startBroadcast(privateKey);
        accountTakeoverChallenge.authenticate();
        vm.stopBroadcast();

        console.log(
            "after hack, isComplete:",
            accountTakeoverChallenge.isComplete()
        );

        assertTrue(accountTakeoverChallenge.isComplete());
    }
}