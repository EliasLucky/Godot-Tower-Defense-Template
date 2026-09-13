# TurretUpgrade Class Structure

`TurretUpgrade` class is a resource responsible for the data of the turret upgrades.

It is required for `Turret` to have `upgrade_data`

## How to create new TurretUpgrade `.tres` resource

1. Go to directory `./scripts/turrets/upgrades/`
2. Click Right Mouse Button on folder `./resources`
3. Choose Create new Resource
4. Choose TurretUpgrade resource
5. Change properties as you wish in Inspector menu

## Turret Upgrade Settings

- `turret_level_texture` (Array[Texture2D]) Turret texture based on its level. `turret_level_texture[current_level]`
- `turret_head_level_texture` (float) Turret head texture based on its level. `turret_head_level_texture[current_level]`
- `attack_speed` (float) By how much attack_speed of the turret will be upgraded
- `attack_speed_multiplies` (bool) Either or not `attack_speed` will be multiplied by when upgrading. `turret.attack_speed * turret.upgrade_data.attack_speed`
- `attack_range` (float) By how much attack_range of the turret will be upgraded
- `attack_range_multiplies` (bool) Either or not `attack_range` will be multiplied by when upgrading.
- `damage` (float) By how much damage of the turret will be upgraded.
- `damage_multiplies` (bool) Either or not `damage` will be multiplied by when upgrading.
- `max_level` (int) Max level that the turret can reach
- `upgrade_cost` (int) Cost of each new upgrade

