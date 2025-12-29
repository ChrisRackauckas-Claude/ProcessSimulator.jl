#=
    Pure Component Registry

    Maps friendly component names (symbols) to Clapeyron database names.
    Components are sourced from Clapeyron.jl data banks.
=#

"""
    PURE_COMPONENTS

Dictionary mapping friendly component names (as Symbols) to their Clapeyron database names.
Multiple aliases are supported for common components (e.g., :H2O and :water both map to "water").

# Example
```julia
PURE_COMPONENTS[:H2O]  # Returns "water"
PURE_COMPONENTS[:CH4]  # Returns "methane"
```
"""
const PURE_COMPONENTS = Dict{Symbol,String}(
    # Water
    :water => "water",
    :H2O => "water",

    # Light alkanes
    :methane => "methane",
    :CH4 => "methane",
    :ethane => "ethane",
    :C2H6 => "ethane",
    :propane => "propane",
    :C3H8 => "propane",
    :butane => "butane",
    :n_butane => "butane",
    :isobutane => "isobutane",
    :pentane => "pentane",
    :n_pentane => "pentane",
    :isopentane => "isopentane",
    :hexane => "hexane",
    :n_hexane => "hexane",
    :heptane => "heptane",
    :n_heptane => "heptane",
    :octane => "octane",
    :n_octane => "octane",
    :nonane => "nonane",
    :decane => "decane",

    # Alkenes
    :ethylene => "ethylene",
    :ethene => "ethylene",
    :C2H4 => "ethylene",
    :propylene => "propylene",
    :propene => "propylene",
    :butene => "butene",
    :isobutene => "isobutene",

    # Aromatics
    :benzene => "benzene",
    :toluene => "toluene",
    :xylene => "o-xylene",
    :o_xylene => "o-xylene",
    :m_xylene => "m-xylene",
    :p_xylene => "p-xylene",
    :ethylbenzene => "ethylbenzene",
    :styrene => "styrene",
    :naphthalene => "naphthalene",

    # Inorganics
    :nitrogen => "nitrogen",
    :N2 => "nitrogen",
    :oxygen => "oxygen",
    :O2 => "oxygen",
    :hydrogen => "hydrogen",
    :H2 => "hydrogen",
    :carbon_monoxide => "carbon monoxide",
    :CO => "carbon monoxide",
    :carbon_dioxide => "carbon dioxide",
    :CO2 => "carbon dioxide",
    :hydrogen_sulfide => "hydrogen sulfide",
    :H2S => "hydrogen sulfide",
    :ammonia => "ammonia",
    :NH3 => "ammonia",
    :argon => "argon",
    :Ar => "argon",
    :helium => "helium",
    :He => "helium",
    :sulfur_dioxide => "sulfur dioxide",
    :SO2 => "sulfur dioxide",
    :nitric_oxide => "nitric oxide",
    :NO => "nitric oxide",
    :nitrogen_dioxide => "nitrogen dioxide",
    :NO2 => "nitrogen dioxide",

    # Alcohols
    :methanol => "methanol",
    :CH3OH => "methanol",
    :ethanol => "ethanol",
    :C2H5OH => "ethanol",
    :propanol => "propanol",
    :isopropanol => "isopropanol",
    :butanol => "butanol",
    :phenol => "phenol",

    # Ketones and aldehydes
    :acetone => "acetone",
    :formaldehyde => "formaldehyde",
    :acetaldehyde => "acetaldehyde",

    # Acids
    :acetic_acid => "acetic acid",
    :formic_acid => "formic acid",

    # Ethers and esters
    :dimethyl_ether => "dimethyl ether",
    :DME => "dimethyl ether",
    :diethyl_ether => "diethyl ether",
    :methyl_acetate => "methyl acetate",
    :ethyl_acetate => "ethyl acetate",

    # Halogenated compounds
    :chloromethane => "chloromethane",
    :dichloromethane => "dichloromethane",
    :chloroform => "chloroform",
    :carbon_tetrachloride => "carbon tetrachloride",

    # Glycols
    :ethylene_glycol => "ethylene glycol",
    :propylene_glycol => "propylene glycol",

    # Cyclic compounds
    :cyclohexane => "cyclohexane",
    :cyclopentane => "cyclopentane",
    :cyclohexene => "cyclohexene",

    # Industrial chemicals
    :methylamine => "methylamine",
    :dimethylamine => "dimethylamine",
    :trimethylamine => "trimethylamine",
    :aniline => "aniline",
    :nitrobenzene => "nitrobenzene",
)

"""
    get_clapeyron_name(component::Symbol) -> String

Convert a friendly component name (Symbol) to the corresponding Clapeyron database name.
Throws an error if the component is not found in the registry.

# Arguments
- `component::Symbol`: The friendly name of the component

# Returns
- `String`: The Clapeyron database name

# Example
```julia
get_clapeyron_name(:H2O)  # Returns "water"
get_clapeyron_name(:CO2)  # Returns "carbon dioxide"
```
"""
function get_clapeyron_name(component::Symbol)
    if !haskey(PURE_COMPONENTS, component)
        error("Component $component not found in PURE_COMPONENTS registry. " *
              "Available components: $(keys(PURE_COMPONENTS))")
    end
    return PURE_COMPONENTS[component]
end

"""
    get_clapeyron_name(component::String) -> String

Pass-through for String components that are already in Clapeyron format.
"""
get_clapeyron_name(component::String) = component

"""
    get_clapeyron_names(components) -> Vector{String}

Convert a collection of component names to Clapeyron database names.

# Arguments
- `components`: A vector of Symbols or Strings

# Returns
- `Vector{String}`: Vector of Clapeyron database names
"""
function get_clapeyron_names(components)
    return [get_clapeyron_name(c) for c in components]
end

"""
    list_available_components() -> Vector{Symbol}

Returns a sorted list of all available component names in the registry.
"""
function list_available_components()
    return sort(collect(keys(PURE_COMPONENTS)))
end

"""
    search_components(pattern::String) -> Vector{Symbol}

Search for components matching a pattern (case-insensitive substring match).

# Example
```julia
search_components("meth")  # Returns [:methane, :methanol, :dimethyl_ether, ...]
```
"""
function search_components(pattern::String)
    pattern_lower = lowercase(pattern)
    matches = Symbol[]
    for (sym, name) in PURE_COMPONENTS
        if occursin(pattern_lower, lowercase(string(sym))) ||
           occursin(pattern_lower, lowercase(name))
            push!(matches, sym)
        end
    end
    return sort(unique(matches))
end
