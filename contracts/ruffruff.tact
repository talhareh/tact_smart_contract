import "@stdlib/deploy";

// Message to join the pool with payment
message JoinPool {
    address: Address;
    amount: Int;
}

// Message to set the holding wallet
message SetHoldingWallet {
    address: Address;
}

// Message to create a new pool
message CreatePool {
    timestamp: Int;
}

// Message to end the pool and select winners
message EndPool {
    timestamp: Int;
}

struct Participant {
    address: Address;
    paidAmount: Int;
}

struct Winner {
    address: Address;
    prizeAmount: Int;
}

contract RafflePool with Deployable {
    // Maps for participants in the current pool and the winners
    participants: map<Address, Participant>;
    holdingWallet: Address;
    poolTotal: Int as coins; // Total amount collected in the current pool

    // Array or map to keep track of winners
    winners: map<Int, Winner>; // Assume an index to keep track of 3 winners
    currentPool: Int;

    init() {
        self.participants = emptyMap();
        self.holdingWallet = newAddress(0, 0);
        self.poolTotal = 0;
        self.currentPool = 0;
        self.winners = emptyMap();
    }

    // Receiver to set the holding wallet address
    receive(msg: SetHoldingWallet) {
        self.holdingWallet = msg.address;
    }

    // Receiver to create a new pool (called every hour)
    receive(msg: CreatePool) {
        self.currentPool = msg.timestamp;
        self.participants = emptyMap(); // Reset participants for the new pool
        self.poolTotal = 0; // Reset pool total
    }

    // Receiver for participants to join the pool
    receive(msg: JoinPool) {
        require(msg.amount == 1 ton, "Entry fee must be 1 TON");
        // Save participant's address and amount paid
        self.participants.set(msg.address, Participant{
            address: msg.address,
            paidAmount: msg.amount
        });

        // Add to pool total
        self.poolTotal = self.poolTotal + msg.amount;

        // Transfer funds to holding wallet
        send(SendParameters{
            to: self.holdingWallet,
            value: msg.amount,
            mode: SendIgnoreErrors
        });
    }

    // Receiver to end the pool and select winners
    receive(msg: EndPool) {
        // Logic to select 3 winners randomly from the participants
        // Calculate prize distribution: 50%, 30%, 10% to winners, 10% to the company

        // Example logic for selecting and storing winners
        let firstWinner: Address = randomParticipant();
        let secondWinner: Address = randomParticipant();
        let thirdWinner: Address = randomParticipant();

        self.winners.set(1, Winner{
            address: firstWinner,
            prizeAmount: self.poolTotal * 50 / 100
        });
        self.winners.set(2, Winner{
            address: secondWinner,
            prizeAmount: self.poolTotal * 30 / 100
        });
        self.winners.set(3, Winner{
            address: thirdWinner,
            prizeAmount: self.poolTotal * 10 / 100
        });

        // Transfer prizes to winners and the company
        distributePrizes();

        // Reset pool for the next round
        self.participants = emptyMap();
        self.poolTotal = 0;
    }

    // Function to randomly select a participant (skeleton, to be implemented)
    fun randomParticipant(): Address {
        // Logic to pick a random participant
        return newAddress(0, 0); // Placeholder
    }

    // Function to distribute prizes to winners and company (skeleton, to be implemented)
    fun distributePrizes() {
        // Logic to send prizes to winners and the company fee
    }

    // Getter to view current participants
    get fun Participants(): map<Address, Participant> {
        return self.participants;
    }

    // Getter to view the holding wallet address
    get fun HoldingWallet(): Address {
        return self.holdingWallet;
    }

    // Getter to view the current pool total
    get fun PoolTotal(): Int {
        return self.poolTotal;
    }

    // Getter to view the winners of the current pool
    get fun Winners(): map<Int, Winner> {
        return self.winners;
    }
}

