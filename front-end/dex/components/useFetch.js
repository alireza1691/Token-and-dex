import { useState, useEffect } from "react";
import { BigNumber, Contract, ethers } from 'ethers'
const useFetch = () => {
    const [account, setAccount] = useState()




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


      return(account)
}

export default useFetch;