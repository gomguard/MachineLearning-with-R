#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(dplyr)
library(tidyr)
library(DBI)
library(RMySQL)
library(shiny)
library(stringr)


con <- dbConnect(MySQL(), 
                 user=getOption("database_userid"), 
                 password=getOption("database_password"), 
                 host=getOption("database.address"), 
                 port=3306,
                 dbname="lch_2019", 
                 client.flag=CLIENT_MULTI_RESULTS)

dbGetQuery(con,"set names utf8") 

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Time Table"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = 'week_selector', label = 'Select Week', choices = 1:8, selected = 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("table_output")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  wk_slt <- reactive(input$week_selector)
  
  
  timetable <- reactivePoll(5000, session,
                            checkFunc = function(){
                              dbGetQuery(con, 'select * from reserve_essay;') %>% 
                                select(id) %>% 
                                filter(id == "") %>% 
                                nrow()
                            },
                            valueFunc = function(){dbGetQuery(con, 'select * from reserve_essay;')}
  )
  
  userdb <- reactivePoll(5000, session,
                         checkFunc = function(){
                           dbGetQuery(con, 'select * from userdb;') %>% 
                             nrow()
                         },
                         valueFunc = function(){dbGetQuery(con, 'select * from userdb;')})
  
  
  timetable_spread <- reactive(timetable() %>% 
                                 left_join(userdb() %>% select(id, name), by = 'id') %>% 
                                 mutate(id_name = str_c(id, ' - ', name)) %>% 
                                 filter(week == wk_slt()) %>% 
                                 select(time, id_name, date) %>% 
                                 spread(key = date, value = id_name))
  
  
  
  output$table_output <- renderTable(expr = timetable_spread())
}

# Run the application 
shinyApp(ui = ui, server = server)