// import { ConnectButton, useWallet } from "@mysten/wallet-kit";

// export default function SendTransaction() {
//   const { connected, getAccounts, signAndExecuteTransaction } = useWallet();

//   const handleClick = async () => {
//     await signAndExecuteTransaction({
//       kind: "moveCall",
//       data: {
//         packageObjectId: "0x2",
//         module: "devnet_nft",
//         function: "mint",
//         typeArguments: [],
//         arguments: [
//           "name",
//           "capy",
//           "https://cdn.britannica.com/94/194294-138-B2CF7780/overview-capybara.jpg?w=800&h=450&c=crop",
//         ],
//         gasBudget: 10000,
//       },
//     });
//   };

//   return (
//     <div>
//     <ConnectButton onClick={() => handleClick()} disabled={!connected}/>
//     </div>
//   );
// }