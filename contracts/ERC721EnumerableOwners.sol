// SPDX-License-Identifier: MIT
// ERC721EnumerableOwners.sol
// Robert Susik (rsusik@kis.p.lodz.pl)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC721EnumerableOwners.sol";

/**
 * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
 * enumerability of all the token owners in the contract.
 */
abstract contract ERC721EnumerableOwners is ERC721, IERC721EnumerableOwners {
    // Array with all owner addresses, used for enumeration
    uint256[] private _allOwners;
    // Mapping from owner address to index of the owner
    mapping(uint256 => uint256) private _allOwnersIndex;

    function ownersNumber() public view virtual override returns (uint256) {
        return _allOwners.length;
    }

    function ownerByIndex(uint256 index) public view virtual override returns (address) {
        require(index < ERC721EnumerableOwners.ownersNumber(), "ERC721EnumerableOwners: global index out of bounds");
        return address(uint160(_allOwners[index]));
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC721EnumerableOwners).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);
        if (from != address(0) && from != to) {
            if (ERC721.balanceOf(from) == 1) {
                _removeOwnerFromOwnerEnumeration(from);
            }
        }
        if (to != address(0) && to != from) {
            // add `to` to owners if he is not already there
            if (ERC721.balanceOf(to) < 1) {
                uint256 ownerAddress = uint256(uint160(to));
                _allOwnersIndex[ownerAddress] = _allOwners.length;
                _allOwners.push(ownerAddress);
            }
        }
    }


    function _removeOwnerFromOwnerEnumeration(address owner) internal {
        uint256 ownerAddress = uint256(uint160(owner));
        uint256 ownerIndex = _allOwnersIndex[ownerAddress];

        uint256 lastOwnerIndex = _allOwners.length - 1;
        uint256 lastOwnerAddress = _allOwners[lastOwnerIndex];

        _allOwners[ownerIndex] = lastOwnerAddress;
        _allOwnersIndex[lastOwnerAddress] = ownerIndex;

        delete _allOwnersIndex[ownerAddress];
        _allOwners.pop();
    }
}