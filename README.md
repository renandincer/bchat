assumes you're using ruby version 2.2.4

install dependencies (sinatra and rspec): 

```
bundle install
```

to run the application:

```
RACK_ENV=production ruby app.rb
```

which will start the application on port 4567 locally.

or on docker: 

```
docker build -t bchat . && docker run -p 80:4567 bchat
```

which will bind it to port 80 on the machine docker is running on.

run tests against it (where TEST_URI is where the server is listening on)

```
TEST_URI=http://192.168.99.100/ rspec
```
