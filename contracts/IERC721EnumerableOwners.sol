// SPDX-License-Identifier: MIT
// IERC721EnumerableOwners.sol
// Robert Susik (rsusik@kis.p.lodz.pl)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title ERC-721 Non-Fungible Token Standard, optional owner enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721EnumerableOwners is IERC721 {
    /**
     * @dev Returns the total amount of token owners.
     */
    function ownersNumber() external view returns (uint256);

    /**
     * @dev Returns an address of owner at a given `index` of all the token owners.
     * Use along with {ownersNumber} to enumerate all owners.
     */
    function ownerByIndex(uint256 index) external view returns (address);
}