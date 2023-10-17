//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Benefit is ERC721Enumerable, Ownable {

    using Strings for uint256;

    string baseURI;
    uint256 public requiredAmount = 2; //Benefit을 받기 위해 소유하고 있어야 할 쿠폰의 개수.
    bool public paused = false;
    address public couponAddress; // Coupon contract address.)

    constructor(
        string memory _initBaseURI
    )
        ERC721("BToken", "BTK")
    {
        setBaseURI(_initBaseURI);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token.");
        return _baseURI();
    }

    function claim() public {
        require(!paused, "Contract is paused");
        IERC721 token = IERC721(couponAddress);
        uint256 ownedAmount = token.balanceOf(msg.sender);
        require(ownedAmount >= requiredAmount, "You don't own enough Coupon NFTs");

        uint256 supply = totalSupply();
        _safeMint(msg.sender, supply + 1);
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function pause(bool _state) public onlyOwner() {
        paused = _state;
    }

}