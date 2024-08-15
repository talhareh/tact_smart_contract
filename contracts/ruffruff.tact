import "@stdlib/deploy";

message SubmitWallet {
    address: Address;
}

message SetHoldingWallet {
    address: Address;
}

message TransferToHoldingWallet {
    amount: Int;
}

struct WalletResponse {
    address: Address;
    randomNumber: Int;
}

contract Ruffruff with Deployable {
    wallets: map<Address, WalletResponse>;
    holdingWallet: Address;

    init() {
        self.wallets = emptyMap();
        self.holdingWallet = newAddress(0,0)  
    }

    receive(msg: SubmitWallet) {
        let randomNumber: Int = random(0, 100);
        let response: WalletResponse = WalletResponse{
            address: msg.address,
            randomNumber: randomNumber
        };
        self.wallets.set(msg.address, response);
    }

    receive(msg: SetHoldingWallet) {
        self.holdingWallet = msg.address;  // Set the holding wallet address
    }

    receive(msg: TransferToHoldingWallet) {
        require(self.holdingWallet != newAddress(0,0), "Holding wallet not set");

        
        let sender: Address = context().sender;
        send(SendParameters{
            to: self.holdingWallet,
            value: msg.amount,
            mode: SendIgnoreErrors
        });
    }

    get fun SubmittedWallets(): map<Address, WalletResponse> {
        return self.wallets;
    }

    get fun HoldingWallet(): Address {
        return self.holdingWallet;
    }
}
