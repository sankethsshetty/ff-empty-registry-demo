import ComposedBridgeContract from Project.ComposedBridgeContract


transaction() {

    prepare(signer: AuthAccount) {
        // if this account doesn't already have an AuthNFT...
        if signer.borrow<&ComposedBridgeContract.Bridge>(from: ComposedBridgeContract.BridgeStoragePath) == nil {
            // save a new AuthNFT to account storage
            signer.save(<-ComposedBridgeContract.mintBridge(), to: ComposedBridgeContract.BridgeStoragePath)

            }
    }

    execute {

    }
}