# Fluid Infrastructure Benchmark

This benchmark summarizes the fluid infrastructure tiers that define pipeline layout, transport scale, and environment specialization.

Assumptions:

- Pipeline extent is the maximum spatial extent of one connected fluid segment before pumps split the network.
- Underground distance is the configured maximum underground pipe connection distance.
- Pump speed is prototype `pumping_speed`, expressed as fluid per tick and approximate fluid per second.
- Pump speed is listed before quality modifiers.
- Regular surface tiers are for non-space, non-Vulcanus surfaces.
- Low-pressure steel is the space-platform steel-equivalent branch.
- Heat-resistant and tungsten are the Vulcanus branch.
- Foundation is the final convergence tier and is available in all environments.
- High-pressure foundation pumping is a pump-only post-foundation compression tier; it does not add new pipes or increase pipeline extent.
- Production-machine and power-building fluidboxes are patched separately; this table describes the pipe and pump infrastructure tiers.

| Fluid Support | Branch | Environment | Pipeline Extent | Underground Distance | Pump Speed | Relative Pump Speed | Primary Role |
|---|---|---|---:|---:|---:|---:|---|
| Iron | starter | regular surfaces | `24` | `4` | `1/tick`, `60/s` | `1x` | compact early steam and short local fluid runs |
| Steel | surface | regular surfaces | `64` | `8` | `4/tick`, `240/s` | `4x` | normal factory-block plumbing and early upgraded power |
| Rubber-lined | surface | regular surfaces | `96` | `12` | `6/tick`, `360/s` | `6x` | late novice surface blocks with lubricant/plastic complexity |
| Heat-resistant | Vulcanus | Vulcanus only | `24` | `4` | `1/tick`, `60/s` | `1x` | initial lava/sulfuric-acid survival infrastructure |
| Tungsten | Vulcanus | Vulcanus only | `64` | `8` | `4/tick`, `240/s` | `4x` | steel-equivalent Vulcanus fluid infrastructure |
| Low-pressure steel | space | space platforms only | `64` | `8` | `4/tick`, `240/s` | `4x` | steel-equivalent platform fluid routing |
| Reinforced | convergence | regular surfaces and Vulcanus path | `192` | `12` | `10/tick`, `600/s` | `10x` | hardened cross-planet trunk infrastructure |
| Foundation | final convergence | all environments | `512` | `20` | `20/tick`, `1200/s` | `20x` | final long-distance and high-throughput trunk infrastructure |
| High-pressure Foundation | postgame pumping | all environments | `512` | n/a | `60/tick`, `3600/s` | `60x` | promethium-driven backbone compression nodes |

## Environment Branches

| Branch | Entry Point | Progression | Notes |
|---|---|---|---|
| Regular surface | Iron | Iron -> Steel -> Rubber-lined -> Reinforced -> Foundation | Main Nauvis and non-specialized surface path. Steel and rubber-lined remain the expected scale for local factory blocks. |
| Vulcanus | Heat-resistant | Heat-resistant -> Tungsten -> Reinforced -> Foundation | Starts constrained so lava handling does not immediately inherit general-purpose surface infrastructure. |
| Space platform | Low-pressure steel | Low-pressure steel -> Foundation | Space fluid infrastructure starts at steel-equivalent stats and only converges at foundation tier. |
| Postgame pump compression | Foundation | Foundation -> High-pressure Foundation Pumping | Pump-only promethium extension for very large backbone networks. Foundation pipes remain the matching pipe tier. |

## Layout Reading

- `24` extent forces compact early builds and keeps shoreline steam placement meaningful.
- `64` extent is the baseline for ordinary local blocks and steel-equivalent specialized branches.
- `96` extent gives rubber-lined blocks more room without becoming long-range transport.
- `192` extent marks reinforced as the first real trunk tier.
- `512` extent makes foundation clearly beyond vanilla `320` while preserving a finite segment-size constraint.
- High-pressure foundation pumps keep the `512` foundation extent and only increase pump throughput.
- Pumps split fluid segments, so each side is checked independently against its lowest connected fluidbox extent.
