import { mudConfig } from "@latticexyz/world/register";

export default mudConfig({
  enums: {
    GameState: ["Join", "Shuffle", "DealCards", "DecryptForOthers", "UploadSecret", "Error", "Finished"],
    Cards:
      [
        "Diamonds_2", "Clubs_2", "Hearts_2", "Spades_2",
        "Diamonds_3", "Clubs_3", "Hearts_3", "Spades_3",
        "Diamonds_4", "Clubs_4", "Hearts_4", "Spades_4",
        "Diamonds_5", "Clubs_5", "Hearts_5", "Spades_5",
        "Diamonds_6", "Clubs_6", "Hearts_6", "Spades_6",
        "Diamonds_7", "Clubs_7", "Hearts_7", "Spades_7",
        "Diamonds_8", "Clubs_8", "Hearts_8", "Spades_8",
        "Diamonds_9", "Clubs_9", "Hearts_9", "Spades_9",
        "Diamonds_10", "Clubs_10", "Hearts_10", "Spades_10",
        "Diamonds_J", "Clubs_J", "Hearts_J", "Spades_J",
        "Diamonds_Q", "Clubs_Q", "Hearts_Q", "Spades_Q",
        "Diamonds_K", "Clubs_K", "Hearts_K", "Spades_K",
        "Diamonds_A", "Clubs_A", "Hearts_A", "Spades_A"
      ],
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
        card: "uint32"
      },
    }

  },
});
