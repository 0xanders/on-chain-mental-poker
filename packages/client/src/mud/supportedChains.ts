import { MUDChain, latticeTestnet } from "@latticexyz/common/chains";
import { foundry } from "@wagmi/chains";
import { doubleTestnet } from "./doubleTestnet";

// If you are deploying to chains other than anvil or Lattice testnet, add them here
// local test
export const supportedChains: MUDChain[] = [foundry, doubleTestnet];
// doubleTest
// export const supportedChains: MUDChain[] = [latticeTestnet, doubleTestnet];
