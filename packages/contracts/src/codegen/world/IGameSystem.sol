// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

interface IGameSystem {
  function isValidCard(bytes32 card) external pure returns (bool);

  function createGame(bytes32 gameId) external;

  function getIdByGameIdAndPlayerAddress(bytes32 gameId, address player) external pure returns (bytes32);

  function joinInGame(bytes32 gameId) external;

  function shuffleAndSave(
    bytes32 gameId,
    bytes32 msgToSign,
    bytes32 resultOfSign,
    bytes32[52] memory cardsHash
  ) external;

  function dealCards(bytes32 gameId) external;

  function decryptCard(bytes32 gameId, address[] memory others, bytes32[] memory tempCardsHash) external;

  function uploadSecretKey(bytes32 gameId, bytes32 secretKey) external;

  function rc4EncryptBytes32(bytes32 input, bytes32 key) external pure returns (bytes32 output);

  function rc4EncryptBytes(bytes memory input, bytes memory key) external pure returns (bytes memory output);
}
