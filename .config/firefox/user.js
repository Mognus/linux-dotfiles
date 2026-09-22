// Restore the previous session instead of opening about:home. Firefox blocks
// extension content scripts on about: pages, so Vimium is dead on the start
// page; real tabs bring the keybindings back.
user_pref("browser.startup.page", 3);
