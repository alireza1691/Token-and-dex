import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import { WalletKitProvider } from "@mysten/wallet-kit";
// import {WalletProvider} from "@mysten/wallet-adapter-react";
import {SuietWalletAdapter} from "@suiet/wallet-adapter";
import '@suiet/wallet-kit/style.css';
import {
  WalletProvider,
  SuietWallet,
  SuiWallet,
  EthosWallet,
  IDefaultWallet,
} from '@suiet/wallet-kit';
// const supportedWallets = [
//   {adapter: new SuietWalletAdapter()},
// ];
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <WalletProvider>
      <App/>
    </WalletProvider>
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
