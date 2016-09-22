require 'rails_helper'

RSpec.describe ExesPoster do
  it { is_expected.to be_const_defined(:VERSION) }
  context 'VERSION' do
    subject { ExesPoster.const_get(:VERSION) }
    it { is_expected.to_not be_nil }
    it { is_expected.to be_frozen }
  end

end
