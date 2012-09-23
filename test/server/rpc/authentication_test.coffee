assert  = require "assert"

describe "Authentication", ->
  
  before (done) ->
    User.remove {}, (err) ->
      Dashboard.remove {}, (err) ->
        done()

  describe "#signup", ->

    describe "if a valid request is made", ->

      before (done) ->

        @res = null

        newUserCredentials = 
          username: "paul" 
          email:    "paul@anephenix.com" 
          password: "123456"

        ass.rpc 'authentication.signup', newUserCredentials, (res) =>
          # For some reason, the res object called back is an array,
          # rather than the object that we get back in the browser
          #
          # See https://github.com/socketstream/socketstream/issues/278
          # for more information on this bug.
          #
          @res = res[0]
          done()

      it "should create a new user record", (done) ->
          User.count (err,count) ->
            assert.equal 1, count
            done()

      it "should append a new hash to the apiKeys set in Redis", (done) ->
        User.findOne {_id: @res.user._id}, (err, user) ->
          Redis.hget "apiKeys", user.apiKey, (err,val) ->
            assert.equal val, user._id
            done()

      it "should generate a dashboard for the new user", (done) ->
        Dashboard.findOne {userId: @res.user._id}, (err, dashboard) ->
          assert.equal dashboard.name, "Your Dashboard"
          done()

      it "should subscribe the user to their own private channel"
      # It would be nice if we could observe channels being 
      # created via pubsub. Find out how.

      it "should return a success response", (done) ->
        assert.equal @res.status, "success"
        done()

    describe "if the user already exists", ->

      before (done) ->

        @res = null 

        newUserCredentials = 
          username: "paul" 
          email:    "paul@anephenix.com" 
          password: "123456"

        ass.rpc 'authentication.signup', newUserCredentials, (res) =>
          @res = res[0]
          done()

      it "should not create another user", (done) ->
        User.count (err,count) ->
          assert.equal 1, count
          done()

      it "should return a failure response", (done) ->
        assert.equal @res.status, "failure"
        done()

    describe "if the user is missing some credentials", ->

      it "should return a failure response", (done) ->
        missingUsername = 
          email:    "earthworm@jim.com"
          password: "123456"

        missingEmail = 
          username: "earthwormJim"
          password: "123456"

        missingPassword = 
          username: "earthwormJim0"
          email:    "earthworm0@jim.com"

        ass.rpc 'authentication.signup', missingUsername, (res) ->
          assert.equal res[0].status, "failure"

          ass.rpc 'authentication.signup', missingEmail, (res) ->
            assert.equal res[0].status, "failure"

            ass.rpc 'authentication.signup', missingPassword, (res) ->
              assert.equal res[0].status, "failure"
              done()

  describe "#signedIn", ->

    it "should return the currently signed-in user"

  describe "#login", ->

    describe "if successful", ->

      it "should return a success status, and the user object"

      it "should subcribe the user to their private channel"

    describe "if not successful", ->

      it "should return the failure status, and explain what went wrong"

  describe "#logout", ->

    it "should remove the userId attribute from the session"

    it "should clear all channels that the session was subscribed to"

    it "should return a success status"

  describe "#isAttributeUnique", ->

    it "should return true if the query finds a document that matches the criteria"

    it "should return false if the query does not find a document that matches the criteria"

  describe "#account", ->

    it "should return the user object based on the user's session"

  describe "#forgotPassword", ->

    describe "if a user is found", ->

      it "should generate a change password token for the user"

      it "should send an email to the user with a link to follow to change their password"

      it "should return a success status"

    describe "if a user is not found", ->

      it "should return a failure status"

      it "should explain what went wrong"

  describe "#loadChangePassword", ->

    describe "if the token is valid", ->

      it "should return a success status"

    describe "if the token is not valid", ->

      it "should return a failure status"

      it "should explain what went wrong"

  describe "#changePassword", ->

    describe "if the user's token is valid", ->

      describe "if a password is provided", ->

        it "should change the user's password to the password provided"

        it "should return a success status"

      describe "if a password is not provided", ->

        it "should return a failure status"

        it "should explain what went wrong"

    describe " if the user's token is not valid", ->

      it "should return a failure status"

      it "should explain what went wrong"

  describe "#changeAccountPassword", ->

    describe "if the user's password matches", ->

      describe "if a new password is provided", ->

        it "should change the user's password to the password provided"

        it "should return a success status"

      describe "if a new password is not provided", ->

        it "should return a failure status"

        it "should explain what went wrong"

    describe "if the user's password does not match", ->

      it "should return a failure status"

      it "should explain what went wrong"

  describe "#changeEmail", ->

    describe "if an email address is provided", ->
      
      describe "if the email address is unique", ->

        it "should change the user's email address"

        it "should return a success status"

      describe "if the email address is not unique", ->

        it "should return a failure status"

        it "should explain what went wrong"

    describe "if an email address is not provided", ->

      it "should return a failure status"

      it "should explain what went wrong"