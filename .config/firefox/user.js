// Restore the previous session instead of opening about:home. Firefox blocks
// extension content scripts on about: pages, so Vimium is dead on the start
// page; real tabs bring the keybindings back.
user_pref("browser.startup.page", 3);

// Default page text uses Plex Sans; websites may still choose their own fonts.
user_pref("font.default.x-western", "sans-serif");
user_pref("font.name.sans-serif.x-western", "IBM Plex Sans");
