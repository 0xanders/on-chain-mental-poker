import { createClientComponents } from "./createClientComponents";
import { createSystemCalls } from "./createSystemCalls";
import { setupNetwork } from "./setupNetwork";
import { getBurnerWallet } from "@latticexyz/std-client";
import { ethers } from "ethers";
import { createDatabase, createDatabaseClient } from "@latticexyz/store-cache";
import config from "../../../contracts/mud.config";
export type SetupResult = Awaited<ReturnType<typeof setup>>;

export async function setup() {
  const network = await setupNetwork();
  const components = createClientComponents(network);
  const systemCalls = createSystemCalls(network, components);
  const privateKey = getBurnerWallet().value
  const wallet = new ethers.Wallet(privateKey);
  let db: ReturnType<typeof createDatabase>;
  let client: ReturnType<typeof createDatabaseClient<typeof config>>;
        db = createDatabase();
        client = createDatabaseClient(db, config);
  return {
    network,
    components,
    systemCalls,
    walletAddress: wallet.address.toLowerCase(),
    client: client
  };
}
