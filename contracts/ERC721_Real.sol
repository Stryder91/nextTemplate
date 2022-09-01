// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
//Ownable is needed to setup sales royalties on Open Sea
//if you are the owner of the contract you can configure sales Royalties in the Open Sea website
import "@openzeppelin/contracts/access/Ownable.sol";
//the rarible dependency files are needed to setup sales royalties on Rarible 
import "./rarible/royalties/contracts/impl/RoyaltiesV2Impl.sol";
import "./rarible/royalties/contracts/LibPart.sol";
import "./rarible/royalties/contracts/LibRoyaltiesV2.sol";
import "./HypeSocietyPaymentSplitter.sol";

contract HypeSocietyCollection is ERC721Enumerable, PaymentSplitter, Ownable, RoyaltiesV2Impl {
  using Strings for uint256;

  string private baseURI;
  string private blindURI;

  uint256 public constant BUY_LIMIT_PER_TX = 5;
  uint256 public constant MAX_NFT_RAFFLE = 2100; 
  uint256 private constant MAX_NFT = 7777; // 100 giveway 

  uint256 public NFTPrice = 0.1 ether;   

  bool public reveal;
  bool public isActive;
  bool public isRaffleActive;

  bytes32 public root;
  mapping(address => uint256) private raffleClaimed;
  uint256 public giveawayCount;

  bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
  address[] private contributors = [0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
                                    0x70997970C51812dc3A010C7d01b50e0d17dc79C8
                                    ];
  uint256[] private sharesContributors = [7000, 3000];

  constructor(
      string memory _name,
      string memory _symbol
  ) ERC721(_name, _symbol) PaymentSplitter(contributors, sharesContributors){
  }

  /*
  * Function to reveal all NFTs
  */
  function revealNow() 
      external 
      onlyOwner 
  {
      reveal = true;
  }

  /*
  * Function setIsActive to activate/desactivate the smart contract
  */
  function setIsActive(
      bool _isActive
  ) 
      external 
      onlyOwner 
  {
      isActive = _isActive;
  }
  
  /*
  * Function setRaffleActive to activate/desactivate the presale  
  */
  function setRaffleActive(
      bool _isActive
  ) 
      external 
      onlyOwner 
  {
      isRaffleActive = _isActive;
  }
  
  /*
  * Function to set Base and Blind URI 
  */
  function setURIs(
      string memory _blindURI, 
      string memory _URI
  ) 
      external 
      onlyOwner 
  {
      blindURI = _blindURI;
      baseURI = _URI;
  }
  
  /*
  * Function to mint new NFTs during the public sale
  * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
  */
  function mintNFT(
      uint256 _numOfTokens
  ) 
      public 
      payable 
  {
  
      require(isActive, "HypeSociety : Contract is not active");
      require(!isRaffleActive, "HypeSociety : Only whiteing from White List");
      require(_numOfTokens <= BUY_LIMIT_PER_TX, "HypeSociety : Cannot mint above limit");
      require((totalSupply() + _numOfTokens) - giveawayCount <= MAX_NFT_RAFFLE, "HypeSociety : Purchase would exceed max public supply of NFTs");
      require(NFTPrice * _numOfTokens == msg.value, "HypeSociety : Ether value sent is not correct");
      
      for(uint i = 0; i < _numOfTokens; i++) {
          _safeMint(msg.sender, totalSupply() - giveawayCount);
      }
  }
  
  /*
  * Function to mint new NFTs during the raffle
  * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
  */ 
  function mintNFTDuringRaffle(
      uint256 _numOfTokens,
      bytes32[] memory _proof
  ) 
      public 
      payable
  {
      require(isActive, "HypeSociety : Contract is not active");
      require(isRaffleActive, "HypeSociety : Only whiteing from White List");
      require(verify(_proof, bytes32(uint256(uint160(msg.sender)))), "HypeSociety : Not whitelisted");
      require(totalSupply() < MAX_NFT_RAFFLE, "HypeSociety : All public tokens have been minted");
      require(_numOfTokens <= BUY_LIMIT_PER_TX, "HypeSociety : Cannot purchase this many tokens");
      require((totalSupply() + _numOfTokens) - giveawayCount <= MAX_NFT_RAFFLE, "HypeSociety : Purchase would exceed max public supply of NFTs");
      require(raffleClaimed[msg.sender] + _numOfTokens <= BUY_LIMIT_PER_TX, "HypeSociety : Purchase exceeds max whiteed");
      require(NFTPrice * _numOfTokens == msg.value, "HypeSociety : Ether value sent is not correct");
      for (uint256 i = 0; i < _numOfTokens; i++) {
          
          raffleClaimed[msg.sender] += 1;
          _safeMint(msg.sender, totalSupply() - giveawayCount);
      }
  }
  
  /*
  * Function to mint all NFTs for giveaway and partnerships
  */
  function mintByOwner(
      address _to, 
      uint256 _tokenId
  ) 
      public 
      onlyOwner
  {
      require(_tokenId >= MAX_NFT_RAFFLE, "HypeSociety : Tokens number to mint must exceed number of public tokens");
      require(_tokenId < MAX_NFT, "HypeSociety : Tokens number to mint cannot exceed number of MAX tokens");
      _safeMint(_to, _tokenId);
      giveawayCount = giveawayCount + 1;
  }
  
  /*
  * Function to mint all NFTs for giveaway and partnerships
  */
  function mintMultipleByOwner(
      address[] memory _to, 
      uint256[] memory _tokenId
  ) 
      public 
      onlyOwner
  {
      require(_to.length == _tokenId.length, "HypeSociety : Should have same length");
      for(uint256 i = 0; i < _to.length; i++){
          require(_tokenId[i] >= MAX_NFT_RAFFLE, "HypeSociety : Tokens number to mint must exceed number of public tokens");
          require(_tokenId[i] < MAX_NFT, "HypeSociety : Tokens number to mint cannot exceed number of MAX tokens");
          _safeMint(_to[i], _tokenId[i]);
          giveawayCount = giveawayCount + 1;
      }
  }
  
  /*
  * Function to get token URI of given token ID
  * URI will be blank untill totalSupply reaches MAX_NFT_PUBLIC
  */
  function tokenURI(
      uint256 _tokenId
  ) 
      public 
      view 
      virtual 
      override 
      returns (string memory) 
  {
      require(_exists(_tokenId), "HypeSociety : URI query for nonexistent token");
      if (!reveal) {
          return string(abi.encodePacked(blindURI));
      } else {
          return string(abi.encodePacked(baseURI, _tokenId.toString()));
      }
  }

  // Standard functions to be overridden 
  function _beforeTokenTransfer(
      address _from, 
      address _to, 
      uint256 _tokenId
  ) 
      internal 
      override(ERC721Enumerable) 
  {
      super._beforeTokenTransfer(_from, _to, _tokenId);
  }

  function setRoot(uint256 _root) onlyOwner() public {
      root = bytes32(_root);
  }

  function verify(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
      bytes32 computedHash = leaf;

      for (uint256 i = 0; i < proof.length; i++) {
          bytes32 proofElement = proof[i];
          
          if (computedHash <= proofElement) {
              // Hash(current computed hash + current element of the proof)
              computedHash = sha256(abi.encodePacked(computedHash, proofElement));
          } else {
              // Hash(current element of the proof + current computed hash)
              computedHash = sha256(abi.encodePacked(proofElement, computedHash));
          }
      }

      // Check if the computed hash (root) is equal to the provided root
      return computedHash == root;
  }

  //configure royalties for Rariable
  function setRoyalties(uint _tokenId, address payable _royaltiesRecipientAddress, uint96 _percentageBasisPoints) public onlyOwner {
      LibPart.Part[] memory _royalties = new LibPart.Part[](1);
      _royalties[0].value = _percentageBasisPoints;
      _royalties[0].account = _royaltiesRecipientAddress;
      _saveRoyalties(_tokenId, _royalties);
  }

  //configure royalties for Mintable using the ERC2981 standard
  function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
      //use the same royalties that were saved for Rariable
      LibPart.Part[] memory _royalties = royalties[_tokenId];
      if(_royalties.length > 0) {
          return (_royalties[0].account, (_salePrice * _royalties[0].value) / 10000);
      }
      return (address(0), 0);
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
      if(interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
          return true;
      }
      if(interfaceId == _INTERFACE_ID_ERC2981) {
          return true;
      }
      return super.supportsInterface(interfaceId);
  }
}
