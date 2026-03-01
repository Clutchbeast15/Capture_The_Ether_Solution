// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {GuessTheSecretNumberChallenge} from "src/Lotteries/GuessTheSecretNumberChallenge.sol";

contract GuessTheSecretNumberChallengeTest is Test {
    GuessTheSecretNumberChallenge public guessTheSecretNumberChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheSecretNumberChallenge = new GuessTheSecretNumberChallenge{value: 1 ether}();
    }

    function testGuessTheSecretNumber() public {
        console.log("my balance:", hacker.balance);
        console.log(
            "challenge balance:",
            address(guessTheSecretNumberChallenge).balance
        );

        vm.startPrank(hacker);
        guessTheSecretNumberChallenge.guess{value: 1 ether}(170);
        vm.stopPrank();

        console.log("my new balance:", hacker.balance);
        console.log(
            "challenge new balance:",
            address(guessTheSecretNumberChallenge).balance
        );

        assertTrue(guessTheSecretNumberChallenge.isComplete());
    }
}