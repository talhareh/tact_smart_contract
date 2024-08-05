import { Blockchain, SandboxContract, TreasuryContract } from '@ton/sandbox';
import { toNano } from '@ton/core';
import { Ruffruff } from '../wrappers/Ruffruff';
import '@ton/test-utils';

describe('Ruffruff', () => {
    let blockchain: Blockchain;
    let deployer: SandboxContract<TreasuryContract>;
    let ruffruff: SandboxContract<Ruffruff>;

    beforeEach(async () => {
        blockchain = await Blockchain.create();

        ruffruff = blockchain.openContract(await Ruffruff.fromInit());

        deployer = await blockchain.treasury('deployer');

        const deployResult = await ruffruff.send(
            deployer.getSender(),
            {
                value: toNano('0.05'),
            },
            {
                $$type: 'Deploy',
                queryId: 0n,
            }
        );

        expect(deployResult.transactions).toHaveTransaction({
            from: deployer.address,
            to: ruffruff.address,
            deploy: true,
            success: true,
        });
    });

    it('should deploy', async () => {
        // the check is done inside beforeEach
        // blockchain and ruffruff are ready to use
    });
});
