describe Medium::ApiError do
  describe 'extracting the message' do
    let(:error) { Medium::ApiError.new(data) }

    context 'from the expected data structure' do
      let(:data) {
        { 'errors' => [{ 'message' => 'a' }] }
      }

      it 'extracts the message' do
        expect(error.message).to eql('a')
      end
    end

    context 'when there are multiple errors' do
      let(:data) {
        { 'errors' => [{ 'message' => 'a' }, { 'message' => 'b' }] }
      }

      it 'uses the first error message' do
        expect(error.message).to eql('a')
      end
    end

    context 'when there are no errors' do
      let(:data) {
        { 'errors' => [] }
      }

      it 'uses a default message' do
        expect(error.message).to eql('Unknown error')
      end
    end

    context 'when there is no errors key' do
      let(:data) { {} }

      it 'uses a default message' do
        expect(error.message).to eql('Unknown error')
      end
    end
  end
end
