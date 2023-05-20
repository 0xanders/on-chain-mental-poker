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

bytes32 constant _tableId = bytes32(abi.encodePacked(bytes16(""), bytes16("HandCard")));
bytes32 constant HandCardTableId = _tableId;

struct HandCardData {
  bytes32 tempCardHash;
  bytes32 cardHash;
  bytes32 card;
}

library HandCard {
  /** Get the table's schema */
  function getSchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](3);
    _schema[0] = SchemaType.BYTES32;
    _schema[1] = SchemaType.BYTES32;
    _schema[2] = SchemaType.BYTES32;

    return SchemaLib.encode(_schema);
  }

  function getKeySchema() internal pure returns (Schema) {
    SchemaType[] memory _schema = new SchemaType[](2);
    _schema[0] = SchemaType.BYTES32;
    _schema[1] = SchemaType.ADDRESS;

    return SchemaLib.encode(_schema);
  }

  /** Get the table's metadata */
  function getMetadata() internal pure returns (string memory, string[] memory) {
    string[] memory _fieldNames = new string[](3);
    _fieldNames[0] = "tempCardHash";
    _fieldNames[1] = "cardHash";
    _fieldNames[2] = "card";
    return ("HandCard", _fieldNames);
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

  /** Get tempCardHash */
  function getTempCardHash(bytes32 gameId, address player) internal view returns (bytes32 tempCardHash) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 0);
    return (Bytes.slice32(_blob, 0));
  }

  /** Get tempCardHash (using the specified store) */
  function getTempCardHash(IStore _store, bytes32 gameId, address player) internal view returns (bytes32 tempCardHash) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 0);
    return (Bytes.slice32(_blob, 0));
  }

  /** Set tempCardHash */
  function setTempCardHash(bytes32 gameId, address player, bytes32 tempCardHash) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    StoreSwitch.setField(_tableId, _keyTuple, 0, abi.encodePacked((tempCardHash)));
  }

  /** Set tempCardHash (using the specified store) */
  function setTempCardHash(IStore _store, bytes32 gameId, address player, bytes32 tempCardHash) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    _store.setField(_tableId, _keyTuple, 0, abi.encodePacked((tempCardHash)));
  }

  /** Get cardHash */
  function getCardHash(bytes32 gameId, address player) internal view returns (bytes32 cardHash) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 1);
    return (Bytes.slice32(_blob, 0));
  }

  /** Get cardHash (using the specified store) */
  function getCardHash(IStore _store, bytes32 gameId, address player) internal view returns (bytes32 cardHash) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 1);
    return (Bytes.slice32(_blob, 0));
  }

  /** Set cardHash */
  function setCardHash(bytes32 gameId, address player, bytes32 cardHash) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    StoreSwitch.setField(_tableId, _keyTuple, 1, abi.encodePacked((cardHash)));
  }

  /** Set cardHash (using the specified store) */
  function setCardHash(IStore _store, bytes32 gameId, address player, bytes32 cardHash) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    _store.setField(_tableId, _keyTuple, 1, abi.encodePacked((cardHash)));
  }

  /** Get card */
  function getCard(bytes32 gameId, address player) internal view returns (bytes32 card) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    bytes memory _blob = StoreSwitch.getField(_tableId, _keyTuple, 2);
    return (Bytes.slice32(_blob, 0));
  }

  /** Get card (using the specified store) */
  function getCard(IStore _store, bytes32 gameId, address player) internal view returns (bytes32 card) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    bytes memory _blob = _store.getField(_tableId, _keyTuple, 2);
    return (Bytes.slice32(_blob, 0));
  }

  /** Set card */
  function setCard(bytes32 gameId, address player, bytes32 card) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    StoreSwitch.setField(_tableId, _keyTuple, 2, abi.encodePacked((card)));
  }

  /** Set card (using the specified store) */
  function setCard(IStore _store, bytes32 gameId, address player, bytes32 card) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    _store.setField(_tableId, _keyTuple, 2, abi.encodePacked((card)));
  }

  /** Get the full data */
  function get(bytes32 gameId, address player) internal view returns (HandCardData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    bytes memory _blob = StoreSwitch.getRecord(_tableId, _keyTuple, getSchema());
    return decode(_blob);
  }

  /** Get the full data (using the specified store) */
  function get(IStore _store, bytes32 gameId, address player) internal view returns (HandCardData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    bytes memory _blob = _store.getRecord(_tableId, _keyTuple, getSchema());
    return decode(_blob);
  }

  /** Set the full data using individual values */
  function set(bytes32 gameId, address player, bytes32 tempCardHash, bytes32 cardHash, bytes32 card) internal {
    bytes memory _data = encode(tempCardHash, cardHash, card);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    StoreSwitch.setRecord(_tableId, _keyTuple, _data);
  }

  /** Set the full data using individual values (using the specified store) */
  function set(
    IStore _store,
    bytes32 gameId,
    address player,
    bytes32 tempCardHash,
    bytes32 cardHash,
    bytes32 card
  ) internal {
    bytes memory _data = encode(tempCardHash, cardHash, card);

    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    _store.setRecord(_tableId, _keyTuple, _data);
  }

  /** Set the full data using the data struct */
  function set(bytes32 gameId, address player, HandCardData memory _table) internal {
    set(gameId, player, _table.tempCardHash, _table.cardHash, _table.card);
  }

  /** Set the full data using the data struct (using the specified store) */
  function set(IStore _store, bytes32 gameId, address player, HandCardData memory _table) internal {
    set(_store, gameId, player, _table.tempCardHash, _table.cardHash, _table.card);
  }

  /** Decode the tightly packed blob using this table's schema */
  function decode(bytes memory _blob) internal pure returns (HandCardData memory _table) {
    _table.tempCardHash = (Bytes.slice32(_blob, 0));

    _table.cardHash = (Bytes.slice32(_blob, 32));

    _table.card = (Bytes.slice32(_blob, 64));
  }

  /** Tightly pack full data using this table's schema */
  function encode(bytes32 tempCardHash, bytes32 cardHash, bytes32 card) internal view returns (bytes memory) {
    return abi.encodePacked(tempCardHash, cardHash, card);
  }

  /** Encode keys as a bytes32 array using this table's schema */
  function encodeKeyTuple(bytes32 gameId, address player) internal pure returns (bytes32[] memory _keyTuple) {
    _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));
  }

  /* Delete all data for given keys */
  function deleteRecord(bytes32 gameId, address player) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /* Delete all data for given keys (using the specified store) */
  function deleteRecord(IStore _store, bytes32 gameId, address player) internal {
    bytes32[] memory _keyTuple = new bytes32[](2);
    _keyTuple[0] = bytes32((gameId));
    _keyTuple[1] = bytes32(uint256(uint160((player))));

    _store.deleteRecord(_tableId, _keyTuple);
  }
}
