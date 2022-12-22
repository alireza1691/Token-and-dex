import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'
import 'bulma/css/bulma.css'
import Link from 'next/link'
import { React ,useState, useEffect } from 'react'
// import { ethers } from 'ethers'
import {/*MoralisProvider,*/ useMoralis, useWeb3Contract} from 'react-moralis'
import { faucetAbi, faucetContractAddress, dexAbi, dexContractAddress, iErc20Abi, dexNew } from '../constants'
import { BigNumber, Contract, ethers } from 'ethers'
import { Tab } from '@headlessui/react'
import { ConnectButton, useWallet } from "@mysten/wallet-kit";
// import Header from '../components/Header'
// import Footer from '../components/footer'
import Header from '../components/Header'
import Footer from '../components/footer'

// import { ethers } from 'hardhat'
// import faucetContract from '../blockchain/faucetAbi'
// import * as nearAPI from "near-api-js";
// import { NearBindgen, near, call, view, initialize, UnorderedMap } from 'near-sdk-js'
// import { setupWalletSelector } from "@near-wallet-selector/core";
// import { setupNearWallet } from "@near-wallet-selector/near-wallet";



export default function main() {

   
const { Moralis, isWeb3Enabled, chainId: chainIdHex } = useMoralis()

const usdcContractAddress = "0x07865c6E87B9F70255377e024ace6630C1Eaa37F"
const istContractAddress = "0x9c3565df44b79a7dbdab3678f0b00b9beabc7d70"

 
const [isConnected, setIsConnected] = useState(false);
const [provider, setProvider] = useState();
const [signer, setSigner] = useState()
const [faucetContract, setFaucetContract] = useState()
const [getFaucetError, setGetFaucetError] = useState ('')
const [address, setAddress] = useState()

const [balance, setBalance] = useState("0")
const [inputValueIst, setInputvalueIst] = useState("0")
const [inputValueUsdc, setInputvalueUsdc] = useState()
const [inputValueShares, setInputvalueShares] = useState()
const [signerAddress, setSignerAddress] = useState()
const [dexContract, setDexContract] = useState()
const [usdcContract, setUsdcContract] = useState()
const [istContract, setIstContract] = useState()
const [userShares, setUserShares] = useState("0")
//   const [pairAmount, setPairAmount] = useState()

const [usdcReserve, setUsdcReserve] = useState()
const [istReserve, setIstReserve] = useState()

const [approvedAmountIst, setApprovedAmountIST] = useState()
const [approvedAmountUsdc, setApprovedAmountUsdc] = useState()

const [outPutUsdc, setOutPutUsdc] = useState("0")

//   const UpdatePairAmount = event => {
//     setPairAmount(event.target.value)
//   }

const totalSupply = 0

  const updateInputIst = event => {
    setInputvalueIst(event.target.value)
  }
  const updateInputUsdc = event => {
    setInputvalueUsdc(event.target.value)
  }
  const updateInputShare = event => {
    setInputvalueShares(event.target.value)
  }


  



  const conncetWalletHandler = async () => {
    if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
      try {
        const accounts = await ethereum.request({method: "eth_requestAccounts"});
        setIsConnected(true)
        let connectedProvider = new ethers.providers.Web3Provider(window.ethereum)
        setProvider(connectedProvider)
        const _signer = connectedProvider.getSigner()
        setSigner(_signer)
        setSignerAddress(_signer.getAddress( ))
        setAddress(accounts[0])
        setFaucetContract(new ethers.Contract( faucetContractAddress , faucetAbi , provider ))
        // setDexContract(new ethers.Contract("0x51a78580a3d04c4fcf9f33c4ba6b611d467f55ab", dexAbi, provider))
        // console.log(`dex contract address: ${dexContract.getAddress()}`);
        const dexC = new ethers.Contract(dexContractAddress, dexAbi, provider)
        setDexContract (dexC)
        
        const dexWithSigner =  dexC.connect(_signer)
        const get = await (dexWithSigner.balanceOf(accounts[0]))
        setUserShares(get.toString())


        setUsdcContract (new ethers.Contract(usdcContractAddress , iErc20Abi ,  provider))
        setIstContract (new ethers.Contract(istContractAddress , iErc20Abi ,  provider))

        console.log(_signer.getAddress( ));
        console.log(accounts[0]);
        // console.log(dexContract);
        // window.location.reload()

        const istR = await dexWithSigner._getReserveMyToken()
        const usdcR = await dexWithSigner._getReserveUsdc()

        console.log(`ist reserve: ${istR} and usdc reserve : ${usdcR}`);

        setIstReserve(istR)
        setUsdcReserve(usdcR)

        // const lev = (usdcR * 10 ** 12) / (istR )
        const lev = (( usdcR / (10**6)) * (1)) / ((istR / (10 ** 18)) + (1))
        // const getFromCon = await dexContract._getCurrentAmountForUsdc(inputValueIst)
        setOutPutUsdc(lev)
        console.log(`output amount for each IST is ${lev} USDC`);
        
      } catch (e) {
        console.log(e);
      }
    } else {
      setIsConnected(false)
    }
  }
