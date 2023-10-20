//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Timer is ERC721Enumerable, ERC721URIStorage, Ownable, AutomationCompatible {

    using Strings for uint256;

    uint public lastBlockTime = block.timestamp;
    uint public timeDifference;
    event PerformEvent(uint time, uint difference);

    uint public count = 20;

    constructor()
        ERC721("TimerToken", "TTK")
    {}

    function tokenURI(uint256 _tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token.");
        return _baseURI();
    }

    /* Chainlink Automatization */
    function checkUpkeep(bytes calldata /*checkData*/) external view override returns (bool upkeepNeeded, bytes memory performData) {
        if (count > 0) {
            return (true, abi.encode(block.timestamp));
        }
    }

    function performUpkeep(bytes calldata performData) external {
        
        count -= 1;

        (uint performTime) =  abi.decode(
            performData,
             (uint)
        );

        timeDifference = performTime - lastBlockTime;
        emit PerformEvent(lastBlockTime, timeDifference);

        lastBlockTime = performTime;
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }
    
    function _burn(uint256 tokenId) internal 
    override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual
    override(ERC721URIStorage, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal
    override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

}