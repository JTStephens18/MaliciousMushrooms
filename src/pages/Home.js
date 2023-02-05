import '../App.css';
import { useState, useEffect } from 'react';
import MintingMushroomAbi from "../utils/artifacts/contracts/MintingMushroom.sol/MintingMushroom.json";
import MetadataAbi from "../utils/artifacts/contracts/Metadata.sol/Metadata.json";
import tokenURIAbi from "../utils/artifacts/contracts/TokenURI.sol/TokenURI.json";
import M1Abi from "../utils/artifacts/contracts/Metadata1.sol/Metadata1.json";
// import MintingMushroomAbi from "./utils/MintingMushroom.json";
// import MetadataAbi from "./utils/Metadata.json";
import { BigNumber, ethers } from 'ethers';
import { MintingMushroomAddress, MetadataAddress, tokenURIAddress, M1Address } from "../constants.js";

function Home() {

  const [mintingMushroomContract, setMintingMushroomContract] = useState(null);
  const [metadataContract, setMetadataContract] = useState(null);
  const [tokenURIContract, setTokenURIContract] = useState(null);
  const [M1Contract, setM1Contract] = useState(null);
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

    const tokenURIContract = new ethers.Contract(
      tokenURIAddress,
      tokenURIAbi.abi,
      signer
    );
    
    setTokenURIContract(tokenURIContract);

    const M1Contract = new ethers.Contract(
      M1Address,
      M1Abi.abi,
      signer
    );

    setM1Contract(M1Contract);
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
  console.log("wallet: ", wallet);
    // const freeMintTxn = await mintingMushroomContract.mintNFT(wallet, data, {value: ethers.utils.parseEther("0.01"), from: wallet});
    const freeMintTxn = await mintingMushroomContract.freeMint(wallet);
    freeMintTxn.wait();
    console.log("Free mint: ", freeMintTxn);

    // mintingMushroomContract.on("part1Made", (tokenId, part1) => {
    //   let data = {
    //     tokenId: parseInt(tokenId._hex),
    //     part1: atob(part1)
    //   }
    //   console.log("part1Made: ", data);
    // })

    // mintingMushroomContract.on("part1Got", (tokenId, mushroom) => {
    //   let data = {
    //     tokenId: parseInt(tokenId._hex),
    //     mushroom: mushroom
    //   }
    //   console.log("part1Got: ", data);
    // })

    mintingMushroomContract.on("tokenURIMade", (tokenURI) => {
      let data = {
        tokenURI: tokenURI
      }
      console.log("data: ", data);
    })

    mintingMushroomContract.on("tokenURIFound", (tokenID, tokenURI) => {
      let data = {
        id: tokenID,
        uri: tokenURI
      }

      console.log("data found: ", data);
    })
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
    // const uri = await tokenURIContract.getTokenURI(1);
    const uri = await mintingMushroomContract.tokenURI(1);
    // await uri.wait();
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
    const increaseSporeTxn = await M1Contract.increaseSpores(1, 1);
    console.log("IncreaseSpore: ", increaseSporeTxn);
    mintingMushroomContract.on("changeMade", (tokenId, mushroom) => {
      let data = {
        tokenId: parseInt(tokenId._hex),
        mushroom: mushroom
      };

      console.log("Data: ", data);
    })
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
    // console.log("test2 element:", test2.element);

    await getMushroomAttributes();

    // const test3 = await metadataContract.getElement(1);
    // console.log("test3: ", test3);

    // const test5 = await metadataContract.makeTokenURI(1);
    // console.log("test5: ", test5);
  }
  
  const getMushroomAttributes = async () => {

    const mushroomAttributes = await mintingMushroomContract.mushroomTokenAttributes(1);
    console.log("mushroomAttributes: ", mushroomAttributes);

    // const mushroomAttributes = await metadataContract.mushroomAttributes(1);
    // console.log("mushroomAttributes: ", mushroomAttributes);
    // console.log("element: ", mushroomAttributes.element);
  };

  const getElement = async () => {

    const updateElement = await metadataContract.updateElement(1, "Water");
    await updateElement.wait();
    console.log("updateElement: ", updateElement);

    // const getData = await metadataContract.getMushroomData(2, {gasLimit: 1000000});
    // console.log("getData: ", getData);
    // console.log("Get Element:", getData.element);
    // const elementTxn = await metadataContract.getElement(1);
    // console.log("element: ", elementTxn);
    // const getArray = await metadataContract.getArray();
    // console.log("Arr", getArray);
  }

  const getData = async () => {
    const data = await M1Contract.getData1(1);
    console.log("Data:", data);
  } 

  const setWeapon = async () => {
    const weaponTxn = await M1Contract.setWeapon(1, "Axe");
    console.log("weaponTxmn: ", weaponTxn);
  }

  const fetching = async () => {
    // fetch("/test").then(
    //   res => res.json()
    // ).then(
    //   data => {
    //     console.log("data: ", data);
    //   }
    // )
    const response = await fetch("/test");
    const data = await response.json();
    console.log("data: ", data);
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
      <button onClick={() => setURI()}>SetURI</button>
      <button onClick={() => increaseSpore()}>Inc</button>
      <button onClick={() => metadataTest()}>Test</button>
      <button onClick={() => getElement()}>Element</button>
      <button onClick={() => getMushroomAttributes()}>Attributes</button>
      <button onClick={() => getData()}>Get data 1</button>
      <button onClick={() => setWeapon()}>Set weapon</button>
      <button onClick={() => fetching()}>Fetch</button>
    </div>
  );
}

export default Home;
