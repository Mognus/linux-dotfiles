# LibreWolf customizations

Both machines use one profile at `~/.config/librewolf/librewolf/default/`.
Home Manager links three files from this repository:

- `librewolf/profiles.ini` selects the stable `default` profile directory.
- `librewolf/librewolf.overrides.cfg` enables loading `chrome/userChrome.css`.
- `librewolf/chrome/userChrome.css` customizes the browser UI.

Browser data stays in the local profile directory, outside Git. No activation
script is needed. Fully restart LibreWolf after changing the CSS.

This deliberately manages a single profile. Adding profiles through LibreWolf's
profile manager can change the shared `profiles.ini`; keep per-machine profile
names and browser data out of the repository.
