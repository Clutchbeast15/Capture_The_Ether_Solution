// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {GuessTheNewNumberChallenge} from "src/Lotteries/GuessTheNewNumberChallenge.sol";
import {Attacker} from "test/LotteriesTest/GuessTheNewNumberTest/NewNumberAttacker.sol";

contract GuessTheNewNumberChallengeTest is Test {
    GuessTheNewNumberChallenge public guessTheNewNumberChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheNewNumberChallenge = new GuessTheNewNumberChallenge{value: 1 ether}();
    }

    function testGuessTheNewNumber() public {
        console.log("my balance:", hacker.balance);
        console.log(
            "challenge balance:",
            address(guessTheNewNumberChallenge).balance
        );

        vm.startPrank(hacker);
        Attacker attacker = new Attacker();
        attacker.attack{value: 1 ether}(address(guessTheNewNumberChallenge));
        vm.stopPrank();

        console.log("my new balance:", hacker.balance);
        console.log(
            "challenge new balance:",
            address(guessTheNewNumberChallenge).balance
        );

        assertTrue(guessTheNewNumberChallenge.isComplete());
    }
}