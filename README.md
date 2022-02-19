# Template 

Template to create Dapp (Decentralized applications) with EVM compatibility.

- Hardhat, Ethersjs (shipped with metamask connection)
- Solidity with simple contract (Greeter)
- Basic script deployment
- Tailwindcss for css work
- React Context to handle state of the app

Cd in repo : 
$ yarn (or npm i)
$ npx hardhat compile

-> get contract address and flag it into utils/ethers

Set up .env based upon env.example:
- PRIVATE_KEY from a Metamask account
- API Rpc like Rinkeby, Mumbai, Polygon, Ethereum 
