import '../styles/globals.css'
import { MoralisProvider } from "react-moralis";
import { WalletKitProvider } from "@mysten/wallet-kit";
import Layout from '../components/Layout'
import { WalletProvider } from '@suiet/wallet-kit';
// import '@suiet/wallet-kit/style.css';
import '../styles/Button.css'

function MyApp({ Component, pageProps }) {
  return (
    // <WalletKitProvider>
    <WalletProvider>
    <MoralisProvider initializeOnMount={false}>
      <Layout>
        <Component {...pageProps} />
      </Layout>
    </MoralisProvider>
    </WalletProvider>
    
    // {/* </WalletKitProvider> */}
  );
}
export default MyApp
