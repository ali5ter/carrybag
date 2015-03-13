# CarryBag library functions for the alcatraz package manager

_cblib_alcatraz=1

install_alcatraz () {

    curl -fsSL https://raw.github.com/supermarin/Alcatraz/master/Scripts/install.sh | sh
    return 0
}

uninstall_alcatrax () {

    rm -rf ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins/Alcatraz.xcplugin
    rm -rf ~/Library/Application\ Support/Alcatraz
    return 0
}

build_carrybag_alcatraz_config () {

    install_alcatraz

    ## Plugins installed through the Alcatraz GUI
    ##  KSImageNamed - autocomplete and preview of imageNamed: calls
    ##  Lin - completion for NSLocalizedString
    ##  OMColorSense -  preview color for UIColor and NSColor objects
    ##  SCXcodeSwitchExpander - autocompletion of swith for a given enum
    ##  VVVDocumenter-Xcode - apply Javadoc
    ##  XAlign - code alignment
    ##  XVim - for vim key bindings

    ## Color schemes installed through the Alcatraz GUI
    ##  Solarized Dark
    ##  Solarized Light

    ## Templates intalled throught the Alcatraz GUI
    ##  Swift Templates

    return 0
}
