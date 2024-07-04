#!/bin/bash

FUNCAO_ORIGEM_DESTINO() {
    # Função para solicitar a origem e o destino do backup
    echo "Digite a origem dos arquivos a serem salvos (caminho absoluto):"
    read -r origem
    echo "Digite o destino para o backup (caminho absoluto):"
    read -r destino1
  # Verifica se os diretórios de origem e destino existem
    if [[ ! -d "$origem" || ! -d "$destino1" ]]; then
        echo "Diretório de origem ou destino inválido."
        return 1
    fi
}

FUNCAO_DESTINO_BACKUP(){
    # Função para solicitar o destino do script de backup
    echo -e "Onde deseja que este backup seja gerado (o script)?"
    echo "Deixe em branco para gerar na pasta atual."
    read -r destino2
    if [[ ! -z $destino2 ]]; then
        localsalvo="$destino2/backup_script.sh"
    else
        localsalvo="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/backup_script.sh"
    fi
}

FUNCAO_BACKUP_RSYNC() {
    # Função para realizar o backup utilizando o comando rsync
    rsync -avh --delete "$origem/" "$destino1/"
    echo "Backup concluído com sucesso!"
}

# Execução do script
echo "Script de Backup de Arquivos"

FUNCAO_ORIGEM_DESTINO

if [[ $? -eq 0 ]]; then
    FUNCAO_DESTINO_BACKUP

    echo "#!/bin/bash" >> "$localsalvo"
    echo >> "$localsalvo"
    echo "rsync -avh --delete \"$origem/\" \"$destino1/\"" >> "$localsalvo"
    chmod +x "$localsalvo"

    FUNCAO_BACKUP_RSYNC

    echo "Script de backup gerado com sucesso em: $localsalvo"
fi
