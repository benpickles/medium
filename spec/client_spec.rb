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
end
