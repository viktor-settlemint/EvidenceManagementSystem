/**
 * Copyright (C) SettleMint NV - All Rights Reserved
 *
 * Use of this file is strictly prohibited without an active license agreement.
 * Distribution of this file, via any medium, is strictly prohibited.
 *
 * For license inquiries, contact hello@settlemint.com
 *
 * SPDX-License-Identifier: UNLICENSED
 */

pragma solidity ^0.8.0;

import '../_library//authentication/Secured.sol';
import '../_library//provenance/statemachine/StateMachine.sol';
import '../_library//utility/metadata/IpfsFieldContainer.sol';
import '../_library//utility/metadata/FileFieldContainer.sol';
import '../_library//utility/conversions/Converter.sol';

/**
 * SupplyChain

 *
 * @title State machine for SupplyChain
 */
contract EvidenceManagementSystem is Converter, StateMachine, IpfsFieldContainer, FileFieldContainer {
  bytes32 public constant STATE_EVIDENCE_COLLECTED = 'EVIDENCES COLLECTED';
  bytes32 public constant STATE_CASE_ID_BUILT = 'CASE ID BUILT';
  
  bytes32 public constant STATE_IN_TRANSIT = 'IN TRANSIT';
  bytes32 public constant STATE_RECEIEVED_AT_PROPERTY_ROOM = 'RECIEVED AT PROPERTY ROOM';
  bytes32 public constant STATE_STOCKED_AT_PROPERTY_ROOM = 'STOCKED AT PROPERTY ROOM';


  bytes32 public constant STATE_RECEIVED_AT_LAB = 'RECIEVED AT LAB';
  bytes32 public constant STATE_CASE_ID_ANALYIS = 'CASE ID ANALYSIS';

  bytes32 public constant STATE_RECEIVED_AT_LAW_ENFORCEMENT = 'RECEIVED AT LAW ENFORCEMENT';
  bytes32 public constant STATE_PROSECUSSION_PROCESS = 'PROSECUTION PROCESS STARTED';
  bytes32 public constant STATE_TRIAL_COURT = 'FRONT OF TRIAL COURT';

  bytes32 public constant ROLE_ADMIN = 'ROLE_ADMIN';
  bytes32 public constant ROLE_TECHNICIAN = 'ROLE_TECHNICIAN';
  bytes32 public constant ROLE_SCIENTIST = 'ROLE_SCIENTIST';
  bytes32 public constant ROLE_TRANSPORTER = 'ROLE_TRANSPORTER';
  bytes32 public constant ROLE_POLICEMAN = 'ROLE_POLICEMAN';
  bytes32 public constant ROLE_JUDGE = 'ROLE_JUDGE';

  bytes32[] public _roles = [ROLE_ADMIN, ROLE_TECHNICIAN, ROLE_SCIENTIST, ROLE_TRANSPORTER, ROLE_POLICEMAN, ROLE_JUDGE];

  string public _uiFieldDefinitionsHash;
  string public _Case_ID;

  constructor(
    address gateKeeper,
    string memory Case_ID,
    string memory ipfsFieldContainerHash,
    string memory uiFieldDefinitionsHash
  ) Secured(gateKeeper) {
    _Case_ID = Case_ID;
    _ipfsFieldContainerHash = ipfsFieldContainerHash;
    _uiFieldDefinitionsHash = uiFieldDefinitionsHash;
    setupStateMachine();
  }

  /**
   * @notice Updates expense properties
   * @param Case_ID It is the order Identification Number
   * @param ipfsFieldContainerHash ipfs hash of supplychainfinance metadata
   */
  function edit(string memory Case_ID, string memory ipfsFieldContainerHash) public {
    _Case_ID = Case_ID;
    _ipfsFieldContainerHash = ipfsFieldContainerHash;
  }

  /**
   * @notice Returns a DID of the supplychainfinance
   * @dev Returns a unique DID (Decentralized Identifier) for the supplychainfinance.
   * @return string representing the DID of the supplychainfinance
   */
  function DID() public view returns (string memory) {
    return string(abi.encodePacked('did:demo:supplychainfinance:', _Case_ID));
  }

  /**
   * @notice Returns all the roles for this contract
   * @return bytes32[] array of raw bytes representing the roles
   */
  function getRoles() public view returns (bytes32[] memory) {
    return _roles;
  }

  function setupStateMachine() internal override {
    //create all states

    createState(STATE_EVIDENCE_COLLECTED);
    createState(STATE_CASE_ID_BUILT);
    createState(STATE_IN_TRANSIT);
    createState(STATE_RECEIEVED_AT_PROPERTY_ROOM);
    createState(STATE_STOCKED_AT_PROPERTY_ROOM);
    createState(STATE_RECEIVED_AT_LAB);
    createState(STATE_CASE_ID_ANALYIS);
    createState(STATE_RECEIVED_AT_LAW_ENFORCEMENT);
    createState(STATE_PROSECUSSION_PROCESS);
    createState(STATE_TRIAL_COURT);

    // add properties

    addNextStateForState(STATE_EVIDENCE_COLLECTED, STATE_CASE_ID_BUILT);
    addNextStateForState(STATE_CASE_ID_BUILT, STATE_IN_TRANSIT);
    addNextStateForState(STATE_IN_TRANSIT, STATE_RECEIEVED_AT_PROPERTY_ROOM);
    addNextStateForState(STATE_RECEIEVED_AT_PROPERTY_ROOM, STATE_STOCKED_AT_PROPERTY_ROOM);
    addNextStateForState(STATE_STOCKED_AT_PROPERTY_ROOM, STATE_IN_TRANSIT);
    addNextStateForState(STATE_IN_TRANSIT, STATE_RECEIVED_AT_LAB);
    addNextStateForState(STATE_RECEIVED_AT_LAB, STATE_CASE_ID_ANALYIS);
    addNextStateForState(STATE_CASE_ID_ANALYIS, STATE_IN_TRANSIT);
    addNextStateForState(STATE_IN_TRANSIT, STATE_RECEIVED_AT_LAW_ENFORCEMENT);
    addNextStateForState(STATE_RECEIVED_AT_LAW_ENFORCEMENT, STATE_PROSECUSSION_PROCESS);
    addNextStateForState(STATE_PROSECUSSION_PROCESS, STATE_TRIAL_COURT);

    addRoleForState(STATE_EVIDENCE_COLLECTED, ROLE_ADMIN);
    addRoleForState(STATE_CASE_ID_BUILT, ROLE_ADMIN);
    addRoleForState(STATE_IN_TRANSIT, ROLE_ADMIN);
    addRoleForState(STATE_RECEIEVED_AT_PROPERTY_ROOM, ROLE_ADMIN);
    addRoleForState(STATE_STOCKED_AT_PROPERTY_ROOM, ROLE_ADMIN); 
    addRoleForState(STATE_RECEIVED_AT_LAB, ROLE_ADMIN);
    addRoleForState(STATE_CASE_ID_ANALYIS, ROLE_ADMIN);
    addRoleForState(STATE_RECEIVED_AT_LAW_ENFORCEMENT, ROLE_ADMIN);
    addRoleForState(STATE_PROSECUSSION_PROCESS, ROLE_ADMIN);
    addRoleForState(STATE_TRIAL_COURT, ROLE_ADMIN);

    setInitialState(STATE_EVIDENCE_COLLECTED);
  }
}
