// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Game, GameData } from "../codegen/tables/Game.sol";
import { Commitment, CommitmentData } from "../codegen/tables/Commitment.sol";
import { HandCard, HandCardData } from "../codegen/tables/HandCard.sol";
import { GameState } from "../codegen/Types.sol";

contract GameSystem is System {
  uint32[52] public constant CARDS = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    50,
    51,
    52
  ];

  modifier onlyState(bytes32 gameId, GameState state) {
    require(gameData.state == GameState.Inactive, "Invalid state");
    _;
  }

  function createGame(bytes32 gameId) public {
    GameData gameData = Game.get(gameId);
    require(gameData.players.length == 0, "Game was created");
    address[] memory players = [msg.sender];
    Game.set(gameId, GameState.Inactive, 3, players, 0);
  }

  function joinInGame(bytes32 gameId) public onlyState(gameId, GameState.Join) {
    GameData gameData = Game.get(gameId);
    _checkIsIn();
    Game.pushPlayers(msg.sender);
    if (Game.lengthPlayers(gameId) == gameData.maxPlayers) {
      Game.setState(gameId, GameState.Shuffle);
    }
  }

  function shuffleAndSave(
    bytes32 gameId,
    bytes32 msgToSign,
    bytes32 resultOfSign,
    bytes32[52] memory cardsHash
  ) public onlyState(gameId, GameState.Shuffle) {
    GameData gameData = Game.get(gameId);
    _checkTurn(gameData);
    Game.setCardsHash(gameId, cardsHash);
    Commitment.set(gameId, msg.sender, msgToSign, resultOfSign, bytes32(0));

    if (gameData.turn + 1 == gameData.maxPlayers) {
      Game.setTurn(0);
      Game.setState(gameId, GameState.DealCards);
    } else {
      Game.setTurn(gameData.turn + 1);
    }
  }

  function dealCards(bytes32 gameId) public onlyState(gameId, GameState.DealCards) {
    GameData gameData = Game.get(gameId);
    _checkTurn(gameData);
    require(gameData.cardIndex < gameData.cardsHash.length);
    HandCard.setCardHash(gameId, msg.sender, gameData.cardsHash[gameData.cardIndex]);
    Game.setCardIndex(gameId, gameData.cardIndex + 1);

    if (gameData.turn + 1 == gameData.maxPlayers) {
      Game.setTurn(0);
      Game.setState(gameId, GameState.DecryptForOthers);
    } else {
      Game.setTurn(gameData.turn + 1);
    }
  }

  function decryptCard(
    bytes32 gameId,
    address[] memory others,
    bytes32[] memory tempCardsHash
  ) public onlyState(gameId, GameState.DecryptForOthers) {
    GameData gameData = Game.get(gameId);
    _checkTurn(gameData);
    require(others.length == tempCardsHash.length, "length not match");
    for (uint i = 0; i < others.length; i++) {
      require(others[i] != msg.sender, "Error");
      HandCard.setTempCardHash(gameId, msg.sender, tempCardsHash[i]);
    }

    if (gameData.turn + 1 == gameData.maxPlayers) {
      Game.setTurn(0);
      Game.setState(gameId, GameState.UploadSecret);
    } else {
      Game.setTurn(gameData.turn + 1);
    }
  }

  function uploadSecretKey(bytes32 gameId, bytes32 secretKey) public onlyState(gameId, GameState.UploadSecret) {
    GameData gameData = Game.get(gameId);
    _checkTurn(gameData);
    Commitment.setKey(gameId, msg.sender, secretKey);

    if (gameData.turn + 1 == gameData.maxPlayers) {
      Game.setTurn(0);
      _settlement();
    } else {
      Game.setTurn(gameData.turn + 1);
    }
  }

  function _settlement(bytes32 gameId) internal {
    
  }

  function _checkTurn(GameData gameData) internal {
    require(gameData.players[gameData.turn] == msg.sender, "Not your turn");
  }

  function _checkIsIn(uint256 gameId) internal view {
    bool isIn;
    address[] memory players = Game.getPlayers(gameId);
    for (uint i = 0; i < players.length; i++) {
      if (players[i] == msg.sender) {
        isIn = true;
        break;
      }
    }

    require(isIn, "Invalid Player");
  }
}
