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
// import { ethers } from 'hardhat'
// import faucetContract from '../blockchain/faucetAbi'
// import * as nearAPI from "near-api-js";
// import { NearBindgen, near, call, view, initialize, UnorderedMap } from 'near-sdk-js'
// import { setupWalletSelector } from "@near-wallet-selector/core";
// import { setupNearWallet } from "@near-wallet-selector/near-wallet";


const Header = ({conncetWalletHandler, isConnected}) =>{


  console.log(isConnected);


  return (
    <div className={styles.container}>
      <div className='box'>
          <nav className='level navbar-has-shadow py-1'>
            <div className='navbar-brand'>
              <h1>Invesweet</h1>
               {/* <div>
                 <ConnectButton>connect</ConnectButton>
                </div> */}
            </div>
            <div className='navbar-end'>
              <div className='navbar-item'>
                <button onClick={''} className='button is-black mr-2' disabled>Near Wallet</button>
                {/* {isConnected ? ("Connected") : (<button onClick={() => connect} className='button is-link'>Connect Wallet</button>)} */}
                {isConnected ? (<button onClick={conncetWalletHandler} className='button is-link' disabled>Connected</button>) : (<button onClick={conncetWalletHandler} className='button is-link'>Connect </button>)}
              </div>
            </div>
          </nav>
        </div>
    </div>
  )
}

export default Header
