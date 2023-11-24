//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract CoffeePOAP is ERC721Enumerable, ERC721URIStorage, Ownable, AutomationCompatible {

    using Strings for uint256;

    string baseURI;
    uint256 public requiredAmount = 3; //Benefit을 받기 위해 소유하고 있어야 할 쿠폰의 개수.
    bool public paused = false;
    address public couponAddress; // Coupon contract address.

    uint256 public mintNeeded = 0;
    event PerformEvent(address[] owners);

    string[] poapTokenURIs = [
        "https://firebasestorage.googleapis.com/v0/b/platfarmmemebership-test.appspot.com/o/nft%2Fmetadata%2Fpoap_0.json?alt=media",
        "https://firebasestorage.googleapis.com/v0/b/platfarmmemebership-test.appspot.com/o/nft%2Fmetadata%2Fpoap_1.json?alt=media"
    ];

    mapping(address => bool) public benefitOwned;

    constructor(
        address _initCouponAddress
    )
        ERC721("POAPToken", "PTK")
    {
        setCouponAddress(_initCouponAddress);
        setBaseURI(poapTokenURIs[0]);

        for (uint256 i = 0; i < totalSupply(); i++) {
            benefitOwned[ownerOf(i)] = true;
        }
    }

    function _baseURI() internal view virtual override 
    returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 _tokenId) public view virtual override(ERC721, ERC721URIStorage)
    returns (string memory) {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token.");
        return _baseURI();
    }

    function totalCouponBalance(address owner) view public
    returns (uint256) {
        IERC721 token = IERC721(couponAddress);
        uint256 ownerOwnedAmount = token.balanceOf(owner);
        return ownerOwnedAmount;
    }

    /* Chainlink Automatization */
    function checkUpkeep(bytes calldata /*checkData*/) external view
    override returns (bool upkeepNeeded, bytes memory performData) {
        
        IERC721Enumerable token = IERC721Enumerable(couponAddress);
        uint256 totalSupply = token.totalSupply();
        address[] memory owners = new address[](totalSupply);
        address[] memory updateNeededOwners = new address[](totalSupply);
        bool needUpkeep;
        

        for (uint256 i = 0; i < token.totalSupply(); i++) {
            owners[i] = token.ownerOf(i+1);
        }

        for (uint256 i = 0; i < owners.length; i++) {
            uint256 balance = token.balanceOf(owners[i]);

            if (balance >= requiredAmount) {
                if (benefitOwned[owners[i]]) {
                    continue;
                } else {
                    updateNeededOwners[i] = owners[i];
                    needUpkeep = true;
                }
            } 
        } 

        if (needUpkeep) {
            performData = abi.encode(updateNeededOwners);
            return (true, performData);
        }   
        
    }

    function performUpkeep(bytes calldata performData) external {
        
        IERC721 token = IERC721(couponAddress);

        (address[] memory owners) = abi.decode(
            performData,
            (address[])
        );

        mintNeeded = owners.length;
        emit PerformEvent(owners);

        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] != address(0)) {
                if (!benefitOwned[owners[i]]) {
                    uint256 ownedAmount = token.balanceOf(owners[i]);
                    require(ownedAmount >= requiredAmount, "You don't own enough Coupon NFTs");   

                    uint256 supply = totalSupply();
                    string memory newURI = poapTokenURIs[(supply + 1) % 2];

                    _safeMint(owners[i], supply + 1);
                    _setTokenURI(supply + 1, newURI);

                    benefitOwned[owners[i]] = true;
                }

            }

        } 

    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setCouponAddress(address _newAddress) public onlyOwner {
        couponAddress = _newAddress;
    }

    function pause(bool _state) public onlyOwner() {
        paused = _state;
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