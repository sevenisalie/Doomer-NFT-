pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract AdvancedCollectible is ERC721, VRFConsumerBase {

    bytes32 internal keyhash;
    uint public fee;
    uint public tokenCounter;

    enum Color {PINK, ORANGE, YELLOW, BLUE}

    //mappings
    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    mapping(uint => Color) public tokenIdToColor;
    mapping(bytes32 => uint) public requestIdToTokenId;


    event requestedCollectible(bytes32 indexed requestId);

    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash) public
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC721("Doomer", "DOOM") 
    {
        keyhash = _keyhash;
        fee = 0.1 * 10**18; //0.1 LINK
        tokenCounter = 0;
    }
    function createCollectible(uint256 userProvidedSeed, string memory tokenURI) public returns (bytes32) {
        bytes32 requestId = requestRandomness(keyhash, userProvidedSeed, fee);
        requestIdToSender[requestId] = msg.sender; //uses the mapping to assign the random Id to the person requesting
        requestIdToTokenURI[requestId] = tokenURI;
        emit requestedCollectible(requestId);
    }

    function fulfillRandomness(bytes32 requestId, uint randomNumber) internal override {
        address tokenOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint newItemId = tokenCounter;
        _safeMint(tokenOwner, newItemId);
        Color color = Color(randomNumber % 4); //modulo three means eiether 0, 1, 2, 3 from the list of colors
        tokenIdToColor[newItemId] = color;
        requestIdToTokenId[requestId] = newItemId;
        tokenCounter = tokenCounter + 1;

    }

    function setTokenURI(uint tokenId, string memory _tokenURI) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: TRANSFER FCALLER IS NOT APPROVED");
        _setTokenURI(tokenId, _tokenURI);
    }
}