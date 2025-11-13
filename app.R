
library(gargle)
library(glue)

library(shiny)
options(cores=4)

library(DBI)
library(dplyr)
library(jsonlite)
library(httr)
library(waiter)
library(shinyToastify)
library(mongolite)
connection_string = 'mongodb+srv://wankr362_db_user:mA2qMZIqZrfVM2B6@chat.ys6dov7.mongodb.net'
call_collection = mongo(collection="call", db="chat", url=connection_string)

# Define UI for application that draws a histogram
ui <- fluidPage(# log rocket
  
  tags$head(includeHTML("google-analytics.html")),
  useShinyToastify(),
  
  
  #twipla
  # HTML("<!-- TWIPLA Tracking Code for https://globalchathub.com/ish-hub-live-1/ --><script>(function(v,i,s,a,t){v[t]=v[t]||fun>"),
  
  tags$a(href="https://www.isolacehub.com","Visit OUR COMPANY SITE",target="_blank"),
  
  #tags$head(includeHTML("google-analytics.html")),
  #use_tracking(),
  
  waiter::use_waiter(),
  tagList(shiny::tags$div(class="random",style="width:100%;height:100vh;background-image:url('girl.jpg'); background-repeat: no-repeat;",shiny::tags$br(),shiny::tags$p(class='random-calls'),shiny::tags$p(class="wait",style="text-align:center;","JUST WAIT ...")))
  
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
  I_p= reactiveValues(L="",p2="",tk="")
  
  
  session$onSessionEnded(function() {
    print(paste0("close",session$token))
    
    #update db after exist to show i am offline
    #query to update by where condition 
    
      
      #nov 10 query_s <- sprintf('{"link_c": "%s"}',linkf)
      sq=paste0('{"user_id": "',session$token,'"}')
      
      update_s <- '{"$set": {"online": "no"}}'
      
      print(call_collection$update(query = sq, update = update_s,multiple = F))
      print("got it")
      print(session$token)
      
    
    
    # Perform the update
    #result <- my_collection$update(query = query,update = up,multiple = FALSE)
    
    
  })
  
  observe({
    showToast(session,input,autoClose = F,type = "success",text = "If you are not connected to someone for more than 1 min, please press Change Room button below")
  }                                                             
  
  )
  #track_usage(storage_mode = store_json(path = "WWW/logs/"))
  
  
  observeEvent(input$Random_again,ignoreInit = T,{
    removeUI(".rand1")
    removeUI("iframe",multiple = T)
    removeUI("iframe",multiple = T)
    
    waiter <- waiter::Waiter$new()
    #waiter::use_waiter()
    
    waiter$show()
    on.exit(waiter$hide())
    #12-16sql=glue_sql("select * from Ip-server where D_time BETWEEN {Sys.time()-minutes(3)} AND {(Sys.time())} AND Person ='1' ",.con = con)
    
    # 12-16 q1=dbExecute(con,sql)
    
    #12-16 print(q1$Link)
    
    
    #######nov2025code for finding  random not engaged person
   # cal <- call_collection$aggregate(
   #   pipeline = '[
   # { "$match": { "online":"yes","engaged":"no" } },
   # { "$sample": { "size": 1 } }
  #]'
   # )
    
    #nov2025code for finding  random not engaged person/find person excluding with own link with not operator
    pipeline <- sprintf('[
      {"$match": {
        "user_id": {"$ne": "%s"},
        "online": "%s",
        "engaged": "%s"
        
      }},
      {"$sample": {"size": 1}}
    ]', session$token, "yes", "no")
    
    
    
    
    cal= call_collection$aggregate(
      pipeline =pipeline)
     
   print( cal)
   print(nrow(cal))
   removeUI(".wait")
    
    #12-16  if(nrow(q1)==0){
    if( nrow(cal)==0){
      removeUI(selector =  "#r1",multiple = T,immediate = T)
      
      insertUI(".random-calls","afterBegin",ui=tagList(shiny::tags$iframe(class="rand1",style="width:100vw;height:80vh;",src=I_p$L,allow="autoplay;camera;microphone;"),actionButton("Random_again","CHANGE PERSON",width = "100%",class="btn-warning")))
      removeUI("#Random_again",multiple = T)
      print("none found1")
      ##nov2025up <- sprintf('{"$set": {"engaged": "%s"}}', mp)
      
      #my_collection$update('{"link_c":"no"}', '{"$set":{"engaged": "no"}}')
      
      # Perform the update
      #result <- my_collection$update(query = query,update = up,multiple = FALSE)
      
      
      #query to update by where condition to show iam not engaged
      query1 <- sprintf('{"user_id" : "%s"}', session$token)
      update1 <- '{"$set": {"engaged": "no"}}'
      
      print(call_collection$update(query = query1, update = update1,multiple = F))
      
      
     #nov 2025 sql=glue_sql("update 'Ip-server' set Person= '1'  where Link={I_p$L} ",.con = con)
      
      #nov 202  dbGetQuery(con,sql)
      
      print(paste("self link",I_p$L))
      #jqui_hide("#r1",effect = "bounce")
    }
    else{
     
      
      
       print("row>0")
      insertUI(".random-calls","afterBegin",ui=tagList(shiny::tags$iframe(class="rand",id="r1",style="width:100vw;height:80vh;",src=cal$link_c,allow="autoplay;camera;microphone;"),actionButton("Random_again","CHANGE PERSON",width = "100%",class="btn-warning")))
      removeUI("#Random_again",multiple = T)
      
      I_p$p2=cal$link_c
      #query to update by where condition to show iam  engaged with the random link on cal
      query2 <- sprintf('{"user_id" : "%s"}', session$token)
      update2 <- '{"$set": {"engaged": "yes"}}'
      
      call_collection$update(query = query2, update = update2,multiple = F)
      
      #query to update by where condition to show iam engaged with the random link on cal
      query3 <- sprintf('{"user_id" : "%s"}', cal$user_id)
      update3 <- '{"$set": {"engaged": "yes"}}'
      
      call_collection$update(query = query3, update = update3,multiple = F)
      
      
      
     
      #12-26  print(paste("2 link ",t()$Link))
      
      # removeUI(".rand")
      #insertUI(".random-calls","afterBegin",ui=shiny::tags$iframe(style="width:100vw;height:80vh;",src="https://r-testing.w>
      
    }
    
  })
  
  
  
 
  
  
  
  # I_p$x=geoloc::wtfismyip()$Your_IPAddress
  
  
  ##########fetching queries non engaged and online/setting first video call
  
  ##########fetching queries non engaged and online
  
  observe({
    
    waiter <- waiter::Waiter$new()
    #waiter::use_waiter()
    
    waiter$show()
    on.exit(waiter$hide())
    ####################nov 2025
    
   
    
    pipeline <- sprintf('[
      {"$match": {
        "user_id": {"$ne": "%s"},
        "online": "%s",
        "engaged": "%s"
        
      }},
      {"$sample": {"size": 1}}
    ]', session$token, "yes", "no")
    
    cal=call_collection$aggregate(
      pipeline =pipeline)
    
    nrow(cal)
    ##########
    
    print("cal value is above")
    
    #12-16 print(paste("t=",t()))
   removeUI(".wait")
    
    if(nrow(cal)==0){
      #12-16      removeUI(selector =  "#r1",multiple = T,immediate = T)
      #12-16      removeUI("iframe",multiple = T)
      print("none found online")
     
      
       removeUI(".rand1")
      removeUI("iframe",multiple = T)
      removeUI("iframe",multiple = T)
      removeUI("#Random_again")
      
      insertUI(".random-calls","afterBegin",ui=tagList(shiny::tags$iframe(class="rand1",style="width:100vw;height:80vh;",src=I_p$L,allow="autoplay;camera;microphone;"),actionButton("Random_again","CHANGE PERSON",width = "100%",class="btn-warning")))
      
      
      #query to update by where condition to show iam not engaged
      qu <- sprintf('{"user_id" : "%s"}', session$token)
      up <- '{"$set": {"engaged": "no"}}'
      
      print("first update")
      print(call_collection$update(query = qu, update = up,multiple = F))
    
      print(paste("self link",I_p$L))
      print(paste0("session id:",session$token))
    
      }
    else{
      print("row>0")
      removeUI(".rand1")
      removeUI("iframe",multiple = T)
      removeUI("iframe",multiple = T)
      removeUI("#Random_again")
      insertUI(".random-calls","afterBegin",ui=tagList(shiny::tags$iframe(class="rand",id="r1",style="width:100vw;height:80vh;",src=cal$link_c,allow="autoplay;camera;microphone;"),actionButton("Random_again","CHANGE PERSON",width = "100%" ,class="btn-warning")))
      
     
      I_p$p2=cal$link_c
      #query to update by where condition to show iam  engaged with the random link on cal
      query2 <- sprintf('{"user_id" : "%s"}', session$token)
      update2 <- '{"$set": {"engaged": "yes"}}'
      
      
      print("second update")
      print(call_collection$update(query = query2, update = update2,multiple = F))
      
      #query to update by where condition to show iam engaged with the random link on cal
      query3 <- sprintf('{"user_id" : "%s"}', cal$user_id)
      update3 <- '{"$set": {"engaged": "yes"}}'
      print("third update")
      
      print(call_collection$update(query = query3, update = update3,multiple = F))
      
      
      
      
      #12-16  print(paste("2 link ",t()$Link))
      
      # removeUI(".rand")
      #insertUI(".random-calls","afterBegin",ui=shiny::tags$iframe(style="width:100vw;height:80vh;",src="https://r-testing.w>
      
      
      
    }
    
    
  })
  #######code for video call api links
  
  #10nov2025 observe({
    #10nov2025waiter <- waiter::Waiter$new()
    #waiter::use_waiter()
    
    #10nov2025waiter$show()
   #10nov2025 on.exit(waiter$hide())
    
    ### new code cloudfare nov 2025
    
    url1 <- "https://api.dyte.io/v2/meetings"
    
    payload1 <- "curl --request POST \\\n  --url https://api.realtime.cloudflare.com/v2/meetings \\\n  --header 'Authorization: Basic <api_authorization_token>' \\\n  --header 'Content-Type: application/json' \\\n  --data '{\n  \"title\": \"Sample meeting\",\n  \"preferred_region\": \"ap-south-1\",\n  \"record_on_start\": true\n}'"
    
    encode1 <- "raw"
    
    response <- VERB("POST", url1, body = payload1, add_headers('Authorization' = 'Basic OTNhMWMwOTktZjgxNS00Y2QwLWFiNjEtZWQ0ZTJmM2VlMzQ2OjE0Yjk2ZTI2ZDc1OWE3NjhhOGY2'), content_type("text/plain"), accept("application/json"), encode = encode1)
    
   x=as.character (content(response, "text"))
    x1=fromJSON(x)
    link1= x1$data$id
    #### generated response
    ##x=as.character('{\"success\":true,\"data\":{\"id\":\"bbbd5681-0dad-428b-9064-5ebf7fbe7853\",\"record_on_start\":false,\"live_stream_on_start\":false,\"persist_chat\":false,\"summarize_on_end\":false,\"is_large\":false,\"status\":\"ACTIVE\",\"created_at\":\"2025-11-02T13:36:33.590Z\",\"updated_at\":\"2025-11-02T13:36:33.590Z\"}}')
    #> 
    #fromJSON(x)
    ################## add a participant
    #library(httr)
    
   #url2 <- "https://api.dyte.io/v2/meetings/bbbd5681-0dad-428b-9064-5ebf7fbe7853/participants"
    
    url2 <- glue("https://api.dyte.io/v2/meetings/",{x1$data$id},"/participants")
    
    
    
    payload2 <- "{\n  \"name\": \"Solace\",\n  \"picture\": \"https://i.imgur.com/test.jpg\",\n  \"preset_name\": \"iam\",\n  \"custom_participant_id\": \"Chat Now\"\n}"
    
    encode2 <- "json"
    
    response <- VERB("POST", url2, body = payload2, add_headers('Authorization' = 'Basic OTNhMWMwOTktZjgxNS00Y2QwLWFiNjEtZWQ0ZTJmM2VlMzQ2OjE0Yjk2ZTI2ZDc1OWE3NjhhOGY2'), content_type("application/json"), accept("application/json"), encode = encode2)
    
    part1=as.character (content(response, "text"))
    part2=fromJSON(part1)
    tok=part2$data$token
    #final generated link for chat
    linkf=glue("https://demo.realtime.cloudflare.com/meeting?id=",{link1},"&authToken=",{tok})
    
    ####### generated reaonse
    #"{\"success\":true,\"data\":{\"token\":\"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmdJZCI6IjkzYTFjMDk5LWY4MTUtNGNkMC1hYjYxLWVkNGUyZjNlZTM0NiIsIm1lZXRpbmdJZCI6ImJiYmQ1NjgxLTBkYWQtNDI4Yi05MDY0LTVlYmY3ZmJlNzg1MyIsInBhcnRpY2lwYW50SWQiOiJhYWExOWRiZi1jZjExLTRmNTMtYjczMC1iYTBmYTI0ZWNiZDIiLCJwcmVzZXRJZCI6IjQ5MWJhZTlkLWRkYzAtNDFlYi1hNWU0LWEwYzI5MThlYzg0MyIsImlhdCI6MTc2MjA5MzQ5MywiZXhwIjoxNzcwNzMzNDkzfQ.maFavEv3GQzPKwgumJl7hfCnEzta7-PSwFWJrzR_xNDvNPHdXdUJYtRwWVI3PnIjkeEbbo2iFU7DUXHfKXca5OzSEdnsNjq3hCv7USwCgikDupcwtVnLzeZBXFNirGJnxZ2k34O0HrMFWXsdReSYrOSeUPwtBDEJd21a4nH7v2T406KGGU7FoKQ_7qF53KeJzdc-teWKMQJ2JPaskXFuemTwIdD4UljQVhThWXoTc6J9pncKcwpcM736P3dHKNS7WDPolke53Zw4TPQrxewPHI34bbf0QZdOPXNuLaKo_yYmzY9FQJNvql8tzj1Rg5KjRU7CeVno-Oq1mMaC4SvVgg\",\"id\":\"aaa19dbf-cf11-4f53-b730-ba0fa24ecbd2\",\"name\":\"Mary Sue\",\"picture\":\"https://i.imgur.com/test.jpg\",\"custom_participant_id\":\"string\",\"preset_id\":\"491bae9d-ddc0-41eb-a5e4-a0c2918ec843\",\"sip_enabled\":false,\"created_at\":\"2025-11-02T14:24:53.422Z\",\"updated_at\":\"2025-11-02T14:24:53.422Z\"}}"
    
    
    ###### working link created from api
    #https://demo.realtime.cloudflare.com/meeting?id=bbbd5681-0dad-428b-9064-5ebf7fbe7853&authToken=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmdJZCI6IjkzYTFjMDk5LWY4MTUtNGNkMC1hYjYxLWVkNGUyZjNlZTM0NiIsIm1lZXRpbmdJZCI6ImJiYmQ1NjgxLTBkYWQtNDI4Yi05MDY0LTVlYmY3ZmJlNzg1MyIsInBhcnRpY2lwYW50SWQiOiJhYWExOWRiZi1jZjExLTRmNTMtYjczMC1iYTBmYTI0ZWNiZDIiLCJwcmVzZXRJZCI6IjQ5MWJhZTlkLWRkYzAtNDFlYi1hNWU0LWEwYzI5MThlYzg0MyIsImlhdCI6MTc2MjA5MzQ5MywiZXhwIjoxNzcwNzMzNDkzfQ.maFavEv3GQzPKwgumJl7hfCnEzta7-PSwFWJrzR_xNDvNPHdXdUJYtRwWVI3PnIjkeEbbo2iFU7DUXHfKXca5OzSEdnsNjq3hCv7USwCgikDupcwtVnLzeZBXFNirGJnxZ2k34O0HrMFWXsdReSYrOSeUPwtBDEJd21a4nH7v2T406KGGU7FoKQ_7qF53KeJzdc-teWKMQJ2JPaskXFuemTwIdD4UljQVhThWXoTc6J9pncKcwpcM736P3dHKNS7WDPolke53Zw4TPQrxewPHI34bbf0QZdOPXNuLaKo_yYmzY9FQJNvql8tzj1Rg5KjRU7CeVno-Oq1mMaC4SvVgg
    
    ### from dashboard link generated
    #https://demo.realtime.cloudflare.com/v2/meeting?id=bbbd5681-0dad-428b-9064-5ebf7fbe7853&authToken=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmdJZCI6IjkzYTFjMDk5LWY4MTUtNGNkMC1hYjYxLWVkNGUyZjNlZTM0NiIsIm1lZXRpbmdJZCI6ImJiYmQ1NjgxLTBkYWQtNDI4Yi05MDY0LTVlYmY3ZmJlNzg1MyIsInBhcnRpY2lwYW50SWQiOiJhYWEyODc0MS00MWM0LTRhNjQtODk4NC0xYTUwNzZmZTliODEiLCJwcmVzZXRJZCI6IjQ5MWJhZTlkLWRkYzAtNDFlYi1hNWU0LWEwYzI5MThlYzg0MyIsImlhdCI6MTc2MjA5Mzk3OCwiZXhwIjoxNzcwNzMzOTc4fQ.IdRo6qHyUMa9Cu96mmCAqV-tg-SOm2av-zFz-KUg10K68L6gPJ8lC0caMJGBdZ-3eDS0okba1EVynKppV5AUgJx-CzqNUVp3MTT7Et4ipuaBRzTAL_S__oJAqboUZtgjxhVlEQ6KroAiUZ24W8tA4o2Xez59iHaUQMWH3bkC1C8cLTG_R2DOeiQDIiOLXPhQf2vyz30mz9wmHKvsvckEHeCUL9Ddy4KT0ON7DQJfcoXn38CDI4F7H4rrTYq26R-U0qMPasA9LGsL1sty7nqLbJw-VtQ1xsB2Ff0A8F8rQm3VUrF1wkeiy8w0THB70LWiK0-WQX_dKycduaJYGzBjrg
    
    ############## working code for recording /update meeting id setting
    #library(httr)
    
   # url3 <- "https://api.realtime.cloudflare.com/v2/meetings/bbbd5681-0dad-428b-9064-5ebf7fbe7853"
    url3 <- glue("https://api.realtime.cloudflare.com/v2/meetings/",{link1})
    
    
    
    payload3 <- "{\n  \"title\": \"string\",\n  \"preferred_region\": \"ap-south-1\",\n  \"record_on_start\": true,\n  \"live_stream_on_start\": false,\n  \"status\": \"ACTIVE\",\n  \"persist_chat\": false,\n  \"summarize_on_end\": false,\n  \"ai_config\": {\n    \"transcription\": {\n      \"keywords\": [\n        \"string\"\n      ],\n      \"language\": \"en-US\",\n      \"profanity_filter\": false\n    },\n    \"summarization\": {\n      \"word_limit\": 500,\n      \"text_format\": \"markdown\",\n      \"summary_type\": \"general\"\n    }\n  }\n}"
    
    encode3 <- "json"
    
    response <- VERB("PATCH", url3, body = payload3, add_headers('Authorization' = 'Basic OTNhMWMwOTktZjgxNS00Y2QwLWFiNjEtZWQ0ZTJmM2VlMzQ2OjE0Yjk2ZTI2ZDc1OWE3NjhhOGY2'), content_type("application/json"), accept("application/json"), encode = encode3)
    
    content(response, "text")
    ######response generated
    
    #Adding all entries , self links ,status in db
    tot_links=sprintf(
      '{"link_c": "%s", "online": "%s", "engaged": "%s","user_id": "%s"}',
      linkf, "yes", "no",session$token
    )
    
    
    call_collection$insert(tot_links)
    
    I_p$L=linkf
    
    
    print(paste("self linko:" ,linkf))
    #insertUI(".random-calls","afterBegin",ui=class="rand",id="r1",shiny::tags$iframe(class="rand",id="r1",style="width:100v>
    
    #10nov2025 observe closing braces  })
  
  
  
  t=reactive({
    
    waiter <- waiter::Waiter$new()
    #waiter::use_waiter()
    
    waiter$show()
    on.exit(waiter$hide())
    
    
    
    ##########fetching queries non engaged and online
    #cal=call_collection$find('{"online":"yes","engaged":"no"}')
    
  #  cal <- call_collection$aggregate(
  #    pipeline = '[
   # { "$match": { "online":"yes","engaged":"no" } },
    #{ "$sample": { "size": 1 } }
  #]' )
    
    #cal
    ##########
    
    
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
