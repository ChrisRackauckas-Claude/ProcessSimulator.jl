#=
    Media Module

    Provides structured media properties using Clapeyron.jl thermodynamic models.

    This module addresses GitHub Issue #1: Structuring of Media properties
    - Big dictionary of pure component models from Clapeyron data banks
    - Generate mixture models from component models
    - Predefined mixtures (e.g., NaturalGasMixture, AirMixture)

    Usage:
    ```julia
    # Using predefined mixtures
    medium = NaturalGasMixture()
    @named stream = MaterialStream(medium)

    # Creating custom mixtures
    medium = ClapeyronMedium([:H2O, :CH4, :CO2]; eos=PCSAFT)
    @named stream = MaterialStream(medium)

    # Using the component registry
    components = search_components("meth")  # Find methane, methanol, etc.
    medium = ClapeyronMedium(components)
    ```
=#

# Include component registry
include("pure_components.jl")

# Include Clapeyron integration
include("clapeyron_medium.jl")

# Include predefined mixtures
include("predefined_mixtures.jl")

# Exports are handled in the main ProcessSimulator module
