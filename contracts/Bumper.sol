// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.19;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Bumper {

    uint256 public number;
    event Bump(address indexed addr, uint indexed num, uint256 tokenid);


    function bump(uint256 tokenId) public {
        number += 1;
        emit Bump(msg.sender, number, tokenId);
    }
}