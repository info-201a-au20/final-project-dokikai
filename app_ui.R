page_one <- tabPanel(
  "Page One (Overview)",
  h2("Put a caption here"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

page_two <- tabPanel(
  "Page Two (Vis 1)",
  h2("Put a caption here"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

page_three <- tabPanel(
  "Page Title (Vis 2)",
  h2("Put a caption here"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

page_four <- tabPanel(
  "Page Title (Vis 3)",
  h2("Put a caption here"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

page_five <- tabPanel(
  "Page Title (Summary Takeaway)",
  h2("Put a caption here"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

ui <- navbarPage(
  "INFO 201",
  page_one,
  page_two,
  page_three,
  page_four,
  page_five
)