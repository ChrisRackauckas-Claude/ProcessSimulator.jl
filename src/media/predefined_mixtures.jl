#=
    Predefined Mixture Media

    Common industrial mixtures with predefined component lists.
    Each function returns a MaterialSource ready for use with MaterialStream.
=#

"""
    NaturalGasMixture(; eos=PR, include_trace=false)

Create a MaterialSource for natural gas mixture.

Default components: methane, ethane, propane, n-butane, carbon dioxide, nitrogen

If `include_trace=true`, also includes: hydrogen sulfide, isobutane, isopentane, n-pentane

# Example
```julia
medium = NaturalGasMixture()
medium = NaturalGasMixture(eos=PCSAFT, include_trace=true)
```
"""
function NaturalGasMixture(; eos=PR, include_trace=false)
    components = ["methane", "ethane", "propane", "butane", "carbon dioxide", "nitrogen"]
    if include_trace
        append!(components, ["hydrogen sulfide", "isobutane", "isopentane", "pentane"])
    end
    return ClapeyronMedium(components; eos=eos, name="NaturalGas")
end

"""
    AirMixture(; eos=PR, include_trace=false)

Create a MaterialSource for air mixture.

Default components: nitrogen, oxygen, argon

If `include_trace=true`, also includes: carbon dioxide

# Example
```julia
medium = AirMixture()
```
"""
function AirMixture(; eos=PR, include_trace=false)
    components = ["nitrogen", "oxygen", "argon"]
    if include_trace
        push!(components, "carbon dioxide")
    end
    return ClapeyronMedium(components; eos=eos, name="Air")
end

"""
    SyngasMixture(; eos=PR)

Create a MaterialSource for synthesis gas (syngas) mixture.

Components: hydrogen, carbon monoxide, carbon dioxide, methane, nitrogen, water

# Example
```julia
medium = SyngasMixture()
```
"""
function SyngasMixture(; eos=PR)
    components = ["hydrogen", "carbon monoxide", "carbon dioxide", "methane", "nitrogen", "water"]
    return ClapeyronMedium(components; eos=eos, name="Syngas")
end

"""
    LPGMixture(; eos=PR)

Create a MaterialSource for liquefied petroleum gas (LPG) mixture.

Components: propane, butane, isobutane, propylene, butene

# Example
```julia
medium = LPGMixture()
```
"""
function LPGMixture(; eos=PR)
    components = ["propane", "butane", "isobutane", "propylene", "butene"]
    return ClapeyronMedium(components; eos=eos, name="LPG")
end

"""
    RefrigerantMixture(components; eos=PR, name="Refrigerant")

Create a MaterialSource for a refrigerant mixture with specified components.

Common refrigerant components in Clapeyron database include various hydrofluorocarbons.

# Example
```julia
medium = RefrigerantMixture(["propane", "isobutane"])
```
"""
function RefrigerantMixture(components; eos=PR, name="Refrigerant")
    return ClapeyronMedium(components; eos=eos, name=name)
end

"""
    CombustionGasMixture(; eos=PR)

Create a MaterialSource for combustion/flue gas mixture.

Components: carbon dioxide, water, nitrogen, oxygen

# Example
```julia
medium = CombustionGasMixture()
```
"""
function CombustionGasMixture(; eos=PR)
    components = ["carbon dioxide", "water", "nitrogen", "oxygen"]
    return ClapeyronMedium(components; eos=eos, name="CombustionGas")
end

"""
    PureWater(; eos=PR)

Create a MaterialSource for pure water.

# Example
```julia
medium = PureWater()
```
"""
function PureWater(; eos=PR)
    return ClapeyronMedium(["water"]; eos=eos, name="Water")
end

"""
    PureMethane(; eos=PR)

Create a MaterialSource for pure methane.

# Example
```julia
medium = PureMethane()
```
"""
function PureMethane(; eos=PR)
    return ClapeyronMedium(["methane"]; eos=eos, name="Methane")
end

"""
    BTXMixture(; eos=PR)

Create a MaterialSource for BTX (benzene, toluene, xylene) mixture.

Components: benzene, toluene, o-xylene, m-xylene, p-xylene

# Example
```julia
medium = BTXMixture()
```
"""
function BTXMixture(; eos=PR)
    components = ["benzene", "toluene", "o-xylene", "m-xylene", "p-xylene"]
    return ClapeyronMedium(components; eos=eos, name="BTX")
end

"""
    SteamReformingMixture(; eos=PR)

Create a MaterialSource for steam methane reforming mixture.

Components: methane, water, hydrogen, carbon monoxide, carbon dioxide

# Example
```julia
medium = SteamReformingMixture()
```
"""
function SteamReformingMixture(; eos=PR)
    components = ["methane", "water", "hydrogen", "carbon monoxide", "carbon dioxide"]
    return ClapeyronMedium(components; eos=eos, name="SteamReforming")
end

"""
    AmmoniaProcessMixture(; eos=PR)

Create a MaterialSource for ammonia synthesis process.

Components: nitrogen, hydrogen, ammonia, methane, argon

# Example
```julia
medium = AmmoniaProcessMixture()
```
"""
function AmmoniaProcessMixture(; eos=PR)
    components = ["nitrogen", "hydrogen", "ammonia", "methane", "argon"]
    return ClapeyronMedium(components; eos=eos, name="AmmoniaProcess")
end
