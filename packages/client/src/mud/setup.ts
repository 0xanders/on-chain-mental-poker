import { createClientComponents } from "./createClientComponents";
import { createSystemCalls } from "./createSystemCalls";
import { setupNetwork } from "./setupNetwork";
import { getBurnerWallet } from "@latticexyz/std-client";
import { ethers } from "ethers";
export type SetupResult = Awaited<ReturnType<typeof setup>>;

export async function setup() {
  const network = await setupNetwork();
  const components = createClientComponents(network);
  const systemCalls = createSystemCalls(network, components);
  const privateKey = getBurnerWallet().value
  const wallet = new ethers.Wallet(privateKey);
  return {
    network,
    components,
    systemCalls,
    walletAddress: wallet.address.toLowerCase()
  };
}
