import { useState, useEffect } from "react/cjs/react.development";
export const Web3Modal = () => {

  const [acc, setAcc] = useState(null);
  const [provider, setProvider] = useState(null);

  useEffect(() => {
    if (provider) {
      provider.on("accountsChanged", (accounts) => {
        setAcc(accounts[0]);
      });
    }
  });

  const connectWallet = async () => {
    const providerOptions = {
      walletconnect: {
        package: WalletConnectProvider, // required
        options: {
          infuraId: "45d1dbd9f914a2020bd02ad494b58b61", // required
        },
      },
      coinbasewallet: {
        package: CoinbaseWalletSDK,
        options: {
          infuraId: "45d1dbd9f914a2020bd02ad494b58b61",
        },
      },
      frame: {
        package: ethProvider, // required
      },
    };
  
    const web3Modal = new Web3Modal({
      network: "mainnet", // optional
      cacheProvider: false, // optional
      providerOptions, // required
      theme: "dark",
      disableInjectedProvider: false,
    });
  
    const provider = await web3Modal.connect();
    setProvider(provider);
    if (provider) {
      provider.on("accountsChanged", (accounts) => {
        setAcc(accounts[0]);
      });
    }
    if (!acc) {
      setAcc(provider.selectedAddress);
    }
  };
  return <div onClick={connectWallet}>Multiwallet</div>;
}
