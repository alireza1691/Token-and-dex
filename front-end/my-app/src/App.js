import {useEffect} from "react";
import {useWallet} from "@mysten/wallet-adapter-react";
import { ConnectButton } from '@suiet/wallet-kit';

function App() {
  // const {
  //   select,
  //   wallet,
  //   connected,
  //   connecting,
  //   disconnect,
  //   getAccounts,
  //   executeMoveCall,
  // } = useWallet();

  // useEffect(() => {
  //   if (!connected || !wallet) return;
  //   (async function () {
  //     console.log(wallet.adapter.name);
  //     const accounts = await getAccounts();
  //     console.log(accounts);
  //   })();
  // }, [connected, wallet]);

  // async function handleExecuteMoveCall() {
  //   await executeMoveCall({
  //     packageObjectId: "0x2",
  //     module: "devnet_nft",
  //     function: "mint",
  //     typeArguments: [],
  //     arguments: [
  //       "name",
  //       "capy",
  //       "https://cdn.britannica.com/94/194294-138-B2CF7780/overview-capybara.jpg?w=800&h=450&c=crop",
  //     ],
  //     gasBudget: 10000,
  //   });
  // }

  return (
    <div className={'app'}>
      <>
      <header>
        <ConnectButton />
      </header>
      </>
    </div>
  )
}
export default App