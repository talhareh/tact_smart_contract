import { toNano } from '@ton/core';
import { Ruffruff } from '../wrappers/Ruffruff';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    //const randomInt = BigInt(Math.random()* 1000000)
    const ruffruff = provider.open(await Ruffruff.fromInit());

    await ruffruff.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(ruffruff.address);

    //console.log("contract ID", await ruffruff.getId())
    // run methods on `ruffruff`
}
