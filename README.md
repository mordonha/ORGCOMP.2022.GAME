# Blackout ICMC

[**Jogo**](./Blackout.asm) desenvolvido em assembly para disciplina do professor Eduardo do Valle Simões  
SSC0511 - Organização de Computadores Digitais - 2021


<details>
  <summary>O jogo</summary>
  
  ## Jogo
  <p align="center">
    <img src="Imgs/Start.png" />
    <img src="Imgs/Map.png" />
    <img src="Imgs/GameOver.png" />
    <img src="Imgs/Win.png" />
    
  </p>
</details>



## Como jogar:
- [Vídeo explicativo](https://youtu.be/9rImgjGsC_k)
- Exibe-se o mapa por alguns segundos
- Apaga-se o mapa, e o mesmo continua a piscar em ciclos de alguns segundos
- Os ciclos variam de acordo com a movimentação do personagem
- Ficando parado, a tela irá piscar novamente mais rápido
- Se movimentando, a tela demorará mais para piscar
- O usuário pode andar pelo mapa através das tecla w, a, s, d
- Ganha-se ao chegar no ponto verde

---

# Store imediato

Nova [**instrução**](TestaStoren.asm) desenvolvida para o [processador](https://github.com/simoesusp/Processador-ICMC) do ICMC  
Formato: `Storen Rx, #0`  
Como funciona: `Indexa a memória com o registrador armazenando o segundo paramêtro como número (valor após #)`

<details>
  <summary>Exemplos</summary>
  
   `Storen R0, #45`  :: Mem[R0] <- 45  
   `Storen R0, #'a'`  :: Mem[R0] <- código da letra na tab asc2
  
  
</details>
 
 ---  

# Dependências para Windows:
## Instalar C++ (se precisar gerar um novo executável do simulador)
- Baixe as [bibliotecas do C++](https://github.com/brechtsanders/winlibs_mingw/releases/download/11.2.0-13.0.0-9.0.0-ucrt-r2/winlibs-i686-posix-dwarf-gcc-11.2.0-mingw-w64ucrt-9.0.0-r2.zip) 
- Deszip  
- Adicione no path das variáveis de ambiente o caminho até a pasta bin  

## Instalar Sublime configurado (contem simulador.exe e montador.exe)
- Baixe o [sublime configurado](sublime_com_montador_simulador.zip) 
- Deszip  

## Executar o código (pré requisito: instalar o sublime configurado)
- Execute ./Sublime Text 3/sublime_text.exe
- Abra o arquivo *.asm que deseja executar
- Pressione F7 (monta o codigo em binario e simula o processador) 
- Pressione Home para iniciar  
   
--- 

# Integrantes:
 > Jansen Caik Ferreira Freitas  
 > Leonardo Minoru Iwashima    
 > Paulo Marcos Ordonha    
