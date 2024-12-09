// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {TestExt} from "../lib/forge-zksync-std/src/TestExt.sol";

contract Printer {
    function print() public view {
        console.log("print");
    }
}

contract ConstructorPrinter {
    constructor() {
        Printer printer = new Printer();
        printer.print();
        console.log("outer print");
        console.logAddress(address(this));
        printer.print();
        console.logBytes1(0xff);
        printer.print();
    }
}

contract ZkConsoleTest is Test, TestExt {
    function testZkConsoleOutputDuringCall() public {
        vmExt.zkVm(true);

        Printer printer = new Printer();
        printer.print();
        console.log("outer print");
        console.logAddress(address(this));
        printer.print();
        console.logBytes1(0xff);
        printer.print();
    }

    function testZkConsoleOutputDuringCreate() public {
        vmExt.zkVm(true);

        new ConstructorPrinter();
    }
}
