-- qmlls ships with Qt (qt6.qtdeclarative). Quickshell writes the import paths into
-- .qmlls.ini next to shell.qml, so the folder holding it is the root, not the git root.
return {
    cmd = { "qmlls" },
    filetypes = { "qml" },
    root_markers = { ".qmlls.ini", ".git" },
}
