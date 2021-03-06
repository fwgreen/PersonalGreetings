import Vapor
import VaporPostgreSQL

let app = Droplet()

app.preparations = [Person.self, Greeting.self]

try app.addProvider(VaporPostgreSQL.Provider.self)

app.get("/") { request in
  return try app.view.make("index.html")
}

app.get("/help") { request in
  return try app.view.make("help.html")
}

app.group("greeting") { greeting in
  let greetings = GreetingController()
  
  greeting.get("/", handler: greetings.index)

  greeting.get("/help", handler: greetings.help)

  greeting.get("/detail", Greeting.self, handler: greetings.detail)

  greeting.get("/new", handler: greetings.prepare)

  greeting.post("/new", handler: greetings.create)

  greeting.get("/edit", Greeting.self, handler: greetings.edit)

  greeting.post("/edit", Greeting.self, handler: greetings.update)

  greeting.get("/all", handler: greetings.all)

  greeting.post("/all", handler: greetings.list)

  greeting.get("/delete", Greeting.self, handler: greetings.delete)
}

app.group("person") { person in
  let persons = PersonController()
  
  person.get("/", handler: persons.index)

  person.get("/help", handler: persons.help)

  person.get("/detail", Person.self, handler: persons.detail)

  person.get("/new", handler: persons.prepare)

  person.post("/new", handler: persons.create)

  person.get("/edit", Person.self, handler: persons.edit)

  person.post("/edit", Person.self, handler: persons.update)

  person.get("/all", handler: persons.all)

  person.post("/all", handler: persons.list)

  person.get("/delete", Person.self, handler: persons.delete)
}

app.run()
