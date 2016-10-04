import Vapor
import HTTP

final class GreetingController {

  func detail(_ request: Request, greeting: Greeting) throws -> ResponseRepresentable {
    return try app.view.make("greeting/detail", [
      "title": "Test App",
      "heading": "Greeting Detail",
      "greeting": greeting.makeNode()
    ])
  }

  func prepare(_ request: Request) throws -> ResponseRepresentable {
    return try app.view.make("greeting/create", [
      "title": "Test App",
      "heading": "Create A Greeting"
    ])
  }

  func create(_ request: Request) throws -> ResponseRepresentable {
    guard let category = request.data["category"]?.string,
          let message = request.data["message"]?.string,
          let quantity = request.data["quantity"]?.int,
          let price = request.data["price"]?.double else {
      throw Abort.custom(status: .badRequest, message: "Incomplete Form")
    }
    var greeting = Greeting(category: category, message: message, quantity: quantity, price: price)
    try greeting.save()
    return Response(redirect: "/greeting/all")
  }

  func edit(_ request: Request, greeting: Greeting) throws -> ResponseRepresentable {
    return try app.view.make("greeting/edit", [
      "title": "Test App",
      "heading": "Edit Greeting",
      "greeting": greeting.makeNode()
    ])
  }

  func update(_ request: Request, updated: Greeting) throws -> ResponseRepresentable {
    var greeting = updated
    if let category = request.data["category"]?.string {
      greeting.category = category
    }
    if let message = request.data["message"]?.string {
      greeting.message = message
    }
    if let quantity = request.data["quantity"]?.int {
      greeting.quantity = quantity
    }
    if let price = request.data["price"]?.double {
      greeting.price = price
    }
    try greeting.save()
    return Response(redirect: "/greeting/all")
  }

  func all(_ request: Request) throws -> ResponseRepresentable {
    return try app.view.make("greeting/table", [
      "title": "Test App",
      "heading": "All Greetings",
      "greetings": Greeting.all().makeNode()
    ])
  }

  func list(_ request: Request) throws -> ResponseRepresentable {
    let list = request.data["greetings"]?.array.flatMap { $0.map { Int($0.string ?? "") ?? 0 } } ?? []
    let greetings = try Greeting.query().filter("id", .in, list).all()
    return try app.view.make("greeting/table", [
      "title": "Test App",
      "heading": "Some Greetings",
      "greetings": greetings.makeNode()
    ])
  }

  func delete(_ request: Request, greeting: Greeting) throws -> ResponseRepresentable {
    try greeting.delete()
    return Response(redirect: "/greeting/all")
  }
}
