var request = require('supertest'),
    express = require('express');

process.env.NODE_ENV = 'test';

var app = require('../app.js');
var _id = '';


describe('POST New Customer', function(){
  it('creates new customer and responds with json success message', function(done){
    request(app)
    .post('/api/customer')
    .set('Accept', 'application/json')
    .expect('Content-Type', /json/)
    .send({"customer": {}})
    .expect(201)
    .end(function(err, res) {
      if (err) {
        throw err;
      }
      _id = res.body._id;
      done();
    });
  });
});


describe('GET List of customers', function(){
  it('responds with a list of customers items in JSON', function(done){
    request(app)
    .get('/api/customers')
    .set('Accept', 'application/json')
    .expect('Content-Type', /json/)
    .expect(200, done);
  });
});

describe('GET Customer by ID', function(){
  it('responds with a single customer item in JSON', function(done){
    request(app)
    .get('/api/customer/'+ _id)
    .set('Accept', 'application/json')
    .expect('Content-Type', /json/)
    .expect(200, done);
  });
});


describe('PUT Customer by ID', function(){
  it('updates customer item in return JSON', function(done){
    request(app)
    .put('/api/customer/'+ _id)
    .set('Accept', 'application/json')
    .expect('Content-Type', /json/)
    .send({ "customer": { "title": "Hell Is Where There Are No Robots" } })    
    .expect(200, done);
  });
});

describe('DELETE Customer by ID', function(){
  it('should delete customer and return 200 status code', function(done){
    request(app)
    .del('/api/customer/'+ _id) 
    .expect(204, done);
  });
});