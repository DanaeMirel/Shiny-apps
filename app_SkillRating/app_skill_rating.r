#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)



read_full_input = function(input, output){
  return(as.numeric(strsplit(input,"\\s+")[[1]]))
}


# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Skill Rating Simulator"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        strong("Global algorithm parameters"),
        fluidRow(
          column(5, numericInput("beta",  "Beta", 4.5, min=0, step = 0.5)),
          column(5, numericInput("draw_margin",  "Draw Margin", 0.01, min=0.001, step = 0.01))
        ),
        radioButtons("presets", "Presets" ,
         c("Default" = "default",
           "Random" = "random",
           "Uneven variances" = "uneq_var",
           "Expected result" = "expected",
           "Upset" = "upset",
           "Boosters" = "boosters"
           #, "Use updated values" = "updated"
         )),
        strong("Values for team 1"),
         uiOutput("team1"),
        strong("Values for team 2"),
         uiOutput("team2"),
         radioButtons("result", "Match result",
                      c("Team 1 wins"="win",
                        "Team 2 wins"="loss",
                        "Draw"="draw"),
                      inline = T),
         actionButton("run", "Run Update")
      ),
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("plot"),
         tableOutput("table")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$team1 <- renderUI({
    if(input$presets == "default"){
      fluidRow(
        column(5, textAreaInput("mu_1", "Mu values", paste(rep(25, 3), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_1", "Sigma values", paste(round(rep(25/3, 3), 2), collapse="\n"), height='75px'))    
        )
    }
    else if(input$presets == "random"){
      fluidRow(
        column(5, textAreaInput("mu_1", "Mu values", paste(round(rnorm(3, 25, 25/3),2), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_1", "Sigma values", paste(round(rgamma(3, 25/3, 2),2), collapse="\n"), height='75px'))    
      )
    }
    else if(input$presets == "uneq_var"){
      fluidRow(
        column(5, textAreaInput("mu_1", "Mu values", paste(round(rnorm(3, 27, 1), 2), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_1", "Sigma values", paste(round(rgamma(3, 25/3, 2), 2), collapse="\n"), height='75px'))    
      )
    }
    else if(input$presets == "expected"){
      fluidRow(
        column(5, textAreaInput("mu_1", "Mu values", paste(round(rnorm(3, 30, 1), 2), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_1", "Sigma values", paste(round(rgamma(3, 25/3, 2), 2), collapse="\n"), height='75px'))    
      )
    }
    else if(input$presets == "upset"){
      fluidRow(
        column(5, textAreaInput("mu_1", "Mu values", paste(round(rnorm(3, 18, 1), 2), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_1", "Sigma values", paste(round(rgamma(3, 25/3, 2), 2), collapse="\n"), height='75px'))    
      )
    }
    else if(input$presets == "boosters"){
      fluidRow(
        column(5, textAreaInput("mu_1", "Mu values", paste(c(25, rnorm(2, 0, 1)), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_1", "Sigma values", paste(round(c(25/3, 2, 2), 2), collapse="\n"), height='75px'))    
      )
    }  
    else if(input$presets == "boosters"){
      if(exists(post_list)){print("ok")}
    }
  })
  output$team2 <- renderUI({
    if(input$presets == "default"){
      fluidRow(
        column(5, textAreaInput("mu_2", "Mu values", paste(rep(25, 3), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_2", "Sigma values", paste(round(rep(25/3, 3), 2), collapse="\n"), height='75px'))    
      )
    }
    else if(input$presets == "random"){
      fluidRow(
        column(5, textAreaInput("mu_2", "Mu values", paste(round(rnorm(3, 25, 25/3),2), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_2", "Sigma values", paste(round(rgamma(3, 25/3, 2),2), collapse="\n"), height='75px'))    
      )
    }
    else if(input$presets == "uneq_var"){
      fluidRow(
        column(5, textAreaInput("mu_2", "Mu values", paste(round(rnorm(3, 25, 1), 2), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_2", "Sigma values", paste(round(rgamma(3, 25/3, 2), 2), collapse="\n"), height='75px'))    
      )
    }
    else if(input$presets == "expected"){
      fluidRow(
        column(5, textAreaInput("mu_2", "Mu values", paste(round(rnorm(3, 20, 1), 2), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_2", "Sigma values", paste(round(rgamma(3, 25/3, 2), 2), collapse="\n"), height='75px'))    
      )
    }
    else if(input$presets == "upset"){
      fluidRow(
        column(5, textAreaInput("mu_2", "Mu values", paste(round(rnorm(3, 32, 1), 2), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_2", "Sigma values", paste(round(rgamma(3, 25/3, 2), 2), collapse="\n"), height='75px'))    
      )
    }
    else if(input$presets == "boosters"){
      fluidRow(
        column(5, textAreaInput("mu_2", "Mu values", paste(round(rnorm(3, 18, 2), 2), collapse="\n"), height='75px')),
        column(5, textAreaInput("s_2", "Sigma values", paste(round(rgamma(3, 25/3, 2), 2), collapse="\n"), height='75px'))    
      )
    }    
  })  
  # test wrapper
  observeEvent(input$run,{
    match_list = list(mu1=read_full_input(input$mu_1),
                          mu2=read_full_input(input$mu_2),
                          s1=read_full_input(input$s_1),
                          s2=read_full_input(input$s_2))
    if(input$result == "win") rank=c(0,1)
    else if (input$result == "loss") rank=c(1,10)
    else rank=c(0,0)
    out = skill_update(match_list, rank, input$beta, input$draw_margin)
    post_list = out[[1]]
    team_df = out[[2]]
    
    final_df = data.frame(
      Team = c(rep(1, length(post_list$mu1)), rep(2, length(post_list$mu2))),
      Mu_Before = round(c(post_list$mu1, post_list$mu2),2),
      Mu_After = round(c(post_list$mu_after1, post_list$mu_after2),2),
      Mu_Update = round(c(post_list$mu_after1, post_list$mu_after2) - c(post_list$mu1, post_list$mu2),2),
      Sigma_Before = round(c(post_list$s1, post_list$s2),2),
      Sigma_After = round(c(post_list$sigma_after1, post_list$sigma_after2),2),
      Sigma_Update = round(c(post_list$sigma_after1, post_list$sigma_after2) - c(post_list$s1, post_list$s2),2)
    )
    
    vec = seq(-10,60,.1)
    plot_df = data.frame(Skill=rep(vec,2), 
                         Density = c(dnorm(vec, team_df$mu[1]/length(post_list$mu1), sqrt(team_df$s2[1]/length(post_list$mu1))),
                                     dnorm(vec, team_df$mu[2]/length(post_list$mu2), sqrt(team_df$s2[2]/length(post_list$mu2)))),
                         Team= factor(rep(1:2, each=length(vec))))
    
    output$plot = renderPlot({
      ggplot(plot_df, aes(Skill, Density, colour = Team)) + geom_line() +
        ggtitle("Team mean skill distribution before match")
    })
    output$table = renderTable({
      final_df
    })
    })
  
}


skill_update = function(match_list, rank, beta, draw_margin){

  l = length(rank)
  mu = unlist(lapply(match_list[1:l], sum))
  s2 = unlist(lapply(match_list[(l+1):(2*l)], function(x){sum(x^2)}))
  teams = data.frame(mu, s2, delta=0, omega=0)
  for(i in 1:l)
    for(q in 1:l){
      if(q==i) next
      c_iq=sqrt(teams$s2[i] + teams$s2[q] + (length(match_list$mu1) + length(match_list$mu2))*beta^2)
      if(rank[q] > rank[i]){
        # Team i won over team team q
        v_value = v((teams$mu[i] - teams$mu[q]) / c_iq, draw_margin / c_iq)
        w_value = w((teams$mu[i] - teams$mu[q]) / c_iq, draw_margin / c_iq)
      }
      else if (rank[q] == rank[i]){  
        # Draw between teams i and q
        v_value = v_tilde((teams$mu[i] - teams$mu[q]) / c_iq, draw_margin / c_iq)
        w_value = w_tilde((teams$mu[i] - teams$mu[q]) / c_iq, draw_margin / c_iq)
      }
      else{
        # Team q won over team team i
        v_value = -v((teams$mu[q]- teams$mu[i]) / c_iq, draw_margin / c_iq)
        w_value = w((teams$mu[q]- teams$mu[i]) / c_iq, draw_margin / c_iq)
      } 
      delta_q = teams$s2[i]/ c_iq * v_value
      eta_q = teams$s2[i] / c_iq^2 * w_value
      teams$omega[i] = teams$omega[i] + delta_q
      teams$delta[i] = teams$delta[i] + eta_q
    }

  for(i in 1:l){
    mu_team_factor = teams$omega[i]/ teams$s2[i] # appears in all team i players updates for mu
    sigma_team_factor = teams$delta[i] / teams$s2[i]
    print(mu_team_factor)
    print(sigma_team_factor)
    match_list[[paste0("mu_after",i)]] = match_list[[paste0("mu",i)]] + match_list[[paste0("s",i)]]^2 * mu_team_factor
    match_list[[paste0("sigma_after",i)]] = 
      sqrt(match_list[[paste0("s",i)]]^2*(1 - match_list[[paste0("s",i)]]^2 * sigma_team_factor))
  }
  return(list(match_list, teams))
}



v = function(x, t){ 
  if(x - t < -27.1293)
    return(t - x)
  return(dnorm(x - t) / pnorm(x - t))
}


v_tilde = function(x, t){
  return(-(dnorm(t - x) - dnorm(-t - x)) / (dnorm(t - x) -  dnorm(-t - x)))
}

w = function(x, t){
  return(v(x, t) * (v(x, t) + (x - t)))
}

w_tilde = function(x, t){
  return(((t - x) * dnorm(t - x) - (-t - x) * dnorm(-t - x)) / 
  (dnorm_cum(t - x) - dnorm_cum(-t - x)) + (v_tilde(x, t)) ** 2)
}


# Run the application 
shinyApp(ui = ui, server = server)

