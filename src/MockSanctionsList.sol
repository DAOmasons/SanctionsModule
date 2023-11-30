// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "./SanctionsList.sol";

contract MockSanctionsList is SanctionsList {

    function mockSetSanctioned(address addr, bool sanctioned) public {
        address[] memory addrs = new address[](1);
        addrs[0] = addr;

        if (sanctioned) {
            addToSanctionsList(addrs);
        } else {
            removeFromSanctionsList(addrs);
        }
    }
}


