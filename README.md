# Godot-Tower-Defense-Template

## Overview

Godot Engine Tower Defense template project. Made with scalability in mind.

Towers can easily be customized. Towers can have custom logic without rewriting whole project.

This project uses OOP and Resources for modular hierarchy.
There are currently two turret types (but can easily be added more):
- `projectile_turret.tscn` (Projectile Turret)
- `ray_turret.tscn` (Ray or Laser Turret)

Turrets can give damage effects to enemies by using `.tres` resource `DamageEffect`.

## Quickstart

- Clone the repository
  ```shell
  git clone https://github.com/EliasLucky/Godot-Tower-Defense-Template.git
  ```
- Open in Godot Engine (v4.6.2+)
- Run the Game
- Read [docs](./docs) to add new turrets, bullets and enemies.

## Documentation

Full documentation for this project is available in [./docs](./docs) directory

# Contribution

## Can I contribute?

Yes! If you are a coder feel free to *Fork* the repository and send your amazing Pull Requests!

## How should I contribute?

Godot Engine alerady has clear PEP8 code style guidelines, so it's difficult to add something to it, but there are certain key points to follow when contributing:
- PEP8 code style guidelines should always be followed. In advance check [Godot Engine Documentation](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) for more information.
- Always try to reference issues in commit messages or pull requests ("related to #614", "closes #619" and etc.).
- Avoid huge code commits where the difference can not even be rendered by browser based web apps (Github for example). Smaller commits make it much easier to understand why and how the changes were made, why (if) it results in certain bugs and etc.
- If there's a reason to commit code that is commented out (there usually should be none), always leave a "FIXME" or "TODO" comment so it's clear for other developers why this was done.

# Branches

- `main` - production ready codebase
