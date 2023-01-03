import Head from 'next/head'
import Image from 'next/image'
import "../public/Invesweet.png";
import styles from '../styles/Home.module.css'
import 'bulma/css/bulma.css'
import Link from 'next/link'
import { React ,useState, useEffect } from 'react'
// import { ethers } from 'ethers'
import {/*MoralisProvider,*/ useMoralis, useWeb3Contract} from 'react-moralis'
import { faucetAbi, faucetContractAddress, dexAbi, dexContractAddress, iErc20Abi, dexNew } from '../constants'
import { BigNumber, Contract, ethers } from 'ethers'
import { Tab } from '@headlessui/react'
import { ConnectButton } from '@suiet/wallet-kit';
// import { ethers } from 'hardhat'
// import faucetContract from '../blockchain/faucetAbi'
// import * as nearAPI from "near-api-js";
// import { NearBindgen, near, call, view, initialize, UnorderedMap } from 'near-sdk-js'
// import { setupWalletSelector } from "@near-wallet-selector/core";
// import { setupNearWallet } from "@near-wallet-selector/near-wallet";


const Header = ({conncetWalletHandler, isConnected}) =>{


  return (
    <div className={styles.container}>
      <div className='box'>
          <nav className='level navbar-has-shadow py-1'>
            <div className='navbar-brand'>
              <div className={styles.navbarBrand}>
              <img src='./Invesweet.png' ></img>
              
               {/* <div>
                 <ConnectButton>connect</ConnectButton>
                </div> */}
                </div>
            </div>
            
            <div className='navbar-end'>
            <ConnectButton className='button  is-normal is-dark mt-2 '>Connect to Sui </ConnectButton>
            
              <div className='navbar-item'>
              
                {/* <button onClick={''} className='button is-black mr-2' disabled>Near Wallet</button> */}
                {/* {isConnected ? ("Connected") : (<button onClick={() => connect} className='button is-link'>Connect Wallet</button>)} */}
                <button onClick={conncetWalletHandler} className='button is-info ' disabled={isConnected}>{isConnected ? 'Wallet connected' : "Connect wallet"}</button>
              </div>
            </div>
          </nav>
        </div>
    </div>
  )
}

export default Header
