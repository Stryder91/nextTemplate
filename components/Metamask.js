import { useContext, useEffect, useState } from 'react'
import { Btn } from '../components/Button'
import { Context } from '../utils/context';
import { Modal } from './Modal';


export const ConnectMetamask = () => {
  
  const [showModal, setShowModal] = useState(false);
  const [account, setAccount] = useState('Connect a wallet');
  const { state, dispatch } = useContext(Context);
  
  useEffect(async () => {
    await getAccount();
  }, [])
  
  const _getNetwork = async () => {
    const windowChain = await window.ethereum.chainId;
    if (account && windowChain !== "0x89") {
      console.log("CHAIN", windowChain, await window.ethereum.chainId);
      setShowModal(true);
    }
  }

  const SwitchNetwork = async () => {
    if (account) {
      await window.ethereum.request({
        method: "wallet_addEthereumChain",
        params: [{
            chainId: "0x89",
            rpcUrls: ["https://rpc-mainnet.matic.network/"],
            chainName: "Matic Mainnet",
            nativeCurrency: {
                name: "MATIC",
                symbol: "MATIC",
                decimals: 18
            },
            blockExplorerUrls: ["https://polygonscan.com/"]
        }]
      });
      window.location.reload();
    }
  }
  
  const getAccount = async () => {
    try {
      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts'});
      const account = handleAccountsChanged(accounts)
      // utils.getAddress to return mixCase and not only lowercase..
      // return utils.getAddress(account);
      let sliceAcc = `${account.slice(0,8)}...${account.slice(-7, -1)}`;
      setAccount(sliceAcc);
      dispatch({
        type: "SET_ACCOUNT",
        payload: account,
      })
      return account;
    } catch (error) {
      if (error.code === 4001) {
        alert('Please connect to metamask to continue')
      } else {
        console.error(error)
      }
    }
  }
  
  const handleAccountsChanged = (accounts) => {
    if (accounts.length === 0 ) {
      console.log("Please connect to metamask")
    } else {
      window.ethereum.on("accountsChanged", () => { window.location.reload() });
      return accounts[0];
    }
  }
  
  return(
    <div className='flex items-center ml-5'>
      <Btn text={account} cb={() => getAccount()} cn="pink-linear py-2 px-3" />
      <Modal
      onClose={() => setShowModal(false)}
      show={showModal}
      color="pink-linear-2"
      >
        <h3 className='white pb-5'>Wrong network</h3>
        <Btn cb={() => SwitchNetwork()} text="Switch to Polygon" p="py-2 px-12 violet payment-choice-item" bg="violet payment-choice-item"/>
      </Modal>
    </div>
  );
}
