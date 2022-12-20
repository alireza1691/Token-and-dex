import '../styles/globals.css'
import { MoralisProvider } from "react-moralis";
import { WalletKitProvider } from "@mysten/wallet-kit";
import Layout from '../components/Layout'

function MyApp({ Component, pageProps }) {
  return (
    // <WalletKitProvider>
    
    <MoralisProvider initializeOnMount={false}>
      <Layout>
        <Component {...pageProps} />
      </Layout>
    </MoralisProvider>
    
    // </WalletKitProvider>
  );
}
export default MyApp
