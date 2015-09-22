module.exports = (app) ->
  # Module dependencies.
  mongoose = require('mongoose')
  Customer = mongoose.models.Customer
  api = {}
  # ALL

  api.customers = (req, res) ->
    q = req.query.q or ''
    sort = req.query.sort or '_id'
    order = req.query.order or 'asc'
    page = parseInt(req.query.page) or 1
    limit = parseInt(req.query.limit) or 20
    offset = (page - 1) * limit
    # missed feature find
    query = Customer.find({})
    Customer.count query._conditions, (err, count) ->
      query.limit(limit).skip(offset).sort(sort: order).exec (err, results) ->
        if err
          res.json 500, err
        else
          results = results or []
          res.json
            total: count
            page: page
            limit: limit
            from: offset + 1
            to: offset + results.length
            results: results
        return
      return
    return

  # GET

  api.Customer = (req, res) ->
    id = req.params.id
    Customer.findOne { '_id': id }, (err, customer) ->
      if err
        res.json 404, err
      else
        res.json customer: customer
      return
    return

  # POST

  api.addCustomer = (req, res) ->
    customer = undefined
    if typeof req.body == 'undefined'
      res.status 500
      return res.json(message: 'Customer is undefined')
    customer = new Customer(req.body)
    customer.save (err) ->
      if !err
        console.log 'created Customer'
        res.json 201, customer.toObject()
      else
        res.json 500, err
    return

  # PUT

  api.editCustomer = (req, res) ->
    id = req.params.id
    Customer.findById id, (err, customer) ->
      if typeof req.body.Name != 'undefined'
        customer.Name = req.body.Name
      if typeof req.body.Email != 'undefined'
        customer.Email = req.body.Email
      if typeof req.body.PreferredBarber != 'undefined'
        customer.PreferredBarber = req.body.PreferredBarber
      customer.save (err) ->
        if !err
          console.log 'updated Customer'
          return res.json(200, customer.toObject())
        else
          return res.json(500, err)
        res.json customer
    return

  # DELETE

  api.deleteCustomer = (req, res) ->
    id = req.params.id
    Customer.findById id, (err, customer) ->
      customer.remove (err) ->
        if !err
          console.log 'removed Customer'
          res.send 204
        else
          console.log err
          res.json 500, err

  app.get '/api/customer', api.customers
  app.get '/api/customer/:id', api.Customer
  app.post '/api/customer', api.addCustomer
  app.put '/api/customer/:id', api.editCustomer
  app.delete '/api/customer/:id', api.deleteCustomer
  return
