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

import '../_library//provenance/statemachine/StateMachineFactory.sol';
import './EvidenceManagementSystem.sol';
import './EvidenceManagementSystemRegistry.sol';

/**
 * @title Factory contract for evidencemanagementsystem state machines
 */
contract EvidenceManagementSystemFactory is StateMachineFactory {
  constructor(GateKeeper gateKeeper, EvidenceManagementSystemRegistry registry) StateMachineFactory(gateKeeper, registry) {}

  /**
   * @notice Create new evidencemanagementsystem
   * @dev Factory method to create a new evidencemanagementsystem. Emits StateMachineCreated event.
   * @param Case_ID Unique Identification Number

   * @param ipfsFieldContainerHash ipfs hash of evidencemanagementsystem metadata
   */
  function create(string memory Case_ID, string memory ipfsFieldContainerHash)
    public
    authWithCustomReason(CREATE_STATEMACHINE_ROLE, 'Sender needs CREATE_STATEMACHINE_ROLE')
  {
    bytes memory memProof = bytes(Case_ID);
    require(memProof.length > 0, 'A Case_ID is required');

    EvidenceManagementSystem evidencemanagementsystem =
      new EvidenceManagementSystem(address(gateKeeper), Case_ID, ipfsFieldContainerHash, _uiFieldDefinitionsHash);

    // Give every role registry a single permission on the newly created expense.
    bytes32[] memory roles = evidencemanagementsystem.getRoles();
    for (uint256 i = 0; i < roles.length; i++) {
      gateKeeper.createPermission(
        gateKeeper.getRoleRegistryAddress(roles[i]),
        address(evidencemanagementsystem),
        roles[i],
        address(this)
      );
    }

    _registry.insert(address(evidencemanagementsystem));
    emit StateMachineCreated(address(evidencemanagementsystem));
  }
}
