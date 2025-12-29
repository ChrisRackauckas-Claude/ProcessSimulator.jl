#=
    Clapeyron Medium Integration

    Functions to create MaterialSource objects from Clapeyron.jl models.
    Provides a bridge between Clapeyron's thermodynamic calculations and
    ProcessSimulator's MaterialSource interface.
=#

using Clapeyron
using Clapeyron: PR, SRK, RK, PCSAFT, CPA, vdW
using Clapeyron: molar_density as clap_molar_density
using Clapeyron: enthalpy as clap_enthalpy
using Clapeyron: entropy as clap_entropy
using Clapeyron: internal_energy as clap_internal_energy
using Clapeyron: pressure as clap_pressure
using Clapeyron: tp_flash as clap_tp_flash
using Clapeyron: mw

"""
    ClapeyronMedium(components; eos=PR, name=nothing)

Create a `MaterialSource` from a Clapeyron equation of state model.

# Arguments
- `components`: A vector of component names (Strings or Symbols). Symbols are
  converted using the `PURE_COMPONENTS` registry.
- `eos=PR`: The equation of state model to use. Options include:
  - `PR` (Peng-Robinson, default)
  - `SRK` (Soave-Redlich-Kwong)
  - `RK` (Redlich-Kwong)
  - `PCSAFT` (PC-SAFT)
  - `CPA` (Cubic Plus Association)
  - `vdW` (van der Waals)
- `name=nothing`: Optional name for the medium. If not provided, component names are joined.

# Returns
- `MaterialSource`: A MaterialSource object with thermodynamic functions from Clapeyron.

# Example
```julia
# Using string component names
medium = ClapeyronMedium(["water", "methanol"])

# Using symbol component names from registry
medium = ClapeyronMedium([:H2O, :CH4, :CO2]; eos=PCSAFT)

# Create a named medium
medium = ClapeyronMedium([:CH4, :C2H6, :C3H8]; name="LightHydrocarbons")
```
"""
function ClapeyronMedium(components; eos=PR, name=nothing)
    # Convert symbols to Clapeyron names
    clap_components = get_clapeyron_names(components)

    # Create the Clapeyron model
    model = eos(clap_components)

    # Get molar weights (kg/mol)
    Mw_values = [mw(model)[i] / 1000.0 for i in 1:length(clap_components)]  # Clapeyron returns g/mol

    # Generate name if not provided
    medium_name = isnothing(name) ? join(clap_components, "_") : string(name)

    # Create wrapper functions that match MaterialSource interface

    # molar_density(p, T, xᵢ; phase) -> mol/m³
    function _molar_density(p, T, xᵢ; phase="unknown")
        z = collect(xᵢ)
        clap_phase = _convert_phase(phase)
        return clap_molar_density(model, p, T, z; phase=clap_phase)
    end

    # VT_enthalpy(ρ, T, xᵢ) -> J/mol
    # Note: Clapeyron enthalpy takes (model, p, T) but MaterialSource interface uses (ρ, T)
    # We need to convert density to pressure first
    function _VT_enthalpy(ρ, T, xᵢ; kwargs...)
        z = collect(xᵢ)
        V = 1.0 / ρ  # molar volume m³/mol
        # Use Clapeyron's VT functions
        return Clapeyron.VT_enthalpy(model, V, T, z)
    end

    # VT_entropy(ρ, T, xᵢ) -> J/(mol·K)
    function _VT_entropy(ρ, T, xᵢ; kwargs...)
        z = collect(xᵢ)
        V = 1.0 / ρ
        return Clapeyron.VT_entropy(model, V, T, z)
    end

    # VT_internal_energy(ρ, T, xᵢ) -> J/mol
    function _VT_internal_energy(ρ, T, xᵢ; kwargs...)
        z = collect(xᵢ)
        V = 1.0 / ρ
        return Clapeyron.VT_internal_energy(model, V, T, z)
    end

    # pressure(ρ, T, xᵢ) -> Pa
    function _pressure(ρ, T, xᵢ; kwargs...)
        z = collect(xᵢ)
        V = 1.0 / ρ
        return clap_pressure(model, V, T, z)
    end

    # tp_flash(p, T, xᵢ) -> flash results
    function _tp_flash(p, T, xᵢ; kwargs...)
        z = collect(xᵢ)
        return clap_tp_flash(model, p, T, z)
    end

    # Create and return MaterialSource
    return MaterialSource(
        medium_name,
        clap_components,
        length(clap_components),
        Mw_values,
        _pressure,
        _molar_density,
        _VT_internal_energy,
        _VT_enthalpy,
        _VT_entropy,
        _tp_flash,
        Reaction[]
    )
end

"""
    _convert_phase(phase::String) -> Symbol

Convert ProcessSimulator phase string to Clapeyron phase symbol.
"""
function _convert_phase(phase::String)
    phase_lower = lowercase(phase)
    if phase_lower == "liquid" || phase_lower == "l"
        return :liquid
    elseif phase_lower == "vapor" || phase_lower == "gas" || phase_lower == "v" || phase_lower == "g"
        return :vapor
    else
        return :unknown
    end
end

"""
    Medium(components; eos=PR, name=nothing)

Alias for `ClapeyronMedium`. Creates a `MaterialSource` from component specifications.

# Example
```julia
medium = Medium([:H2O, :CH4]; eos=PR)
```
"""
const Medium = ClapeyronMedium

# Re-export common EOS types for convenience
export PR, SRK, RK, PCSAFT, CPA, vdW
