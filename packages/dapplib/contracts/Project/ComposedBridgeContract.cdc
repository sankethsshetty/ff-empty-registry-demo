import RegistryWoodContract from Project.RegistryWoodContract
import RegistryStoneContract from Project.RegistryStoneContract
import NonFungibleToken from Flow.NonFungibleToken

pub contract ComposedBridgeContract {

    // total number of bridges
    pub var totalBridges: UInt64
    
    // Named Paths for users to use
    pub let BridgeStoragePath: StoragePath



    init() {
        self.totalBridges = 0
        self.BridgeStoragePath = /storage/BridgeStoragePath

    }

    pub fun getTotalBridges(): UInt64 {
        return self.totalBridges
    }

    // user demands a bridge.
    pub fun mintBridge(): @Bridge{
        // dynamically mint
        self.totalBridges = self.totalBridges + 1
        
        let woodTenant = self.account.getCapability(RegistryWoodContract.TenantPublicPath).borrow<&RegistryWoodContract.Tenant>()! as &RegistryWoodContract.Tenant
        let stoneTenant = self.account.getCapability(RegistryStoneContract.TenantPublicPath).borrow<&RegistryStoneContract.Tenant>()! as &RegistryStoneContract.Tenant

        let woodMinterRef = woodTenant.getWoodRef() as &RegistryWoodContract.WoodMinter
        let stoneMinterRef = stoneTenant.getStoneRef() as &RegistryStoneContract.StoneMinter

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