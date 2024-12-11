// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface VmExt {
    /// Registers bytecodes for ZK-VM for transact/call and create instructions.
    function zkRegisterContract(
        string calldata name,
        bytes32 evmBytecodeHash,
        bytes calldata evmDeployedBytecode,
        bytes calldata evmBytecode,
        bytes32 zkBytecodeHash,
        bytes calldata zkDeployedBytecode
    ) external pure;

    /// Enables/Disables use ZK-VM usage for transact/call and create instructions.
    function zkVm(bool enable) external pure;

    /// When running in zkEVM context, skips the next CREATE or CALL, executing it on the EVM instead.
    /// All `CREATE`s executed within this skip, will automatically have `CALL`s to their target addresses
    /// executed in the EVM, and need not be marked with this cheatcode at every usage location.
    function zkVmSkip() external pure;

    /// Use a paymaster for the next ZK-VM call.
    function zkUsePaymaster(address paymaster, bytes calldata input) external;

    /// Mark a contract as a factory dependency.
    function zkUseFactoryDep(string calldata contractName) external;
}

abstract contract TestExt {
    // Cheat code address, 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D.
    address internal constant VM_EXT_ADDRESS =
        address(uint160(uint256(keccak256("hevm cheat code"))));

    VmExt internal constant vmExt = VmExt(VM_EXT_ADDRESS);
}
