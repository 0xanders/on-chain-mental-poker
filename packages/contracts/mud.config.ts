import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    GameState: ["Join", "Shuffle", "DealCards", "DecryptForOthers", "UploadSecret", "Error", "Finished"]
  },

  tables: {
    Game: {
      dataStruct: true,
      keySchema: {
        id: "bytes32",
      },
      schema: {
        state: "GameState",
        maxPlayers: "uint256",
        turn: "uint8",
        cardIndex: "uint8",
        winner: "address",
        cardsHash: "bytes32[52]",
        players: "address[]"
      },
    },
    Commitment: {
      keySchema: {
        gameId: "bytes32",
        player: "address"
      },
      schema: {
        msgToSign: "bytes32",
        resultOfSign: "bytes32",
        key: "bytes32"
      },
    },

    HandCard: {
      keySchema: {
        gameId: "bytes32",
        player: "address"
      },
      schema: {
        tempCardHash: "bytes32",
        cardHash: "bytes32",
        card: "bytes32"
      },
    }

  },
});
