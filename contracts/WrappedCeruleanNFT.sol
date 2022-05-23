// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/interfaces/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

contract WrappedCeruleanNFT is ERC721Upgradeable, ERC721HolderUpgradeable, ReentrancyGuardUpgradeable {
  event Wrapped(address indexed by, uint256 _tokenId);
  event Unwrapped(address indexed by, uint256 _tokenId);

  /// @dev CeruleanNFT contract address
  address public ceruleanNFT;

  function initialize(
    string memory _name,
    string memory _symbol,
    address _ceruleanNFT
  ) external initializer {
    __ERC721_init_unchained(_name, _symbol);
    __ERC721Holder_init();
    __ReentrancyGuard_init();

    // set ceruleanNFT address
    ceruleanNFT = _ceruleanNFT;
  }

  /**
   * @notice Wrap CeruleanNFT
   * @dev CeruleanNFT should be locked on the contract
   * @dev msg.sender should be the CeruleanNFT owner or get approved by the CeruleanNFT owner
   * @dev WrappedCeruleanNFT tokenId is the same as the CeruleanNFT one
   * @param _tokenId CeruleanNFT tokenId to wrap
   */
  function wrap(uint256 _tokenId) external nonReentrant {
    // get CeruleanNFT owner
    address owner = IERC721Upgradeable(ceruleanNFT).ownerOf(_tokenId);

    // check if msg.sender is the owner
    require(msg.sender == owner, "No owning CeruleanNFT");

    // lock CeruleanNFT
    IERC721Upgradeable(ceruleanNFT).safeTransferFrom(owner, address(this), _tokenId);

    // mint WrappedCeruleanNFT
    _safeMint(owner, _tokenId, bytes(""));

    emit Wrapped(owner, _tokenId);
  }

  /**
   * @notice Unwrap CeruleanNFT
   * @dev msg.sender should be the WrappedCeruleanNFT owner or get approved by the WrappedCeruleanNFT owner
   * @dev CeruleanNFT should be unlocked to the WrappedCeruleanNFT owner
   * @param _tokenId WrappedCeruleanNFT tokenId to unwrap
   */
  function unwrap(uint256 _tokenId) external nonReentrant {
    // get WrappedCeruleanNFT owner
    address owner = ownerOf(_tokenId);

    // check if msg.sender is the owner
    require(msg.sender == owner, "No owning WrappedCeruleanNFT");

    // burn WrappedCeruleanNFT
    _burn(_tokenId);

    // unlock CeruleanNFT
    IERC721Upgradeable(ceruleanNFT).safeTransferFrom(address(this), owner, _tokenId);

    emit Unwrapped(owner, _tokenId);
  }
}
