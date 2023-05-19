// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Game, GameData } from "../codegen/tables/Game.sol";
import { GameState } from "../codegen/Types.sol";

contract GameSystem is System {
  uint32[52] constant  public CARDS = [1,2,3,4...52];
  
  function createGame(bytes32 gameId) public {
    GameData gameData = Game.get(gameId);
    require(gameData.players.length == 0, "Game was created");
    address[] memory players = [msg.sender];
    Game.set(gameId, GameState.Inactive, 3, players, 0);
  }

  function joinInGame(bytes32 gameId) public {
    GameData gameData = Game.get(gameId);
    require(gameData.state == GameState.Inactive, "Cannot join in");
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
        bytes32[52] memory cardsHash_
    ) public {
      // turn?
      // gameData.players[turn] == msg.sender;

        
    }

    function dealCards() public{

    }

    function decryptCard(){
      
    }

    function uploadSecret(bytes32 secret) public{
      a 上传秘钥
      保存a的明牌
    }

    function settlement() public {


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
