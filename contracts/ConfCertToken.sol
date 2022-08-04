// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "./ERC721EnumerableOwners.sol";

/*
 *
 * roles:
        • organizer = owner - can perform all activities
        • participant (transfer, list cert., validate cert., list part.), some activities require organizer confirmation
        • others (list cert., validate cert., list part.) - all blockchain users, not a role specifically

    actions:
        • mint certifications,
        • revoke certifications (burn the tokens),
        • transfer certifications,
        • list Participant’s (or other users’) certifications,
        • list the conference certifications / Participants,
        • validate the participant’s certificate.

 *
 *
*/

contract ConfCertToken is ERC721, ERC721URIStorage, ERC721Enumerable, ERC721EnumerableOwners, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor(address organizer, uint256 initialTokenId)
    ERC721("International Conference on XYZ", "ICX") {
        _tokenIds = Counters.Counter(initialTokenId);
        transferOwnership(organizer);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://icxyz.com/";
    }
    
    /// Create Certificate
    function mint(
        address _to,
        string calldata _uri
    ) 
    external onlyOwner 
    returns (uint256) {
        uint256 newTokenId = _tokenIds.current();
        _safeMint(_to, newTokenId);
        _setTokenURI(newTokenId, _uri);
        _tokenIds.increment();
        return newTokenId;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual onlyOwner
    override {
        _transfer(from, to, tokenId);
    }

    function burn(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal onlyOwner // block transfers from all but owner
        override(ERC721, ERC721Enumerable, ERC721EnumerableOwners) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) 
        internal onlyOwner // block burning from all but owner
        override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public view
        override(ERC721, ERC721URIStorage)
        returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public view
        override(ERC721, ERC721Enumerable, ERC721EnumerableOwners)
        returns (bool) {
        return super.supportsInterface(interfaceId);
    }


}
