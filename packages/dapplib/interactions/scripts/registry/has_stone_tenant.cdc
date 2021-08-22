import RegistryStoneContract from Project.RegistryStoneContract

// Checks to see if an account has an Stone Tenant

pub fun main(tenant: Address): Bool {
    let hasStoneTenant = getAccount(tenant).getCapability(RegistryStoneContract.TenantPublicPath)
                        .borrow<&RegistryStoneContract.Tenant>()

    if hasStoneTenant == nil {
        return false
    } else {
        return true
    }
}