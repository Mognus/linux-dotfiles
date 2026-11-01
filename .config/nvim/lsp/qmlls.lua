-- Prefer a project's QML import configuration over the surrounding Git root.
return {
    cmd = { "qmlls" },
    filetypes = { "qml" },
    root_markers = { ".qmlls.ini", ".git" },
}
