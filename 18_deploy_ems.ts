import { AdminRoleRegistryContract } from '../types/truffle-contracts/AdminRoleRegistry';
//import { BuyerRoleRegistryContract } from '../types/truffle-contracts/BuyerRoleRegistry';
import { GateKeeperContract } from '../types/truffle-contracts/GateKeeper';
import { EvidenceManagementSystemFactoryContract, EvidenceManagementSystemFactoryInstance } from '../types/truffle-contracts/EvidenceManagementSystemFactory';
import { EvidenceManagementSystemRegistryContract } from '../types/truffle-contracts/EvidenceManagementSystemRegistry';
import { deployStateMachineSystem } from './_helpers/provenance/statemachine';

const GateKeeper: GateKeeperContract = artifacts.require('GateKeeper');
const EvidenceManagementSystemRegistry: EvidenceManagementSystemRegistryContract = artifacts.require('EvidenceManagementSystemRegistry');
const EvidenceManagementSystemFactory: EvidenceManagementSystemFactoryContract = artifacts.require('EvidenceManagementSystemFactory');
const AdminRoleRegistry: AdminRoleRegistryContract = artifacts.require('AdminRoleRegistry');
//const BuyerRoleRegistry: BuyerRoleRegistryContract = artifacts.require('BuyerRoleRegistry');

// eslint-disable-next-line @typescript-eslint/no-var-requires
const { enabledFeatures, storeIpfsHash } = require('../../truffle-config.js'); // two dirs up, because it is compiled into ./dist/migrations

module.exports = async (deployer: Truffle.Deployer, network: string, accounts: string[]) => {
  if (enabledFeatures().includes('EVIDENCEMANAGEMENTSYSTEM')) {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const uiDefinitions = require('../../contracts/evidencemanagementsystem/UIDefinitions.json');

    const { factory } = await deployStateMachineSystem(
      deployer,
      accounts,
      GateKeeper,
      EvidenceManagementSystemRegistry,
      EvidenceManagementSystemFactory,
      [AdminRoleRegistry],
      uiDefinitions,
      storeIpfsHash
    );

    const EvidenceManagementSystems = [
      {
        Case_ID: '5YJXCAE45GFF00001',

        Case_date: 1558362520
      },
      {
        Case_ID: '5YJRE1A31A1P01234',

        Case_date: 1558062520
      },
    ];

    for (const EvidenceManagementSystem of EvidenceManagementSystems) {
      await createEvidenceManagementSystemn(factory, EvidenceManagementSystem);
    }
  }
};

async function createEvidenceManagementSystemn(
  factory: EvidenceManagementSystemFactoryInstance,
  EvidenceManagementSystem: {
    Case_ID: string;

    Case_date: number;

  }
) {
  const ipfsHash = await storeIpfsHash({
    Case_date: EvidenceManagementSystem.Case_date,
  });
  await factory.create(EvidenceManagementSystem.Case_ID, ipfsHash);
}
