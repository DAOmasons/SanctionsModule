// SPDX-License-Identifier: UNLICENSED
// Made with love by boiler

pragma solidity ^0.8.19;

import { HatsModule } from "hats-module/HatsModule.sol";
import { IHatsEligibility } from "hats-protocol/Interfaces/IHatsEligibility.sol";

/// @title Sanctions Check for Hats Protocol
/// @notice This contract extends HatsModule to include sanctions checking functionality
/// @dev Interfaces with a sanctions oracle to determine eligibility for Hats
interface SanctionsList {
    /// @notice Check if an address is sanctioned
    /// @param addr The address to be checked
    /// @return bool Returns true if the address is sanctioned, false otherwise
    function isSanctioned(address addr) external view returns (bool);
}

/// @title Sanctioned Hats Eligibility Module
/// @notice Module for determining Hat eligibility based on sanctions list
/// @dev Inherits from HatsModule and implements IHatsEligibility
contract SanctionedHat is HatsModule, IHatsEligibility {
    address constant SANCTIONS_CONTRACT = 0x40C57923924B5c5c5455c48D93317139ADDaC8fb; // Address of the sanctions list contract

    /// @notice Constructor for SanctionedHat
    /// @dev Sets up the HatsModule with a version string
    /// @param _version Version string for the HatsModule
    constructor(string memory _version) HatsModule(_version) {}

 /* /// @notice Determines the eligibility and standing of a wearer address for a Hat
    /// @dev Checks if the wearer is sanctioned and assigns eligibility and standing accordingly
    /// @param _wearer Address of the potential or current Hat wearer
    /// @param _hatId (unused) ID of the Hat, included for interface compliance
    /// @return eligible True if the wearer is eligible, false otherwise
    /// @return standing True if the wearer is in good standing, false otherwise */
    function getWearerStatus(address _wearer, uint256 /* _hatId */)
        public
        view
        override
        returns (bool eligible, bool standing)
    {
        SanctionsList sanctionsList = SanctionsList(SANCTIONS_CONTRACT);
        bool isSanctioned = sanctionsList.isSanctioned(_wearer); // Checks if the address is sanctioned

        if (isSanctioned) {
            return (false, false); // Sanctioned addresses are not eligible and not in good standing
        }
        
        return (true, true); // Address is not sanctioned, eligible and in good standing
    }
}
