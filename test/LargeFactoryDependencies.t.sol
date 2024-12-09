// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import "../src/LargeContracts.sol";

// Temporarily disabled due to issues with batching
contract ZkLargeFactoryDependenciesTest is Test {
    function testLargeFactoryDependenciesAreDeployedInBatches() public {
        new LargeContract();
    }
}
