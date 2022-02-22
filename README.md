# Template 

Template to create Dapp (Decentralized applications) with EVM compatibility.

- Hardhat, Ethersjs (shipped with metamask connection)
- Solidity with simple contract (Greeter)
- Basic script deployment
- Tailwindcss for css work
- React Context to handle state of the app
- Mongodb database for simple CRUD with moongoose ORM

# Set up

1) Set up *.env* based upon *env.example*:
- PRIVATE_KEY from a Metamask account
- API Rpc like Rinkeby, Mumbai, Polygon, Ethereum 
- Provide a mongodb_uri if database needed

2) Cd in repo : 
```
$ yarn (or npm i)
$ npx hardhat compile
```
-> get contract address and flag it into utils/ethers

3) Run server
```
$ npm run dev
```

# Deploy contracts



