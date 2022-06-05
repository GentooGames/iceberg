# iceberg
foundational gamemaker project for all other games to be spun off of so that base functionality does not have to be re-implemented constantly.

# version
0.0.0 (in-progress)

# design goals
- integrate PubSub design pattern into core game systems using xdstudio's xpublisher
- encapsulated setup() and teardown() entity methods, allowing for more complex inheritance trees with pseudo-"super()" functionality
- easy to read, understand, and manage global_data_files
- globalized system structs containing extended gamemaker functionality, without the need to implement through an excessive amount of controller objects. such as:
  - audio control
  - iota clocks control
  - debug control
  - display control
  - publisher events control
  - gui control
  - input handling
  - particles
  - room transitions
  - unit_tests
  - window control

# assets
paid assets will not be included, and are automatically excluded from this repositroy through the .gitignore file
iceberg is built with these assets in mind, and in order for it to work properly, these assets must be included.

paid assets excluded from this repository through the .gitignore file are:
- YAL's gmlive (https://yellowafterlife.itch.io/gamemaker-live)
- YAL's native cursors (https://yellowafterlife.itch.io/gamemaker-native-cursors)
- YAL's window freeze fix (https://yellowafterlife.itch.io/window-freeze-fix)

open source/free assets included in this repository are:
- sahaun's snowstate (https://github.com/sohomsahaun/SnowState)
- xdstudio's xpublisher (https://xdstudios.itch.io/xpublisher)
- juju's iota (https://github.com/JujuAdams/iota)
- bfrymire's crispy (https://github.com/bfrymire/crispy)

custom systems written by __gentoo__ and included in this repository are:
- gentui (https://github.com/GentooGames/gentui)
- orderly (https://github.com/GentooGames/orderly)
- weestate (https://github.com/GentooGames/weestate)
- gstat (https://github.com/GentooGames/gstat)

please support these awesome developers financially with donations when possible.
