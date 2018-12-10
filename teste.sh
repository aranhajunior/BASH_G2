#!/bin/bash
#
# script do trabalho 1, Desenvolver um Shell Script com exemplo de case e manipulação de dados -  G1 Bash
# Autores: Alessandro Aranha,  Marco Antonio Barbosa
# Versão 1: 24/09/2018
# Versão 2: 01/10/2018
# Inicio  do Case
menu(){
    clear

    # Mostra informações de menu para operações do usuario, não é variagel, somente texto.
    echo "Digite 1 - Instalar o servidor de SSH(SSHd)"
    echo "Digite 2 - Remover o SSHd"
    echo "Digite 3 - Realizar uma cópia de segurança do arquivo '/ete/ssh/sshd_config'"
    echo "Digite 4 - Trocar a porta do SSHd para porta definida."
    echo "Digite 5 - Retornar a porta padrão do SSHd"
    echo "Digite 6 - Conectar a uma máquina remota (ssh) definida."
    echo "Digite 7 - Sair"

    read opcao

    # Parte do case que vincula o numero com o nome do segmento de funções.
    case "$opcao" in
    	1) 	instalar ;;

    	2) 	remover ;;

	3) 	copiarcp  ;;

	4) 	trocarporta  ;;

	5) 	portapadrao  ;;

	6) 	conectarremot  ;;

        7)
    	    clear
            sair
        ;;
    
    	*)
    	    clear
    	    op_inv
    	;;
    esac
}

instalar(){
    clear
    echo "  ---  Instalar  ---  "
    sudo apt install openssh-server
    read pause
    menu
}

remover(){
    clear
   echo "  ---  Remover  ---  "
   sudo apt remove openssh-server -y
    read pause
    menu
}

copiarcp  (){
    clear
    echo "  ---  Copiar cp  ---  "
    # copiando arquivo para pasta tmp como backup
    cp /etc/ssh/sshd_config /tmp/sshd_config.bkp
    # exibe o arquivo da pasta tmp como bk
    ls /tmp/*.bkp
    echo "  ---  Copia concluida  ---  "
    read pause

    menu
}

trocarporta (){
    clear
    echo "  ---   Trocar porta   ---  "
     
    porta_atual=`cat /etc/ssh/sshd_config | grep 'Port ' | awk '{print $2}'`    

    echo "A porta atual do SSHd é $porta_atual"     #imprime na tela a porta atual do sshd
    echo "Digite a nova porta do servidor de SSH"
    read porta_nova	

    teste_hashtag=`cat /etc/ssh/sshd_config | grep '#Port *' | awk '{print $1}'`
    if [ "$teste_hashtag" = "#Port" ] ; then
      sudo sed -i "s/#Port 22/Port $porta_nova/" /etc/ssh/sshd_config
    else
      sudo sed -i "s/Port $porta_atual/Port $porta_nova/" /etc/ssh/sshd_config
    fi

 
    porta_confirmacao=`cat /etc/ssh/sshd_config | grep 'Port ' | awk '{print $2}'`
    echo "Alterado porta do SSHd para $porta_confirmacao"
 
   read pause
   clear

    sudo systemctl restart sshd			            #reinicia o serviço do sshd

    read pause
    menu
}


portapadrao (){
    clear
   echo "  ---  Porta Padrão  ---  "

    porta_atual=`cat /etc/ssh/sshd_config | grep 'Port ' | awk '{print $2}'`    
    echo "A porta atual do SSHd é $porta_atual"     #imprime na tela a porta atual do sshd
    porta_nova='22'

    if [ "$teste_hashtag" = "#Port" ] ; then
    # arquivo com a linha da porta comentada e com a porta 22

    # a linha abaixo realiza a troca da porta do sshd, utilizando o comando sed
    # repare que são utilizadas as variáveis $porta_atual e $porta_nova
    # esta linha necessita do sudo
       sudo sed -i "s/#Port 22/Port $porta_nova/" /etc/ssh/sshd_config
   else
       # linha da porta não comentada, pode ser porta 22 ou não
       sudo sed -i "s/Port $porta_atual/Port $porta_nova/" /etc/ssh/sshd_config
   fi


   porta_confirmacao=`cat /etc/ssh/sshd_config | grep 'Port ' | awk '{print $2}'`
   echo "Alterado porta do SSHd para $porta_confirmacao"

   read pause
   clear

    sudo systemctl restart sshd			            #reinicia o serviço do sshd

    read pause
    menu
}


conectarremot(){
    clear
   echo "  ---  Reiniciar  ---  "
    echo " Digite um enderepo IP para conectar remoto:  "
    read ipescolhido

    # coloca o endereco para sessão remota
    ssh aluno@$ipescolhido
    read pause
    menu
}


sair(){
    echo "Sair"
    read pause
    clear
}

op_inv(){
    echo "Opcao invalida, retornando ao menu principal"
    read pause
    menu
}

menu