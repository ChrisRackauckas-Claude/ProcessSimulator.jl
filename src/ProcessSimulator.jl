module ProcessSimulator

using ModelingToolkit
using ModelingToolkit: t_nounits as t, D_nounits as D
using ModelingToolkit: scalarize, equations, get_unknowns

# Base
include("base/materials.jl")
include("base/base_components.jl")
include("base/utils.jl")

# Media (Clapeyron integration for thermodynamic properties)
include("media/Media.jl")

# Fluid handling
include("fluid_handling/compressors.jl")
include("fluid_handling/heat_exchangers.jl")

# Reactors
include("reactors/CSTR.jl")

# Exports - Base types
export AbstractMaterialSource, MaterialSource, Reaction
export MaterialStream, MaterialConnector
export HeatConnector, WorkConnector
export SimpleControlVolume, TPControlVolume

# Exports - Media (Clapeyron integration)
export PURE_COMPONENTS
export get_clapeyron_name, get_clapeyron_names
export list_available_components, search_components
export ClapeyronMedium, Medium
export PR, SRK, RK, PCSAFT, CPA, vdW

# Exports - Predefined mixtures
export NaturalGasMixture, AirMixture, SyngasMixture, LPGMixture
export RefrigerantMixture, CombustionGasMixture
export PureWater, PureMethane
export BTXMixture, SteamReformingMixture, AmmoniaProcessMixture

end
