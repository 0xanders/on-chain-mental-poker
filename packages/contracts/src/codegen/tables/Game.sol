// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

// Import schema type
import { SchemaType } from "@latticexyz/schema-type/src/solidity/SchemaType.sol";

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { Schema, SchemaLib } from "@latticexyz/store/src/Schema.sol";
import { PackedCounter, PackedCounterLib } from "@latticexyz/store/src/PackedCounter.sol";

// Import user types
import { GameState } from "./../Types.sol";

bytes32 constant _tableId = bytes32(abi.encodePacked(bytes16(""), bytes16("Game")));
bytes32 constant GameTableId = _tableId;

struct GameData {
  GameState state;
  uint256 maxPlayers;
  address[] players;
  uint8 turn;
  bytes32[52] cardsHash;
  uint8 cardIndex;
  address winner;
}

library Game {
  /** Get the table's schema */
  function getSchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](7);
    _schema[0] = SchemaType.UINT8;
    _schema[1] = SchemaType.UINT256;
    _schema[2] = SchemaType.ADDRESS_ARRAY;
    _schema[3] = SchemaType.UINT8;
    _schema[4] = SchemaType.BYTES32_ARRAY;
    _schema[5] = SchemaType.UINT8;
    _schema[6] = SchemaType.ADDRESS;

    return SchemaLib.encode(_schema);
  }

  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](1);
    _schema[0] = SchemaType.BYTES32;

    return SchemaLib.encode(_schema);
  }

  /** Get the table's metadata */
  function getMetadata() internal pure returns (string memory, string[] memory) {
    string[] memory _fieldNames = new string[](7);
    _fieldNames[0] = "state";
    _fieldNames[1] = "maxPlayers";
    _fieldNames[2] = "players";
    _fieldNames[3] = "turn";
    _fieldNames[4] = "cardsHash";
    _fieldNames[5] = "cardIndex";
    _fieldNames[6] = "winner";
    return ("Game", _fieldNames);
  }

  /** Register the table's schema */
  function registerSchema() internal {
    StoreSwitch.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Register the table's schema (using the specified store) */
  function registerSchema(IStore _store) internal {
    _store.registerSchema(_tableId, getSchema(), getKeySchema());
  }

  /** Set the table's metadata */
  function setMetadata() internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    StoreSwitch.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Set the table's metadata (using the specified store) */
  function setMetadata(IStore _store) internal {
    (string memory _tableName, string[] memory _fieldNames) = getMetadata();
    _store.setMetadata(_tableId, _tableName, _fieldNames);
  }

  /** Get state */
  function getState(bytes32 id) internal view returns (GameState state) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 0);
    return GameState(uint8(Bytes.slice1(_blob, 0)));
  }

  /** Get state (using the specified store) */
  function getState(IStore _store, bytes32 id) internal view returns (GameState state) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 0);
    return GameState(uint8(Bytes.slice1(_blob, 0)));
  }

  /** Set state */
  function setState(bytes32 id, GameState state) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.setField(_tableId, _keyTuple, 0, abi.encodePacked(uint8(state)));
  }

  /** Set state (using the specified store) */
  function setState(IStore _store, bytes32 id, GameState state) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.setField(_tableId, _keyTuple, 0, abi.encodePacked(uint8(state)));
  }

  /** Get maxPlayers */
  function getMaxPlayers(bytes32 id) internal view returns (uint256 maxPlayers) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 1);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Get maxPlayers (using the specified store) */
  function getMaxPlayers(IStore _store, bytes32 id) internal view returns (uint256 maxPlayers) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 1);
    return (uint256(Bytes.slice32(_blob, 0)));
  }

  /** Set maxPlayers */
  function setMaxPlayers(bytes32 id, uint256 maxPlayers) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.setField(_tableId, _keyTuple, 1, abi.encodePacked((maxPlayers)));
  }

  /** Set maxPlayers (using the specified store) */
  function setMaxPlayers(IStore _store, bytes32 id, uint256 maxPlayers) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.setField(_tableId, _keyTuple, 1, abi.encodePacked((maxPlayers)));
  }

  /** Get players */
  function getPlayers(bytes32 id) internal view returns (address[] memory players) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 2);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_address());
  }

  /** Get players (using the specified store) */
  function getPlayers(IStore _store, bytes32 id) internal view returns (address[] memory players) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 2);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_address());
  }

  /** Set players */
  function setPlayers(bytes32 id, address[] memory players) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.setField(_tableId, _keyTuple, 2, EncodeArray.encode((players)));
  }

  /** Set players (using the specified store) */
  function setPlayers(IStore _store, bytes32 id, address[] memory players) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.setField(_tableId, _keyTuple, 2, EncodeArray.encode((players)));
  }

  /** Get the length of players */
  function lengthPlayers(bytes32 id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    uint256 _byteLength = StoreSwitch.getFieldLength(_tableId, _keyTuple, 2, getSchema());
    return _byteLength / 20;
  }

  /** Get the length of players (using the specified store) */
  function lengthPlayers(IStore _store, bytes32 id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    uint256 _byteLength = _store.getFieldLength(_tableId, _keyTuple, 2, getSchema());
    return _byteLength / 20;
  }

  /** Get an item of players (unchecked, returns invalid data if index overflows) */
  function getItemPlayers(bytes32 id, uint256 _index) internal view returns (address) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getFieldSlice(_tableId, _keyTuple, 2, getSchema(), _index * 20, (_index + 1) * 20);
    return (address(Bytes.slice20(_blob, 0)));
  }

  /** Get an item of players (using the specified store) (unchecked, returns invalid data if index overflows) */
  function getItemPlayers(IStore _store, bytes32 id, uint256 _index) internal view returns (address) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getFieldSlice(_tableId, _keyTuple, 2, getSchema(), _index * 20, (_index + 1) * 20);
    return (address(Bytes.slice20(_blob, 0)));
  }

  /** Push an element to players */
  function pushPlayers(bytes32 id, address _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.pushToField(_tableId, _keyTuple, 2, abi.encodePacked((_element)));
  }

  /** Push an element to players (using the specified store) */
  function pushPlayers(IStore _store, bytes32 id, address _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.pushToField(_tableId, _keyTuple, 2, abi.encodePacked((_element)));
  }

  /** Pop an element from players */
  function popPlayers(bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.popFromField(_tableId, _keyTuple, 2, 20);
  }

  /** Pop an element from players (using the specified store) */
  function popPlayers(IStore _store, bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.popFromField(_tableId, _keyTuple, 2, 20);
  }

  /** Update an element of players at `_index` */
  function updatePlayers(bytes32 id, uint256 _index, address _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.updateInField(_tableId, _keyTuple, 2, _index * 20, abi.encodePacked((_element)));
  }

  /** Update an element of players (using the specified store) at `_index` */
  function updatePlayers(IStore _store, bytes32 id, uint256 _index, address _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.updateInField(_tableId, _keyTuple, 2, _index * 20, abi.encodePacked((_element)));
  }

  /** Get turn */
  function getTurn(bytes32 id) internal view returns (uint8 turn) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 3);
    return (uint8(Bytes.slice1(_blob, 0)));
  }

  /** Get turn (using the specified store) */
  function getTurn(IStore _store, bytes32 id) internal view returns (uint8 turn) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 3);
    return (uint8(Bytes.slice1(_blob, 0)));
  }

  /** Set turn */
  function setTurn(bytes32 id, uint8 turn) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.setField(_tableId, _keyTuple, 3, abi.encodePacked((turn)));
  }

  /** Set turn (using the specified store) */
  function setTurn(IStore _store, bytes32 id, uint8 turn) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.setField(_tableId, _keyTuple, 3, abi.encodePacked((turn)));
  }

  /** Get cardsHash */
  function getCardsHash(bytes32 id) internal view returns (bytes32[52] memory cardsHash) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 4);
    return toStaticArray_bytes32_52(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /** Get cardsHash (using the specified store) */
  function getCardsHash(IStore _store, bytes32 id) internal view returns (bytes32[52] memory cardsHash) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 4);
    return toStaticArray_bytes32_52(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /** Set cardsHash */
  function setCardsHash(bytes32 id, bytes32[52] memory cardsHash) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.setField(_tableId, _keyTuple, 4, EncodeArray.encode(fromStaticArray_bytes32_52(cardsHash)));
  }

  /** Set cardsHash (using the specified store) */
  function setCardsHash(IStore _store, bytes32 id, bytes32[52] memory cardsHash) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.setField(_tableId, _keyTuple, 4, EncodeArray.encode(fromStaticArray_bytes32_52(cardsHash)));
  }

  /** Get the length of cardsHash */
  function lengthCardsHash(bytes32 id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    uint256 _byteLength = StoreSwitch.getFieldLength(_tableId, _keyTuple, 4, getSchema());
    return _byteLength / 32;
  }

  /** Get the length of cardsHash (using the specified store) */
  function lengthCardsHash(IStore _store, bytes32 id) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    uint256 _byteLength = _store.getFieldLength(_tableId, _keyTuple, 4, getSchema());
    return _byteLength / 32;
  }

  /** Get an item of cardsHash (unchecked, returns invalid data if index overflows) */
  function getItemCardsHash(bytes32 id, uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getFieldSlice(_tableId, _keyTuple, 4, getSchema(), _index * 32, (_index + 1) * 32);
    return (Bytes.slice32(_blob, 0));
  }

  /** Get an item of cardsHash (using the specified store) (unchecked, returns invalid data if index overflows) */
  function getItemCardsHash(IStore _store, bytes32 id, uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getFieldSlice(_tableId, _keyTuple, 4, getSchema(), _index * 32, (_index + 1) * 32);
    return (Bytes.slice32(_blob, 0));
  }

  /** Push an element to cardsHash */
  function pushCardsHash(bytes32 id, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.pushToField(_tableId, _keyTuple, 4, abi.encodePacked((_element)));
  }

  /** Push an element to cardsHash (using the specified store) */
  function pushCardsHash(IStore _store, bytes32 id, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.pushToField(_tableId, _keyTuple, 4, abi.encodePacked((_element)));
  }

  /** Pop an element from cardsHash */
  function popCardsHash(bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.popFromField(_tableId, _keyTuple, 4, 32);
  }

  /** Pop an element from cardsHash (using the specified store) */
  function popCardsHash(IStore _store, bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.popFromField(_tableId, _keyTuple, 4, 32);
  }

  /** Update an element of cardsHash at `_index` */
  function updateCardsHash(bytes32 id, uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.updateInField(_tableId, _keyTuple, 4, _index * 32, abi.encodePacked((_element)));
  }

  /** Update an element of cardsHash (using the specified store) at `_index` */
  function updateCardsHash(IStore _store, bytes32 id, uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.updateInField(_tableId, _keyTuple, 4, _index * 32, abi.encodePacked((_element)));
  }

  /** Get cardIndex */
  function getCardIndex(bytes32 id) internal view returns (uint8 cardIndex) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 5);
    return (uint8(Bytes.slice1(_blob, 0)));
  }

  /** Get cardIndex (using the specified store) */
  function getCardIndex(IStore _store, bytes32 id) internal view returns (uint8 cardIndex) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 5);
    return (uint8(Bytes.slice1(_blob, 0)));
  }

  /** Set cardIndex */
  function setCardIndex(bytes32 id, uint8 cardIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.setField(_tableId, _keyTuple, 5, abi.encodePacked((cardIndex)));
  }

  /** Set cardIndex (using the specified store) */
  function setCardIndex(IStore _store, bytes32 id, uint8 cardIndex) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.setField(_tableId, _keyTuple, 5, abi.encodePacked((cardIndex)));
  }

  /** Get winner */
  function getWinner(bytes32 id) internal view returns (address winner) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 6);
    return (address(Bytes.slice20(_blob, 0)));
  }

  /** Get winner (using the specified store) */
  function getWinner(IStore _store, bytes32 id) internal view returns (address winner) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 6);
    return (address(Bytes.slice20(_blob, 0)));
  }

  /** Set winner */
  function setWinner(bytes32 id, address winner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.setField(_tableId, _keyTuple, 6, abi.encodePacked((winner)));
  }

  /** Set winner (using the specified store) */
  function setWinner(IStore _store, bytes32 id, address winner) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.setField(_tableId, _keyTuple, 6, abi.encodePacked((winner)));
  }

  /** Get the full data */
  function get(bytes32 id) internal view returns (GameData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = StoreSwitch.getRecord(_tableId, _keyTuple, getSchema());
    return decode(_blob);
  }

  /** Get the full data (using the specified store) */
  function get(IStore _store, bytes32 id) internal view returns (GameData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    bytes memory _blob = _store.getRecord(_tableId, _keyTuple, getSchema());
    return decode(_blob);
  }

  /** Set the full data using individual values */
  function set(
    bytes32 id,
    GameState state,
    uint256 maxPlayers,
    address[] memory players,
    uint8 turn,
    bytes32[52] memory cardsHash,
    uint8 cardIndex,
    address winner
  ) internal {
    bytes memory _data = encode(state, maxPlayers, players, turn, cardsHash, cardIndex, winner);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.setRecord(_tableId, _keyTuple, _data);
  }

  /** Set the full data using individual values (using the specified store) */
  function set(
    IStore _store,
    bytes32 id,
    GameState state,
    uint256 maxPlayers,
    address[] memory players,
    uint8 turn,
    bytes32[52] memory cardsHash,
    uint8 cardIndex,
    address winner
  ) internal {
    bytes memory _data = encode(state, maxPlayers, players, turn, cardsHash, cardIndex, winner);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.setRecord(_tableId, _keyTuple, _data);
  }

  /** Set the full data using the data struct */
  function set(bytes32 id, GameData memory _table) internal {
    set(
      id,
      _table.state,
      _table.maxPlayers,
      _table.players,
      _table.turn,
      _table.cardsHash,
      _table.cardIndex,
      _table.winner
    );
  }

  /** Set the full data using the data struct (using the specified store) */
  function set(IStore _store, bytes32 id, GameData memory _table) internal {
    set(
      _store,
      id,
      _table.state,
      _table.maxPlayers,
      _table.players,
      _table.turn,
      _table.cardsHash,
      _table.cardIndex,
      _table.winner
    );
  }

  /** Decode the tightly packed blob using this table's schema */
  function decode(bytes memory _blob) internal view returns (GameData memory _table) {
    // 55 is the total byte length of static data
    PackedCounter _encodedLengths = PackedCounter.wrap(Bytes.slice32(_blob, 55));

    _table.state = GameState(uint8(Bytes.slice1(_blob, 0)));

    _table.maxPlayers = (uint256(Bytes.slice32(_blob, 1)));

    _table.turn = (uint8(Bytes.slice1(_blob, 33)));

    _table.cardIndex = (uint8(Bytes.slice1(_blob, 34)));

    _table.winner = (address(Bytes.slice20(_blob, 35)));

    // Store trims the blob if dynamic fields are all empty
    if (_blob.length > 55) {
      uint256 _start;
      // skip static data length + dynamic lengths word
      uint256 _end = 87;

      _start = _end;
      _end += _encodedLengths.atIndex(0);
      _table.players = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_address());

      _start = _end;
      _end += _encodedLengths.atIndex(1);
      _table.cardsHash = toStaticArray_bytes32_52(SliceLib.getSubslice(_blob, _start, _end).decodeArray_bytes32());
    }
  }

  /** Tightly pack full data using this table's schema */
  function encode(
    GameState state,
    uint256 maxPlayers,
    address[] memory players,
    uint8 turn,
    bytes32[52] memory cardsHash,
    uint8 cardIndex,
    address winner
  ) internal view returns (bytes memory) {
    uint40[] memory _counters = new uint40[](2);
    _counters[0] = uint40(players.length * 20);
    _counters[1] = uint40(cardsHash.length * 32);
    PackedCounter _encodedLengths = PackedCounterLib.pack(_counters);

    return
      abi.encodePacked(
        state,
        maxPlayers,
        turn,
        cardIndex,
        winner,
        _encodedLengths.unwrap(),
        EncodeArray.encode((players)),
        EncodeArray.encode(fromStaticArray_bytes32_52(cardsHash))
      );
  }

  /** Encode keys as a bytes32 array using this table's schema */
  function encodeKeyTuple(bytes32 id) internal pure returns (bytes32[] memory _keyTuple) {
    _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));
  }

  /* Delete all data for given keys */
  function deleteRecord(bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /* Delete all data for given keys (using the specified store) */
  function deleteRecord(IStore _store, bytes32 id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32((id));

    _store.deleteRecord(_tableId, _keyTuple);
  }
}

function toStaticArray_bytes32_52(bytes32[] memory _value) pure returns (bytes32[52] memory _result) {
  // in memory static arrays are just dynamic arrays without the length byte
  assembly {
    _result := add(_value, 0x20)
  }
}

function fromStaticArray_bytes32_52(bytes32[52] memory _value) view returns (bytes32[] memory _result) {
  _result = new bytes32[](52);
  uint256 fromPointer;
  uint256 toPointer;
  assembly {
    fromPointer := _value
    toPointer := add(_result, 0x20)
  }
  Memory.copy(fromPointer, toPointer, 1664);
}
