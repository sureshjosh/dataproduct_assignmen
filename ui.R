library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Yearly(2010-2015) Sales of 4 Companies"),
  sidebarPanel(
    sliderInput('year', 'Predict Sales: Select Future Year', value = 2016, min = 2016, max = 2025, step = 1),
    h6('[formula = sales ~ year * factor(company)]')
  ),
  mainPanel(
    textOutput('plot_hover'),
    plotOutput('Plot1',hover = hoverOpts(id ="plot_hover")),
    h5('Sales data (in 1000$) of 4 companies from Year 2010 - Year 2015'),
    h5('This app is using a linear model to predict the sales data for year 2016 onward.'),
    h4('Please hover over the mouse to the dot in the plot to see the actual value of sales.')
  )
))
