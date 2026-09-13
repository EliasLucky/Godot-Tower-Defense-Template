# Turret Classes Structure

You can see turret examples in directory `./scripts/turrets/resources/`.

## Overview

Each turret class (`ProjectileTurret`, `RayTurret`, etc.) extends from `Turret` class. Scene `./scripts/turrets/turret.tscn` is a base class which all other turret scenes have to inherit.

`Turret` class in order to shoot relies on the signal `timeout` of the timer `cooldown_timer`. This signal calls function `attack()` which then calls `attack_inherited()`.

`attack_inherited()` is a function that can be "overriden". Other turret classes (that have `extends Turret`) can have their own logic on how they shoot by using this function.

## How to create new turret scene

1. Go to directory `./scripts/turrets/`.
2. Click Right Mouse Button on one of the scenes: `projectile_turret.tscn`, `ray_turret.tscn`, `turret.tscn`.
3. Choose "New Inherited Scene".
4. Save your new created turret scene into `./scripts/turrets/resources/`
5. Change properties as you wish in Inspector menu

## How to create new turret class

1. Go to directory `./scripts/turrets/`.
2. Create new script (e.g. `new_turret.gd`)
3. Copy contents of `projectile_turret.gd` and paste them into your newly created script.
4. Change the logic of how your turret will show in `attack_inherited()` function.

## How to create new turret scene for new turret class

1. Go to directory `./scripts/turrets/`.
2. Click Right Mouse Button on the scene `turret.tscn`
3. Choose "New Inherited Scene".
4. Attach to the root of the scene your turret script (e.g. `new_turret.gd`)
5. Save your new created turret scene into `./scripts/turrets/resources/`
