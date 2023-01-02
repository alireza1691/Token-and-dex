import { useState, useEffect } from "react";
import { BigNumber, Contract, ethers } from 'ethers'
const useFetch = () => {
    const [account, setAccount] = useState()
    const [isConnected, setIsConnected] = useState(false);
    const [provider, setProvider] = useState();
    const [signer, setSigner] = useState()
    const [faucetContract, setFaucetContract] = useState()
    const [address, setAddress] = useState()
    const [dexContract, setDexContract] = useState()
    const [usdcContract, setUsdcContract] = useState()
    const [istContract, setIstContract] = useState()
    const [userShares, setUserShares] = useState("0")
    const [usdcReserve, setUsdcReserve] = useState()
    const [istReserve, setIstReserve] = useState()
    const [outPutUsdc, setOutPutUsdc] = useState("0")
    const [outPutIst, setOutPutIst] = useState("0")
    const [pairAmount , setPairAmount ] = useState("0")

    const usdcContractAddress = "0x07865c6E87B9F70255377e024ace6630C1Eaa37F"
    const istContractAddress = "0x9c3565df44b79a7dbdab3678f0b00b9beabc7d70"



    const conncetWalletHandler = async () => {
      if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
        try {
          const accounts = await ethereum.request({method: "eth_requestAccounts"});
          setIsConnected(true)
          let connectedProvider = new ethers.providers.Web3Provider(window.ethereum)
          setProvider(connectedProvider)
          const _signer = connectedProvider.getSigner()
          setSigner(_signer)
          const chainId = await _signer.getChainId()
          const goerliChainId = 5
          console.log('chain id:',chainId);
          if(chainId === goerliChainId){
            console.log('connected to the georli network');
          } else {
            try {
              await provider.request({
                method: 'wallet_switchEthereumChain',
                params: [{ chainId: goerliChainId}],
              });
            } catch (error) {
              if (error.code === 4902) {
              console.log("This network is not available in your metamask, please add it")
              try {
                await window.ethereum.request({
                  method: 'wallet_addEthereumChain',
                  params: [
                    {
                      chainId: '0x5',
                      rpcUrl: 'https://goerli.infura.io/v3/',
                      nativeCurrency: {
                        name: GoerliEtherem,
                        Symbol: GoerliETH,
                        decimals: 18
                      },
                      blockExplorerUrl: 'https://goerli.etherscan.io',
                    },
                  ],
                });
              } catch (addError) {
                  console.log(addError);
                }
              }
              console.log("Failed to switch to the network")
            }
            }
          
          
          setAddress(accounts[0])
          setFaucetContract(new ethers.Contract( faucetContractAddress , faucetAbi , provider ))
          const dexC = new ethers.Contract(dexContractAddress, dexAbi, provider)
          setDexContract (dexC)
          const dexWithSigner =  dexC.connect(_signer)
          const get = await (dexWithSigner.balanceOf(accounts[0]))
          setUserShares(get.toString())
          setUsdcContract (new ethers.Contract(usdcContractAddress , iErc20Abi ,  provider))
          setIstContract (new ethers.Contract(istContractAddress , iErc20Abi ,  provider))
  
          console.log(_signer.getAddress( ));
          console.log(accounts[0]);
  
          const istR = await dexWithSigner._getReserveMyToken()
          const usdcR = await dexWithSigner._getReserveUsdc()
  
          console.log(`ist reserve: ${istR} and usdc reserve : ${usdcR}`);
  
          setIstReserve(istR)
          setUsdcReserve(usdcR)
  
          // const lev = (usdcR * 10 ** 12) / (istR )
          const usdcOutPut = (( usdcR / (10**6)) * (1)) / ((istR / (10 ** 18)) + (1))
          const istUPOutPut = (( istR / (10**6)) * (1)) / ((usdcR / (10 ** 18)) + (1))
    
          setOutPutUsdc(usdcOutPut)
          setOutPutIst(istUPOutPut)
  
          setPairAmount(((usdcR * (10**12))/(istR)))
          window.ethereum.on('accountsChanged',async () =>{
            const newAccounts = await ethereum.request({method: "eth_requestAccounts"})
            setAddress(newAccounts[0])
            console.log("connected wallet changed to:",newAccounts[0]);
          })
        
          ethereum.on('chainChanged', async () => {
            const newChainId = await signer.getChainId()
            console.log(`chain id changed to :${newChainId}`);
            window.location.reload();
          })
          ethereum.on('disconnect', setIsConnected(false));
          const isConnected3 = ethereum.isConnected()
          setIsConnected(isConnected3)
          
          console.log('user disconnected!');
          }catch (e) {
          console.log(e);
        }
      } else {
        setIsConnected(false)
      }
    }
  
    useEffect(() => {
        async function accountChanged () {
          window.ethereum.on("accountsChanged", async () =>{
              const accounts = await window.ethereum.request({
                  method: 'eth_requestAccounts',
              })
              if (accounts.length) {
                setAccount(accounts[0])
              } else {
                  window.location.reload()
              }
          })
        }
        accountChanged()
      },[address])

      


      return(account,conncetWalletHandler,address,isConnected,provider,signer,faucetContract,dexContract,usdcContract,istContract,userShares,usdcReserve,istReserve,outPutUsdc,outPutIst,pairAmount)
}

export default useFetch;