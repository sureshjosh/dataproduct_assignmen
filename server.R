library(shiny)
library(ggplot2)

sales_data <- data.frame(
  year = rep(c(2010,2011,2012,2013,2014,2015), 4),
  company = c(rep(c('company1'), 6), 
              rep(c('company2'), 6), 
              rep(c('company3'), 6), 
              rep(c('company4'), 6)),
  sales = c(
    c(366 ,756 ,2554 ,4504 ,3106 ,2348),
    c(1982 ,7637 ,17098 ,14399 ,17890 ,18785),
    c(26 ,26 ,100 ,241 ,323 ,241),
    c(50 ,59 ,130 ,206 ,250 ,204)
  )
)
model <- glm(sales ~ year * factor(company), data = sales_data)

gen_data <- function(start_year, end_year, companies) {
  #generate data for year bewteen start_year and end_year
  year <- c()
  company <- c()
  count <- length(companies)
  for (y in start_year:end_year) {
    year <-	c(year, c(rep(y,count)))
    company <- c(company, companies)
  }
  data.frame(year = year, company = company)
}

g <- ggplot(sales_data, aes(x = round(year,0), y = log(sales), color = company, size = 10)) +
  geom_point(size = 7) + theme_bw(base_family = "Times", base_size = 12) + 
  labs(y="log(Sales)", x="Year", size=5 ) + 
  theme(axis.text=element_text(size=15),axis.title=element_text(size=15,face="bold"))

shinyServer(function(input, output) {
  output$Plot1 <- renderPlot({
    gen_new_data <- function(start_year, end_year, companies) {
      #generate data for year
      year <- c()
      company <- c()
      count <- length(companies)
      for (y in start_year:end_year) {
        year <-	c(year, c(rep(y,count)))
        company <- c(company, companies)
      }
      data.frame(year = year, company = company)
    }
    
    output$year <- renderText({input$year})
    output$plot_hover <- renderText({
      if(!is.null(input$plot_hover)){
        paste0("Sales(log)=",round(input$plot_hover$y,1),"
               Year=",round(input$plot_hover$x,0) )}
      })
    year <- input$year
    new_data <-
      gen_data(2016, year, c('company1','company2','company3','company4'))
    new_data$sales <- stats::predict(model, new_data)
    #geom_line(data = new_data,size = 1, linetype =3)
    g +  geom_line(size = 2) + geom_point(data = new_data,size = 5, shape =8)
  })
})