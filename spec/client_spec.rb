describe Medium::Client do
  def response_fixture(name)
    path = File.expand_path("../responses/#{name}", __FILE__)
    File.read(path)
  end

  let(:client) { Medium::Client.new('qwerty') }
  let(:me_url) { 'https://api.medium.com/v1/me' }

  describe '#create_post' do
    let(:me) { response_fixture('me') }
    let(:post_url) { 'https://api.medium.com/v1/users/5303d74c64f66366f00cb9b2a94f3251bf5/posts' }
    let(:response) { client.create_post(params) }

    before do
      stub_request(:get, me_url).and_return(me)
    end

    context 'when successful' do
      let(:create_post_http_response) { response_fixture('create_post') }
      let(:params) {
        {
          canonicalUrl: 'http://jamietalbot.com/posts/liverpool-fc',
          content: '<h1>Liverpool FC</h1><p>You’ll never walk alone.</p>',
          contentFormat: 'html',
          publishStatus: 'public',
          tags: ['football', 'sport', 'Liverpool'],
          title: 'Liverpool FC',
        }
      }

      before do
        stub_request(:post, post_url).and_return(create_post_http_response)
        response
      end

      it 'posts JSON' do
        expect(a_request(:post, post_url).with { |req|
          data = JSON.parse(req.body)

          expect(data.fetch('canonicalUrl')).to eql('http://jamietalbot.com/posts/liverpool-fc')
          expect(data.fetch('content')).to eql('<h1>Liverpool FC</h1><p>You’ll never walk alone.</p>')
          expect(data.fetch('contentFormat')).to eql('html')
          expect(data.fetch('publishStatus')).to eql('public')
          expect(data.fetch('tags')).to eql(['football', 'sport', 'Liverpool'])
          expect(data.fetch('title')).to eql('Liverpool FC')
        }).to have_been_made
      end

      it 'returns response data' do
        expect(response['data']).to eql({
          'authorId' => '5303d74c64f66366f00cb9b2a94f3251bf5',
          'canonicalUrl' => 'http://jamietalbot.com/posts/liverpool-fc',
          'id' => 'e6f36a',
          'license' => 'all-rights-reserved',
          'licenseUrl' => 'https://medium.com/policy/9db0094a1e0f',
          'publishStatus' => 'public',
          'publishedAt' => 1442286338435,
          'tags' => ['football', 'sport', 'Liverpool'],
          'title' => 'Liverpool FC',
          'url' => 'https://medium.com/@majelbstoat/liverpool-fc-e6f36a',
        })
      end
    end
  end

  describe '#me' do
    let(:me_http_response) { response_fixture('me') }
    let(:response) { client.me }

    before do
      stub_request(:get, me_url).and_return(me_http_response)
    end

    context 'when successful' do
      it 'returns response data' do
        expect(response['data']).to eql({
          'id' => '5303d74c64f66366f00cb9b2a94f3251bf5',
          'imageUrl' => 'https://images.medium.com/0*fkfQiTzT7TlUGGyI.png',
          'name' => 'Jamie Talbot',
          'url' => 'https://medium.com/@majelbstoat',
          'username' => 'majelbstoat',
        })
      end
    end
  end

  describe '#publication_contributors' do
    let(:contributors_url) { 'https://api.medium.com/v1/publications/b45573563f5a/contributors' }
    let(:response) { client.publication_contributors('b45573563f5a') }

    before do
      stub_request(:get, me_url).and_return(response_fixture('me'))
    end

    context 'when successful' do
      let(:contributors_http_response) { response_fixture('publication_contributors') }

      before do
        stub_request(:get, contributors_url).and_return(contributors_http_response)
      end

      it 'returns response data' do
        expect(response['data']).to eql([
          {
            'publicationId' => 'b45573563f5a',
            'role' => 'editor',
            'userId' => '13a06af8f81849c64dafbce822cbafbfab7ed7cecf82135bca946807ea351290d',
          },
          {
            'publicationId' => 'b45573563f5a',
            'role' => 'editor',
            'userId' => '1c9c63b15b874d3e354340b7d7458d55e1dda0f6470074df1cc99608a372866ac',
          },
          {
            'publicationId' => 'b45573563f5a',
            'role' => 'editor',
            'userId' => '1cc07499453463518b77d31650c0b53609dc973ad8ebd33690c7be9236e9384ad',
          },
          {
            'publicationId' => 'b45573563f5a',
            'role' => 'writer',
            'userId' => '196f70942410555f4b3030debc4f199a0d5a0309a7b9df96c57b8ec6e4b5f11d7',
          },
          {
            'publicationId' => 'b45573563f5a',
            'role' => 'writer',
            'userId' => '14d4a581f21ff537d245461b8ff2ae9b271b57d9554e25d863e3df6ef03ddd480',
          }
        ])
      end
    end
  end

  describe '#publications' do
    let(:publications_url) { 'https://api.medium.com/v1/users/5303d74c64f66366f00cb9b2a94f3251bf5/publications' }
    let(:response) { client.publications }

    before do
      stub_request(:get, me_url).and_return(response_fixture('me'))
    end

    context 'when successful' do
      let(:publications_http_response) { response_fixture('publications') }

      before do
        stub_request(:get, publications_url).and_return(publications_http_response)
      end

      it 'returns response data' do
        expect(response['data']).to eql([
          {
            'description' => 'What is this thing and how does it work?',
            'id' => 'b969ac62a46b',
            'imageUrl' => 'https://cdn-images-1.medium.com/fit/c/200/200/0*ae1jbP_od0W6EulE.jpeg',
            'name' => 'About Medium',
            'url' => 'https://medium.com/about',
          },
          {
            'description' => 'Medium’s Developer resources',
            'id' => 'b45573563f5a',
            'imageUrl' => 'https://cdn-images-1.medium.com/fit/c/200/200/1*ccokMT4VXmDDO1EoQQHkzg@2x.png',
            'name' => 'Developers',
            'url' => 'https://medium.com/developers',
          }
        ])
      end
    end
  end
end