useEffect(() => {
  async function accountChanged () {
    window.ethereum.on("accountsChanged", async function() {
        const accounts = await window.ethereum.request({
            method: 'eth-accounts',
        })
        if (accounts.length) {
            setAddress(accounts[0])
        } else {
            window.location.reload()
        }
    })
  }
  accountChanged()
},)

  const getCurrentWalletConnected = async () => {
    if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
      try {

        const connectedProvider = new ethers.providers.Web3Provider(window.ethereum)
        const accounts = await provider.send("eth_accounts", []);
        if (accounts.length > 0) {
          setSigner(connectedProvider.getSigner())
          setSignerAddress(signer.getAddress( ))
          setFaucetContract(new ethers.Contract( faucetContractAddress , faucetAbi , provider ))
        } else {
          console.log("Connect your wallet using the connect button");
        }
      } catch (e) {
        console.log(e);
      }
    }
  }

  const addWalletListener = async () => {
    if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
      window.ethereum.on("accounsChanged", (accounts) => {
        setAddress(accounts[0])
      })
  } else {
    setAddress("")
    console.log("please install metamask");
  }
  }
    
  // const { runContractFunction: getFaucet } = useWeb3Contract({
  //   abi: faucetAbi,
  //   contractAddress: faucetContractAddress, // specify the networkId
  //   functionName: "getFaucet",
  //   params: {inputValue1},
  // })

  const getFaucetToken = async () => {
    setGetFaucetError("")
    try {
      const contractWithSigner = faucetContract.connect(signer)
      const resp = await contractWithSigner.requestTokens()   
    } catch (err) {
      console.log(err.message);
      setGetFaucetError(err.message)
    }
  }

  const approveUSDC = async () => {
    const USDCSigner = usdcContract.connect(signer)
    console.log(USDCSigner);
    const approveUSDC = await USDCSigner.approve(dexContractAddress, (ethers.utils.parseUnits(inputValueUsdc.toString(), "mwei")))
    const valueNow = ethers.utils.parseUnits(inputValueUsdc.toString(), "mwei")
    setApprovedAmountUsdc(valueNow)
  }
  const approveIST = async () => {
    const ISTSigner = istContract.connect(signer)
    console.log(ISTSigner);
    const approveIST = await ISTSigner.approve(dexContractAddress,(ethers.utils.parseEther(inputValueIst)))
    const valueNow = ethers.utils.parseEther(inputValueIst)
    setApprovedAmountIST(valueNow)
  }

  const provideLiquidity = async () => {
    try {
        const _gasLimit = ethers.utils.hexlify(1000000)
        // const _gasPrice = provider.getGasPrice()
        const _gasPrice = ethers.utils.parseUnits("10.0", "gwei")

        const dexWithSigner = dexContract.connect(signer)
        const resp = await dexWithSigner._addLiquidity(ethers.utils.parseUnits(inputValueUsdc , "mwei"),ethers.utils.parseEther(inputValueIst), {
            gasLimit: _gasLimit,
            gasPrice: _gasPrice
        })
        // setApprovedAmountUsdc(0)
        // setApprovedAmountIST(0)
    } catch (err) {
        console.log(err.message);
    }
  }
  

  const withdrawLiquidity = async () => {
    try {
        const _gasLimit = ethers.utils.hexlify(1000000)
        // const _gasPrice = provider.getGasPrice()
        const _gasPrice = ethers.utils.parseUnits("10.0", "gwei")
        // const _gasPrice = BigNumber.from(1613539020)
        console.log(_gasPrice);
        const dexWithSigner = dexContract.connect(signer)
        console.log(dexWithSigner);
        const resp = await dexWithSigner._removeLiquidity(inputValueShares, {
            gasLimit: _gasLimit,
            gasPrice: _gasPrice
        })
    } catch (err) {
        console.log(err.message);
    }
  }

  const getBalance = async () => {
    const dexWithSigner = dexContract.connect(signer)
    const get = await (dexWithSigner.balanceOf(address))
    
    console.log(get.toString());
    setUserShares(get.toString())
    // setUserShares(get)
  }


  const swapIstToUsdc = async () => {
    const _gasLimit = ethers.utils.hexlify(1000000)
    const _gasPrice = ethers.utils.parseUnits("10.0", "gwei")

    const dexWithSigner = dexContract.connect(signer)
    const _swap = await (dexWithSigner._swap(istContractAddress,ethers.utils.parseEther(inputValueIst),{
        gasLimit: _gasLimit,
        gasPrice: _gasPrice 
    }))
  }
  const swapUsdcToIst = async () => {
    const _gasLimit = ethers.utils.hexlify(1000000)
    const _gasPrice = ethers.utils.parseUnits("10.0", "gwei")

    const dexWithSigner = dexContract.connect(signer)
    const _swap = await (dexWithSigner._swap(usdcContractAddress,ethers.utils.parseUnits(inputValueUsdc, "mwei"),{
        gasLimit: _gasLimit,
        gasPrice: _gasPrice 
    }))
  }


