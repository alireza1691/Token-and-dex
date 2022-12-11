import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'
import 'bulma/css/bulma.css'
import Link from 'next/link'
import { useState, useEffect } from 'react'
import { ethers } from 'ethers'
import {/*MoralisProvider,*/ useMoralis} from 'react-moralis'
// import { ethers } from 'hardhat'
// import faucetContract from '../blockchain/faucetAbi'

export default function faucet() {

  const [isConnected, setIsConnected] = useState(false);
  const [provider, setProvider] = useState();
  const [signer, setSigner] = useState()
  const [error, setError] = useState ('')
  const [address, setAddress] = useState()
  const [web3, setWeb3] = useState()
  const [bcContract, setBcContract] = useState()
  const [balance, setBalance] = useState("0")
  const [inputValue1, setInputvalue1] = useState()
  const [inputValue2, setInputvalue2] = useState()
  const [inputValue3, setInputvalue3] = useState()
  const [betPlayers, setBetPlayers] = useState([])
  const [totalValue, setTotalValue] = useState()

  const connect =async () => {
    if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
      try {
        await ethereum.request({method: "eth_requestAccounts"});
        setIsConnected(true)
        let connectedProvider = new ethers.providers.Web3Provider(window.ethereum)
        setProvider(connectedProvider)
        setSigner(connectedProvider.getSigner())
      } catch (e) {
        console.log(e);
      }
    } else {
      setIsConnected(false)
    }
  }

  // const connectWalletHandler = async () => {
  //   setError('')
  //   if (typeof window !== "undefined" && typeof window.ethereum !== "undefined"){
  //       try{
  //           const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
  //           const account = accounts[0];
  //           setAddress(account)
  //           // const provider = new ethers.providers.Web3Provider(web3.currentProvider);
  //           // setWeb3(web3)
  //           // const accounts = await web3.eth.getAccounts();
            
  //           document.getElementById("connectButton").innerHTML = "Connected!"
            
  //       } catch (err) {
  //           setError(err.message)
  //       }
        
  //   } else {
  //       console.log("please install metamask")
  //   }
  // }

  // const getFaucet = async () => {
  //   await faucetContract.methods.getFaucet().send()
  // }


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
      <div className='box'>
          <nav className='level navbar-has-shadow py-1'>
            <div className='navbar-brand'>
              <h1>Invesweet</h1>
            </div>
            <div className='navbar-end'>
              <div className='navbar-item'>
                {/* {isConnected ? ("Connected") : (<button onClick={() => connect} className='button is-link'>Connect Wallet</button>)} */}
                {isConnected ? (<button onClick={connect} className='button is-link'>Connected</button>) : (<button onClick={connect} className='button is-link'>Connect </button>)}
              </div>
            </div>
          </nav>
        </div>

      <main className={styles.main}>
        <div className='box'>
          <div className="tabs  is-centered ">
            <ul className=''>
              <li><Link href='/swap'>Swap</Link></li>
              <li><Link href='/liquidity'>Pool</Link></li>
              <li className="is-active"><a>Faucet</a></li>
            </ul>
          </div>
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
                    <button className='button is-link mt-2 mr-2'>Claim</button>
                </div>
                </div>
               
        </div>
      </main>

      <footer className={styles.footer}>
        <a
          href="https://vercel.com?utm_source=create-next-app&utm_medium=default-template&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          Powered by{' '}
          <span className={styles.logo}>
            <Image src="/vercel.svg" alt="Vercel Logo" width={72} height={16} />
          </span>
        </a>
      </footer>
    </div>
  )
  }
