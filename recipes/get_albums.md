# GET /albums Route Design Recipe

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code.

_Replace the below with your own design. Think of all the different possible responses your route will return._

```
Response when the post is found: 200 OK
Content: HTML content for a list of all albums with
links to corresponding GET /albums/:id page for each
```

## 3. Write Examples

_Replace these with your own design._

```html
<!-- GET /albums -->

<html>
  <head></head>
  <body>
    <h1>Albums</h1>

    <div>
      Title: <a href='/albums/1'>Doolittle</a>
      Released: 1989
    </div>

    <div>
      Title: <a href='/albums/2'>Surfer Rosa</a>
      Released: 1988
    </div>

    <!-- ... -->
  </body>
</html>
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /albums" do
    it 'returns 200 OK with HTML listing all albums with /albums/:id links' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include("Title: <a href=\'/albums/1\'>Doolittle</a>")
      expect(response.body).to include('Released: 1989')
      expect(response.body).to include("Title: <a href=\'/albums/12\'>Ring Ring</a>")
      expect(response.body).to include('Released: 1973')
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
