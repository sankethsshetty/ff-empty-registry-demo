import RegistryInterface from Project.RegistryInterface
import RegistryService from Project.RegistryService


// A contract in Cadence is a collection of type definitions of interfaces, structs, resources, data (its state), and code (its functions) that lives in the contract storage area of an account in Flow.
pub contract RegistryWoodContract: RegistryInterface {

    // Maps an address (of the customer/DappContract) to the amount
    // of tenants they have for a specific RegistryContract.
    access(contract) var clientTenants: {Address: UInt64}

    // Total Wood supply across all the Tenants that want to manage their own wood.
    pub var totalWoodSupply : UInt64

    // Tenant
    //
    // Requirement that all conforming multitenant smart contracts have
    // to define a resource called Tenant to store all data and things
    // that would normally be saved to account storage in the contract's
    // init() function
    // 
    pub resource Tenant {

        pub var totalTenantWoodSupply: UInt64
        pub let woodMinter: @WoodMinter

        // when a tenant is created he is initialised with 0 supply and a minter
        init() {
            self.totalTenantWoodSupply = 0
            self.woodMinter <- create WoodMinter()
    
        }

        // this function has to be inside the Tenant resource because its a ref to a nested resource
        pub fun getWoodRef(): &WoodMinter {
            return &self.woodMinter as &WoodMinter
        }

        pub fun updateTotalTenantWoodSupply(){
            self.totalTenantWoodSupply = self.totalTenantWoodSupply + 1
        }

        destroy(){
            destroy self.woodMinter
        }

        
    }

    // instance
    // instance returns an Tenant resource.
    //
    pub fun instance(authNFT: &RegistryService.AuthNFT): @Tenant {
        let clientTenant = authNFT.owner!.address
        if let count = self.clientTenants[clientTenant] {
            self.clientTenants[clientTenant] = self.clientTenants[clientTenant]! + (1 as UInt64)
        } else {
            self.clientTenants[clientTenant] = (1 as UInt64)
        }

        return <-create Tenant()
    }

    // getTenants
    // getTenants returns clientTenants.
    //
    pub fun getTenants(): {Address: UInt64} {
        return self.clientTenants
    }

    // NFT resource definitions
    pub resource WoodMinter{
        init(){}

        pub fun mintWood(_tenant: &RegistryWoodContract.Tenant):@Wood {
            // update supply in 2 places
            RegistryWoodContract.totalWoodSupply = RegistryWoodContract.totalWoodSupply + 1
            _tenant.updateTotalTenantWoodSupply()
            
            return <- create Wood()
        }

    }

    // NFT resource definitions
    pub resource Wood{
        init(){}

    }

    // Named Paths
    //
    pub let TenantStoragePath: StoragePath
    pub let TenantPublicPath: PublicPath


    init() {
        // Initialize clientTenants
        self.clientTenants = {}

        self.totalWoodSupply = 0

        // Set Named paths
        self.TenantStoragePath = /storage/RegistryWoodTenant
        self.TenantPublicPath = /public/RegistryWoodTenant
    }
}