//   function getTotalSupply(props) {
//     return<h1>Amout Of Pair Must Be: {props.amount}</h1>
//   }


//   const handleSuccess = async function(tx) {
//     await tx.wait(1)
//     handleNewNotification(tx)
// }

// const handleNewNotification = function () {
//     dispatch ({
//         type: "info",
//         message: "Transaction Complete",
//         title: "Tx Notification",
//         position: "topR",
//         icon: "bell"
//     })
// }


  return (
    <div className={styles.container}>
      <Head>
        <title>Invesweet Pool</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
        
      <Header conncetWalletHandler={conncetWalletHandler} isConnected={isConnected}/>
    
      <main className={styles.main}>
        <div className='box is-large'>
        <span className='navbar-end is-link has-text-grey'>
        {address && address.length > 0 ? `Connected to: ${address.substring(0,6)}...${address.substring(38)}` :"Please connect your wallet"}
      </span>
          <div className="  is-centered ">
            <Tab.Group>
              <Tab.List className='py-3'>
                <Tab className='button is-light is-normal mx-2'>Swap</Tab>
                <Tab className='button is-light is-normal mx-2'>Pool</Tab>
                <Tab className='button is-light is-normal mx-2'>Faucet</Tab>
              </Tab.List>
              <Tab.Panels>
                <Tab.Panel>
                  <div className='box'>
                    <label className="label">IST to USDC</label>
                    <div className="control">
                      <div className="navbar-item is-hoverable navbar-end ">
                      </div>
                      <input onChange={updateInputIst} className="input mt-2" /*value={inputValue1}*/ type="text" placeholder="Input IST amount..."  />
                      <input className="input mt-2" value={""} type="text" placeholder={`You get ${inputValueIst * outPutUsdc} USDC`} />
                      <button onClick={async () => await approveIST()} className='button is-link mt-2 mr-2'>Approve</button>
                      <button onClick={async () => await swapIstToUsdc()} className='button is-link mt-2' >Swap</button>
                    </div>
                  </div>
                  <div className='box'>
                    <label className="label">USDC to IST</label>
                    <div className="control">
                      <div className="navbar-item is-hoverable navbar-end ">
                       </div>
                            <input onChange={updateInputUsdc} className="input mt-2" /*value={""}*/ type="text" placeholder="Input USDC amount..."  />
                            <input className="input mt-2" value={""} type="text" placeholder="0" />
                            <button onClick={async () => await approveUSDC()} className='button is-link mt-2 mr-2'>Approve</button>
                            <button onClick={async () => await swapUsdcToIst()} className='button is-link mt-2' >Swap</button>
                        </div>
                      </div>
                    </Tab.Panel>
                    <Tab.Panel>
                    <div className='box'>
              <label className="label">Deposit liquidity</label>
                {/* <div>
                    <getTotalSupply amount= "This amount"/>
                </div> */}
                
              {/* <div className='navbar-end has-text-grey-light'>Require this amout for pair: {inputValueIst}</div> */}
                <div className="control">
                  <div className="navbar-item is-hoverable navbar-end ">
                  </div>
                  <input onChange={updateInputUsdc} className="input mt-2"  type="text" placeholder="Input USDC amount..." />
                  <input onChange={updateInputIst} className="input mt-2"  type="text" placeholder="Input IST amount..." />
                  <button onClick={async () => await approveUSDC()} className='button is-link mt-2 mr-2'>Approve USDC</button>
                  <button onClick={async () => await approveIST()} className='button is-link mt-2 mr-2'>Approve IST</button>
                  <button onClick={async () => await provideLiquidity()} className='button is-link mt-2' >Deposit</button>
                </div>
              </div>
              <div className='box'>
              <label className="label">Withdraw liquidity</label>
                <div className="control">
                  <div className="navbar-item is-hoverable navbar-end ">
                  </div>
                  <div className='navbar-end has-text-grey-light'>Your shares: {userShares}</div>
                  <input onChange={updateInputShare} className="input mt-2 has-text-grey" /*value={""}*/ type="text" placeholder="Input your shares..." />
                  {/* <input className="input mt-2" value={""} type="text" placeholder="Input IST amount..." /> */}
                  <button onClick={async () => await withdrawLiquidity()} className='button is-link mt-2 mr-2'>Approve</button>
                  <button className='button is-link mt-2' disabled>Withdraw</button>
                </div>
              </div>
                    </Tab.Panel>
                    <Tab.Panel>
                    <div className='has-text-weight-semibold py-2'>
                <p>Get test tokens once a day</p>
              </div>
              <p>These tokens hasn't any real value, you can use them for tesntnet transactions like Swap & Provide liquidity</p>
                <div className='box mt-4'>
                  <label className="label">Get testnet tokens</label>
                    <div className="control">
                      <div className="navbarzz-item is-hoverable navbar-end ">
                    </div>
                    <input className="input mt-2" value={""} type="text" placeholder="Input your address..."  />
                    <button onClick={async () => await getFaucetToken()} className='button is-link mt-2 mr-2'>Claim</button>
                  </div>
                </div>      
              
                    </Tab.Panel>
                </Tab.Panels>
            </Tab.Group>
           
          </div>
            <div className='is-hidden' id='faucet'>
              </div>
            </div>
        </main>
        <Footer/>
    </div>
  )
  }
  
