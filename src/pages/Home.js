import '../App.css';
import { useState, useEffect } from 'react';
import MintingMushroomAbi from "../utils/artifacts/contracts/MintingMushroom.sol/MintingMushroom.json";
import MetadataAbi from "../utils/artifacts/contracts/Metadata.sol/Metadata.json";
// import MintingMushroomAbi from "./utils/MintingMushroom.json";
// import MetadataAbi from "./utils/Metadata.json";
import { BigNumber, ethers } from 'ethers';
import { MintingMushroomAddress, MetadataAddress } from "../constants.js";

function Home() {

  const [mintingMushroomContract, setMintingMushroomContract] = useState(null);
  const [metadataContract, setMetadataContract] = useState(null);
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

    const metadataContract = new ethers.Contract(
      MetadataAddress,
      MetadataAbi.abi,
      signer
    );
    setMetadataContract(metadataContract);
  };

  const getMintLimit = async () => {
    const mintLimitTxn = await mintingMushroomContract._mintLimit();
    console.log("mintLimitTxn", mintLimitTxn);
    const tokenId = await mintingMushroomContract.getTokenIds();
    console.log("id: ", tokenId.toString());
    const balanceTxn = await mintingMushroomContract.getBalance();
    console.log("Balance: ", balanceTxn.toString());
    const mushroom = await mintingMushroomContract.getMushroom(1);
    console.log("mushroom: ", mushroom);
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
    const hasNFT = await mintingMushroomContract.checkIfHasNFT(wallet);
    console.log("Has NFT: ", hasNFT);
  };

  const retrieveURI = async () => {
    const uri = await metadataContract.returnExtension();
    console.log("uri: ", uri);
  };

  // const setURI = async () => {
  //   const setURITxn = await metadataContract.getTokenURI(1, 10, "Axe", "Helmet", "Pencil", "Spark", "https://ipfs.io/ipfs/QmR5tYrw1rqrKmNrma9BkfESag9PJhBCcNMhV31tZs5vZ1?filename=1.png");
  //   // await setURITxn.wait();
  //   console.log("setURI: ", setURITxn);
  //   const intermediary = setURITxn.replace("data:application/json;base64,", "");
  //   console.log("Tester: ", JSON.parse(atob(intermediary)));
  // }

  const setURI = async () => {
    const setURITxn = await mintingMushroomContract.tokenURI(1);
    console.log("SetURI: ", setURITxn);
  }

  const increaseSpore = async () => {
    const increaseSporeTxn = await mintingMushroomContract.increaseSpores(1, 1);
    console.log("IncreaseSpore: ", increaseSporeTxn);
  };

  const metadataTest = async () => {
    const numb = BigNumber.from(1);
    console.log("num", numb);
    const data = {
      id: 1,
      spores: 0,
      backgroundColor: "blue",
      head: "round",
      eyes: "Wide",
      mouth: "Open",
      element: "Fire",
      weapon: "Axe",
      armor: "None",
      accessory: "Necklace",
      level: 3
  };
    const test1 = await metadataContract.setMushroomData(data);
    await test1.wait();
    console.log("Test1: ", test1);
    // const test2 = await metadataContract.mushroomAttributes(numb);
    // const test2 = await metadataContract.getMushroomData(1);
    // console.log("Test2: ", test2);
    // // console.log("test2 data:", test2.element);

    // const test3 = await metadataContract.getElement(1);
    // console.log("test3: ", test3);

    // const test4 = await metadataContract.getMushroomBytes(1);
    // console.log("test4: ", test4);

    const test5 = await metadataContract.makeTokenURI(1);
    // await test5.wait();
    console.log("test5: ", test5);
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
      <button onClick={() => retrieveURI()}>GetURI</button>
      <button onClick={() => console.log("t")}>test</button>
      <button onClick={() => setURI()}>SetURI</button>
      <button onClick={() => increaseSpore()}>Inc</button>
      <button onClick={() => metadataTest()}>Test</button>
    </div>
  );
}

export default Home;
