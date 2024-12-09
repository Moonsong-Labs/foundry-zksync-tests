// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {
    IPaymaster,
    ExecutionResult,
    PAYMASTER_VALIDATION_SUCCESS_MAGIC
} from "zksync-contracts/zksync-contracts/l2/system-contracts/interfaces/IPaymaster.sol";
import {IPaymasterFlow} from "zksync-contracts/zksync-contracts/l2/system-contracts/interfaces/IPaymasterFlow.sol";
import {
    TransactionHelper,
    Transaction
} from "zksync-contracts/zksync-contracts/l2/system-contracts/libraries/TransactionHelper.sol";
import "zksync-contracts/zksync-contracts/l2/system-contracts/Constants.sol";
import {console} from "../lib/forge-std/src/console.sol";
contract MyPaymaster is IPaymaster {
    modifier onlyBootloader() {
        require(msg.sender == BOOTLOADER_FORMAL_ADDRESS, "Only bootloader can call this method");
        _;
    }

    constructor() payable {}

    function validateAndPayForPaymasterTransaction(bytes32, bytes32, Transaction calldata _transaction)
        external
        payable
        onlyBootloader
        returns (bytes4 magic, bytes memory context)
    {
        console.log("validateAndPayForPaymasterTransaction");
        console.log(address(this).balance);
        require(address(this).balance > 0, "Paymaster balance is 0");
        // Always accept the transaction
        magic = PAYMASTER_VALIDATION_SUCCESS_MAGIC;
        console.logBytes4(magic);

        // Pay for the transaction fee
        uint256 requiredETH = _transaction.gasLimit * _transaction.maxFeePerGas;
        (bool success,) = payable(BOOTLOADER_FORMAL_ADDRESS).call{value: requiredETH}("");
        require(success, "Failed to transfer tx fee to the bootloader");
    }

    function postTransaction(
        bytes calldata _context,
        Transaction calldata _transaction,
        bytes32,
        bytes32,
        ExecutionResult _txResult,
        uint256 _maxRefundedGas
    ) external payable override onlyBootloader {}

    receive() external payable {}
}
