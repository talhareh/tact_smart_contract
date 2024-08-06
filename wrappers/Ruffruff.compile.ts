import { CompilerConfig } from '@ton/blueprint';

export const compile: CompilerConfig = {
    lang: 'tact',
    target: 'contracts/ruffruff.tact',
    options: {
        debug: true,
    },
};
