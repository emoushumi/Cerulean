// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract CeruleanNFT is ERC721Upgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
  event NFTMintAllowed(address indexed by, address indexed minter, uint256 startAt, uint256 endAt, uint256 minPrice);

  /// @dev User Mint Info
  struct UserMintInfo {
    uint256 mintStartAt;
    uint256 mintEndAt;
    uint256 minPrice;
  }

  /// @dev TokenId
  uint256 public tokenId;

  /// @dev User -> UserMintInfo
  mapping(address => UserMintInfo) public userMintInfo;

  function initialize(string memory _name, string memory _symbol) external initializer {
    __ERC721_init_unchained(_name, _symbol);
    __Ownable_init();
    __ReentrancyGuard_init();
  }

  /**
   * @notice Mint CeruleanNFT
   * @dev msg.sender can mint CeruleanNFT only during the period allowed
   * @dev msg.sender should pay Ether more than the minimun price set
   */
  function mint() external payable nonReentrant {
    // check mint conditions
    require(
      userMintInfo[msg.sender].mintStartAt <= block.timestamp && block.timestamp <= userMintInfo[msg.sender].mintEndAt,
      "Invalid mint time"
    );
    require(msg.value >= userMintInfo[msg.sender].minPrice, "Lower price");

    // mint NFT
    tokenId++;
    _safeMint(msg.sender, tokenId, bytes(""));
  }

  /**
   * @notice Allow minting CeruleanNFT
   * @dev Only owner
   * @dev _minter Minter address
   * @dev _startAt Mint start time
   * @dev _endAt Mint end time
   * @dev _minPrice Mint min price
   */
  function allowNFTMint(
    address _minter,
    uint256 _startAt,
    uint256 _endAt,
    uint256 _minPrice
  ) external onlyOwner {
    // update userMintInfo
    userMintInfo[_minter].mintStartAt = _startAt;
    userMintInfo[_minter].mintEndAt = _endAt;
    userMintInfo[_minter].minPrice = _minPrice;

    emit NFTMintAllowed(msg.sender, _minter, _startAt, _endAt, _minPrice);
  }
}
