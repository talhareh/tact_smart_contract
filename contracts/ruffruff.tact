import "@stdlib/deploy";

message SubmitWallet {
    address: Address;
}

struct WalletResponse {
    address: Address;
    randomNumber: Int;
}

contract Ruffruff with Deployable {
    wallets: map<Address, WalletResponse>;

    init() {
        self.wallets = emptyMap();
    }

    receive(msg: SubmitWallet) {
        let randomNumber: Int = random(0, 100);
        let response: WalletResponse = WalletResponse{
            address: msg.address,
            randomNumber: randomNumber
        };
        self.wallets.set(msg.address, response);
    }

    get fun getSubmittedWallets(): map<Address, WalletResponse> {
        return self.wallets;
    }
}
