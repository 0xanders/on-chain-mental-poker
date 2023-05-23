import { MUDChain } from "@latticexyz/common/chains";

export const doubleTestnet = {
    name: "Double Testnet",
    id: 31337,
    network: "double-testnet",
    nativeCurrency: { decimals: 18, name: "Ether", symbol: "ETH" },
    rpcUrls: {
        default: {
            http: ["https://pokertestrpc.double.one"],
            webSocket: ["wss://pokertestrpc.double.one"],
        },
        public: {
            http: ["https://pokertestrpc.double.one"],
            webSocket: ["wss://pokertestrpc.double.one"],
        },
    },
    modeUrl: "",
    faucetUrl: "",
} as const satisfies MUDChain;
