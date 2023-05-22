// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { Game, GameData } from "../codegen/tables/Game.sol";
import { Commitment, CommitmentData } from "../codegen/tables/Commitment.sol";
import { HandCard, HandCardData } from "../codegen/tables/HandCard.sol";
import { GameState } from "../codegen/Types.sol";

contract GameSystem is System {

  function isValidCard(bytes32 card) public pure returns (bool) {
    uint256 cardNumber = uint256(card);
    return cardNumber >= 1 && cardNumber <= 52;
  }

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
    initCards(gameId);  
  }

  function initCards(bytes32 gameId) internal {
    bytes32[52] memory CARDS  = [
        bytes32(uint256(1)), bytes32(uint256(2)), bytes32(uint256(3)), bytes32(uint256(4)),
        bytes32(uint256(5)), bytes32(uint256(6)), bytes32(uint256(7)), bytes32(uint256(8)), bytes32(uint256(9)),
        bytes32(uint256(10)), bytes32(uint256(11)), bytes32(uint256(12)), bytes32(uint256(13)), bytes32(uint256(14)),
        bytes32(uint256(15)), bytes32(uint256(16)), bytes32(uint256(17)), bytes32(uint256(18)), bytes32(uint256(19)),
        bytes32(uint256(20)), bytes32(uint256(21)), bytes32(uint256(22)), bytes32(uint256(23)), bytes32(uint256(24)),
        bytes32(uint256(25)), bytes32(uint256(26)), bytes32(uint256(27)), bytes32(uint256(28)), bytes32(uint256(29)),
        bytes32(uint256(30)), bytes32(uint256(31)), bytes32(uint256(32)), bytes32(uint256(33)), bytes32(uint256(34)),
        bytes32(uint256(35)), bytes32(uint256(36)), bytes32(uint256(37)), bytes32(uint256(38)), bytes32(uint256(39)),
        bytes32(uint256(40)), bytes32(uint256(41)), bytes32(uint256(42)), bytes32(uint256(43)), bytes32(uint256(44)),
        bytes32(uint256(45)), bytes32(uint256(46)), bytes32(uint256(47)), bytes32(uint256(48)), bytes32(uint256(49)),
        bytes32(uint256(50)), bytes32(uint256(51)),bytes32(uint256(52))
    ];

    Game.setCardsHash(gameId, CARDS);
  }

  function getIdByGameIdAndPlayerAddress(bytes32 gameId, address player) public pure returns (bytes32) {
    return keccak256(abi.encodePacked(gameId, player));
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
    bytes32 commitmentId = getIdByGameIdAndPlayerAddress(gameId, msg.sender);
    Commitment.set(commitmentId, msgToSign, resultOfSign, bytes32(0));

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
    bytes32 handCardId = getIdByGameIdAndPlayerAddress(gameId, msg.sender);
    HandCard.setCardHash(handCardId, gameData.cardsHash[gameData.cardIndex]);
    HandCard.setTempCardHash(handCardId, gameData.cardsHash[gameData.cardIndex]);
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
      bytes32 handCardId = getIdByGameIdAndPlayerAddress(gameId, others[i]);

      HandCard.setTempCardHash(handCardId, tempCardsHash[i]);
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

    bytes32 commitmentId = getIdByGameIdAndPlayerAddress(gameId, msg.sender);

    bytes32 sign = Commitment.getMsgToSign(commitmentId);
    bytes32 resultOfSign1 = Commitment.getResultOfSign(commitmentId);
    bytes32 resultOfSign2 = rc4EncryptBytes32(sign, secretKey);    
    require(resultOfSign1 == resultOfSign2, "invalid secretKey");


    Commitment.setKey(commitmentId, secretKey);

    if (gameData.turn + 1 == gameData.maxPlayers) {
      Game.setTurn(gameId, 0);
      _settlement(gameId);
    } else {
      Game.setTurn(gameId, gameData.turn + 1);
    }
  }

  function _settlement(bytes32 gameId) internal {
    address[] memory players = Game.getPlayers(gameId);

    bytes32[] memory keys = new bytes32[](players.length);
    for (uint i = 0; i < players.length; i++) {
      bytes32 commitmentId = getIdByGameIdAndPlayerAddress(gameId, players[i]);

      bytes32 key = Commitment.getKey(commitmentId);
      keys[i] = key;
    }

    uint winnnerIndex = 0;
    uint winnerCard = 0;
    for (uint i = 0; i < players.length; i++) {
      bytes32 handCardId = getIdByGameIdAndPlayerAddress(gameId, players[i]);
      bytes32 cardHash = HandCard.getCardHash(handCardId);
      bytes32 card = cardHash;
      for(uint j = 0; j < keys.length; j++) {        
        card = rc4EncryptBytes32(card, keys[j]);
      }
      if(!isValidCard(card)) {
        Game.setState(gameId, GameState.Error);
        return;
      }

      HandCard.setCard(handCardId, card);
      if(uint256(card) > winnerCard) {
        winnerCard = uint256(card);
        winnnerIndex = i;
      }
    }

    Game.setState(gameId, GameState.Finished);
    Game.setWinner(gameId, players[winnnerIndex]);
  }

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

  function rc4EncryptBytes32(
        bytes32 input,
        bytes32 key
    ) public pure returns (bytes32 output) {
        bytes memory input_bytes = abi.encodePacked(input);
        bytes memory key_bytes = abi.encodePacked(key);

        bytes memory output_bytes = rc4EncryptBytes(
            input_bytes,
            key_bytes
        );

        assembly {
            output := mload(add(output_bytes, 32))
        }
    }

    function rc4EncryptBytes(
        bytes memory input,
        bytes memory key
    ) public pure returns (bytes memory output) {
        //Generate Key Schedule State
        bytes memory state = abi.encodePacked(
            uint(
                0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f
            ),
            uint(
                0x202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f
            ),
            uint(
                0x404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f
            ),
            uint(
                0x606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f
            ),
            uint(
                0x808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f
            ),
            uint(
                0xa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebf
            ),
            uint(
                0xc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedf
            ),
            uint(
                0xe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff
            )
        );

        unchecked {
            uint8 m = 0;
            uint keylen = key.length;
            uint i = 0;
            for (; i < 256; i++) {
                m = m + uint8(state[i]) + uint8(key[i % keylen]);

                bytes1 temp1 = state[i];
                state[i] = state[m];
                state[m] = temp1;
            }

            //Get Keystream and XOR with input
            output = new bytes(input.length);

            uint8 n = 0;
            m = 0;
            for (i = 0; i < input.length; i++) {
                //Adjust n and m
                n++;
                m += uint8(state[n]);

                //Swap state
                bytes1 temp1 = state[n];
                state[n] = state[m];
                state[m] = temp1;

                uint8 temp2 = uint8(state[n]) + uint8(state[m]);
                temp2 = uint8(state[temp2]);
                temp2 ^= uint8(input[i]);
                output[i] = bytes1(uint8(temp2));
            }
        }
    }
}
