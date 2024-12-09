// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "forge-std/StdInvariant.sol";
import "../src/Deposit.sol";

contract ZkInvariantTest is StdInvariant, Test {
    Deposit deposit;

    uint256 constant dealAmount = 1 ether;

    function setUp() external {
        // to fund for fees
        targetSender(address(65536 + 1));
        targetSender(address(65536 + 12));
        targetSender(address(65536 + 123));
        targetSender(address(65536 + 1234));

        for (uint256 i = 0; i < targetSenders().length; i++) {
            vm.deal(targetSenders()[i], dealAmount); // to pay fees
        }

        deposit = new Deposit();
        targetContract(address(deposit));
    }

    //FIXME: seems to not be detected, forcing values in test config
    // forge-config: default.invariant.runs = 2
    function invariant_itWorks() external payable {}

    receive() external payable {}
}
