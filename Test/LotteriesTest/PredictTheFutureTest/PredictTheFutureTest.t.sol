// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {PredictTheFutureChallenge} from "src/Lotteries/PredictTheFuture.sol";
import {Attacker} from "test/LotteriesTest/PredictTheFutureTest/PredictFutureAttacker.sol";

contract PredictTheFutureChallengeTest is Test {
    PredictTheFutureChallenge public predictTheFutureChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        predictTheFutureChallenge = new PredictTheFutureChallenge{value: 1 ether}();
    }

    function testPredictTheFurture() public {
        console.log("my balance:", hacker.balance);
        console.log(
            "challenge balance:",
            address(predictTheFutureChallenge).balance
        );

        vm.startPrank(hacker);
        Attacker attacker = new Attacker(address(predictTheFutureChallenge));
        attacker.lockInGuess{value: 1 ether}(6);

        /*
        // TODO
        uint blockNum = block.number;
        uint i = 1;

        while(there are reverts) {
            vm.roll(blockNum + i);

            attacker.attack();

            ++i;
        }
        */

        vm.stopPrank();

        console.log("my new balance:", hacker.balance);
        console.log(
            "challenge new balance:",
            address(predictTheFutureChallenge).balance
        );

        // assertTrue(predictTheFutureChallenge.isComplete());
    }
}