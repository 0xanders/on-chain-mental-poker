// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Game, GameData } from "../codegen/tables/Game.sol";
import { Commitment, CommitmentData } from "../codegen/tables/Commitment.sol";
import { HandCard, HandCardData } from "../codegen/tables/HandCard.sol";
import { GameState } from "../codegen/Types.sol";

contract GameSystem is System {
  modifier onlyState(bytes32 gameId, GameState state) {
    require(Game.getState(gameId) == state, "Invalid state");
    _;
  }

  function createGame(bytes32 gameId) public {
    GameData memory gameData = Game.get(gameId);
    require(gameData.players.length == 0, "Game was created");
    address[] memory players;
    Game.pushPlayers(gameId, msg.sender);
    Game.setState(gameId, GameState.Join);
    Game.setMaxPlayers(gameId, 3);
  }

  function joinInGame(bytes32 gameId) public onlyState(gameId, GameState.Join) {
    GameData memory gameData = Game.get(gameId);
    _checkIsIn(gameId);
    Game.pushPlayers(gameId, msg.sender);
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
    GameData memory gameData = Game.get(gameId);
    _checkTurn(gameData);
    Game.setCardsHash(gameId, cardsHash);
    Commitment.set(gameId, msg.sender, msgToSign, resultOfSign, bytes32(0));

    if (gameData.turn + 1 == gameData.maxPlayers) {
      Game.setTurn(gameId, 0);
      Game.setState(gameId, GameState.DealCards);
    } else {
      Game.setTurn(gameId, gameData.turn + 1);
    }
  }

  function dealCards(bytes32 gameId) public onlyState(gameId, GameState.DealCards) {
    GameData memory gameData = Game.get(gameId);
    _checkTurn(gameData);
    require(gameData.cardIndex < gameData.cardsHash.length);
    HandCard.setCardHash(gameId, msg.sender, gameData.cardsHash[gameData.cardIndex]);
    Game.setCardIndex(gameId, gameData.cardIndex + 1);

    if (gameData.turn + 1 == gameData.maxPlayers) {
      Game.setTurn(gameId, 0);
      Game.setState(gameId, GameState.DecryptForOthers);
    } else {
      Game.setTurn(gameId, gameData.turn + 1);
    }
  }

  function decryptCard(
    bytes32 gameId,
    address[] memory others,
    bytes32[] memory tempCardsHash
  ) public onlyState(gameId, GameState.DecryptForOthers) {
    GameData memory gameData = Game.get(gameId);
    _checkTurn(gameData);
    require(others.length == tempCardsHash.length, "length not match");
    for (uint i = 0; i < others.length; i++) {
      require(others[i] != msg.sender, "Error");
      HandCard.setTempCardHash(gameId, msg.sender, tempCardsHash[i]);
    }

    if (gameData.turn + 1 == gameData.maxPlayers) {
      Game.setTurn(gameId, 0);
      Game.setState(gameId, GameState.UploadSecret);
    } else {
      Game.setTurn(gameId, gameData.turn + 1);
    }
  }

  function uploadSecretKey(bytes32 gameId, bytes32 secretKey) public onlyState(gameId, GameState.UploadSecret) {
    GameData memory gameData = Game.get(gameId);
    _checkTurn(gameData);
    Commitment.setKey(gameId, msg.sender, secretKey);

    if (gameData.turn + 1 == gameData.maxPlayers) {
      Game.setTurn(gameId, 0);
      _settlement(gameId);
    } else {
      Game.setTurn(gameId, gameData.turn + 1);
    }
  }

  function _settlement(bytes32 gameId) internal {}

  function _checkTurn(GameData memory gameData) internal {
    require(gameData.players[gameData.turn] == msg.sender, "Not your turn");
  }

  function _checkIsIn(bytes32 gameId) internal view {
    bool isIn;
    address[] memory players = Game.getPlayers(gameId);
    for (uint i = 0; i < players.length; i++) {
      if (players[i] == msg.sender) {
        isIn = true;
        break;
      }
    }

    require(!isIn, "Invalid Player");
  }
}
