//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract CollectionHype is ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  using SafeMath for uint256;

  string private baseURI;
  bytes32 private root;
  uint public constant MAX_NFT_PUBLIC = 1000;
  uint public constant MAX_MINT_PER_USER = 5;

  uint private priceNFT = 0.1 ether;
  uint private nftRemaining;

  address private royalties;

  // How many NFTs have minted each owner 
  mapping(address => uint) private ownerToNfts;

  // token id increment with each mint
  Counters.Counter public tokenCount;

  constructor(string memory _baseUri, address royaltiesWallet) ERC721("My721", "721") {
    nftRemaining = MAX_NFT_PUBLIC;
    baseURI = _baseUri;
    royalties = royaltiesWallet;
  }

  function getRemaining() external onlyOwner view returns(uint){
    return nftRemaining;
  }

  // Mint test
  // bytes32 _root, bytes32[] memory _proof
  function mint(uint _amount) payable public returns(uint) {
    // require(verify(_root, bytes32(uint(uint160(msg.sender))), _proof), "Not whitelisted");
    require(msg.value >= _amount * priceNFT, "Error quantity not correct");
    require(nftRemaining > 0, "Sold Out : No NFT remaining");
    uint alreadyMinted = ownerToNfts[msg.sender].add(_amount);
    require(alreadyMinted <= MAX_MINT_PER_USER, "User already minted 5 tokens"); 

    uint temp = ownerToNfts[msg.sender];
    ownerToNfts[msg.sender] = temp.add(_amount);

    uint tokenId;

    require(royalties != address(0), "Error address is zero");
    payable(royalties).transfer(msg.value);

    for (uint i=0; i<_amount; i++) {
      tokenCount.increment();
      tokenId = tokenCount.current();
      _mint(msg.sender, tokenId);
      _setTokenURI(tokenId, uri(tokenId));
    }

    nftRemaining.sub(_amount);
    return tokenId;
  }

  function withdrawAll() public onlyOwner{
    require(address(this).balance > 0, "No fund in contract balance");
    payable(msg.sender).transfer(address(this).balance);
  }

  function uri(uint256 _tokenId) private view returns(string memory) {
    return string(
      abi.encodePacked(
        baseURI,
        Strings.toString(_tokenId),
        ".json"
      )
    );
  }  
}

