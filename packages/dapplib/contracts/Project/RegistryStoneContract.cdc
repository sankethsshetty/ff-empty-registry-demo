import RegistryInterface from Project.RegistryInterface
import RegistryService from Project.RegistryService

pub contract RegistryStoneContract: RegistryInterface {

    // Maps an address (of the customer/DappContract) to the amount
    // of tenants they have for a specific RegistryContract.
    access(contract) var clientTenants: {Address: UInt64}

    // Total Stone supply accross all the Tenants that want to manage their own stone.
    pub var totalStoneSupply : UInt64
    
   
    // Tenant
    //
    // Requirement that all conforming multitenant smart contracts have
    // to define a resource called Tenant to store all data and things
    // that would normally be saved to account storage in the contract's
    // init() function
    // 
    pub resource Tenant {

        pub var totalTenantStoneSupply: UInt64
        pub var stoneMinter: @StoneMinter

        // when a tenant is created he is initialised with 0 supply and a minter
        init() {
            self.totalTenantStoneSupply = 0
            self.stoneMinter <- create StoneMinter()
        }


        pub fun getStoneRef(): &StoneMinter {
            return &self.stoneMinter as &StoneMinter
        }

        pub fun updateTotalTenantStoneSupply(){
            self.totalTenantStoneSupply = self.totalTenantStoneSupply + 1
        }

        destroy(){
            destroy self.stoneMinter
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
    pub resource StoneMinter{
        init(){
        }

        pub fun mintStone(_tenant: &RegistryStoneContract.Tenant): @Stone {
            // update supply in 2 places
            RegistryStoneContract.totalStoneSupply = RegistryStoneContract.totalStoneSupply + 1
            _tenant.updateTotalTenantStoneSupply()

            return <- create Stone()
        }
            
    }

    // NFT resource definitions
    pub resource Stone{
        init(){}

    }

    // Named Paths
    //
    pub let TenantStoragePath: StoragePath
    pub let TenantPublicPath: PublicPath


    init() {
        // Initialize clientTenants
        self.clientTenants = {}
        
        self.totalStoneSupply = 0

        // Set Named paths
        self.TenantStoragePath = /storage/RegistryStoneTenant
        self.TenantPublicPath = /public/RegistryStoneTenant
    }
}