import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";
import "@openzeppelin/hardhat-upgrades";
import dotenv from "dotenv";
dotenv.config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const GOERLI_URL = process.env.GOERLI_URL;
const ARBITRUM_GOERLI_URL = process.env.ARBITRUM_GOERLI_URL;
const BSC_TESTNET_URL = process.env.BSC_TESTNET_URL;
const POLYGON_MUMBAI_URL = process.env.POLYGON_MUMBAI_URL;
const SCROLL_TESTNET_URL = process.env.SCROLL_TESTNET_URL;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const ARBISCAN_API_KEY = process.env.ARBISCAN_API_KEY;

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.18",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  networks: {
    goerli: {
      url: GOERLI_URL,
      accounts: [`${PRIVATE_KEY}`],
    },
    arbitrumGoerli: {
      url: ARBITRUM_GOERLI_URL,
      accounts: [`${PRIVATE_KEY}`],
    },
    bscTestnet: {
      url: BSC_TESTNET_URL,
      accounts: [`${PRIVATE_KEY}`],
    },
    polygonMumbai: {
      url: POLYGON_MUMBAI_URL,
      accounts: [`${PRIVATE_KEY}`],
    },
    scrollTestnet: {
      url: SCROLL_TESTNET_URL,
      accounts: [`${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    // apiKey: ETHERSCAN_API_KEY,
    apiKey: ARBISCAN_API_KEY,
  },
};

export default config;
