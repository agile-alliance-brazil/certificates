# frozen_string_literal: true

describe Hash do
  describe 'except' do
    it 'should take keys and remove from hash' do
      hash = { key: 'value', other: 1, 'string' => :works }

      expect(hash.except(:key)).to eq(other: 1, 'string' => :works)
      expect(hash.except('string')).to eq(key: 'value', other: 1)
    end
  end
end
