require("@nomiclabs/hardhat-waffle");
require('dotenv').config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RINK_API = process.env.RINK_API;

module.exports = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
      chainId: 1337,
    },
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${RINK_API}`,
      accounts: [`${PRIVATE_KEY}`]
    },
  }
}