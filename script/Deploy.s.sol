// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Script, console2 } from "forge-std/Script.sol";
import { SanctionsModule } from "../src/SanctionsModule.sol";

contract Deploy is Script {
  SanctionsModule public implementation;
  bytes32 public SALT = bytes32(abi.encode(0xe22dfed15d74553ffe7dc973acb1aedc7e978ba4ff4e16525e1fce221c98e065));

  // default values
  bool internal _verbose = true;
  string internal _version = "1.0.1"; // increment this with each new deployment

  /// @dev Override default values, if desired.
  function prepare(bool verbose, string memory version) public {
    _verbose = verbose;
    _version = version;
  }

  /// @dev Set up the deployer via their private key from the environment
  function deployer() public returns (address) {
    uint256 privKey = vm.envUint("PRIVATE_KEY");
    return vm.rememberKey(privKey);
  }

  function _log(string memory prefix) internal view {
    if (_verbose) {
      console2.log(string.concat(prefix, "SanctionsModule:"), address(implementation));
    }
  }

  /// @dev Deploy the contract to a deterministic address via forge's create2 deployer factory.
  function run() public virtual {
    vm.startBroadcast(deployer());

    // Deploy the SanctionedHat contract
    implementation = new SanctionsModule{ salt: SALT}("1.0.1");

    vm.stopBroadcast();

    _log("");
    }
}

/// @dev Deploy pre-compiled ir-optimized bytecode to a non-deterministic address
contract DeployPrecompiled is Deploy {
    /// @dev Update SALT and default values in Deploy contract

    function run() public override {
        vm.startBroadcast(deployer());

        // Encode the constructor argument for SanctionedHat
        bytes memory args = abi.encode("1.0.1" /* Replace with your desired version string */);

        /// @dev Load and deploy pre-compiled ir-optimized bytecode.
        implementation = SanctionsModule(deployCode("optimized-out/SanctionsModule.sol/SanctionsModule.json", args));

        vm.stopBroadcast();

        _log("Precompiled ");
    }
}

/* FORGE CLI COMMANDS

## A. Simulate the deployment locally
forge script script/Deploy.s.sol -f mainnet

## B. Deploy to real network and verify on etherscan
forge script script/Deploy.s.sol -f mainnet --broadcast --verify

## C. Fix verification issues (replace values in curly braces with the actual values)
forge verify-contract --chain-id 1 --num-of-optimizations 1000000 --watch --constructor-args $(cast abi-encode \
 "constructor({args})" "{arg1}" "{arg2}" "{argN}" ) \ 
 --compiler-version v0.8.19 {deploymentAddress} \
 src/{Counter}.sol:{Counter} --etherscan-api-key $ETHERSCAN_KEY

## D. To verify ir-optimized contracts on etherscan...
  1. Run (C) with the following additional flag: `--show-standard-json-input > etherscan.json`
  2. Patch `etherscan.json`: `"optimizer":{"enabled":true,"runs":100}` =>
`"optimizer":{"enabled":true,"runs":100},"viaIR":true`
  3. Upload the patched `etherscan.json` to etherscan manually

  See this github issue for more: https://github.com/foundry-rs/foundry/issues/3507#issuecomment-1465382107

*/
