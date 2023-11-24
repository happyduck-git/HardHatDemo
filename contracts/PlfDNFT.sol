//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Multicall.sol";

contract PlfDNFT is ERC721URIStorage, Multicall {
    uint256 private _nextTokenId;

    constructor()
        ERC721("GGToken", "GTK")
    {}

    // (public) Mint NFT
    function safeMint(address to, string memory uri) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        console.log("Minted token id: %s", tokenId);
    }

    // (public) Update token uri
    function updateTokenUri(uint256 tokenId, string memory uri) public {
        _setTokenURI(tokenId, uri);
        console.log("TokenUri updated... token id # %s", tokenId);
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function multicall(bytes[] calldata data) external override virtual returns (bytes[] memory results) {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            results[i] = Address.functionDelegateCall(address(this), data[i]);
        }
        return results;
    }
}