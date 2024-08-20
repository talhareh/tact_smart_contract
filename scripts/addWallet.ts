import { NetworkProvider, sleep } from "@ton/blueprint";
import { Ruffruff } from "../wrappers/Ruffruff";
import { Address, toNano } from "@ton/core";


export async function run(provider:NetworkProvider){

    const ruff = provider.open(Ruffruff.fromAddress(Address.parse('EQC7AGTh1uEb3yLVGQn699LR0dEvbSKjiiry6n6qFIF1Styh')));
    
    // const addr = Address.parse('UQBTzIdjCd753CUT1Itz46dGBCWb3W69BvPf9E5UQ2eW-DTI')
    // const listBefore = await ruff.getSubmittedWallets()
    // console.log("List in start : ", listBefore)

    // await ruff.send(
    //     provider.sender(),
    //     {
    //         value: toNano("0.01")
    //     },
    //     {
    //         $$type: "SubmitWallet",
    //         address:addr,
            
    //     }
    // )

    // let listAfter = await ruff.getSubmittedWallets()
    // console.log("Wallet added : ", listAfter)



    // 2. Set the holding wallet address
    //const holdingWalletAddr = Address.parse('EQCAMqa2TlkJCFVlekQZjAqMP-lGuxFO9fjVu6aAA27r046z');
    
    // console.log("Setting holding wallet address:", holdingWalletAddr);
    // await ruff.send(
    //     provider.sender(),
    //     {
    //         value: toNano("0.01")
    //     },
    //     {
    //         $$type: "SetHoldingWallet",
    //         address: holdingWalletAddr,
    //     }
    // );

    //Check that the holding wallet is set
    // const currentHoldingWallet = await ruff.getHoldingWallet();
    // console.log("Current holding wallet:", currentHoldingWallet);

    // 3. Transfer tokens to the holding wallet
    const transferAmount = toNano("0.01");
    // console.log(`Transferring ${transferAmount.toString()} tokens to holding wallet`);

    await ruff.send(
        provider.sender(),
        {
            value: transferAmount
        },
        {
            $$type: "TransferToHoldingWallet",
            amount: transferAmount,
        }
    );

    // console.log("Tokens transferred to holding wallet:", holdingWalletAddr);

}