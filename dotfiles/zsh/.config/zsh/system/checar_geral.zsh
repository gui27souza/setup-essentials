# ZSH_DESC - Mostra updates pendentes, sincroniza pacotes e roda testes de integridade do sistema

# Mostra no terminal quantos updates estão esperando (sem baixar nem atualizar),
# sincroniza a lista de pacotes instalados e valida as configs/módulos do repositório.

checar_geral() {

    with_separator check_updates
    with_separator sync_pkglist
    with_separator quality_gate
    with_separator check_kde_status
    with_separator check_dotfiles_status

    with_separator log_success "✨ Checagem geral concluída com sucesso!"

    echo
}
