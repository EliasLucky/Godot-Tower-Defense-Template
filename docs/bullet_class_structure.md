# Bullet Class Structure

`Bullet` class is responsible for all the things that are related to projectiles.

Rou can be easily customized through `RoundSettings` resources.

## How to create new bullet scene

1. Go to directory `./scripts/turrets/bullet/`
2. Click Right Mouse Button on scene `bullet.tscn`
3. Choose "New Inherited Scene"
4. Save your new created bullet scene into `./scripts/turrets/bullet/resources/`
5. Change properties as you wish in Inspector menu

## Bullet Settings

Do NOT change bullet settings directly from `bullet.gd`. Settings such as `speed`, `damage` and `pierce` are overwritten by `ProjectileTurret`.

If you want to change these properties then go to the turret and change these properties in there.

Additionally, you can create custom turret class and apply custom logic on your bullets.

- `speed` (float) The speed of bulet
- `damage` (float) Damage that will be given to the enemy to which the bullet has reached
- `pierce` (int) How many times bullet can apply damage to the enemy
- `time` (float) Time after which bullet will `queue_free()`. It was made so if bullet did not reach an enemy and actually flew out of the map then delete it.

