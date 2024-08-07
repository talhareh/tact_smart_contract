import { NetworkProvider, sleep } from "@ton/blueprint";
import { Ruffruff } from "../wrappers/Ruffruff";
import { Address, toNano } from "@ton/core";


export async function run(provider:NetworkProvider){

    const ruff = provider.open(Ruffruff.fromAddress(Address.parse('EQB7vFlIfwZvW2uJWkBZmYTMNE5XiAPmGVE-Sq5MrWKlYWpW')));
    const addr = Address.parse('EQDa7mjzjXAfkKgqoFANUJlzYZoUL69cItzS2pSpPMOH7gsd')
    const listBefore = await ruff.getGetSubmittedWallets()
    console.log("List in start : ", listBefore)

    await ruff.send(
        provider.sender(),
        {
            value: toNano("0.05")
        },
        {
            $$type: "SubmitWallet",
            address:addr,
            
        }
    )

    let listAfter = await ruff.getGetSubmittedWallets()
    let attempt = 1
    while(listAfter === listBefore){
        console.log('Adding Wallet, attempt#', attempt)
        await sleep(2000)
        listAfter = await ruff.getGetSubmittedWallets();
        attempt++;

    }
    console.log("Wallet added : ", listAfter)
}