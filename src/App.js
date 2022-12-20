import logo from './logo.svg';
import './App.css';
import { useState, useEffect } from 'react';
import MintingMushroomAbi from "./utils/MintingMushroom.json"
import { ethers } from 'ethers';
import { MintingMushroomAddress } from "./constants.js";

function App() {

  const [mintingMushroomContract, setMintingMushroomContract] = useState(null);
  const [wallet, setWallet] = useState(null);

  useEffect(() => {
    loadBlockchainData();
  }, []);

  const loadBlockchainData = async () => {
    const { ethereum } = window;
    if (!ethereum) {
      alert("Get MetaMask!");
      return;
    }
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
    const account = accounts[0];
    setWallet(account);
    const provider = new ethers.providers.Web3Provider(ethereum);
    const signer = provider.getSigner();
    // const MintingMushroomFactory = await ethers.getContractFactory("MintingMushroom", signer);
    // const mintingMushroom = await MintingMushroomFactory.deploy(account);
    const mintingMushroomContract = new ethers.Contract(
      MintingMushroomAddress,
      MintingMushroomAbi.abi,
      signer
    );
    setMintingMushroomContract(mintingMushroomContract);
  };

  const getMintLimit = async () => {
    const mintLimitTxn = await mintingMushroomContract._mintLimit();
    console.log("mintLimitTxn", mintLimitTxn);
    const tokenId = await mintingMushroomContract.getTokenIds();
    console.log("id: ", tokenId.toString());
    const balanceTxn = await mintingMushroomContract.getBalance();
    console.log("Balance: ", balanceTxn.toString());
  }

  const freeMint = async () => {
    // const freeMintTxn = await mintingMushroomContract.mintNFT(wallet, {value: ethers.utils.parseEther("0.01")});
    const freeMintTxn = await mintingMushroomContract.freeMint(wallet);
    freeMintTxn.wait();
    console.log("Free mint: ", freeMintTxn);
  }

  const withdraw = async () => {
    const withdrawTxn = await mintingMushroomContract.withdrawBalance(wallet, ethers.utils.parseEther("0.01"));
    withdrawTxn.wait();
    console.log("Withdraw: ", withdrawTxn);
  }

  const checkIfHasNFT = async () => {
    const hasNFT = await mintingMushroomContract.checkIfHasNFT();
    console.log("Has NFT: ", hasNFT);
  }

  return (
    <div className="App">
      <button
        onClick={() => {
          getMintLimit();
        }}
      >Log</button>
      <button onClick={() => freeMint()}>Free Mint</button>
      <button onClick={() => withdraw()}>Withdraw</button>
      <button onClick={() => checkIfHasNFT()}>Check</button>
    </div>
  );
}

export default App;
