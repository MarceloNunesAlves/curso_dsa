# Estudo de Caso 2 - Machine Learning com LDA e Modelagem de Tópicos Para Classificação de Texto

# Acompanhe as aulas no Capítulo 11 do Curso com os detalhes do Estudo de Caso.

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap11/RegressaoLogistica")

# Pacotes (caso algum pacote não esteja instalado, instale!)
library(tm)
library(dplyr)
library(plyr)
library(ldatuning)
library(stringr)
library(topicmodels)
library(stringi)
library(NLP)
library(tibble)
library(tidytext)
library(tsne)
library(shiny)
library(shinyjs)
library(LDAvis)

# Criando a função da interface do dashboard
ui <- shinyUI(fluidPage(useShinyjs(), titlePanel("Classificação de Texto com LDA"),
    
    # Layout da barra lateral
    sidebarLayout(

      # Painel lateral
      sidebarPanel(width = 2,
        
        # Layout do painel de input
        selectInput("nTerms", "Topics:", selected = "5", c("2" = "2", "5" = "5", "10" = "10", "20" = "20", "50" = "50")),
        
        # Input para selecionar o arquivo de entrada
        fileInput("file1", "Arquivo de Entrada:", multiple = FALSE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
        
        # Botão de download
        downloadButton(outputId = "downloadHTML", label = "Download"),
        
        # Input para checkbox se o arquivo tem header
        checkboxInput("header", "Header", TRUE),
        
        # Input para selecionar o separador de colunas do arquivo
        radioButtons("sep", "Separador", choices = c(Vírgula = ",", PontoVírgula = ";", Tab = "\t"), selected = ","),
        
        # Input para selecionar aspas o texto
        radioButtons("quote", "Aspas", choices = c(Nenhum = "", "Aspas Duplas" = '"', "Aspas Simples" = "'"), selected = '"')
      ),
      
      # Painel principal para mostrar os outputs
      mainPanel(
        
        # Output
        visOutput('myDash')
        
      )
    )
  )
)

# Construindo a aplicação
server <- shinyServer(function(input, output, session) {
  
  # Ativa string JSON
  ldaJsonString <- reactiveVal(value = "")
  
  # Ativa o Shiny JS
  shinyjs::disable(id = "downloadHTML")
  
  # Cria o output (o dashboard)
  output$myDash <- renderVis({

    print("Executando a Função")
    shinyjs::disable(id="downloadHTML")
    
    req(input$file1)

    withProgress(message = "Calculando Tópicos...", expr = {
        
      # Bloco de tratamento de erro
      tryCatch(
      {
        
          # Carrega o arquivo e converte as variáveis
          text = read.csv(input$file1$datapath, header = input$header, sep = input$sep, quote = input$quote)
          textdf <- data.frame(text)
          df <- textdf[1]
          textBody2 <- sapply(df, as.character)
          incProgress(amount = 0.1)
          
          print(sprintf("Leitura do Arquivo CSV %s", input$file1$datapath))
  
          # Processamento de Linguagem Natural
          
          # Remove linhas em branco
          textBody2 <- textBody2[!textBody2 %in% ""] %>%
            
            # Converte para 'ASCII'
            iconv('UTF-8', 'ASCII') %>% 
            
            # Remove dígitos
            removeNumbers() %>% 
            
            # Remove pontuações (mantendo as contrações)
            removePunctuation(preserve_intra_word_contractions = TRUE, preserve_intra_word_dashes = FALSE) 
          
          # Barra de progresso do processamento
          incProgress(amount = 0.1)
          
          # Substitui os caracteres de controle por espaço
          textBody2 <- gsub("[[:cntrl:]]", " ", textBody2)  
          
          # Remove os espaços em branco no início dos documentos
          textBody2 <- gsub("^[[:space:]]+", "", textBody2) 
          
          # Remove os espaços em branco no final dos documentos
          textBody2 <- gsub("[[:space:]]+$", "", textBody2) %>% 
            tolower() 
          
          # Remove a contra-barra
          textBody2 <- gsub("\\\\", "", textBody2) 
          
          # Barra de progresso do processamento
          incProgress(amount = 0.1)
          
          # Lista de stop words
          stop_words = stopwords(kind = "en")
          
          # Remove stopwords e hashtags
          for (i in 1:length(textBody2)){
            
            # Remove stopwords
            textBody2[i] <- removeWords(textBody2[i], stop_words)
            
              # Remove hashtags do início das palavras
              textBody2[i] <- gsub("\\btag", "", textBody2[i]) %>%  
                
                # Remove pontuação
                str_replace_all("[[:punct:]]", " ") %>%  
                
                # Stemming
                stemDocument(language = "english") 
          }
          
          # Remove os espaços em branco no início dos documentos
          textBody2 <- gsub("^[[:space:]]+", "", textBody2) 
          
          # Remove os espaços em branco no final dos documentos
          textBody2 <- gsub("[[:space:]]+$", "", textBody2)             
          
          # Cria o corpus
          textBody2.corpus = VCorpus(VectorSource(textBody2)) 
          
          # Cria a matriz document-term
          textBody2.dtm = DocumentTermMatrix(textBody2.corpus) 
          
          # Barra de progresso do processamento
          incProgress(amount = 0.1)
          
          # Criando o tokenizador
          BigramTokenizer <- function(x)
          unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
          
          # Criando a matriz document-term
          textBody2.dtm2 <- DocumentTermMatrix(textBody2.corpus, control = list(tokenize = BigramTokenizer))
          textBody2.uniBiDtm = cbind(textBody2.dtm,textBody2.dtm2)
          
          # Se algum documento tiver total igual a zero, removemos
          uniq <- unique(textBody2.uniBiDtm$i)
          textBody2.dtmNew <- textBody2.uniBiDtm[uniq,]
  
          # Corpus para usar com LDA
          corpusNew <- textBody2.corpus$content[uniq]
          
          # Barra de progresso do processamento
          incProgress(amount = 0.1)
          
          # Cria o Modelo LDA
          modelo_lda <- LDA(textBody2.dtmNew, as.numeric(input$nTerms), method = "Gibbs", control = list(seed = 7, iter = 100, alpha = 0.02))
  
          # Barra de progresso do processamento
          incProgress(amount = 0.1)
          
          print("Tópicos Encontrados")
          createdTopics = TRUE
          
        },
        error = function(e) {
          
          # Retorna o erro, caso ocorra
          stop(safeError(e))
        }
      )
      
      # Cria a lista de tópicos a partir de modelo_lda
      if(createdTopics){
        
        # Limites dos tópicos
        phi <- posterior(modelo_lda)$terms %>% as.matrix
        theta <- posterior(modelo_lda)$topics %>% as.matrix
        vocab <- colnames(phi)
        doc_length <- vector()
        
        # Processamento do corpus
        for (i in 1:length(corpusNew)) {
          temp <- paste(corpusNew[[i]], collapse = ' ')
          doc_length <- c(doc_length, stri_count(temp, regex = '\\S+'))
        }

        # Barra de progresso do processamento
        incProgress(amount = 0.1)
        
        # Matriz de frequência
        freq_matrix <- tidy(textBody2.dtmNew)
        term_frequency <- aggregate(freq_matrix$value, by=list(freq_matrix$column), FUN=sum)
        svd_tsne <- function(x) {
          
          # Não causará erro, o número de tópicos é 2
          tsne(svd(x)$u)
        }
        print("Criando JSON")

        # Barra de progresso do processamento
        incProgress(amount = 0.1)
        
        # Cria o documento JSON para o plot no Dashboard
        json <- createJSON(phi = phi, theta = theta, vocab = vocab, doc.length = doc_length, term.frequency = term_frequency$x, mds.method = svd_tsne)
        
        # Barra de progresso do processamento
        incProgress(amount = 0.1)
        
        # Conclui a criação do Dashboard
        shinyjs::enable(id="downloadHTML")
        
        ldaJsonString(json)
        
        return(json)
        
      }
    })
  })
  
  # Plot do Dashboard
  output$downloadHTML <- downloadHandler(
    filename = function() {
      paste("lda-visualisation", input$nTerms, ".html", sep = "")
    },
    content = function(file) {
      
      htmlTemplate <- "
      <link rel='stylesheet' type='text/css' href='https://cdn.rawgit.com/bmabey/pyLDAvis/files/ldavis.v1.0.0.css'>

      <div id='ldavis_el1242829485730617925476252464'></div>
      
      <script type='text/javascript'>
      
      var ldavis_el1242829485730617925476252464_data = %s

      function LDAvis_load_lib(url, callback){
        var s = document.createElement('script');
        s.src = url;
        s.async = true;
        s.onreadystatechange = s.onload = callback;
        s.onerror = function(){console.warn('failed to load library ' + url);};
        document.getElementsByTagName('head')[0].appendChild(s);
      }
      
      if(typeof(LDAvis) !== 'undefined'){
        !function(LDAvis){
          new LDAvis('#' + 'ldavis_el1242829485730617925476252464', ldavis_el1242829485730617925476252464_data);
        }(LDAvis);
      }else if(typeof define === 'function' && define.amd){
        require.config({paths: {d3: 'https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.5/d3.min'}});
        require(['d3'], function(d3){
          window.d3 = d3;
          LDAvis_load_lib('https://cdn.rawgit.com/bmabey/pyLDAvis/files/ldavis.v1.0.0.js', function(){
            new LDAvis('#' + 'ldavis_el1242829485730617925476252464', ldavis_el1242829485730617925476252464_data);
          });
        });
      }else{
        LDAvis_load_lib('https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.5/d3.min.js', function(){
          LDAvis_load_lib('https://cdn.rawgit.com/bmabey/pyLDAvis/files/ldavis.v1.0.0.js', function(){
            new LDAvis('#' + 'ldavis_el1242829485730617925476252464', ldavis_el1242829485730617925476252464_data);
          })
        });
      }
      </script>
      "
      
      writeLines(sprintf(htmlTemplate, ldaJsonString()), file)
    }
  )
})

# Executa a app
shinyApp(ui = ui, server = server)

