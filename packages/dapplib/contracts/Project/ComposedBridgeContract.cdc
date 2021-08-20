import RegistryWoodContract from Project.RegistryWoodContract
import RegistryStoneContract from Project.RegistryStoneContract
import NonFungibleToken from Flow.NonFungibleToken

pub contract ComposedBridgeContract {

    // total number of bridges
    pub var totalBridges: UInt64


    init() {
        self.totalBridges = 0

    }

    pub fun getTotalBridges(): UInt64 {
        return self.totalBridges
    }

    // user demands a bridge.
    pub fun mintBridge(/*recipient */): @Bridge{
        // dynamically mint
        self.totalBridges = self.totalBridges + 1
        
        let woodTenant = self.account.borrow<&RegistryWoodContract.Tenant>(from: /storage/RegistryWoodTenant)! as &RegistryWoodContract.Tenant
        let stoneTenant = self.account.borrow<&RegistryStoneContract.Tenant>(from: /storage/RegistryStoneTenant)! as &RegistryStoneContract.Tenant

        let woodMinterRef = self.account.borrow<&RegistryWoodContract.Tenant>(from: /storage/RegistryWoodTenant)!.getWoodRef() as &RegistryWoodContract.WoodMinter
        let stoneMinterRef = self.account.borrow<&RegistryStoneContract.Tenant>(from: /storage/RegistryStoneTenant)!.getStoneRef() as &RegistryStoneContract.StoneMinter

        let wood <- woodMinterRef.mintWood(_tenant: woodTenant)
        let stone <- stoneMinterRef.mintStone(_tenant: stoneTenant)

        return <- create Bridge(wood: <- wood, stone: <- stone)
    }

    

    pub resource Bridge: NonFungibleToken.INFT {
        
        pub let id: UInt64
        pub let bridgeWood: @RegistryWoodContract.Wood
        pub let bridgeStone: @RegistryStoneContract.Stone

        init(wood: @RegistryWoodContract.Wood, stone: @RegistryStoneContract.Stone) {
            self.id = ComposedBridgeContract.getTotalBridges()
            self.bridgeWood <- wood
            self.bridgeStone <- stone
        }

        destroy(){
            destroy self.bridgeWood
            destroy self.bridgeStone
        }
    }

}