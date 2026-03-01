// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {GuessTheNumberChallenge} from "src/Lotteries/GuessTheNumber.sol";

contract GuessTheNumberChallengeTest is Test {
    GuessTheNumberChallenge public guessTheNumberChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheNumberChallenge = new GuessTheNumberChallenge{value: 1 ether}();
    }

    function testGuessTheNumber() public {
        console.log("my balance:", hacker.balance);
        console.log("challenge balance:", address(guessTheNumberChallenge).balance);

        vm.startPrank(hacker);
        guessTheNumberChallenge.guess{value: 1 ether}(42);
        vm.stopPrank();

        console.log("my new balance:", hacker.balance);
        console.log("challenge new balance:", address(guessTheNumberChallenge).balance);

        assertTrue(guessTheNumberChallenge.isComplete());
    }
}