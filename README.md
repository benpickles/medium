# Medium API Ruby Client

[![Build Status](https://travis-ci.org/benpickles/medium.svg?branch=master)](https://travis-ci.org/benpickles/medium)
[![Code Climate](https://codeclimate.com/github/benpickles/medium.svg)](https://codeclimate.com/github/benpickles/medium)

Requires a Medium access token, a [self-issued access token](https://github.com/Medium/medium-api-docs#22-self-issued-access-tokens) is the easiest way to get started.

## Example

```ruby
client = Medium::Client.new(access_token)
client.create_post(
  canonicalUrl: 'http://example.com/hello-world',
  content: '<p>Some interesting words.</p>',
  contentFormat: 'html',
  publishStatus: 'draft',
  title: 'Hello World',
)
```

## API

`Medium::Client.new(access_token)`

`Medium::Client#create_post(params)` - [Medium API docs](https://github.com/Medium/medium-api-docs#creating-a-post)

`Medium::Client#create_publication_post(publication_id, params)` - [Medium API docs](https://github.com/Medium/medium-api-docs#creating-a-post-under-a-publication)

`Medium::Client#me` - [Medium API docs](https://github.com/Medium/medium-api-docs#getting-the-authenticated-users-details)

`Medium::Client#publication_contributors(publication_id)` - [Medium API docs](https://github.com/Medium/medium-api-docs#fetching-contributors-for-a-publication)

`Medium::Client#publications` - [Medium API docs](https://github.com/Medium/medium-api-docs#listing-the-users-publications)
