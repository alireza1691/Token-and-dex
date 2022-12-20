import '../styles/globals.css'
import { MoralisProvider } from "react-moralis";
import { WalletKitProvider } from "@mysten/wallet-kit";
import Layout from '../components/Layout'

function MyApp({ Component, pageProps }) {
  return (
    // <WalletKitProvider>
    // <Layout>
    <MoralisProvider initializeOnMount={false}>
        <Component {...pageProps} />
    </MoralisProvider>
    // </Layout>
    // </WalletKitProvider>
  );
}
export default MyApp
