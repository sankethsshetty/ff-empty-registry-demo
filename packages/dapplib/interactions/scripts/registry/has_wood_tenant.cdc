import RegistryWoodContract from Project.RegistryWoodContract

// Checks to see if an account has an AuthNFT

pub fun main(tenant: Address): Bool {
    let hasWoodTenant = getAccount(tenant).getCapability(RegistryWoodContract.TenantPublicPath)
                        .borrow<&RegistryWoodContract.Tenant>()

    if hasWoodTenant == nil {
        return false
    } else {
        return true
    }
}