import '../styles/globals.css'
import { MoralisProvider } from "react-moralis";
import { WalletKitProvider } from "@mysten/wallet-kit";

function MyApp({ Component, pageProps }) {
  return (
    // <WalletKitProvider>
    <MoralisProvider initializeOnMount={false}>
        <Component {...pageProps} />
    </MoralisProvider>
    // </WalletKitProvider>
  );
}
export default MyApp
