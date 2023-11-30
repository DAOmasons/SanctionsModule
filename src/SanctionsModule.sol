// SPDX-License-Identifier: MIT
// Made with love by boiler @ DAO Masons

pragma solidity ^0.8.19;

//   ____    ______  _____                                                           
//  /\  _`\ /\  _  \/\  __`\      /'\_/`\                                            
//  \ \ \/\ \ \ \L\ \ \ \/\ \    /\      \     __      ____    ___     ___     ____  
//   \ \ \ \ \ \  __ \ \ \ \ \   \ \ \__\ \  /'__`\   /',__\  / __`\ /' _ `\  /',__\ 
//    \ \ \_\ \ \ \/\ \ \ \_\ \   \ \ \_/\ \/\ \L\.\_/\__, `\/\ \L\ \/\ \/\ \/\__, `\
//     \ \____/\ \_\ \_\ \_____\   \ \_\\ \_\ \__/.\_\/\____/\ \____/\ \_\ \_\/\____/
//      \/___/  \/_/\/_/\/_____/    \/_/ \/_/\/__/\/_/\/___/  \/___/  \/_/\/_/\/___/ 
//                                                                                   
//                                                                                   

import { HatsModule } from "hats-module/HatsModule.sol";
import { IHatsEligibility } from "hats-protocol/Interfaces/IHatsEligibility.sol";

/// @title Sanctions Check for Hats Protocol
/// @notice This contract extends HatsModule to include sanctions checking functionality. 
/// SanctionsModule checks ethereum wallet addresses against the OFAC Sanctions list.
/// Be a good citizen, Comply!
/// @dev Interfaces with chain analysis sanctions oracle to determine eligibility for Hats

interface SanctionsList {
      function isSanctioned(address addr) external view returns (bool);
}

/// @notice Determines the eligibility and standing of a wearer address for a Hat
/// @dev Checks if the wearer is sanctioned and assigns eligibility and standing accordingly
// @param _wearer Address of the potential or current Hat wearer
// @param _hatId (unused) ID of the Hat, included for interface compliance
// @return eligible True if the wearer is eligible, false otherwise
// @return standing True if the wearer is in good standing, false otherwise */

contract SanctionsModule is HatsModule, IHatsEligibility {
    address constant SANCTIONS_CONTRACT = 0x40C57923924B5c5c5455c48D93317139ADDaC8fb; // Address of the sanctions list contract
    
    constructor(string memory _version) HatsModule(_version) {}
    
    function getWearerStatus(address _wearer, uint256 /* _hatId */) // hatId is not required for this contract, enter 0 when calling function
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
