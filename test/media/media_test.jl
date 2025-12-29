using ProcessSimulator
using Test

@testset "Media Module Tests" begin
    @testset "Pure Component Registry" begin
        # Test that registry has components
        components = list_available_components()
        @test length(components) > 50

        # Test common component lookups
        @test get_clapeyron_name(:H2O) == "water"
        @test get_clapeyron_name(:water) == "water"
        @test get_clapeyron_name(:CH4) == "methane"
        @test get_clapeyron_name(:methane) == "methane"
        @test get_clapeyron_name(:CO2) == "carbon dioxide"
        @test get_clapeyron_name(:N2) == "nitrogen"
        @test get_clapeyron_name(:O2) == "oxygen"
        @test get_clapeyron_name(:H2) == "hydrogen"

        # Test passthrough for strings
        @test get_clapeyron_name("water") == "water"
        @test get_clapeyron_name("methane") == "methane"

        # Test batch conversion
        names = get_clapeyron_names([:H2O, :CH4, :CO2])
        @test names == ["water", "methane", "carbon dioxide"]

        # Test search functionality
        meth_results = search_components("meth")
        @test :methane in meth_results
        @test :methanol in meth_results
        @test length(meth_results) >= 2

        # Test error for unknown component
        @test_throws ErrorException get_clapeyron_name(:unknown_component_xyz)
    end

    @testset "ClapeyronMedium Creation" begin
        # Test with symbol components
        medium1 = ClapeyronMedium([:H2O, :CH4])
        @test medium1.N_c == 2
        @test "water" in medium1.components
        @test "methane" in medium1.components
        @test length(medium1.Mw) == 2

        # Test with string components
        medium2 = ClapeyronMedium(["water", "ethane", "propane"])
        @test medium2.N_c == 3
        @test medium2.name == "water_ethane_propane"

        # Test with custom name
        medium3 = ClapeyronMedium([:CH4, :C2H6]; name="LightGas")
        @test medium3.name == "LightGas"

        # Test with different EOS
        medium_pr = ClapeyronMedium(["methane"]; eos=PR)
        medium_srk = ClapeyronMedium(["methane"]; eos=SRK)
        @test medium_pr.N_c == 1
        @test medium_srk.N_c == 1
    end

    @testset "Predefined Mixtures" begin
        # Natural gas mixture
        ng = NaturalGasMixture()
        @test ng.N_c >= 6
        @test "methane" in ng.components
        @test "ethane" in ng.components
        @test "carbon dioxide" in ng.components

        # Natural gas with trace components
        ng_trace = NaturalGasMixture(include_trace=true)
        @test ng_trace.N_c > ng.N_c

        # Air mixture
        air = AirMixture()
        @test "nitrogen" in air.components
        @test "oxygen" in air.components
        @test "argon" in air.components

        # Syngas mixture
        syngas = SyngasMixture()
        @test "hydrogen" in syngas.components
        @test "carbon monoxide" in syngas.components

        # LPG mixture
        lpg = LPGMixture()
        @test "propane" in lpg.components
        @test "butane" in lpg.components

        # Pure components
        water = PureWater()
        @test water.N_c == 1
        @test "water" in water.components

        methane = PureMethane()
        @test methane.N_c == 1
        @test "methane" in methane.components

        # BTX mixture
        btx = BTXMixture()
        @test "benzene" in btx.components
        @test "toluene" in btx.components

        # Steam reforming
        sr = SteamReformingMixture()
        @test "water" in sr.components
        @test "hydrogen" in sr.components

        # Ammonia process
        nh3 = AmmoniaProcessMixture()
        @test "ammonia" in nh3.components
        @test "nitrogen" in nh3.components
    end

    @testset "Thermodynamic Properties" begin
        medium = PureWater()
        T = 373.15  # 100°C
        p = 101325.0  # 1 atm
        x = [1.0]

        # Test molar density
        ρ = medium.molar_density(p, T, x)
        @test ρ > 0
        @test ρ < 100000  # Reasonable range for steam

        # Test enthalpy
        h = medium.VT_enthalpy(ρ, T, x)
        @test isfinite(h)

        # Test entropy
        s = medium.VT_entropy(ρ, T, x)
        @test isfinite(s)

        # Test internal energy
        u = medium.VT_internal_energy(ρ, T, x)
        @test isfinite(u)

        # Test pressure calculation (round-trip)
        p_calc = medium.pressure(ρ, T, x)
        @test isapprox(p_calc, p, rtol=1e-3)

        # Test with mixture
        ng = NaturalGasMixture()
        z = [0.9, 0.05, 0.02, 0.01, 0.01, 0.01]  # Typical natural gas
        ρ_ng = ng.molar_density(p, 300.0, z)
        @test ρ_ng > 0
    end

    @testset "Medium Alias" begin
        # Test that Medium is an alias for ClapeyronMedium
        medium = Medium([:H2O, :CH4])
        @test medium.N_c == 2
        @test medium isa MaterialSource
    end
end
